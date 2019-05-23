//
//  CBPeripheral+MKAdd.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "CBPeripheral+MKAdd.h"
#import <objc/runtime.h>
#import "MKBXPService.h"

static const char *capabilities = "capabilities";
static const char *activeSlot = "activeSlot";
static const char *advertisingInterval = "advertisingInterval";
static const char *radioTxPower = "radioTxPower";
static const char *advertisedTxPower = "advertisedTxPower";
static const char *lockState = "lockState";
static const char *unlock = "unlock";
static const char *publicECDHKey = "publicECDHKey";
static const char *eidIdentityKey = "eidIdentityKey";
static const char *advSlotData = "advSlotData";
static const char *factoryReset = "factoryReset";
static const char *remainConnectable = "remainConnectable";

static const char *iBeaconWrite = "iBeaconWrite";
static const char *iBeaconNotify = "iBeaconNotify";

static const char *vendor = "vendor";
static const char *modeID = "modeID";
static const char *hardware = "hardware";
static const char *firmware = "firmware";
static const char *software = "software";
static const char *productionDate = "productionDate";
static const char *battery = "battery";
static const char *dfu = "dfu";

@implementation CBPeripheral (MKAdd)

- (void)updateCharacterWithService:(CBService *)service{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:eddyStoneConfigServiceUUID]]) {
        //eddyStone通用配置服务
        [self setEddystoneCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:iBeaconConfigServiceUUID]]){
        //iBeacon配置服务
        [self setiBeaconCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:deviceInfoServiceUUID]]){
        //系统信息(软件版本、硬件版本等)
        [self setDeviceInfoCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:batteryServiceUUID]]){
        //电池服务
        [self setBatteryCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:dfuServiceUUID]]){
        //DFU功能
        [self setDFUCharacteristic:service];
        return;
    }
}

- (void)setNil{
    objc_removeAssociatedObjects(self);
}

- (BOOL)getAllCharacteristics{
    if (![self eddystoneServiceSuccess] || ![self iBeaconServiceSuccess]
        || ![self deviceInfoServiceSuccess] || ![self batteryServiceSuccess] || ![self dfuServiceSuccess]) {
        return NO;
    }
    return YES;
}

#pragma mark - getters
- (CBCharacteristic *)capabilities{
    return objc_getAssociatedObject(self, &capabilities);
}

- (CBCharacteristic *)activeSlot{
    return objc_getAssociatedObject(self, &activeSlot);
}

- (CBCharacteristic *)advertisingInterval{
    return objc_getAssociatedObject(self, &advertisingInterval);
}

- (CBCharacteristic *)radioTxPower{
    return objc_getAssociatedObject(self, &radioTxPower);
}

- (CBCharacteristic *)advertisedTxPower{
    return objc_getAssociatedObject(self, &advertisedTxPower);
}

- (CBCharacteristic *)lockState{
    return objc_getAssociatedObject(self, &lockState);
}

- (CBCharacteristic *)unlock{
    return objc_getAssociatedObject(self, &unlock);
}

- (CBCharacteristic *)publicECDHKey{
    return objc_getAssociatedObject(self, &publicECDHKey);
}

- (CBCharacteristic *)eidIdentityKey{
    return objc_getAssociatedObject(self, &eidIdentityKey);
}

- (CBCharacteristic *)advSlotData{
    return objc_getAssociatedObject(self, &advSlotData);
}

- (CBCharacteristic *)factoryReset{
    return objc_getAssociatedObject(self, &factoryReset);
}

- (CBCharacteristic *)remainConnectable{
    return objc_getAssociatedObject(self, &remainConnectable);
}

- (CBCharacteristic *)iBeaconWrite{
    return objc_getAssociatedObject(self, &iBeaconWrite);
}

- (CBCharacteristic *)iBeaconNotify{
    return objc_getAssociatedObject(self, &iBeaconNotify);
}

- (CBCharacteristic *)modeID{
    return objc_getAssociatedObject(self, &modeID);
}

- (CBCharacteristic *)firmware{
    return objc_getAssociatedObject(self, &firmware);
}

- (CBCharacteristic *)productionDate{
    return objc_getAssociatedObject(self, &productionDate);
}

- (CBCharacteristic *)hardware{
    return objc_getAssociatedObject(self, &hardware);
}

- (CBCharacteristic *)software{
    return objc_getAssociatedObject(self, &software);
}

- (CBCharacteristic *)vendor{
    return objc_getAssociatedObject(self, &vendor);
}

- (CBCharacteristic *)battery{
    return objc_getAssociatedObject(self, &battery);
}

- (CBCharacteristic *)dfu{
    return objc_getAssociatedObject(self, &dfu);
}

#pragma mark -
- (void)setEddystoneCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:capabilitiesUUID]]) {
            objc_setAssociatedObject(self, &capabilities, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:activeSlotUUID]]){
            objc_setAssociatedObject(self, &activeSlot, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisingIntervalUUID]]){
            objc_setAssociatedObject(self, &advertisingInterval, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:radioTxPowerUUID]]){
            objc_setAssociatedObject(self, &radioTxPower, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisedTxPowerUUID]]){
            objc_setAssociatedObject(self, &advertisedTxPower, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:lockStateUUID]]){
            objc_setAssociatedObject(self, &lockState, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:unlockUUID]]){
            objc_setAssociatedObject(self, &unlock, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:publicECDHKeyUUID]]){
            objc_setAssociatedObject(self, &publicECDHKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:eidIdentityKeyUUID]]){
            objc_setAssociatedObject(self, &eidIdentityKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advSlotDataUUID]]){
            objc_setAssociatedObject(self, &advSlotData, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:factoryResetUUID]]){
            objc_setAssociatedObject(self, &factoryReset, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:remainConnectableUUID]]){
            objc_setAssociatedObject(self, &remainConnectable, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setiBeaconCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconWriteUUID]]) {
            objc_setAssociatedObject(self, &iBeaconWrite, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconNotifyUUID]]){
            objc_setAssociatedObject(self, &iBeaconNotify, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)setDeviceInfoCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:modeIDUUID]]){
            //产品型号
            objc_setAssociatedObject(self, &modeID, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:firmwareUUID]]){
            //固件版本
            objc_setAssociatedObject(self, &firmware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:productionDateUUID]]){
            //生产日期
            objc_setAssociatedObject(self, &productionDate, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:hardwareUUID]]){
            //硬件版本
            objc_setAssociatedObject(self, &hardware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:softwareUUID]]){
            //软件版本
            objc_setAssociatedObject(self, &software, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:vendorUUID]]){
            //厂商自定义
            objc_setAssociatedObject(self, &vendor, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)setBatteryCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:batteryCBCharacteristicUUID]]) {
            objc_setAssociatedObject(self, &battery, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
}

- (void)setDFUCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:dfuCBCharacteristicUUID]]) {
            objc_setAssociatedObject(self, &dfu, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            break;
        }
    }
}

- (BOOL)eddystoneServiceSuccess{
    if (!self.capabilities || !self.activeSlot || !self.advertisingInterval
        || !self.radioTxPower || !self.advertisedTxPower || !self.lockState
        || !self.unlock || !self.advSlotData || !self.factoryReset) {
        return NO;
    }
    return YES;
}

- (BOOL)iBeaconServiceSuccess{
    if (!self.iBeaconNotify || !self.iBeaconWrite) {
        return NO;
    }
    return YES;
}

- (BOOL)deviceInfoServiceSuccess{
    if (!self.vendor || !self.modeID || !self.hardware || !self.firmware || !self.software
        || !self.productionDate) {
        return NO;
    }
    return YES;
}

- (BOOL)batteryServiceSuccess{
    if (!self.battery) {
        return NO;
    }
    return YES;
}

- (BOOL)dfuServiceSuccess{
    //    if (!self.dfu) {
    //        return NO;
    //    }
    return YES;
}

@end
