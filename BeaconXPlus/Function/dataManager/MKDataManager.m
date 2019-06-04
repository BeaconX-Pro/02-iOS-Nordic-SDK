//
//  MKDataManager.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDataManager.h"
#import "MKSlotDataTypeModel.h"
#import "MKBLELogManager.h"

NSString *const MKCentralManagerStateChangedNotification = @"MKCentralManagerStateChangedNotification";
NSString *const MKPeripheralConnectStateChangedNotification = @"MKPeripheralConnectStateChangedNotification";
NSString *const MKPeripheralLockStateChangedNotification = @"MKPeripheralLockStateChangedNotification";

@interface MKDataManager ()<MKBXPCentralManagerDelegate>

/**
 slot的详情数据
 */
@property (nonatomic, strong)NSMutableDictionary *slotDetailDic;

/**
 设置给eddStone的详情数据
 */
@property (nonatomic, strong)NSDictionary *setSlotDetailDic;

@property (nonatomic, strong)MKSlotDataTypeModel *dataModel;

/**
 读取slot详细数据成功回调
 */
@property (nonatomic, copy)void (^readSlotDetailSucBlock)(id returnData);

/**
 读取slot详细数据失败回调
 */
@property (nonatomic, copy)void (^readSlotDetailFailBlock)(NSError *error);

/**
 设置slot详情数据成功回调
 */
@property (nonatomic, copy)void (^setSlotDetailSucBlock)(void);

/**
 设置slot详情数据失败回调
 */
@property (nonatomic, copy)void (^setSlotDetailFailBlock)(NSError *error);

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
    if (connectState == MKBXPConnectStatusDisconnect) {
        [MKBLELogManager deleteLog];
    }
}

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralLockStateChangedNotification object:nil];
}

#pragma mark - event method
- (void)setStateDelegate{
    [MKBXPCentralManager shared].stateDelegate = self;
}

@end
