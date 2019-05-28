//
//  MKDataManager.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCentralManagerStateChangedNotification;
extern NSString *const MKPeripheralConnectStateChangedNotification;
extern NSString *const MKPeripheralLockStateChangedNotification;

@class MKSlotDataTypeModel;
@interface MKDataManager : NSObject

@property (nonatomic, copy)NSString *password;

+ (MKDataManager *)shared;

@end

NS_ASSUME_NONNULL_END
