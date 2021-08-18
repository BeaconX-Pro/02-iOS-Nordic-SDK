//
//  MKBXDeviceInfoDataProtocol.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 下面定义的这些key都是mk_bx_deviceInfoCell_params返回的json里面的key
 */
//设备当前电压mV
static NSString *const mk_bx_deviceInfo_batteryKey = @"mk_bx_deviceInfo_batteryKey";
//设备mac地址
static NSString *const mk_bx_deviceInfo_macAddressKey = @"mk_bx_deviceInfo_macAddressKey";
//设备产品型号
static NSString *const mk_bx_deviceInfo_produceKey = @"mk_bx_deviceInfo_produceKey";
//设备软件版本
static NSString *const mk_bx_deviceInfo_softwareKey = @"mk_bx_deviceInfo_softwareKey";
//设备固件版本
static NSString *const mk_bx_deviceInfo_firmwareKey = @"mk_bx_deviceInfo_firmwareKey";
//设备硬件版本
static NSString *const mk_bx_deviceInfo_hardwareKey = @"mk_bx_deviceInfo_hardwareKey";
//设备生产日期
static NSString *const mk_bx_deviceInfo_manuDateKey = @"mk_bx_deviceInfo_manuDateKey";
//设备厂商信息
static NSString *const mk_bx_deviceInfo_manuKey = @"mk_bx_deviceInfo_manuKey";


@protocol MKBXDeviceInfoDataProtocol <NSObject>

/// 读取设备信息
/// @param sucBlock 成功回调(里面应该包含上面的key值信息，缺少的信息则右侧数据信息不显示)
/// @param failedBlock 失败回调
- (void)readWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
