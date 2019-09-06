//
//  CBPeripheral+MKAdd.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKAdd)

#pragma mark - EddyStone服务下面的特征

@property (nonatomic, strong, readonly)CBCharacteristic *capabilities;
@property (nonatomic, strong, readonly)CBCharacteristic *activeSlot;
@property (nonatomic, strong, readonly)CBCharacteristic *advertisingInterval;
@property (nonatomic, strong, readonly)CBCharacteristic *radioTxPower;
@property (nonatomic, strong, readonly)CBCharacteristic *advertisedTxPower;
@property (nonatomic, strong, readonly)CBCharacteristic *lockState;
@property (nonatomic, strong, readonly)CBCharacteristic *unlock;
@property (nonatomic, strong, readonly)CBCharacteristic *publicECDHKey;
@property (nonatomic, strong, readonly)CBCharacteristic *eidIdentityKey;
@property (nonatomic, strong, readonly)CBCharacteristic *advSlotData;
@property (nonatomic, strong, readonly)CBCharacteristic *factoryReset;
@property (nonatomic, strong, readonly)CBCharacteristic *remainConnectable;

#pragma mark - iBeacon设置服务下面的特征
@property (nonatomic, strong, readonly)CBCharacteristic *deviceType;
@property (nonatomic, strong, readonly)CBCharacteristic *slotType;
@property (nonatomic, strong, readonly)CBCharacteristic *disconnectListen;
@property (nonatomic, strong, readonly)CBCharacteristic *battery;
@property (nonatomic, strong, readonly)CBCharacteristic *threeSensor;
@property (nonatomic, strong, readonly)CBCharacteristic *temperatureHumidity;
@property (nonatomic, strong, readonly)CBCharacteristic *recordTH;
@property (nonatomic, strong, readonly)CBCharacteristic *iBeaconWrite;
@property (nonatomic, strong, readonly)CBCharacteristic *iBeaconNotify;

#pragma mark - 系统信息下面的特征
/**
 Manufacturer,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *vendor;

/**
 Product Model,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *modeID;

/**
 Manufacture Date,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *productionDate;

/**
 Hardware Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *hardware;

/**
 Firmware Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *firmware;

/**
 Software Version,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *software;

#pragma mark - DFU下面的特征

/**
 dfu
 */
@property (nonatomic, strong, readonly)CBCharacteristic *dfu;

- (void)updateCharacterWithService:(CBService *)service;

- (void)setNil;

- (BOOL)getAllCharacteristics;

@end

NS_ASSUME_NONNULL_END
