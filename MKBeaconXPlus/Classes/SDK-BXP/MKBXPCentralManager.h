//
//  MKBXPCentralManager.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBXPOperationID.h"

NS_ASSUME_NONNULL_BEGIN

@class CBCentralManager,CBPeripheral;
@class MKBXPBaseBeacon;

extern NSString *const mk_bxp_receiveThreeAxisAccelerometerDataNotification;
extern NSString *const mk_bxp_receiveHTDataNotification;
extern NSString *const mk_bxp_receiveRecordHTDataNotification;

/*
 After connecting the device, if no password is entered within one minute, it returns 0x00. After successful password change, it returns 0x01. Factory reset of the device,it returns 0x02.
 */
extern NSString *const mk_bxp_deviceDisconnectTypeNotification;

//Notification of device connection status changes.
extern NSString *const mk_bxp_peripheralConnectStateChangedNotification;

//Notification of changes in the status of the Bluetooth Center.
extern NSString *const mk_bxp_centralManagerStateChangedNotification;

//Notification of changes in the status of the Eddystone Lock State.
extern NSString *const mk_bxp_peripheralLockStateChangedNotification;

typedef NS_ENUM(NSInteger, mk_bxp_centralManagerStatus) {
    mk_bxp_centralManagerStatusUnable,                           //不可用
    mk_bxp_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bxp_centralConnectStatus) {
    mk_bxp_centralConnectStatusUnknow,                                           //未知状态
    mk_bxp_centralConnectStatusConnecting,                                       //正在连接
    mk_bxp_centralConnectStatusConnected,                                        //连接成功
    mk_bxp_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bxp_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_bxp_lockState) {
    mk_bxp_lockStateUnknow,
    mk_bxp_lockStateLock,
    mk_bxp_lockStateOpen,
    mk_bxp_lockStateUnlockAutoMaticRelockDisabled,
};

@protocol mk_bxp_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param beaconList device
- (void)mk_bxp_receiveBeacon:(NSArray <MKBXPBaseBeacon *>*)beaconList;

@optional

/// Starts scanning equipment.
- (void)mk_bxp_startScan;

/// Stops scanning equipment.
- (void)mk_bxp_stopScan;

@end

@interface MKBXPCentralManager : NSObject<MKBLEBaseCentralManagerProtocol>

@property (nonatomic, weak)id <mk_bxp_centralManagerScanDelegate>delegate;

/// Current connection status
@property (nonatomic, assign, readonly)mk_bxp_centralConnectStatus connectState;

@property (nonatomic, assign, readonly)mk_bxp_lockState lockState;

+ (MKBXPCentralManager *)shared;

/// Destroy the MKLoRaTHCentralManager singleton and the MKBLEBaseCentralManager singleton. After the dfu upgrade, you need to destroy these two and then reinitialize.
+ (void)sharedDealloc;

/// Destroy the MKLoRaTHCentralManager singleton and remove the manager list of MKBLEBaseCentralManager.
+ (void)removeFromCentralList;

- (nonnull CBCentralManager *)centralManager;

/// Currently connected devices
- (nullable CBPeripheral *)peripheral;

/// Current Bluetooth center status
- (mk_bxp_centralManagerStatus )centralStatus;

/// Bluetooth Center starts scanning
- (void)startScan;

/// Bluetooth center stops scanning
- (void)stopScan;

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

- (void)disconnect;

/**
 Add a design task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param commandData Communication data
 @param characteristic characteristic
 @param sucBlock Communication succeed callback
 @param failedBlock Communication failed callback
 */
- (void)addTaskWithTaskID:(mk_bxp_taskOperationID)operationID
              commandData:(NSString *)commandData
           characteristic:(CBCharacteristic *)characteristic
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Add a reading task (app - > peripheral) to the queue
 
 @param operationID operationID
 @param characteristic characteristic
 @param sucBlock Communication succeed callback
 @param failedBlock Communication failed callback
 */
- (void)addReadTaskWithTaskID:(mk_bxp_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

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
