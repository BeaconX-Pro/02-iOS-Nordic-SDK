//
//  MKBXPCentralManager.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKBXPPeripheral.h"
#import "MKBXPOperation.h"
#import "MKBXPTaskAdopter.h"
#import "MKBXPAdopter.h"
#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPBaseBeacon.h"
#import "MKBXPService.h"

NSString *const mk_bxp_receiveThreeAxisAccelerometerDataNotification = @"mk_bxp_receiveThreeAxisAccelerometerDataNotification";
NSString *const mk_bxp_receiveHTDataNotification = @"mk_bxp_receiveHTDataNotification";
NSString *const mk_bxp_receiveRecordHTDataNotification = @"mk_bxp_receiveRecordHTDataNotification";
NSString *const mk_bxp_deviceDisconnectTypeNotification = @"mk_bxp_deviceDisconnectTypeNotification";
NSString *const mk_bxp_peripheralConnectStateChangedNotification = @"mk_bxp_peripheralConnectStateChangedNotification";
NSString *const mk_bxp_centralManagerStateChangedNotification = @"mk_bxp_centralManagerStateChangedNotification";
NSString *const mk_bxp_peripheralLockStateChangedNotification = @"mk_bxp_peripheralLockStateChangedNotification";
NSString *const mk_bxp_receiveLightSensorDataNotification = @"mk_bxp_receiveLightSensorDataNotification";
NSString *const mk_bxp_receiveLightSensorStatusDataNotification = @"mk_bxp_receiveLightSensorStatusDataNotification";


static MKBXPCentralManager *manager = nil;
static dispatch_once_t onceToken;

@interface NSObject (MKBXPCentralManager)

@end

@implementation NSObject (MKBXPCentralManager)

+ (void)load{
    [MKBXPCentralManager shared];
}

@end

@interface MKBXPCentralManager ()

@property (nonatomic, assign)mk_bxp_centralConnectStatus connectState;

@property (nonatomic, assign)mk_bxp_lockState lockState;

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

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
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
            beaconModel.connectEnable = [advertisementData[CBAdvertisementDataIsConnectable] boolValue];
        }
        if ([self.delegate respondsToSelector:@selector(mk_bxp_receiveBeacon:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate mk_bxp_receiveBeacon:beaconList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxp_startScan)]) {
        [self.delegate mk_bxp_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxp_stopScan)]) {
        [self.delegate mk_bxp_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    if (self.readingLockState) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectState = mk_bxp_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectState = mk_bxp_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectState = mk_bxp_centralConnectStatusDisconnect;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectState = mk_bxp_centralConnectStatusConnectedFailed;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_disconnectListenUUID]]) {
        //设备断开原因
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        MKBLEBase_main_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_deviceDisconnectTypeNotification
                                                                object:nil
                                                              userInfo:@{@"type":content}];
        });
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_notifyUUID]]) {
        //判断是否是lockState改变通知
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (content.length > 6 && [[content substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"eb63"]) {
            NSString *state = [content substringFromIndex:(content.length - 2)];
            mk_bxp_lockState lockState = mk_bxp_lockStateUnknow;
            if ([state isEqualToString:@"00"]) {
                //锁定状态
                lockState = mk_bxp_lockStateLock;
            }else if ([state isEqualToString:@"01"]){
                lockState = mk_bxp_lockStateOpen;
            }else if ([state isEqualToString:@"02"]){
                lockState = mk_bxp_lockStateUnlockAutoMaticRelockDisabled;
            }
            [self updateLockState:lockState];
            return;
        }
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_threeSensorUUID]]) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_receiveThreeAxisAccelerometerDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"axisData":dataList}];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_temperatureHumidityUUID]]) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_receiveHTDataNotification
                                                                    object:nil
                                                                  userInfo:htData];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_recordTHUUID]]) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_receiveRecordHTDataNotification
                                                                    object:nil
                                                                  userInfo:@{@"dataList":dataList}];
            });
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lightSensorUUID]]) {
        //光感数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        if (content.length == 14) {
            NSString *date = [MKBXPAdopter deviceTime:[content substringWithRange:NSMakeRange(0, 12)]];
            NSString *state = [content substringWithRange:NSMakeRange(12, 2)];
            NSDictionary *lightData = @{
                @"date":date,
                @"state":state,
            };
            MKBLEBase_main_safe(^{
                [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_receiveLightSensorDataNotification
                                                                    object:nil
                                                                  userInfo:lightData];
            });
            return;
        }
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lightStatusUUID]]) {
        //光感状态数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        MKBLEBase_main_safe(^{
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_receiveLightSensorStatusDataNotification
                                                                object:nil
                                                              userInfo:@{@"status":content}];
        });
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
    
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_bxp_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_bxp_centralManagerStatusEnable
    : mk_bxp_centralManagerStatusUnable;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                                       [CBUUID UUIDWithString:@"FEAB"]]
                                                             options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
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
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (sucBlock) {
            MKBLEBase_main_safe(^{sucBlock(lockState);});
        }
    };
    MKBXPPeripheral *bxpPeripheral = [[MKBXPPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxpPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self sendPasswordToDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
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
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bxp_taskOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    MKBXPOperation *operation = [self generateOperationWithOperationID:operationID
                                                           commandData:commandData
                                                        characteristic:characteristic
                                                              sucBlock:sucBlock
                                                           failedBlock:failedBlock];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_bxp_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    MKBXPOperation *operation = [self generateReadOperationWithID:operationID
                                                   characteristic:characteristic
                                                         sucBlock:sucBlock
                                                      failedBlock:failedBlock];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (BOOL)notifyThreeAxisAcceleration:(BOOL)notify {
    if (self.connectState != mk_bxp_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxp_threeSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxp_threeSensor];
    return YES;
}

- (BOOL)notifyTHData:(BOOL)notify {
    if (self.connectState != mk_bxp_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxp_temperatureHumidity == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxp_temperatureHumidity];
    return YES;
}

- (BOOL)notifyRecordTHData:(BOOL)notify {
    if (self.connectState != mk_bxp_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxp_recordTH == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxp_recordTH];
    return YES;
}

- (BOOL)notifyLightSensorData:(BOOL)notify {
    if (self.connectState != mk_bxp_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxp_lightSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxp_lightSensor];
    return YES;
}

- (BOOL)notifyLightStatusData:(BOOL)notify {
    if (self.connectState != mk_bxp_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxp_lightStatus == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxp_lightStatus];
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
        mk_bxp_lockState lockState = [self fetchLockState];
        if (self.readingLockState) {
            //读取lockState操作，不需要进行后续步骤
            //读取完数据之后断开连接
            [[MKBLEBaseCentralManager shared] disconnect];
            self.readingLockState = NO;
            if (self.readLockStateBlock) {
                NSString *lockInfo = @"00";
                if (lockState == mk_bxp_lockStateUnlockAutoMaticRelockDisabled) {
                    lockInfo = @"02";
                }
                MKBLEBase_main_safe(^{
                    self.readLockStateBlock(lockInfo);
                });
            }
            return ;
        }
        [self updateLockState:lockState];
        [self updateConnectProgress:50.f];
        if (lockState == mk_bxp_lockStateUnknow) {
            [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.failedBlock];
            self.readingLockState = NO;
            return;
        }
        if (lockState == mk_bxp_lockStateLock) {
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
            mk_bxp_lockState newLockState = [self fetchLockState];
            [self updateLockState:newLockState];
            [self updateConnectProgress:100.f];
            if (newLockState == mk_bxp_lockStateUnknow || newLockState == mk_bxp_lockStateLock) {
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
        self.connectState = mk_bxp_centralConnectStatusConnected;
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_peripheralConnectStateChangedNotification
                                                            object:nil];
        
        if (self.sucBlock) {
            self.sucBlock([MKBLEBaseCentralManager shared].peripheral);
        }
    });
}

- (mk_bxp_lockState)fetchLockState{
    __block mk_bxp_lockState lockState = mk_bxp_lockStateUnknow;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    MKBXPOperation *operation = [[MKBXPOperation alloc] initOperationWithID:mk_bxp_taskReadLockStateOperation commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral readValueForCharacteristic:sself.peripheral.bxp_lockState];
    } completeBlock:^(NSError *error, id returnData) {
        if (!error) {
            NSString *state = returnData[@"lockState"];
            if ([state isEqualToString:@"00"]) {
                //锁定状态
                lockState = mk_bxp_lockStateLock;
            }else if ([state isEqualToString:@"01"]){
                lockState = mk_bxp_lockStateOpen;
            }else if ([state isEqualToString:@"02"]){
                lockState = mk_bxp_lockStateUnlockAutoMaticRelockDisabled;
            }else{
                lockState = mk_bxp_lockStateUnknow;
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
    MKBXPOperation *operation = [[MKBXPOperation alloc] initOperationWithID:mk_bxp_taskReadUnlockOperation commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral readValueForCharacteristic:sself.peripheral.bxp_unlock];
    } completeBlock:^(NSError *error, id returnData) {
        if (!error) {
            RAND_DATA_ARRAY = returnData[@"RAND_DATA_ARRAY"];
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
    if (!self.peripheral || !self.peripheral.bxp_unlock) {
        return NO;
    }
    __block BOOL success = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    MKBXPOperation *operation = [[MKBXPOperation alloc] initOperationWithID:mk_bxp_taskConfigUnlockOperation commandBlock:^{
        __strong typeof(self) sself = weakSelf;
        [sself.peripheral writeValue:keyData forCharacteristic:sself.peripheral.bxp_unlock type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, id returnData) {
        if (!error) {
            success = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - communication method
- (MKBXPOperation *)generateOperationWithOperationID:(mk_bxp_taskOperationID)operationID
                                         commandData:(NSString *)commandData
                                      characteristic:(CBCharacteristic *)characteristic
                                            sucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failedBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"Input parameter error" failedBlock:failedBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failedBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPOperation *operation = [[MKBXPOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError *error, id returnData) {
        __strong typeof(self) sself = weakSelf;
        [sself parseTaskResult:error returnData:returnData sucBlock:sucBlock failedBlock:failedBlock];
    }];
    return operation;
}

- (MKBXPOperation *)generateReadOperationWithID:(mk_bxp_taskOperationID)operationID
                                 characteristic:(CBCharacteristic *)characteristic
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failedBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failedBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXPOperation *operation = [[MKBXPOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError *error, id returnData) {
        __strong typeof(self) sself = weakSelf;
        [sself parseTaskResult:error returnData:returnData sucBlock:sucBlock failedBlock:failedBlock];
    }];
    return operation;
}

- (void)parseTaskResult:(NSError *)error
             returnData:(id)returnData
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (error) {
        MKBLEBase_main_safe(^{
            if (failedBlock) {
                failedBlock(error);
            }
        });
        return ;
    }
    if (!returnData) {
        [self operationFailedBlockWithMsg:@"Request data error" failedBlock:failedBlock];
        return ;
    }
    NSDictionary *resultDic = @{@"msg":@"success",
                                @"code":@"1",
                                @"result":returnData,
                                };
    MKBLEBase_main_safe(^{
        if (sucBlock) {
            sucBlock(resultDic);
        }
    });
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
    MKBXPPeripheral *bxpPeripheral = [[MKBXPPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxpPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self updateConnectProgress:30.f];
        [self sendPasswordToDevice];
    } failedBlock:failedBlock];
}

- (void)updateLockState:(mk_bxp_lockState)lockState {
    self.lockState = lockState;
    MKBLEBase_main_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxp_peripheralLockStateChangedNotification
                                                            object:nil
                                                          userInfo:@{}];
    });
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

@end
