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

@property (nonatomic, strong, readonly)CBCharacteristic *iBeaconWrite;
@property (nonatomic, strong, readonly)CBCharacteristic *iBeaconNotify;

#pragma mark - 系统信息下面的特征
/**
 厂商信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *vendor;

/**
 产品型号信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *modeID;

/**
 生产日期
 */
@property (nonatomic, strong, readonly)CBCharacteristic *productionDate;

/**
 硬件信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *hardware;

/**
 固件信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *firmware;

/**
 软件版本信息,R
 */
@property (nonatomic, strong, readonly)CBCharacteristic *software;

#pragma mark - DFU下面的特征

/**
 dfu升级用的
 */
@property (nonatomic, strong, readonly)CBCharacteristic *dfu;

#pragma mark - battery下面的特征
@property (nonatomic, strong, readonly)CBCharacteristic *battery;

- (void)updateCharacterWithService:(CBService *)service;

- (void)setNil;

- (BOOL)getAllCharacteristics;

@end

NS_ASSUME_NONNULL_END
