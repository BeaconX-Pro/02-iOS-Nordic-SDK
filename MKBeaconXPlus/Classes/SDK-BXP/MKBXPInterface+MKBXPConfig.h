//
//  MKBXPInterface+MKBXPConfig.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPInterface.h"

#import "MKBXPCentralManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Target SLOT numbers(enum)，slot0~slot4
 */
typedef NS_ENUM(NSInteger, mk_bxp_activeSlotNo) {
    mk_bxp_activeSlot1,//SLOT 0
    mk_bxp_activeSlot2,//SLOT 1
    mk_bxp_activeSlot3,//SLOT 2
    mk_bxp_activeSlot4,//SLOT 3
    mk_bxp_activeSlot5,//SLOT 4
    mk_bxp_activeSlot6,//SLOT 5
};
typedef NS_ENUM(NSInteger, mk_bxp_slotRadioTxPower) {
    mk_bxp_slotRadioTxPowerNeg40dBm,   //-40dBm
    mk_bxp_slotRadioTxPowerNeg20dBm,   //-20dBm
    mk_bxp_slotRadioTxPowerNeg16dBm,   //-16dBm
    mk_bxp_slotRadioTxPowerNeg12dBm,   //-12dBm
    mk_bxp_slotRadioTxPowerNeg8dBm,    //-8dBm
    mk_bxp_slotRadioTxPowerNeg4dBm,    //-4dBm
    mk_bxp_slotRadioTxPower0dBm,       //0dBm
    mk_bxp_slotRadioTxPower3dBm,       //3dBm
    mk_bxp_slotRadioTxPower4dBm,       //4dBm 
};
typedef NS_ENUM(NSInteger, mk_bxp_urlHeaderType) {
    mk_bxp_urlHeaderType1,             //http://www.
    mk_bxp_urlHeaderType2,             //https://www.
    mk_bxp_urlHeaderType3,             //http://
    mk_bxp_urlHeaderType4,             //https://
};

typedef NS_ENUM(NSInteger, mk_bxp_threeAxisDataRate) {
    mk_bxp_threeAxisDataRate1hz,           //1hz
    mk_bxp_threeAxisDataRate10hz,          //10hz
    mk_bxp_threeAxisDataRate25hz,          //25hz
    mk_bxp_threeAxisDataRate50hz,          //50hz
    mk_bxp_threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_bxp_threeAxisDataAG) {
    mk_bxp_threeAxisDataAG0,               //±2g
    mk_bxp_threeAxisDataAG1,               //±4g
    mk_bxp_threeAxisDataAG2,               //±8g
    mk_bxp_threeAxisDataAG3                //±16g
};

typedef NS_ENUM(NSInteger, mk_bxp_HTStorageConditions) {
    mk_bxp_HTStorageConditionsT,               // Store data when temperature changes
    mk_bxp_HTStorageConditionsH,               // Store data when humidity changes
    mk_bxp_HTStorageConditionsTH,              // Store data when temperature or humidity changes
    mk_bxp_HTStorageConditionsTime,            // Store data when time changes
};


@protocol MKBXPDeviceTimeProtocol <NSObject>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@protocol MKBXPHTStorageConditionsProtocol <NSObject>

@property (nonatomic, assign)mk_bxp_HTStorageConditions condition;

/**
 mk_bxp_HTStorageConditions != mk_bxp_HTStorageConditionsTime,0~1000，Represent 0 ° C ~ 100 ° C
 */
@property (nonatomic, assign)NSInteger temperature;

/**
 mk_bxp_HTStorageConditions != mk_bxp_HTStorageConditionsTime,0~1000, Represent 0%~100%
 */
@property (nonatomic, assign)NSInteger humidity;

/**

 mk_bxp_HTStorageConditions == mk_bxp_HTStorageConditionsTime, In case, the range value is 1~255
 */
@property (nonatomic, assign)NSInteger time;

@end

@interface MKBXPInterface (MKBXPConfig)

/**
 Modifying connection password.Only if the device’s LockState is in UNLOCKED state, the password can be modified.
 
 @param newPassword New password, 16 characters
 @param originalPassword Old password, 16 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configNewPassword:(NSString *)newPassword
             originalPassword:(NSString *)originalPassword
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Resetting to factory state (RESET).NOTE:When resetting the device, the connection password will not be restored which shall remain set to its current value.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_factoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting lockState

 @param lockState MKBXPLockState
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configLockState:(mk_bxp_lockState)lockState
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configPowerOffWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting device’s connection status.
 NOTE: Be careful to set device’s connection statue .Once the device is set to not connectable, it may not be connected, and other parameters cannot be configured.
 
 @param connectEnable YES：Connectable，NO：Not Connectable
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configConnectStatus:(BOOL)connectEnable
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;
/**
 MokoBeaconX provides up to 6 SLOTs for users to configure advertisement frame. Before configering the SLOT’s parameter， you should switch the SLOT to target SLOT fristly; otherwise the configuration is only for the currently active SLOT.

 @param slotNo Target SLOT number to switch to
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configActiveSlot:(mk_bxp_activeSlotNo)slotNo
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting Advertised Tx Power(RSSI@0m, only for eddystone frame).Advertised Tx Power is different for each SLOT. Before setting the target SLOT’s Advertised Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Advertised Tx Power set is only for the currently active SLOT.
 
 @param advTxPower Advertised Tx Power, range from -100dBm to +20dBm
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configAdvTxPower:(NSInteger)advTxPower
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting Radio Tx Power.Radio Tx Power is different for each SLOT. Before setting the target SLOT’s Radio Tx Power, you should switch the SLOT to target SLOT(Please refer to ，setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the Radio Tx Power set is only for the currently active SLOT.

 @param power power
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configRadioTxPower:(mk_bxp_slotRadioTxPower )power
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting the advertising interval of the current SLOT

 @param interval Advertising interval, unit: 100ms, range: 1~100
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configAdvInterval:(NSInteger)interval
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as TLM.To configure the target SLOT type as TLM, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as TLM.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTLMAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;
/**
 configuring currently active SLOT as UID.To configure the target SLOT type as UID, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as UID.
 
 @param nameSpace NameSpace, 20 characters
 @param instanceID Instance，12 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configUIDAdvDataWithNameSpace:(NSString *)nameSpace
                               instanceID:(NSString *)instanceID
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as URL.To configure the target SLOT type as URL, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as URL.
 
 @param urlHeader URL Scheme Prefix.
 @param urlContent Encoded URL. If the URL contains HTTP URL encoding, the length of the left datas should be 16bytes at most. If the URL doesn’t contain HTTP URL encoding, the full length of Encoded URL should be 2-17bytes.
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configURLAdvData:(mk_bxp_urlHeaderType )urlHeader
                  urlContent:(NSString *)urlContent
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as iBeacon.To configure the target SLOT type as iBeacon, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as iBeacon.
 
 @param major major,0~65535
 @param minor minor,0~65535
 @param uuid uuid
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configiBeaconAdvDataWithMajor:(NSInteger)major
                                    minor:(NSInteger)minor
                                     uuid:(NSString *)uuid
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Configuring currently active SLOT as NO DATA.To configure the target SLOT type as NO DATA, you should switch the SLOT to target SLOT(Please refer to setEddystoneActiveSlot:sucBlock:failedBlock:); otherwise the currently active SLOT will configured as NO DATA.
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configNODATAAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting Device Name

 @param deviceName deviceName，1~20 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configDeviceInfoAdvDataWithDeviceName:(NSString *)deviceName
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current SLOT to 3-axis sensor

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configThreeAxisAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current SLOT to the temperature and humidity data SLOT

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configHTAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor

 @param dataRate sampling rate
 @param acceleration scale
 @param sensitivity The sensitivity of the device to move, the greater the value, the slower it is. 1~255
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configThreeAxisDataParams:(mk_bxp_threeAxisDataRate)dataRate
                         acceleration:(mk_bxp_threeAxisDataAG)acceleration
                          sensitivity:(NSInteger)sensitivity
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current time of the device

 @param protocol time
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configDeviceTime:(id <MKBXPDeviceTimeProtocol>)protocol
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the storage data conditions of the sensor temperature and humidity

 @param protocol protocol
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configHTStorageConditions:(id <MKBXPHTStorageConditionsProtocol>)protocol
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the temperature and humidity sampling rate

 @param rate Sampling rate, the unit is S, that is, how many seconds to sample the temperature and humidity data, 1s~65535s
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configHTSamplingRate:(NSInteger)rate
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current active SLOT without trigger condition

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsNoneWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current active SLOT temperature trigger condition

 @param above YES:Trigger when temperature is above temperature, NO: Trigger when temperature is lower than temperature
 @param temperature Triggered temperature condition, -20~90
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithTemperature:(BOOL)above
                                       temperature:(NSInteger)temperature
                                  startAdvertising:(BOOL)start
                                          sucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current active SLOT humidity trigger condition

 @param above YES: Triggered when the temperature is above the humidity, NO: Triggered when the temperature is lower than the humidity
 @param humidity Triggered humidity condition, 0~100
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithHudimity:(BOOL)above
                                       humidity:(NSInteger)humidity
                               startAdvertising:(BOOL)start
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting the current active SLOT double tap trigger condition

 @param time duration, unit s, 0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithDoubleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting the current active SLOT TripleTap trigger condition
 
 @param time duration, unit s, 0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithTripleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting the current active SLOT move trigger condition
 
 @param time duration, unit s,0~65535
 @param start YES: Start advertising, NO: stop advertising
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_configTriggerConditionsWithMoves:(NSInteger)time
                                       start:(BOOL)start
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Setting the current active SLOT ambient light detected trigger condition
/// @param time duration, unit s,0~65535
/// @param start YES: Start advertising, NO: stop advertising
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_configTriggerConditionsWithAmbientLightDetected:(NSInteger)time
                                                      start:(BOOL)start
                                                   sucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Setting the current active SLOT single tap trigger condition
/// @param time duration, unit s,0~65535
/// @param start YES: Start advertising, NO: stop advertising
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_configTriggerConditionsWithSingleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Delete the temperature and humidity data stored in the device

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_deleteBXPRecordHTDatasWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Setting whether the device can be shut down using the button.
/// note:The device whose production date must be after 2021.01.01 can support this instruction.
/// @param isOn isOn
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_configButtonPowerStatus:(BOOL)isOn
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Delete the light sensor data stored in the device

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxp_clearLightSensorDatasWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)bxp_configLEDTriggerStatus:(BOOL)isOn
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)bxp_configResetBeaconByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// The firmware recognizes the effective double-click or triple-click action corresponding to the button interval.
/// @param interval 5 ~ 15(Uit:100ms)
/// @param sucBlock success callback
/// @param failedBlock failed callback
+ (void)bxp_configEffectiveClickInterval:(NSInteger)interval
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Only the BXP-CL-a firmware version is supported.
/// @param timestamp UTC
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxp_configTimeStamp:(unsigned long)timestamp
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;

/// Scan response packet.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxp_configScanResponsePacket:(BOOL)isOn
                            sucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
