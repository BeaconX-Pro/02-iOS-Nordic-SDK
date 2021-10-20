//
//  MTConnectionHandler.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 5/12/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Version) {
    VersionUndefined = 0,
    VersionBase,   // version base
    Version0_9_8,   // 0.9.8 user password support, device info support
    Version0_9_9,   // 0.9.9 remote shut down support.
    Version2_0_0,   // 2.0.0 Trigger support.
    Version2_2_60,   // 2.2.60  Trigger broadcast settings support.
    Version2_3_12,   // 2.3.12  
    Version2_4_01,   // 2.4.01  Add SixAxis/Magnetometer/AtmosphericPressure.
    VersionMax = 1000,
};

typedef NS_ENUM(NSUInteger, Connectable) {
    ConnectableNone = 0,
    ConnectableYes,    // device can be connected.
    ConnectableNo,     // device can't be connected.
};

typedef NS_ENUM(NSUInteger, PasswordStatus) {
    PasswordStatusUndefined = 0,
    PasswordStatusNone,   // doesn't require password when connect to this device.
    PasswordStatusRequire, // require password when connect to this device.
};

typedef NS_ENUM(NSUInteger, EndStatus) {
    EndStatusUndefined = 0,
    EndStatusNone,    // have none sensor data
    EndStatusSuccess,  // sensor data sync successfully
    EndStatusError     // sensor data sync error.
};

typedef NS_ENUM(NSInteger, ConnectionStatus) {
    StatusConnectFailed = -2,
    StatusDisconnected = -1,
    StatusUndifined = 0,
    StatusConnecting,
    StatusConnected,
    StatusReadingInfo,
    StatusDeviceValidating,
    StatusPasswordValidating,
    StatusSycingTime,
    StatusReadingConnectable,
    StatusReadingFeature,
    StatusReadingFrames,
    StatusReadingTriggers,
    StatusReadingSensorInfo,
    StatusCompleted,
};

@class MTConnectionHandler;

@protocol ConnectionDelegate <NSObject>

//return current connectionHandler object
- (MTConnectionHandler *)returnConnection;

@end

@class MTConnectionFeature, MinewFrame, MTTriggerData, MTSensorHandler, MTLineBeaconData, MTSlotHandler;

typedef void(^MTTriggerWroteBlock)(BOOL);

typedef void(^MTPasswordBlock)(NSString *password);

typedef void(^MTPasswordRequireBlock)(MTPasswordBlock);

typedef void(^MTStatusChangeBlock)(ConnectionStatus status, NSError *error);

typedef void(^MTCOperationBlock)(BOOL success, NSError *error);

typedef void(^MTLineBeaconOperatBlock)(MTLineBeaconData *sd);


@interface MTConnectionHandler : NSObject

// current connecting status
@property (nonatomic, assign, readonly) ConnectionStatus status;

// macString of device
@property (nonatomic, strong) NSString *macString;

// manufacture info
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *infoDict;

// every frame for each slot
@property (nonatomic, strong, readonly) NSArray<MinewFrame *> *allFrames;

// every trigger for each slot.
@property (nonatomic, strong, readonly) NSArray<MTTriggerData *> *triggers;

// firmware version of current device
@property (nonatomic, assign, readonly) Version version;

// feature of device
@property (nonatomic, strong, readonly) MTConnectionFeature *feature;

// current connectable of this device
@property (nonatomic, assign, readonly) Connectable connectable;

// listen device connection status changes
@property (nonatomic, copy) MTStatusChangeBlock statusChangedHandler;

// connecting required password or not
@property (nonatomic, assign, readonly) PasswordStatus passwordStatus;

//sensorHandler of device
@property (nonatomic, strong, readonly) MTSensorHandler *sensorHandler;

//beaconHandler of device
@property (nonatomic, strong, readonly) MTSlotHandler *slotHandler;


/**
 write triggerData to device

 @param trigger a triggerData instance
 @param handler call back wrote success or not.
 */
- (void)writeTrigger:(MTTriggerData *)trigger completion:(MTTriggerWroteBlock)handler;


/**
 write frameData to device, every frame has a slotNumber, be careful about the slot wanted to change.

 @param frame a frame instance
 @param handler call back wrote success or not.
 */
- (void)writeFrame:(MinewFrame *)frame completion:(MTCOperationBlock)handler;


/**
 reset this device to default settings.

 @param completionHandler call back result
 */
- (void)resetFactorySettings:(MTCOperationBlock)completionHandler;


/**
 set connectable of this device, if connectableYes, this device can be connect,
 
 * Danger!!!! set able to No must make sure there is a button on the device.
 
 @param able connectableYes or ConnectableNo
 @param handler call back set connectable successfully or not
 */
- (void)updateConnectable:(Connectable)able completion:(MTCOperationBlock)handler;

/**
 change connection password, please note the length of password string must be 8 !!!!!!!

 @param password  password wanted to set, length must be 8.
 @param handler set password successfully or not.
 */
- (void)modifyPassword:(NSString *)password completion:(MTCOperationBlock)handler;


/**
 remove connection password.

 @param completionHandler callback remove password successfully or not.
 */
- (void)removePassword:(MTCOperationBlock)completionHandler;

// /* Danger !!!*/shut down the device,if the Model Number String is Beacon Plus-BL,not work
- (void)poweroff:(MTCOperationBlock)completionHandler;



@end
