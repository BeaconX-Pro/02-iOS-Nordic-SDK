//
//  MKDataManager.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDataManager.h"

NSString *const MKCentralManagerStateChangedNotification = @"MKCentralManagerStateChangedNotification";
NSString *const MKPeripheralConnectStateChangedNotification = @"MKPeripheralConnectStateChangedNotification";
NSString *const MKPeripheralLockStateChangedNotification = @"MKPeripheralLockStateChangedNotification";

@interface MKDataManager ()<MKBXPCentralManagerDelegate>

@end

@implementation MKDataManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setStateDelegate];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setStateDelegate)
                                                     name:@"MKCentralDeallocNotification"
                                                   object:nil];
    }
    return self;
}

+ (MKDataManager *)shared {
    static MKDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[MKDataManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - MKBXPCentralManagerDelegate
- (void)bxp_centralStateChanged:(MKBXPCentralManagerState)managerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCentralManagerStateChangedNotification object:nil];
}

- (void)bxp_peripheralConnectStateChanged:(MKBXPConnectStatus)connectState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralConnectStateChangedNotification object:nil];
}

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralLockStateChangedNotification object:nil];
}

#pragma mark - event method
- (void)setStateDelegate{
    [MKBXPCentralManager shared].stateDelegate = self;
}

@end
