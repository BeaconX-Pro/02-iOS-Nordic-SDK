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
//00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器
@property (nonatomic, copy)NSString *deviceType;

+ (MKDataManager *)shared;

@end

NS_ASSUME_NONNULL_END
