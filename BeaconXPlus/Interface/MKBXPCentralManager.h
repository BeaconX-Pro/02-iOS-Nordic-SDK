//
//  MKBXPCentralManager.h
//  BeaconXPlus
//
//  Created by aa on 2019/4/18.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MKBXPEnumeration.h"
#import "MKBXPNormalDefines.h"
#import "MKBXPProtocols.h"
#import "MKBXPOperationIDDefines.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKBXPReceiveThreeAxisAccelerometerDataNotification;
extern NSString *const MKBXPReceiveHTDataNotification;
extern NSString *const MKBXPReceiveRecordHTDataNotification;

@class MKBXPTaskOperation;
@interface MKBXPCentralManager : NSObject

/**
 central
 */
@property (nonatomic, strong, readonly)CBCentralManager *centralManager;
/**
 Current connected device
 */
@property (nonatomic, strong, readonly)CBPeripheral *peripheral;
/**
 Current device’s connect state
 */
@property (nonatomic, assign, readonly)MKBXPConnectStatus connectState;
/**
 Current central's state
 */
@property (nonatomic, assign, readonly)MKBXPCentralManagerState managerState;
/**
 Current device’s LockState
 */
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
/**
 Interface of connection
 
 @param peripheral peripheral
 @param password password,ascii
 @param progressBlock progress callback
 @param sucBlock Connection succeed callback
 @param failedBlock Connection failed callback
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock;
/**
 Gets the current lockstate of the device，00(locked)、02(UnlockAutoMaticRelockDisabled)
 
 @param peripheral peripheral
 @param sucBlock read success callback
 @param failedBlock read failed callback
 */
- (void)readLockStateWithPeripheral:(CBPeripheral *)peripheral
                           sucBlock:(void (^)(NSString *lockState))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Interface of connection, if lockstate is 02, no password connection is required, otherwise an error will be reported.
 
 @param peripheral peripheral
 @param progressBlock progress callback
 @param sucBlock Connection succeed callback
 @param failedBlock Connection failed callback
 */
- (void)connectPeripheral:(CBPeripheral *)peripheral
            progressBlock:(MKConnectProgressBlock)progressBlock
                 sucBlock:(MKConnectSuccessBlock)sucBlock
              failedBlock:(MKConnectFailedBlock)failedBlock;
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
 Custom operation is added to the task queue
 
 @param operation operation
 */
- (void)addOperation:(MKBXPTaskOperation *)operation;

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
