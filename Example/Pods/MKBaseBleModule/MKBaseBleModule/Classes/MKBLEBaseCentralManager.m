//
//  MKBLEBaseCentralManager.m
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import "MKBLEBaseCentralManager.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

NSString *const MKPeripheralConnectStateChangedNotification = @"MKPeripheralConnectStateChangedNotification";
NSString *const MKCentralManagerStateChangedNotification = @"MKCentralManagerStateChangedNotification";

static MKBLEBaseCentralManager *manager = nil;
static dispatch_once_t onceToken;

static NSTimeInterval const defaultConnectTime = 20.f;

@interface NSObject (MKBLECentralManager)

@end

@implementation NSObject (MKBLECentralManager)

+ (void)load{
    [MKBLEBaseCentralManager shared];
}

@end

@interface MKBLEBaseCentralManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager *centralManager;

@property (nonatomic, strong)id <MKBLEBasePeripheralProtocol>peripheralManager;

@property (nonatomic, strong)NSMutableArray <id <MKBLEBaseCentralManagerProtocol>> *managerList;

@property (nonatomic, strong)dispatch_queue_t centralManagerQueue;

@property (nonatomic, assign)MKPeripheralConnectState connectStatus;

@property (nonatomic, assign)MKCentralManagerState centralStatus;

@property (nonatomic, assign)mk_currentAction managerAction;

@property (nonatomic, strong)dispatch_source_t connectTimer;

@property (nonatomic, copy)MKBLEConnectFailedBlock connectFailBlock;

@property (nonatomic, copy)MKBLEConnectSuccessBlock connectSucBlock;

@property (nonatomic, assign)BOOL connectTimeout;

@property (nonatomic, assign)BOOL isConnecting;

@property (nonatomic, strong)NSOperationQueue *operationQueue;

@end

@implementation MKBLEBaseCentralManager

#pragma mark - life circle

- (instancetype)init {
    if (self = [super init]) {
        _centralManagerQueue = dispatch_queue_create("moko.com.centralManager", DISPATCH_QUEUE_SERIAL);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_centralManagerQueue];
    }
    return self;
}

+ (MKBLEBaseCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[MKBLEBaseCentralManager alloc] init];
        }
    });
    return manager;
}

+ (void)singleDealloc {
    onceToken = 0;
    manager = nil;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self updateCentralManagerState];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([RSSI integerValue] == 127 || self.managerList.count == 0) {
        return;
    }
    MKBLEBase_main_safe(^{
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol> protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(MKBLEBaseCentralManagerDiscoverPeripheral:advertisementData:RSSI:)]) {
                    [protocol MKBLEBaseCentralManagerDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
                }
            }
        }
    });
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_managerActionConnecting) {
        return;
    }
    peripheral.delegate = self;
    [self.peripheralManager setNil];
    [self.peripheralManager discoverServices];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self connectPeripheralFailed];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"---------->The peripheral is disconnect");
    if (self.connectStatus != MKPeripheralConnectStateConnected) {
        //连接过程中的断开不处理
        return;
    }
    [self.operationQueue cancelAllOperations];
    [self.peripheralManager setNil];
    self.peripheralManager = nil;
    [self updatePeripheralConnectState:MKPeripheralConnectStateDisconnect];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_managerActionConnecting) {
        return;
    }
    if (error) {
        [self connectPeripheralFailed];
        return;
    }
    [self.peripheralManager setNil];
    [self.peripheralManager discoverCharacteristics];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (self.connectTimeout || !self.peripheralManager || self.managerAction != mk_managerActionConnecting) {
        return;
    }
    if (error) {
        [self connectPeripheralFailed];
        return;
    }
    [self.peripheralManager updateCharacterWithService:service];
    if ([self.peripheralManager connectSuccess]) {
        [self connectPeripheralSuccess];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error || self.connectTimeout || !self.peripheralManager || self.managerAction != mk_managerActionConnecting) {
        return;
    }
    [self.peripheralManager updateCurrentNotifySuccess:characteristic];
    if ([self.peripheralManager connectSuccess]) {
        [self connectPeripheralSuccess];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    MKBLEBase_main_safe(^{
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(peripheral:didUpdateValueForCharacteristic:error:)]) {
                    [protocol peripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
                }
            }
        }
    });
    if (error) {
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKBLEBaseOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didUpdateValueForCharacteristic:characteristic];
                break;
            }
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    MKBLEBase_main_safe(^{
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(peripheral:didWriteValueForCharacteristic:error:)]) {
                    [protocol peripheral:peripheral didWriteValueForCharacteristic:characteristic error:error];
                }
            }
        }
    });
    if (error) {
        return;
    }
    @synchronized(self.operationQueue) {
        NSArray *operations = [self.operationQueue.operations copy];
        for (NSOperation <MKBLEBaseOperationProtocol>*operation in operations) {
            if (operation.executing) {
                [operation peripheral:peripheral didWriteValueForCharacteristic:characteristic];
                break;
            }
        }
    }
}

#pragma mark - public method
- (CBPeripheral *)peripheral {
    return self.peripheralManager.peripheral;
}

- (void)loadDataManager:(id<MKBLEBaseCentralManagerProtocol>)dataManager {
    @synchronized (self.managerList) {
        if (dataManager
            && [dataManager conformsToProtocol:@protocol(MKBLEBaseCentralManagerProtocol)]
            && ![self.managerList containsObject:dataManager]) {
            [self.managerList addObject:dataManager];
        }
    }
}

- (BOOL)removeDataManager:(nonnull id <MKBLEBaseCentralManagerProtocol>)dataManager {
    @synchronized (self.managerList) {
        if (!dataManager ||
            ![dataManager conformsToProtocol:@protocol(MKBLEBaseCentralManagerProtocol)] ||
            ![self.managerList containsObject:dataManager]) {
            return NO;
        }
        [self.managerList removeObject:dataManager];
        return YES;
    }
}

- (BOOL)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)services options:(NSDictionary<NSString *,id> *)options {
    if (self.centralManager.state != CBManagerStatePoweredOn) {
        //当前蓝牙状态不可用
        return NO;
    }
    if (self.managerAction == mk_managerActionScan) {
        //处于扫描状态
        [self.centralManager stopScan];
    }else if (self.managerAction == mk_managerActionConnecting) {
        //处于连接状态
        [self connectPeripheralFailed];
    }
    self.managerAction = mk_managerActionScan;
    MKBLEBase_main_safe(^{
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(MKBLEBaseCentralManagerStartScan)]) {
                    [protocol MKBLEBaseCentralManagerStartScan];
                }
            }
        }
    });
    [self.centralManager scanForPeripheralsWithServices:services options:options];
    return YES;
}

- (BOOL)stopScan {
    if (self.managerAction == mk_managerActionScan) {
        [self.centralManager stopScan];
    }else if (self.managerAction == mk_managerActionConnecting) {
        [self connectPeripheralFailed];
    }
    self.managerAction = mk_managerActionDefault;
    MKBLEBase_main_safe(^{
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(MKBLEBaseCentralManagerStopScan)]) {
                    [protocol MKBLEBaseCentralManagerStopScan];
                }
            }
        }
    });
    return YES;
}

- (void)connectDevice:(id <MKBLEBasePeripheralProtocol>)peripheralProtocol
             sucBlock:(MKBLEConnectSuccessBlock)sucBlock
          failedBlock:(MKBLEConnectFailedBlock)failedBlock {
    if (!peripheralProtocol || !peripheralProtocol.peripheral || ![peripheralProtocol conformsToProtocol:@protocol(MKBLEBasePeripheralProtocol)]) {
        [MKBLEBaseSDKAdopter operationProtocolErrorBlock:failedBlock];
        return;
    }
    if (self.centralManager.state != CBManagerStatePoweredOn) {
        //蓝牙状态不可用
        [MKBLEBaseSDKAdopter operationCentralBlePowerOffBlock:failedBlock];
        return;
    }
    if (self.isConnecting) {
        [MKBLEBaseSDKAdopter operationConnectingErrorBlock:failedBlock];
        return;
    }
    [self.operationQueue cancelAllOperations];
    self.isConnecting = YES;
    __weak typeof(self) weakSelf = self;
    [self connectWithProtocol:peripheralProtocol sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        __strong typeof(self) sself = weakSelf;
        [sself clearConnectBlock];
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearConnectBlock];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}
- (void)disconnect {
    if (self.centralManager.state != CBManagerStatePoweredOn || !self.peripheralManager || !self.peripheralManager.peripheral) {
        return;
    }
    [self.operationQueue cancelAllOperations];
    [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
    self.peripheralManager = nil;
    self.isConnecting = NO;
}

- (BOOL)sendDataToPeripheral:(NSString *)data
              characteristic:(CBCharacteristic *)characteristic
                        type:(CBCharacteristicWriteType)type {
    if (!self.peripheralManager
        || !self.peripheralManager.peripheral
        || !MKValidStr(data)
        || !characteristic
        || self.peripheralManager.peripheral.state != CBPeripheralStateConnected) {
        return NO;
    }
    NSData *commandData = [MKBLEBaseSDKAdopter stringToData:data];
    if (!MKValidData(commandData)) {
        return NO;
    }
    [self.peripheralManager.peripheral writeValue:commandData forCharacteristic:characteristic type:type];
    return YES;
}

- (BOOL)readyToCommunication{
    if (!self.peripheralManager || !self.peripheralManager.peripheral) {
        return NO;
    }
    return (self.connectStatus == MKPeripheralConnectStateConnected);
}

- (BOOL)addOperation:(NSOperation<MKBLEBaseOperationProtocol> *)operation {
    if (!operation
        || ![operation isKindOfClass:NSOperation.class]
        || ![operation conformsToProtocol:@protocol(MKBLEBaseOperationProtocol)]) {
        return NO;
    }
    @synchronized (self.operationQueue.operations) {
        if (![self.operationQueue.operations containsObject:operation]) {
            [self.operationQueue addOperation:operation];
        }
    }
    return YES;
}

- (BOOL)removeOperation:(nonnull NSOperation <MKBLEBaseOperationProtocol>*)operation {
    if (!operation
        || ![operation isKindOfClass:NSOperation.class]
        || ![operation conformsToProtocol:@protocol(MKBLEBaseOperationProtocol)]) {
        return NO;
    }
    @synchronized (self.operationQueue.operations) {
        if ([self.operationQueue.operations containsObject:operation]) {
            [operation cancel];
        }
    }
    return YES;
}
 
#pragma mark - private method
- (void)updateCentralManagerState {
    MKCentralManagerState managerState = (self.centralManager.state == CBManagerStatePoweredOn ? MKCentralManagerStateEnable : MKCentralManagerStateUnable);
    self.centralStatus = managerState;
    MKBLEBase_main_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MKCentralManagerStateChangedNotification object:nil];
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(MKBLEBaseCentralManagerStateChanged:)]) {
                    [protocol MKBLEBaseCentralManagerStateChanged:managerState];
                }
            }
        }
    });
    if (self.centralManager.state == CBManagerStatePoweredOn) {
        return;
    }
    switch (self.managerAction) {
        case mk_managerActionDefault:
            {
                if (self.connectStatus == MKPeripheralConnectStateConnected) {
                    [self updatePeripheralConnectState:MKPeripheralConnectStateDisconnect];
                }
                if (self.peripheralManager) {
                    [self.peripheralManager setNil];
                    self.peripheralManager = nil;
                }
            }
            break;
        case mk_managerActionScan:
            {
                [self stopScan];
            }
            break;
        case mk_managerActionConnecting:
            {
                [self connectPeripheralFailed];
            }
            break;
        default:
            break;
    }
}

#pragma mark - connect private method
- (void)connectWithProtocol:(id <MKBLEBasePeripheralProtocol>)peripheralProtocol
                        sucBlock:(MKBLEConnectSuccessBlock)sucBlock
                    failedBlock:(MKBLEConnectFailedBlock)failedBlock{
    if (self.peripheralManager) {
        if (self.peripheralManager.peripheral) {
            [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
        }
        [self.peripheralManager setNil];
        self.peripheralManager = nil;
    }
    
    self.peripheralManager = peripheralProtocol;
    self.managerAction = mk_managerActionConnecting;
    self.connectSucBlock = nil;
    self.connectSucBlock = sucBlock;
    self.connectFailBlock = nil;
    self.connectFailBlock = failedBlock;
    [self centralConnectPeripheral:peripheralProtocol.peripheral];
}

- (void)centralConnectPeripheral:(CBPeripheral *)peripheral{
    if (!peripheral) {
        return;
    }
    [self.centralManager stopScan];
    [self updatePeripheralConnectState:MKPeripheralConnectStateConnecting];
    [self initConnectTimer];
    [self.centralManager connectPeripheral:peripheral options:@{}];
}

- (void)initConnectTimer{
    self.connectTimeout = NO;
    self.connectTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,_centralManagerQueue);
    dispatch_source_set_timer(self.connectTimer, dispatch_time(DISPATCH_TIME_NOW, defaultConnectTime * NSEC_PER_SEC),  defaultConnectTime * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.connectTimer, ^{
        __strong typeof(self) sself = weakSelf;
        sself.connectTimeout = YES;
        [sself connectPeripheralFailed];
    });
    dispatch_resume(self.connectTimer);
}

- (void)resetOriSettings{
    if (self.connectTimer) {
        dispatch_cancel(self.connectTimer);
    }
    self.managerAction = mk_managerActionDefault;
    self.connectTimeout = NO;
    self.isConnecting = NO;
}

- (void)connectPeripheralFailed{
    [self resetOriSettings];
    if (self.peripheralManager) {
        if (self.peripheralManager.peripheral) {
            [self.centralManager cancelPeripheralConnection:self.peripheralManager.peripheral];
        }
        [self.peripheralManager setNil];
        self.peripheralManager = nil;
    }
    [self updatePeripheralConnectState:MKPeripheralConnectStateConnectedFailed];
    [MKBLEBaseSDKAdopter operationConnectFailedBlock:self.connectFailBlock];
}

- (void)connectPeripheralSuccess{
    if (self.connectTimeout || !self.peripheralManager) {
        return;
    }
    [self resetOriSettings];
    [self updatePeripheralConnectState:MKPeripheralConnectStateConnected];
    MKBLEBase_main_safe(^{
        if (self.connectSucBlock) {
            self.connectSucBlock(self.peripheralManager.peripheral);
        }
    });
}

- (void)updatePeripheralConnectState:(MKPeripheralConnectState)state {
    self.connectStatus = state;
    MKBLEBase_main_safe(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralConnectStateChangedNotification object:nil];
        @synchronized (self.managerList) {
            for (id <MKBLEBaseCentralManagerProtocol>protocol in self.managerList) {
                if ([protocol respondsToSelector:@selector(MKBLEBasePeripheralConnectStateChanged:)]) {
                    [protocol MKBLEBasePeripheralConnectStateChanged:state];
                }
            }
        }
    });
}

- (void)clearConnectBlock{
    if (self.connectSucBlock) {
        self.connectSucBlock = nil;
    }
    if (self.connectFailBlock) {
        self.connectFailBlock = nil;
    }
}

#pragma mark - getter
- (NSMutableArray<id<MKBLEBaseCentralManagerProtocol>> *)managerList {
    if (!_managerList) {
        _managerList = [NSMutableArray array];
    }
    return _managerList;
}

- (NSOperationQueue *)operationQueue{
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return _operationQueue;
}

@end
