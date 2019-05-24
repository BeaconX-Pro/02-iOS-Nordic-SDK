//
//  MKDeviceInfoModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDeviceInfoModel : NSObject

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

- (void)startLoadSystemInformation:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
