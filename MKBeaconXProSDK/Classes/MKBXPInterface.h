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
 Read the device type,00: without sensor,01: with 3-axis accelerometer sensor,02: with temperature and humidity sensor, 03: with 3-axis accelerometer / temperature and humidity sensor

 @param sucBlock success callback
 @param failedBlock failed callback
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
 Reading Radio Tx Power.Radio Tx Power is different for each SLOT. Before reading the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setBXPActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the advertisement data set in the active SLOT.The advertisement data is different for each SLOT. Before reading the advertisement data, you should switch the SLOT to target SLOT(Please refer to setBXPActiveSlot:sucBlock:failedBlock:); otherwise the advertisement data read is only for the currently active SLOT.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before reading the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setBXPActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvTxPowerWithSuccessBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Read the advertising interval of the current SLOT

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPAdvIntervalWithSuccessBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor
 
 @{
 @"samplingRate":The 3-axis accelerometer sampling rate is 5 levels in total, 00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"gravityReference": The 3-axis accelerometer scale is 4 levels, which are 00--±2g；01--±4g；02--±8g；03--±16g
 @"sensitivity": Represents the device to determine the sensitivity of the device's movement. The larger the value, the slower it is.
 }

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPThreeAxisDataParamsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read temperature and humidity sampling rate

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPHTSamplingRateWithSuccessBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read temperature and humidity storage conditions
 
 @{
 @"functionType":tempFunction,
 @"temperature":temperValue,
 @"humidity":humidity,
 @"storageTime":time,
 };
 @"functionType":
 
 1. Only preset the temperature value, that is, when the temperature changes exceed the preset value, record the temperature and humidity data (00);
 2. Only preset the humidity value, that is, when the humidity changes exceed the preset value, record the temperature and humidity data (01);
 3. Simultaneously preset temperature and humidity values, if any change in temperature or humidity exceeds the preset value, record the temperature and humidity data (02);
 4. Store according to the preset time, that is, reach the preset duration and store the temperature and humidity data once (03)
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPHTStorageConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read device current time

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPDeviceTimeWithSuccessBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read device current trigger condition

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)readBXPTriggerConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
