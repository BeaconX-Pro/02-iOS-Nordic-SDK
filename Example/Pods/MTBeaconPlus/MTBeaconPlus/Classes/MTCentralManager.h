//
//  MTCentralManager.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//
#import "MTConnectionHandler.h"

@class MTPeripheral, CBCentralManager;

// iphone bluetooth state, this sdk works well only in poweron state
typedef NS_ENUM(NSUInteger, PowerState) {
    PowerStateUnknown = 0,
    PowerStateResetting,
    PowerStateUnsupported,
    PowerStateUnauthorized,
    PowerStatePoweredOff,
    PowerStatePoweredOn,
};

// get scanned devices in this block
typedef void(^MTScanBlock)(NSArray<MTPeripheral *> *peripherals);

// listen state change
typedef void(^PowerStateBlock)(PowerState state);


@interface MTCentralManager : NSObject

// current iphone bluetooth state
@property (nonatomic, assign) PowerState state;

// iphone bluetooth state
@property (nonatomic, copy) PowerStateBlock stateBlock;

// if SDK scannning devices
@property (nonatomic, assign, readonly) BOOL scanning;

// current scanned devices
@property (nonatomic, strong, readonly) NSArray<MTPeripheral *> *scannedPeris;

// CB Framework shared central instance
@property (nonatomic, strong, readonly) CBCentralManager *centralManager;


/**
 get shared MTCentralManager instance

 @return MTC instance
 */
+ (instancetype)sharedInstance;


/**
  start scan devices,
  get scanned devices in handler block or "scannedPeris" property.

 @param handler listen scanned devices
 */
- (void)startScan:(MTScanBlock)handler;

// stop scanning
- (void)stopScan;


/**
  try connect to a mtperipheral instance.

 @param per MTPeripheral instance wanted to be connected
 @param handler can't be nil!!!!!! incase password required in connection stage.
 */
- (void)connectToPeriperal:(MTPeripheral *)per passwordRequire:(MTPasswordRequireBlock)handler;


/**
 disconnect from a mtperipheral instance.

 @param per MTPeripheral instance wanted to be disconnected.
 */
- (void)disconnectFromPeriperal:(MTPeripheral *)per;

@end

