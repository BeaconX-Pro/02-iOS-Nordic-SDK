//
//  MKBXPCentralManager.h
//  tempasdfjasd
//
//  Created by aa on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "MKBLEBaseDataProtocol.h"
#import "MKBXPOperationIDDefines.h"

extern NSString * _Nonnull const MKBXPReceiveThreeAxisAccelerometerDataNotification;
extern NSString * _Nonnull const MKBXPReceiveHTDataNotification;
extern NSString * _Nonnull const MKBXPReceiveRecordHTDataNotification;

@class CBCentralManager,CBPeripheral;
@class MKBXPBaseBeacon;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXPConnectStatus) {
    MKBXPConnectStatusUnknow,
    MKBXPConnectStatusConnecting,
    MKBXPConnectStatusConnected,
    MKBXPConnectStatusConnectedFailed,
    MKBXPConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, MKBXPCentralManagerState) {
    MKBXPCentralManagerStateUnable,
    MKBXPCentralManagerStateEnable,
};

typedef NS_ENUM(NSInteger, MKBXPLockState) {
    MKBXPLockStateUnknow,
    MKBXPLockStateLock,
    MKBXPLockStateOpen,
    MKBXPLockStateUnlockAutoMaticRelockDisabled,
};

@protocol MKBXPScanDelegate <NSObject>

- (void)bxp_didReceiveBeacon:(NSArray <MKBXPBaseBeacon *>*)beaconList;

@optional
- (void)bxp_centralManagerStartScan;
- (void)bxp_centralManagerStopScan;

@end

@protocol MKBXPCentralManagerDelegate <NSObject>

- (void)bxp_centralStateChanged:(MKBXPCentralManagerState)managerState;

- (void)bxp_peripheralConnectStateChanged:(MKBXPConnectStatus)connectState;

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState;

@end

@interface MKBXPCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, assign, readonly)MKBXPConnectStatus connectState;

@property (nonatomic, assign, readonly)MKBXPLockState lockState;

/**
 scan delegate
 */
@property (nonatomic, weak)id <MKBXPScanDelegate>scanDelegate;
/**
 state delegate of central and peripheral
 */
@property (nonatomic, weak)id <MKBXPCentralManagerDelegate>stateDelegate;

+ (MKBXPCentralManager *)shared;

+ (void)attempDealloc;

- (void)startScanPeripheral;
- (void)stopScanPeripheral;

- (nonnull CBCentralManager *)centralManager;

- (nonnull CBPeripheral *)peripheral;

- (MKBXPCentralManagerState)managerState;

/**
 Interface of connection
 
 @param peripheral peripheral
 @param password password,ascii
 @param progressBlock progress callback
 @param sucBlock Connection succeed callback
 @param failedBlock Connection failed callback
 */
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 password:(nonnull NSString *)password
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Gets the current lockstate of the device，00(locked)、02(UnlockAutoMaticRelockDisabled)
 
 @param peripheral peripheral
 @param sucBlock read success callback
 @param failedBlock read failed callback
 */
- (void)readLockStateWithPeripheral:(nonnull CBPeripheral *)peripheral
                           sucBlock:(void (^)(NSString *lockState))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Interface of connection, if lockstate is 02, no password connection is required, otherwise an error will be reported.
 
 @param peripheral peripheral
 @param progressBlock progress callback
 @param sucBlock Connection succeed callback
 @param failedBlock Connection failed callback
 */
- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 disconnect
 */
- (void)disconnect;
/**
 Add a design task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param commandData Communication data
 @param characteristic characteristic
 @param successBlock Communication succeed callback
 @param failureBlock Communication failed callback
 */
- (void)addTaskWithTaskID:(MKBXPOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock;
/**
 Add a reading task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param characteristic characteristic
 @param successBlock Communication succeed callback
 @param failureBlock Communication failed callback
 */
- (void)addReadTaskWithTaskID:(MKBXPOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Whether to monitor 3-axis accelerometer sensor data

 @param notify BOOL
 @return result
 */
- (BOOL)notifyThreeAxisAcceleration:(BOOL)notify;

/**
 Whether to monitor temperature and humidity sensor data

 @param notify BOOL
 @return result
 */
- (BOOL)notifyTHData:(BOOL)notify;

/**
 Whether to monitor the stored temperature and humidity

 @param notify BOOL
 @return result
 */
- (BOOL)notifyRecordTHData:(BOOL)notify;

@end

NS_ASSUME_NONNULL_END
