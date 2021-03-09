//
//  MKBLEBaseCentralManager.h
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_currentAction) {
    mk_managerActionDefault,
    mk_managerActionScan,
    mk_managerActionConnecting,
};

///  当前外设连接状态发生改变通知
extern NSString *const MKPeripheralConnectStateChangedNotification;
///  当前蓝牙中心状态发生改变通知
extern NSString *const MKCentralManagerStateChangedNotification;

/// 连接外设失败block
typedef void(^MKBLEConnectFailedBlock)(NSError *error);
///  连接外设成功block
typedef void(^MKBLEConnectSuccessBlock)(CBPeripheral *peripheral);

@interface MKBLEBaseCentralManager : NSObject

/// 当前中心
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;

/// 当前管理的MKBLECentralManagerProtocol列表
@property (nonatomic, strong, readonly)NSMutableArray <id <MKBLEBaseCentralManagerProtocol>> *managerList;

/// 当前外设连接状态
@property (nonatomic, assign, readonly)MKPeripheralConnectState connectStatus;

/// 当前蓝牙中心状态
@property (nonatomic, assign, readonly)MKCentralManagerState centralStatus;

/// 当前manager处于什么状态，默认、连接、和扫描
@property (nonatomic, assign, readonly)mk_currentAction managerAction;

+ (MKBLEBaseCentralManager *)shared;

/// 销毁单例
+ (void)singleDealloc;

/// 当前连接的外设
- (nullable CBPeripheral *)peripheral;

/// 将一个满足MKBLECentralManagerProtocol的对象加入到管理列表
/// @param dataManager MKBLECentralManagerProtocol
- (void)loadDataManager:(nonnull id <MKBLEBaseCentralManagerProtocol>)dataManager;

/// 将满足MKBLECentralManagerProtocol的对象移除管理列表
/// @param dataManager MKBLECentralManagerProtocol的对象
- (BOOL)removeDataManager:(nonnull id <MKBLEBaseCentralManagerProtocol>)dataManager;

#pragma mark - ************************* 扫描 **************************

/// 扫描
/// @param services A list of <code>CBUUID</code> objects representing the service(s) to scan for.
/// @param options An optional dictionary specifying options for the scan.
- (BOOL)scanForPeripheralsWithServices:(nullable NSArray<CBUUID *> *)services
                               options:(nullable NSDictionary<NSString *,id> *)options;

/// 停止扫描
- (BOOL)stopScan;

#pragma mark - ************************* 连接 **************************

/// 连接设备
/// @param peripheralProtocol MKBLEPeripheralProtocol
/// @param sucBlock Success Callback
/// @param failedBlock Failure Callback
- (void)connectDevice:(nonnull id <MKBLEBasePeripheralProtocol>)peripheralProtocol
             sucBlock:(nullable MKBLEConnectSuccessBlock)sucBlock
          failedBlock:(nullable MKBLEConnectFailedBlock)failedBlock;

/// 断开当前连接的外设
- (void)disconnect;

#pragma mark - ************************* 数据交互 **************************

/// 给当前连接的外设发送数据
/// @param data Data
/// @param characteristic characteristic
/// @param type Specifies which type of write is to be performed on a CBCharacteristic.
- (BOOL)sendDataToPeripheral:(nonnull NSString *)data
              characteristic:(nonnull CBCharacteristic *)characteristic
                        type:(CBCharacteristicWriteType)type;

/// 当前设备是否可以通信
- (BOOL)readyToCommunication;

/// 添加一个operation到当前数据队列
/// @param operation operation
- (BOOL)addOperation:(nonnull NSOperation <MKBLEBaseOperationProtocol>*)operation;

/// 将一个operation移出当前数据队列
/// @param operation operation
- (BOOL)removeOperation:(nonnull NSOperation <MKBLEBaseOperationProtocol>*)operation;

@end

NS_ASSUME_NONNULL_END
