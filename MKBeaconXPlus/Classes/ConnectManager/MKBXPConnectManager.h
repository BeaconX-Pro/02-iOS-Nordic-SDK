//
//  MKBXPConnectManager.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPConnectManager : NSObject

@property (nonatomic, copy)NSString *password;

//00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器
//04:光感,05三轴+光感
@property (nonatomic, copy)NSString *deviceType;

/// 生产日期在2021/01/01(含)以后的都是新版本
@property (nonatomic, assign)BOOL newVersion;

/// 是否打开了密码验证，当lockState为mk_bxp_lockStateOpen,表明设备打开了密码验证
@property (nonatomic, assign)BOOL passwordVerification;

+ (MKBXPConnectManager *)shared;

/// 清除当前所有参数
- (void)clearParams;

@end

NS_ASSUME_NONNULL_END
