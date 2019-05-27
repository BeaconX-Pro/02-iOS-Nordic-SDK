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

@end

NS_ASSUME_NONNULL_END
