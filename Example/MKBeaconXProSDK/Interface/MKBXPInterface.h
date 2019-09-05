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
/**
 Reading current connection status
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading current frame types of the 5 SLOTs,
 eg:@"001020506070":@"00":UID,@"10":URL,@"20":TLM,@"40":设备信息,@"50":iBeacon,@"60":3轴加速度计,@"70":温湿度传感器,@"FF":NO DATA

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Radio Tx Power.Radio Tx Power is different for each SLOT. Before reading the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the advertisement data set in the active SLOT.The advertisement data is different for each SLOT. Before reading the advertisement data, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the advertisement data read is only for the currently active SLOT.
 To read the advertisement data set in the active SLOT, host must get the current SLOT type(Please refer to readEddStoneSlotDataTypeWithSuccessBlock:failedBlock: to get all 6 SLOTS advertisement types).
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before reading the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvTxPowerWithSuccessBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 读取当前通道的广播间隔

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvIntervalWithSuccessBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/**
 读取通道里面三轴传感器采样率、重力加速度参考值和灵敏度
 
 @{
 @"samplingRate":采样率一共5个档，分别为00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"gravityReference":重力加速度参考值一共4个档，分别为00--±2g；01--±4g；02--±8g；03--±16g
 @"sensitivity":代表设备判断设备发生移动的灵敏度，数值越大，越迟钝。
 }

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPThreeAxisDataParamsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/**
 读取温湿度采样率

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPHTSamplingRateWithSuccessBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 读取温湿度存储条件

 @{
 @"functionType":tempFunction,
 @"temperature":temperValue,
 @"humidity":humidity,
 @"storageTime":time,
 };
 @"functionType":
 1、只预设温度值，即当温度变化超过预设值，记录一次温湿度数据（00）；
 2、只预设湿度值，即当湿度变化超过预设值，记录一次温湿度数据（01）；
 3、同时预设温湿度值，温度或湿度任意一个变化超过预设值，便记录一次温湿度数据（02）；
 4、按照预设时间存储，即达到预设时长，存储一次温湿度数据（03）
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPHTStorageConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/**
 读取设备当前时间

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPDeviceTimeWithSuccessBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/**
 读取设备当前触发条件

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPTriggerConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
