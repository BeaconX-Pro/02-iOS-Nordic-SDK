//
//  MKBXPInterface.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPInterface : NSObject

/**
 Read the device type,00: without sensor,01: with 3-axis accelerometer sensor,02: with temperature and humidity sensor, 03: with 3-axis accelerometer / temperature and humidity sensor

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s MAC address
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readMacAddresWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the device's modeID
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s software version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s firmware version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s hardware version
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the vendor information
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readVendorWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading device’s battery power percentage
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading current connection status
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading current frame types of the 6 SLOTs,
 eg:@"001020506070":
 @[@"00",@"10",@"20",@"50",@"60",@"70"]
 
 @"00":UID,
 @"10":URL,
 @"20":TLM,
 @"40":Device Info,
 @"50":iBeacon,
 @"60":3-axis,
 @"70":H&T,
 @"FF":NO DATA

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Radio Tx Power.Radio Tx Power is different for each SLOT. Before reading the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，bxp_configActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading the advertisement data set in the active SLOT.The advertisement data is different for each SLOT. Before reading the advertisement data, you should switch the SLOT to target SLOT(Please refer to bxp_configActiveSlot:sucBlock:failedBlock:); otherwise the advertisement data read is only for the currently active SLOT.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Reading Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before reading the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，bxp_configActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power read is only for the currently active SLOT.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readAdvTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Read the advertising interval of the current SLOT

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
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
+ (void)bxp_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read temperature and humidity sampling rate

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readHTSamplingRateWithSucBlock:(void (^)(id returnData))sucBlock
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
+ (void)bxp_readHTStorageConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read device current time

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readDeviceTimeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read device current trigger condition

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_readTriggerConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read whether the device can be shut down using the button.
/// note:The device whose production date must be after 2021.01.01 can support this instruction.
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_readButtonPowerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the status of light sensor.
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_readLightSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)bxp_readLEDTriggerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)bxp_readResetBeaconByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
