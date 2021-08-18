//
//  MKBXPDeviceInfoModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDeviceInfoDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPDeviceInfoModel : NSObject<MKBXDeviceInfoDataProtocol>

/**
 电池电量
 */
@property (nonatomic, copy)NSString *battery;

/**
 mac地址
 */
@property (nonatomic, copy)NSString *macAddress;

/**
 产品型号
 */
@property (nonatomic, copy)NSString *produce;

/**
 软件版本
 */
@property (nonatomic, copy)NSString *software;

/**
 固件版本
 */
@property (nonatomic, copy)NSString *firmware;

/**
 硬件版本
 */
@property (nonatomic, copy)NSString *hardware;

/**
 生产日期
 */
@property (nonatomic, copy)NSString *manuDate;

/**
 厂商信息
 */
@property (nonatomic, copy)NSString *manu;

- (void)readWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
