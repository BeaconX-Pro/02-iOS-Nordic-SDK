//
//  MKBXPCentralManager.m
//  tempasdfjasd
//
//  Created by aa on 2020/9/24.
//

#import "MKBXPCentralManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBXPBaseBeacon.h"

#import "MKBXPPeripheral.h"
#import "MKBXPTaskOperation.h"
#import "CBPeripheral+MKAdd.h"
#import "MKBXPAdopter.h"
#import "MKBXPService.h"

static MKBXPCentralManager *manager = nil;
static dispatch_once_t onceToken;

NSString *const MKBXPReceiveThreeAxisAccelerometerDataNotification = @"MKBXPReceiveThreeAxisAccelerometerDataNotification";
NSString *const MKBXPReceiveHTDataNotification = @"MKBXPReceiveHTDataNotification";
NSString *const MKBXPReceiveRecordHTDataNotification = @"MKBXPReceiveRecordHTDataNotification";

@interface MKBXPCentralManager ()

@property (nonatomic, assign)MKBXPLockState lockState;

@property (nonatomic, assign)MKBXPConnectStatus connectState;

@property (nonatomic, assign)BOOL readingLockState;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, copy)void (^progressBlock)(float progress);

@property (nonatomic, copy)void (^readLockStateBlock)(NSString *lockState);

@property (nonatomic, copy)NSString *password;

@end

@implementation MKBXPCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
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

+ (void)attempDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *beaconList = [MKBXPBaseBeacon parseAdvData:advertisementData];
        for (NSInteger i = 0; i < beaconList.count; i ++) {
            MKBXPBaseBeacon *beaconModel = beaconList[i];
            beaconModel.identifier = peripheral.identifier.UUIDString;
            beaconModel.rssi = RSSI;
            beaconModel.peripheral = peripheral;
            beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
        }
        if ([self.scanDelegate respondsToSelector:@selector(bxp_didReceiveBeacon:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scanDelegate bxp_didReceiveBeacon:beaconList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.scanDelegate respondsToSelector:@selector(bxp_centralManagerStartScan)]) {
        [self.scanDelegate bxp_centralManagerStartScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.scanDelegate respondsToSelector:@selector(bxp_centralManagerStopScan)]) {
        [self.scanDelegate bxp_centralManagerStopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    if ([self.stateDelegate respondsToSelector:@selector(bxp_centralStateChanged:)]) {
        [self.stateDelegate bxp_centralStateChanged:[self managerState]];
    }
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    if (self.readingLockState) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectState = MKBXPConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectState = MKBXPConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectState = MKBXPConnectStatusDisconnect;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectState = MKBXPConnectStatusConnectedFailed;
    }
    if ([self.stateDelegate respondsToSelector:@selector(bxp_peripheralConnectStateChanged:)]) {
        MKBLEBase_main_safe(^{
            [self.stateDelegate bxp_peripheralConnectStateChanged:self.connectState];
        });
    }
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconNotifyUUID]]) {
        //判断是否是lockState改变通知
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
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
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
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
            MKBLEBase_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveThreeAxisAccelerometerDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"axisData":dataList}];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:temperatureHumidityUUID]]) {
        //监听的温湿度数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (content.length == 8) {
            NSInteger tempTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(0, 4)]] integerValue];
            NSInteger tempHui = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(4, 4)];
            NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
            NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
            NSDictionary *htData = @{
                                     @"temperature":temperature,
                                     @"humidity":humidity,
                                     };
            MKBLEBase_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveHTDataNotification
                                                                    object:nil
                                                                  userInfo:htData];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:recordTHUUID]]) {
        //监听的符合采样条件已储存的温湿度数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (content.length == 20 || content.length == 40) {
            NSMutableArray *dataList = [NSMutableArray array];
            for (NSInteger i = 0; i < content.length / 20; i ++) {
                NSString *subContent = [content substringWithRange:NSMakeRange(i * 20, 20)];
                NSString *date = [MKBXPAdopter deviceTime:[subContent substringWithRange:NSMakeRange(0, 12)]];
                NSInteger tempTemp = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]] integerValue];
                NSInteger tempHui = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(16, 4)];
                NSString *temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
                NSString *humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
                NSDictionary *htData = @{
                                         @"temperature":temperature,
                                         @"humidity":humidity,
                                         @"date":date,
                                         };
                [dataList addObject:htData];
            }
            MKBLEBase_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MKBXPReceiveRecordHTDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"dataList":dataList}];
            });
        }
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - Public method
- (void)startScanPeripheral {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                                       [CBUUID UUIDWithString:@"FEAB"]]
                                                             options:nil];
}
- (void)stopScanPeripheral {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (nonnull CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (nonnull CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (MKBXPCentralManagerState)managerState {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable ?
            MKBXPCentralManagerStateEnable : MKBXPCentralManagerStateUnable);
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(CBPeripheral * _Nonnull peripheral))sucBlock
              failedBlock:(void (^)(NSError * _Nonnull error))failedBlock {
    if (![MKBLEBaseSDKAdopter asciiString:password] || password.length > 16) {
        [self operationFailedBlockWithMsg:@"Password Error" failedBlock:failedBlock];
        return;
    }
    self.password = nil;
    self.password = password;
    [self connectPeripheral:peripheral
              progressBlock:progressBlock
                   sucBlock:sucBlock
                failedBlock:failedBlock];
}

- (void)readLockStateWithPeripheral:(nonnull CBPeripheral *)peripheral
                           sucBlock:(void (^)(NSString *lockState))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.readingLockState) {
        [self operationFailedBlockWithMsg:@"Device is busy now" failedBlock:failedBlock];
        return;
    }
    self.readingLockState = YES;
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.progressBlock = nil;
    __weak typeof(self) weakSelf = self;
    self.readLockStateBlock = ^(NSString *lockState) {
        if (sucBlock) {
            MKBLEBase_main_safe(^{sucBlock(lockState);});
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
    };
    MKBXPPeripheral *bxpPeripheral = [[MKBXPPeripheral alloc] init];
    bxpPeripheral.peripheral = peripheral;
    [[MKBLEBaseCentralManager shared] connectDevice:bxpPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self sendPasswordToDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
    }];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
            progressBlock:(void (^)(float))progressBlock
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * _Nonnull))failedBlock {
    if (self.readingLockState) {
        [self operationFailedBlockWithMsg:@"Device is busy now" failedBlock:failedBlock];
        return;
    }
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self connect:peripheral progressBlock:^(float progress) {
        if (progressBlock) {
            progressBlock(progress);
        }
    } sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (sucBlock) {
            sucBlock(peripheral);
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
    } failedBlock:^(NSError * _Nonnull error) {
        if (failedBlock) {
            failedBlock(error);
        }
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
    }];
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
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(MKBXPOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock{
    MKBXPTaskOperation *operation = [self generateReadOperationWithID:operationID
                                                         characteristic:characteristic
                                                           successBlock:successBlock
                                                           failureBlock:failureBlock];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
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

#pragma mark - 解锁过程
- (void)updateConnectProgress:(float)progress{
    MKBLEBase_main_safe(^{
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
    });
}
- (void)sendPasswordToDevice{
    dispatch_async(dispatch_queue_create("unlockEddystoneQueue", 0), ^{
        MKBXPLockState lockState = [self fetchLockState];
        if (self.readingLockState) {
            //读取lockState操作，不需要进行后续步骤
            if (self.readLockStateBlock) {
                NSString *lockInfo = @"00";
                if (lockState == MKBXPLockStateUnlockAutoMaticRelockDisabled) {
                    lockInfo = @"02";
                }
                MKBLEBase_main_safe(^{
                    self.readLockStateBlock(lockInfo);
                });
            }
            //读取完数据之后断开连接
            [[MKBLEBaseCentralManager shared] disconnect];
            self.readingLockState = NO;
            return ;
        }
        [self updateLockState:lockState];
        [self updateConnectProgress:50.f];
        if (lockState == MKBXPLockStateUnknow) {
            [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.failedBlock];
            self.readingLockState = NO;
            return;
        }
        if (lockState == MKBXPLockStateLock) {
            //锁定状态
            //先读取设备的unlock数据，返回16位的随机key
            NSData *randKey = [self fetchRandDataArray];
            [self updateConnectProgress:65.f];
            if (!MKValidData(randKey) || randKey.length != 16) {
                [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.failedBlock];
                self.readingLockState = NO;
                return;
            }
            NSData *keyToUnlock = [MKBXPAdopter fetchKeyToUnlockWithPassword:self.password randKey:randKey];
            if (!MKValidData(keyToUnlock)) {
                [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.failedBlock];
                self.readingLockState = NO;
                return;
            }
            //当前密码与unlock返回的16位key进行aes128加密之后生成对应的解锁码，发送给设备的unlock特征进行解锁
            BOOL sendToUnlockSuccess = [self sendKeyToUnlock:keyToUnlock];
            [self updateConnectProgress:80.f];
            if (!sendToUnlockSuccess) {
                [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.failedBlock];
                self.readingLockState = NO;
                return;
            }
            //解锁码发送给设备之后，再次获取设备的锁定状态，看看是否解锁成功
            MKBXPLockState newLockState = [self fetchLockState];
            [self updateLockState:newLockState];
            [self updateConnectProgress:100.f];
            if (newLockState == MKBXPLockStateUnknow || newLockState == MKBXPLockStateLock) {
                [self operationFailedBlockWithMsg:@"Password Error" failedBlock:self.failedBlock];
                self.readingLockState = NO;
                return;
            }
            self.readingLockState = NO;
            [self connectDeviecSuccess];
            return;
        }
        self.readingLockState = NO;
        [self connectDeviecSuccess];
    });
    
}

- (void)connectDeviecSuccess {
    MKBLEBase_main_safe(^{
        self.connectState = MKBXPConnectStatusConnected;
        if ([self.stateDelegate respondsToSelector:@selector(bxp_peripheralConnectStateChanged:)]) {
            [self.stateDelegate bxp_peripheralConnectStateChanged:self.connectState];
        }
        
        if (self.sucBlock) {
            self.sucBlock([MKBLEBaseCentralManager shared].peripheral);
        }
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
    [[MKBLEBaseCentralManager shared] addOperation:operation];
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
    [[MKBLEBaseCentralManager shared] addOperation:operation];
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
    [[MKBLEBaseCentralManager shared] addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method

- (void)connect:(CBPeripheral *)peripheral
  progressBlock:(void (^)(float progress))progressBlock
       sucBlock:(void (^)(CBPeripheral * _Nonnull peripheral))sucBlock
    failedBlock:(void (^)(NSError * _Nonnull error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    self.progressBlock = nil;
    self.progressBlock = progressBlock;
    [self updateConnectProgress:5.f];
    MKBXPPeripheral *bxpPeripheral = [[MKBXPPeripheral alloc] init];
    bxpPeripheral.peripheral = peripheral;
    [[MKBLEBaseCentralManager shared] connectDevice:bxpPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self updateConnectProgress:30.f];
        [self sendPasswordToDevice];
    } failedBlock:failedBlock];
}

- (void)updateLockState:(MKBXPLockState)lockState{
    self.lockState = lockState;
    if ([self.stateDelegate respondsToSelector:@selector(bxp_LockStateChanged:)]) {
        MKBLEBase_main_safe(^{
            [self.stateDelegate bxp_LockStateChanged:lockState];
        });
    }
}

- (void)clearAllParams {
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.progressBlock = nil;
    self.readLockStateBlock = nil;
    self.readingLockState = NO;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BXPCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

#pragma mark - communication method
- (MKBXPTaskOperation *)generateOperationWithOperationID:(MKBXPOperationID)operationID
                                               commandData:(NSString *)commandData
                                            characteristic:(CBCharacteristic *)characteristic
                                              successBlock:(void (^)(id returnData))successBlock
                                              failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"Input parameter error" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
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
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPTaskOperation *operation = [[MKBXPTaskOperation alloc] initOperationWithID:operationID resetNum:NO commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
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
        MKBLEBase_main_safe(^{
            if (failureBlock) {
                failureBlock(error);
            }
        });
        return ;
    }
    if (!returnData) {
        [self operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
        return ;
    }
    NSString *lev = returnData[MKBXPDataStatusLev];
    if ([lev isEqualToString:@"1"]) {
        //通用无附加信息的
        NSArray *dataList = (NSArray *)returnData[MKBXPDataInformation];
        if (!MKValidArray(dataList)) {
            [self operationFailedBlockWithMsg:@"request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":dataList[0],
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
        return;
    }
    //对于有附加信息的
    NSDictionary *resultDic = @{@"msg":@"success",
                                @"code":@"1",
                                @"result":returnData[MKBXPDataInformation],
                                };
    MKBLEBase_main_safe(^{
        if (successBlock) {
            successBlock(resultDic);
        }
    });
}

@end
