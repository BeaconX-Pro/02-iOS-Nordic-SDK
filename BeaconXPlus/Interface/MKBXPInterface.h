//
//  MKBXPInterface.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPInterface : NSObject

/**
 读取设备类型,00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器

 @param sucBlock 成功回调
 @param failedBlock 失败回调
 */
+ (void)readBXPDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s MAC address
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPMacAddresWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the device's modeID
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s software version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s firmware version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s hardware version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the vendor information
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPVendorWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s battery power percentage
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
