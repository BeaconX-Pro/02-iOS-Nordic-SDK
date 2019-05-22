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

NS_ASSUME_NONNULL_BEGIN

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

- (void)startScanPeripheral;
- (void)stopScanPeripheral;

@end

NS_ASSUME_NONNULL_END