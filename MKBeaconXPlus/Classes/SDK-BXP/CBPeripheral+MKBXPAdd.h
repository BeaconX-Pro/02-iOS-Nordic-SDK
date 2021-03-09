//
//  CBPeripheral+MKBXPAdd.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBXPAdd)

#pragma mark - eddyStone服务下面的特征

@property (nonatomic, strong, readonly)CBCharacteristic *bxp_capabilities;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_activeSlot;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_advertisingInterval;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_radioTxPower;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_advertisedTxPower;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_lockState;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_unlock;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_publicECDHKey;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_eidIdentityKey;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_advSlotData;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_factoryReset;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_remainConnectable;

#pragma mark - iBeacon设置服务下面的特征
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_deviceType;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_slotType;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_disconnectListen;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_battery;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_threeSensor;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_temperatureHumidity;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_recordTH;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_customWrite;
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_customNotify;

#pragma mark - 系统信息下面的特征
/**
 Manufacturer,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_vendor;

/**
 Product Model,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_modeID;

/**
 Manufacture Date,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_productionDate;

/**
 Hardware Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_hardware;

/**
 Firmware Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_firmware;

/**
 Software Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *bxp_software;

- (void)bxp_updateCharacterWithService:(CBService *)service;

- (void)bxp_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxp_connectSuccess;

- (void)bxp_setNil;

@end

NS_ASSUME_NONNULL_END
