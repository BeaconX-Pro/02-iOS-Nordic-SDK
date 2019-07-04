//
//  MKBXPCentralManager.m
//  BeaconXPlus
//
//  Created by aa on 2019/4/18.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPCentralManager.h"
#import "MKBXPDefines.h"
#import "MKBXPAdopter.h"
#import "CBPeripheral+MKAdd.h"
#import "MKBXPService.h"
#import "MKBXPTaskOperation.h"

#import "MKBXPBaseBeacon.h"

typedef NS_ENUM(NSInteger, managerMode) {
    managerDefaultMode,
    managerScanMode,
    managerConnectMode,
};

NSString *const MKBXPReceiveThreeAxisAccelerometerDataNotification = @"MKBXPReceiveThreeAxisAccelerometerDataNotification";
NSString *const MKBXPReceiveHTDataNotification = @"MKBXPReceiveHTDataNotification";
NSString *const MKBXPReceiveRecordHTDataNotification = @"MKBXPReceiveRecordHTDataNotification";

static MKBXPCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface MKBXPCentralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager *centralManager;

@property (nonatomic, strong)dispatch_queue_t centralManagerQueue;

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, assign)BOOL timeout;

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@property (nonatomic, assign)managerMode currentMode;

@property (nonatomic, assign)MKBXPConnectStatus connectState;

@property (nonatomic, assign)MKBXPCentralManagerState managerState;

@property (nonatomic, assign)MKBXPLockState lockState;

@property (nonatomic, copy)NSString *password;

@property (nonatomic, copy)MKConnectSuccessBlock sucBlock;

@property (nonatomic, copy)MKConnectFailedBlock failedBlock;

@property (nonatomic, copy)MKConnectProgressBlock progressBlock;

@property (nonatomic, assign)BOOL readingLockState;

@property (nonatomic, copy)void (^readLockStateBlock)(NSString *lockState);

/**
 防止连续调用连接产生问题
 */
@property (nonatomic, assign)BOOL isConnecting;

@end

@implementation MKBXPCentralManager
#pragma mark - life circle

- (instancetype)init{
    if (self = [super init]) {
        _centralManagerQueue = dispatch_queue_create("MKBXPManagerQueue", DISPATCH_QUEUE_SERIAL);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_centralManagerQueue];
    }
    return self;
}

+ (MKBXPCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXPCentralManager new];
        }
    });
    return manager;
}

+ (void)attempDealloc{
    onceToken = 0;
    manager = nil;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    [self updateManagerState];
    if (central.state == CBCentralManagerStatePoweredOn) {
        return;
    }
    if (self.currentMode == managerDefaultMode) {
        [self cancelConnectedPeripheral];
        return;
    }
    if (self.currentMode == managerScanMode) {
        [self stopScanPeripheral];
        return;
    }
    [self connectPeripheralFailed:NO];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if ([RSSI integerValue] == 127) {
        return;
    }
    dispatch_async(_centralManagerQueue, ^{
        NSArray *beaconList = [MKBXPBaseBeacon parseAdvData:advertisementData];
        for (NSInteger i = 0; i < beaconList.count; i ++) {
            MKBXPBaseBeacon *beaconModel = beaconList[i];
            beaconModel.identifier = peripheral.identifier.UUIDString;
            beaconModel.rssi = RSSI;
            beaconModel.peripheral = peripheral;
            beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
        }
        if ([self.scanDelegate respondsToSelector:@selector(bxp_didReceiveBeacon:)]) {
            moko_main_safe(^{
                [self.scanDelegate bxp_didReceiveBeacon:beaconList];
            });
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    if (self.timeout) {
        return;
    }
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
    [self updateConnectProgress:20.f];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self connectPeripheralFailed:NO];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"断开连接");
    [self cancelConnectedPeripheral];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        [self connectPeripheralFailed:NO];
        return;
    }
    if (self.timeout) {
        return;
    }
    for (CBService *service in peripheral.services) {
        //发现服务
        [peripheral discoverCharacteristics:@[] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        [self connectPeripheralFailed:NO];
        return;
    }
    if (self.timeout) {
        return;
    }
    [self.peripheral updateCharacterWithService:service];
    if ([self.peripheral getAllCharacteristics]) {
        //所有特征全部设置完毕，可以进行下一步登录操作
        [self updateConnectProgress:40.f];
        [self sendPasswordToDevice];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconNotifyUUID]]) {
        //判断是否是lockState改变通知
        NSString *content = [MKBXPAdopter hexStringFromData:characteristic.value];
        if (content.length > 6 && [[content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"eb63"]) {
            NSString *state = [content substringFromIndex:(content.length - 2)];
            MKBXPLockState lockState = MKBXPLockStateUnknow;
            if ([state isEqualToString:@"00"]) {
                //锁定状态
                lockState = MKBXPLockStateLock;
            }else if ([state isEqualToString:@"01"]){
                lockState = MKBXPLockStateOpen;
            }else if ([state isEqualToString:@"02"]){
                lockState = MKBXPLockStateUnlockAutoMaticRelockDisabled;
            }
            [self updateLockState:lockState];
            return;
        }
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:threeSensorUUID]]) {
        //监听的三轴加速度数据
        NSString *content = [MKBXPAdopter hexStringFromData:characteristic.value];
        if (content.length >= 12) {
            NSMutableArray *dataList = [NSMutableArray array];
            for (NSInteger i = 0; i < content.length / 12; i ++) {
                NSString *subContent = [[content substringWithRange:NSMakeRange(i * 12, 12)] uppercaseString];
                NSDictionary *dic = @{
                                      @"x-Data":[subContent substringWithRange:NSMakeRange(0, 4)],
                                      @"y-Data":[subContent substringWithRange:NSMakeRange(4, 4)],
                                      @"z-Data":[subContent substringWithRange:NSMakeRange(8, 4)],
                                      };
                [dataList addObject:dic];
            }
            moko_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveThreeAxisAccelerometerDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"axisData":dataList}];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:temperatureHumidityUUID]]) {
        //监听的温湿度数据
        NSString *content = [MKBXPAdopter hexStringFromData:characteristic.value];
        if (content.length == 8) {
            NSInteger tempTemp = [[MKBXPAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(0, 4)]] integerValue];
            NSInteger tempHui = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(4, 4)];
            NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
            NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
            NSDictionary *htData = @{
                                     @"temperature":temperature,
                                     @"humidity":humidity,
                                     };
            moko_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveHTDataNotification
                                                                    object:nil
                                                                  userInfo:htData];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:recordTHUUID]]) {
        //监听的符合采样条件已储存的温湿度数据
        NSString *content = [MKBXPAdopter hexStringFromData:characteristic.value];
        if (content.length == 20 || content.length == 40) {
            NSMutableArray *dataList = [NSMutableArray array];
            for (NSInteger i = 0; i < content.length / 20; i ++) {
                NSString *subContent = [content substringWithRange:NSMakeRange(i * 20, 20)];
                NSString *date = [MKBXPAdopter deviceTime:[subContent substringWithRange:NSMakeRange(0, 12)]];
                NSInteger tempTemp = [[MKBXPAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]] integerValue];
                NSInteger tempHui = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(16, 4)];
                NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
                NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
                NSDictionary *htData = @{
                                         @"temperature":temperature,
                                         @"humidity":humidity,
                                         @"date":date,
                                         };
                [dataList addObject:htData];
            }
            moko_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveRecordHTDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"dataList":dataList}];
            });
        }
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (MKBXPTaskOperation *operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:NULL];
                break;
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (MKBXPTaskOperation *operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didWriteValueForCharacteristic:characteristic error:NULL];
                break;
            }
        }
    }
}

#pragma mark - Public method
- (void)startScanPeripheral{
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        //蓝牙状态不可用
        return;
    }
    if (self.currentMode == managerScanMode) {
        [self.centralManager stopScan];
    }
    self.currentMode = managerScanMode;
    if ([self.scanDelegate respondsToSelector:@selector(bxp_centralManagerStartScan)]) {
        moko_main_safe(^{
            [self.scanDelegate bxp_centralManagerStartScan];
        });
    }
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                          [CBUUID UUIDWithString:@"FEAB"]]
                                                options:nil];
}

- (void)stopScanPeripheral{
    [self.centralManager stopScan];
    self.currentMode = managerDefaultMode;
    if ([self.scanDelegate respondsToSelector:@selector(bxp_centralManagerStopScan)]) {
        moko_main_safe(^{
            [self.scanDelegate bxp_centralManagerStopScan];
        });
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock{
    if (!peripheral) {
        [MKBXPAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password) || password.length > 16) {
        [MKBXPAdopter operationPasswordErrorBlock:failedBlock];
        return;
    }
    if (password.length != [password dataUsingEncoding:NSUTF8StringEncoding].length) {
        [MKBXPAdopter operationPasswordErrorBlock:failedBlock];
        return;
    }
    if (self.managerState != MKBXPCentralManagerStateEnable) {
        [MKBXPAdopter operationCentralBlePowerOffBlock:failedBlock];
        return;
    }
    if (self.isConnecting) {
        //正在连接
        [MKBXPAdopter operationCannotReconnectErrorBlock:failedBlock];
        return;
    }
    self.isConnecting = YES;
    if (self.currentMode == managerScanMode) {
        [self stopScanPeripheral];
    }
    BOOL needDelay = NO;
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.operationQueue cancelAllOperations];
        [self.peripheral setNil];
        self.peripheral = nil;
        needDelay = YES;
    }
    self.password = password;
    __weak typeof(self) weakSelf = self;
    void (^connectSucBlock)(CBPeripheral *peripheral) = ^(CBPeripheral *peripheral){
        if (sucBlock) {
            moko_main_safe(^{sucBlock(peripheral);});
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
    };
    void (^connectFailedBlock)(NSError *error) = ^(NSError *error){
        if (failedBlock) {
            moko_main_safe(^{failedBlock(error);});
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
    };
    void (^connectProgressBlock)(float progress) = ^(float progress){
        if (progressBlock) {
            moko_main_safe(^{progressBlock(progress);});
        }
    };
    NSDictionary *params = @{
                             @"sucBlock":connectSucBlock,
                             @"failedBlock":connectFailedBlock,
                             @"progressBlock":connectProgressBlock,
                             @"peripheral":peripheral,
                             };
    [self performSelector:@selector(connectPeripheralWithParams:) withObject:params afterDelay:(needDelay ? 1.f : 0.0f)];
}

- (void)disconnect{
    self.currentMode = managerDefaultMode;
    [self.operationQueue cancelAllOperations];
    [self updateConnectState:MKBXPConnectStatusDisconnect];
    [self updateLockState:MKBXPLockStateLock];
    self.isConnecting = NO;
    if (!self.peripheral || self.centralManager.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    [self.peripheral setNil];
    self.peripheral = nil;
}

- (void)readLockStateWithPeripheral:(CBPeripheral *)peripheral
                           sucBlock:(void (^)(NSString *lockState))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock{
    if (self.isConnecting) {
        [MKBXPAdopter operationCannotReconnectErrorBlock:failedBlock];
        self.readingLockState = NO;
        return;
    }
    self.isConnecting = YES;
    if (self.readingLockState) {
        self.isConnecting = NO;
        return;
    }
    self.readingLockState = YES;
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.operationQueue cancelAllOperations];
        [self.peripheral setNil];
        sleep(1.f);
    }
    self.peripheral = nil;
    self.peripheral = peripheral;
    self.currentMode = managerConnectMode;
    [self startConnectTimer];
    __weak typeof(self) weakSelf = self;
    self.readLockStateBlock = ^(NSString *lockState) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
        if (sucBlock) {
            moko_main_safe(^{sucBlock(lockState);});
        }
    };
    self.failedBlock = ^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
        if (failedBlock) {
            moko_main_safe(^{failedBlock(error);});
        }
    };
    [self.centralManager connectPeripheral:self.peripheral options:@{}];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock{
    if (!peripheral) {
        [MKBXPAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (self.managerState != MKBXPCentralManagerStateEnable) {
        [MKBXPAdopter operationCentralBlePowerOffBlock:failedBlock];
        return;
    }
    if (self.isConnecting) {
        //正在连接
        [MKBXPAdopter operationCannotReconnectErrorBlock:failedBlock];
        return;
    }
    self.isConnecting = YES;
    if (self.currentMode == managerScanMode) {
        [self stopScanPeripheral];
    }
    BOOL needDelay = NO;
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.operationQueue cancelAllOperations];
        [self.peripheral setNil];
        self.peripheral = nil;
        needDelay = YES;
    }
    __weak typeof(self) weakSelf = self;
    void (^connectSucBlock)(CBPeripheral *peripheral) = ^(CBPeripheral *peripheral){
        if (sucBlock) {
            moko_main_safe(^{sucBlock(peripheral);});
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
    };
    void (^connectFailedBlock)(NSError *error) = ^(NSError *error){
        if (failedBlock) {
            moko_main_safe(^{failedBlock(error);});
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllConnectParams];
    };
    void (^connectProgressBlock)(float progress) = ^(float progress){
        if (progressBlock) {
            moko_main_safe(^{progressBlock(progress);});
        }
    };
    NSDictionary *params = @{
                             @"sucBlock":connectSucBlock,
                             @"failedBlock":connectFailedBlock,
                             @"progressBlock":connectProgressBlock,
                             @"peripheral":peripheral,
                             };
    [self performSelector:@selector(connectPeripheralWithParams:) withObject:params afterDelay:(needDelay ? 1.f : 0.0f)];
}

- (void)addTaskWithTaskID:(MKBXPOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock{
    MKBXPTaskOperation *operation = [self generateOperationWithOperationID:operationID
                                                                 commandData:commandData
                                                              characteristic:characteristic
                                                                successBlock:successBlock
                                                                failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

- (void)addReadTaskWithTaskID:(MKBXPOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock{
    MKBXPTaskOperation *operation = [self generateReadOperationWithID:operationID
                                                         characteristic:characteristic
                                                           successBlock:successBlock
                                                           failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

- (void)addOperation:(MKBXPTaskOperation *)operation{
    if (!operation) {
        return;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
}

- (BOOL)notifyThreeAxisAcceleration:(BOOL)notify {
    if (self.connectState != MKBXPConnectStatusConnected || self.peripheral == nil || self.peripheral.threeSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.threeSensor];
    return YES;
}

- (BOOL)notifyTHData:(BOOL)notify {
    if (self.connectState != MKBXPConnectStatusConnected || self.peripheral == nil || self.peripheral.temperatureHumidity == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.temperatureHumidity];
    return YES;
}

- (BOOL)notifyRecordTHData:(BOOL)notify {
    if (self.connectState != MKBXPConnectStatusConnected || self.peripheral == nil || self.peripheral.recordTH == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.recordTH];
    return YES;
}

#pragma mark - private method
#pragma mark - connect
- (void)connectPeripheralWithParams:(NSDictionary *)params{
    self.progressBlock = params[@"progressBlock"];
    self.sucBlock = params[@"sucBlock"];
    self.failedBlock = params[@"failedBlock"];
    self.peripheral = params[@"peripheral"];
    self.currentMode = managerConnectMode;
    [self startConnectTimer];
    [self updateConnectProgress:5.f];
    [self updateConnectState:MKBXPConnectStatusConnecting];
    [self.centralManager connectPeripheral:self.peripheral options:@{}];
}

- (void)startConnectTimer{
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.timeout = NO;
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_centralManagerQueue);
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 20 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.connectTimer, start, interval, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.connectTimer, ^{
        __strong typeof(self) sself = weakSelf;
        sself.timeout = YES;
        [sself connectPeripheralFailed:NO];
    });
    dispatch_resume(self.connectTimer);
}

#pragma mark - connect result method

- (void)resetOriSettings{
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.timeout = NO;
    self.currentMode = managerDefaultMode;
}

- (void)connectPeripheralFailed:(BOOL)isPasswordError{
    [self resetOriSettings];
    if (self.peripheral) {
        [self.centralManager cancelPeripheralConnection:self.peripheral];
        [self.peripheral setNil];
    }
    self.peripheral = nil;
    [self updateConnectState:MKBXPConnectStatusConnectedFailed];
    if (isPasswordError) {
        [MKBXPAdopter operationPasswordErrorBlock:self.failedBlock];
        return;
    }
    [MKBXPAdopter operationConnectFailedBlock:self.failedBlock];
}

- (void)connectPeripheralSuccess{
    if (self.timeout) {
        return;
    }
    [self resetOriSettings];
    [self updateConnectState:MKBXPConnectStatusConnected];
    if (self.sucBlock) {
        moko_main_safe(^{self.sucBlock(self.peripheral);});
    }
}

- (void)cancelConnectedPeripheral{
    if (!self.peripheral) {
        return;
    }
    [self updateConnectState:MKBXPConnectStatusDisconnect];
    [self.centralManager cancelPeripheralConnection:self.peripheral];
    [self.peripheral setNil];
    self.peripheral = nil;
    [self.operationQueue cancelAllOperations];
}

#pragma mark -

- (void)updateConnectState:(MKBXPConnectStatus)state{
    self.connectState = state;
    if ([self.stateDelegate respondsToSelector:@selector(bxp_peripheralConnectStateChanged:)]) {
        moko_main_safe(^{
            [self.stateDelegate bxp_peripheralConnectStateChanged:state];
        });
    }
}

- (void)updateManagerState{
    MKBXPCentralManagerState managerState = MKBXPCentralManagerStateUnable;
    if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        managerState = MKBXPCentralManagerStateEnable;
    }
    self.managerState = managerState;
    if ([self.stateDelegate respondsToSelector:@selector(bxp_centralStateChanged:)]) {
        moko_main_safe(^{
            [self.stateDelegate bxp_centralStateChanged:managerState];
        });
    }
}

- (void)updateLockState:(MKBXPLockState)lockState{
    self.lockState = lockState;
    if ([self.stateDelegate respondsToSelector:@selector(bxp_LockStateChanged:)]) {
        moko_main_safe(^{
            [self.stateDelegate bxp_LockStateChanged:lockState];
        });
    }
}

- (void)clearAllConnectParams{
    self.progressBlock = nil;
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.password = nil;
    self.isConnecting = NO;
    self.readLockStateBlock = nil;
    self.readingLockState = NO;
}

#pragma mark - communication method
- (MKBXPTaskOperation *)generateOperationWithOperationID:(MKBXPOperationID)operationID
                                               commandData:(NSString *)commandData
                                            characteristic:(CBCharacteristic *)characteristic
                                              successBlock:(void (^)(id returnData))successBlock
                                              failureBlock:(void (^)(NSError *error))failureBlock{
    if (!self.peripheral && self.connectState != MKBXPConnectStatusConnected) {
        [MKBXPAdopter operationDisconnectedErrorBlock:failureBlock];
        return nil;
    }
    if (self.lockState != MKBXPLockStateOpen && self.lockState != MKBXPLockStateUnlockAutoMaticRelockDisabled) {
        //锁定状态
        [MKBXPAdopter operationLockedErrorBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [MKBXPAdopter operationParamsErrorBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [MKBXPAdopter operationCharacteristicErrorBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself sendCommandToPeripheral:commandData characteristic:characteristic];
    } completeBlock:^(NSError *error, MKBXPOperationID operationID, id returnData) {
        __strong typeof(self) sself = weakSelf;
        [sself parseTaskResult:error returnData:returnData successBlock:successBlock failureBlock:failureBlock];
    }];
    return operation;
}

- (MKBXPTaskOperation *)generateReadOperationWithID:(MKBXPOperationID)operationID
                                       characteristic:(CBCharacteristic *)characteristic
                                         successBlock:(void (^)(id returnData))successBlock
                                         failureBlock:(void (^)(NSError *error))failureBlock{
    if (!self.peripheral && self.connectState != MKBXPConnectStatusConnected) {
        [MKBXPAdopter operationDisconnectedErrorBlock:failureBlock];
        return nil;
    }
    if (self.lockState != MKBXPLockStateOpen && self.lockState != MKBXPLockStateUnlockAutoMaticRelockDisabled) {
        //锁定状态
        [MKBXPAdopter operationLockedErrorBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [MKBXPAdopter operationCharacteristicErrorBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError *error, MKBXPOperationID operationID, id returnData) {
        __strong typeof(self) sself = weakSelf;
        [sself parseTaskResult:error returnData:returnData successBlock:successBlock failureBlock:failureBlock];
    }];
    return operation;
}

- (void)parseTaskResult:(NSError *)error
             returnData:(id)returnData
           successBlock:(void (^)(id returnData))successBlock
           failureBlock:(void (^)(NSError *error))failureBlock{
    if (error) {
        moko_main_safe(^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
        return ;
    }
    if (!returnData) {
        [MKBXPAdopter operationRequestDataErrorBlock:failureBlock];
        return ;
    }
    NSString *lev = returnData[MKBXPDataStatusLev];
    if ([lev isEqualToString:@"1"]) {
        //通用无附加信息的
        NSArray *dataList = (NSArray *)returnData[MKBXPDataInformation];
        if (!MKValidArray(dataList)) {
            [MKBXPAdopter operationRequestDataErrorBlock:failureBlock];
            return;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":dataList[0],
                                    };
        moko_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
        return;
    }
    //对于有附加信息的
    if (![lev isEqualToString:@"2"]) {
        //
        return;
    }
    NSDictionary *resultDic = @{@"msg":@"success",
                                @"code":@"1",
                                @"result":returnData[MKBXPDataInformation],
                                };
    moko_main_safe(^{
        if (successBlock) {
            successBlock(resultDic);
        }
    });
}

- (void)sendCommandToPeripheral:(NSString *)commandData characteristic:(CBCharacteristic *)characteristic{
    if (!self.peripheral || !MKValidStr(commandData) || !characteristic) {
        return;
    }
    NSData *data = [MKBXPAdopter stringToData:commandData];
    if (!MKValidData(data)) {
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
}

#pragma mark - 解锁过程
- (void)updateConnectProgress:(float)progress{
    moko_main_safe(^{
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
    });
}
- (void)sendPasswordToDevice{
    if (self.timeout) {
        //如果处于超时
        return;
    }
    dispatch_async(dispatch_queue_create("unlockEddystoneQueue", 0), ^{
        MKBXPLockState lockState = [self fetchLockState];
        if (self.readingLockState) {
            //z读取lockState操作，不需要进行后续步骤
            if (self.readLockStateBlock) {
                NSString *lockInfo = @"00";
                if (lockState == MKBXPLockStateUnlockAutoMaticRelockDisabled) {
                    lockInfo = @"02";
                }
                moko_main_safe(^{
                    self.readLockStateBlock(lockInfo);
                });
            }
            return ;
        }
        [self updateLockState:lockState];
        [self updateConnectProgress:50.f];
        if (self.timeout) {
            return;
        }
        if (lockState == MKBXPLockStateUnknow) {
            [self connectPeripheralFailed:NO];
            return;
        }
        if (lockState == MKBXPLockStateLock) {
            //锁定状态
            //先读取设备的unlock数据，返回16位的随机key
            NSData *randKey = [self fetchRandDataArray];
            [self updateConnectProgress:65.f];
            if (self.timeout) {
                return;
            }
            if (!MKValidData(randKey) || randKey.length != 16) {
                [self connectPeripheralFailed:NO];
                return;
            }
            NSData *keyToUnlock = [MKBXPAdopter fetchKeyToUnlockWithPassword:self.password randKey:randKey];
            if (!MKValidData(keyToUnlock)) {
                [self connectPeripheralFailed:NO];
                return;
            }
            //当前密码与unlock返回的16位key进行aes128加密之后生成对应的解锁码，发送给设备的unlock特征进行解锁
            BOOL sendToUnlockSuccess = [self sendKeyToUnlock:keyToUnlock];
            [self updateConnectProgress:80.f];
            if (self.timeout) {
                return;
            }
            if (!sendToUnlockSuccess) {
                [self connectPeripheralFailed:NO];
                return;
            }
            //解锁码发送给设备之后，再次获取设备的锁定状态，看看是否解锁成功
            MKBXPLockState newLockState = [self fetchLockState];
            [self updateLockState:newLockState];
            [self updateConnectProgress:100.f];
            if (self.timeout) {
                return;
            }
            if (newLockState == MKBXPLockStateUnknow || newLockState == MKBXPLockStateLock) {
                [self connectPeripheralFailed:YES];
                return;
            }
            [self connectPeripheralSuccess];
            return;
        }
        [self connectPeripheralSuccess];
    });
    
}

- (MKBXPLockState)fetchLockState{
    __block MKBXPLockState lockState = MKBXPLockStateUnknow;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:MKBXPReadLockStateOperation resetNum:NO commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral readValueForCharacteristic:sself.peripheral.lockState];
    } completeBlock:^(NSError *error, MKBXPOperationID operationID, id returnData) {
        if (!error) {
            NSArray *dataList = (NSArray *)returnData[MKBXPDataInformation];
            NSDictionary *resultDic = dataList[0];
            NSString *state = resultDic[@"lockState"];
            if ([state isEqualToString:@"00"]) {
                //锁定状态
                lockState = MKBXPLockStateLock;
            }else if ([state isEqualToString:@"01"]){
                lockState = MKBXPLockStateOpen;
            }else if ([state isEqualToString:@"02"]){
                lockState = MKBXPLockStateUnlockAutoMaticRelockDisabled;
            }else{
                lockState = MKBXPLockStateUnknow;
            }
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return lockState;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return lockState;
}

- (NSData *)fetchRandDataArray{
    __block NSData *RAND_DATA_ARRAY = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:MKBXPReadUnlockOperation resetNum:NO commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral readValueForCharacteristic:sself.peripheral.unlock];
    } completeBlock:^(NSError *error, MKBXPOperationID operationID, id returnData) {
        if (!error) {
            NSArray *dataList = (NSArray *)returnData[MKBXPDataInformation];
            NSDictionary *resultDic = dataList[0];
            RAND_DATA_ARRAY = resultDic[@"RAND_DATA_ARRAY"];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    if (!operation) {
        return RAND_DATA_ARRAY;
    }
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return RAND_DATA_ARRAY;
}

- (BOOL)sendKeyToUnlock:(NSData *)keyData{
    if (!self.peripheral || !self.peripheral.unlock) {
        return NO;
    }
    __block BOOL success = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:MKBXPSetUnlockOperation resetNum:NO commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral writeValue:keyData forCharacteristic:sself.peripheral.unlock type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, MKBXPOperationID operationID, id returnData) {
        if (!error) {
            success = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    @synchronized (self.operationQueue){
        [self.operationQueue addOperation:operation];
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - setter & getter
- (NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
