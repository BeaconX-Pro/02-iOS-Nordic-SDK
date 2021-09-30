//
//  CBPeripheral+MKBXPAdd.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKBXPAdd.h"

#import <objc/runtime.h>

#import "MKBXPService.h"

static const char *bxp_capabilities = "bxp_capabilities";
static const char *bxp_activeSlot = "bxp_activeSlot";
static const char *bxp_advertisingInterval = "bxp_advertisingInterval";
static const char *bxp_radioTxPower = "bxp_radioTxPower";
static const char *bxp_advertisedTxPower = "bxp_advertisedTxPower";
static const char *bxp_lockState = "bxp_lockState";
static const char *bxp_unlock = "bxp_unlock";
static const char *bxp_publicECDHKey = "bxp_publicECDHKey";
static const char *bxp_eidIdentityKey = "bxp_eidIdentityKey";
static const char *bxp_advSlotData = "bxp_advSlotData";
static const char *bxp_factoryReset = "bxp_factoryReset";
static const char *bxp_remainConnectable = "bxp_remainConnectable";

static const char *bxp_deviceTypeKey = "bxp_deviceTypeKey";
static const char *bxp_slotTypeKey = "bxp_slotTypeKey";
static const char *bxp_battery = "bxp_battery";
static const char *bxp_disconnectListenKey = "bxp_disconnectListenKey";
static const char *bxp_threeSensorKey = "bxp_threeSensorKey";
static const char *bxp_temperatureHumidityKey = "bxp_temperatureHumidityKey";
static const char *bxp_recordTHKey = "bxp_recordTHKey";
static const char *bxp_lightSensorKey = "bxp_lightSensorKey";
static const char *bxp_lightStatusKey = "bxp_lightStatusKey";

static const char *bxp_customWrite = "bxp_customWrite";
static const char *bxp_customNotify = "bxp_customNotify";

static const char *bxp_vendor = "bxp_vendor";
static const char *bxp_modeID = "bxp_modeID";
static const char *bxp_hardware = "bxp_hardware";
static const char *bxp_firmware = "bxp_firmware";
static const char *bxp_software = "bxp_software";
static const char *bxp_productionDate = "bxp_productionDate";

static const char *bxp_customNotifySuccessKey = "bxp_customNotifySuccessKey";
static const char *bxp_disconnectListenSuccessKey = "bxp_disconnectListenSuccessKey";

@implementation CBPeripheral (MKBXPAdd)

- (void)bxp_updateCharacterWithService:(CBService *)service {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_configServiceUUID]]) {
        //eddyStone通用配置服务
        [self bxp_updateEddystoneCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_customServiceUUID]]){
        //自定义配置服务
        [self bxp_updateCustomCharacteristic:service];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_deviceServiceUUID]]){
        //系统信息(软件版本、硬件版本等)
        [self bxp_updateDeviceInfoCharacteristic:service];
        return;
    }
}

- (void)bxp_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_notifyUUID]]){
        objc_setAssociatedObject(self, &bxp_customNotifySuccessKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_disconnectListenUUID]]) {
        objc_setAssociatedObject(self, &bxp_disconnectListenSuccessKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bxp_connectSuccess {
    if (![self bxp_serviceSuccess] || ![self bxp_customServiceSuccess] || ![self bxp_deviceInfoServiceSuccess]) {
        return NO;
    }
    return YES;
}

- (void)bxp_setNil {
    objc_setAssociatedObject(self, &bxp_capabilities, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_activeSlot, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_advertisingInterval, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_radioTxPower, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_advertisedTxPower, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_lockState, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_unlock, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_publicECDHKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_eidIdentityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_advSlotData, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_factoryReset, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_remainConnectable, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_deviceTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_slotTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_battery, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxp_disconnectListenKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_threeSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_temperatureHumidityKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_recordTHKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_lightSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_lightStatusKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_customNotify, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_customWrite, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxp_vendor, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_modeID, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_hardware, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_firmware, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_software, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_productionDate, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxp_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxp_disconnectListenSuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter
- (CBCharacteristic *)bxp_capabilities{
    return objc_getAssociatedObject(self, &bxp_capabilities);
}

- (CBCharacteristic *)bxp_activeSlot{
    return objc_getAssociatedObject(self, &bxp_activeSlot);
}

- (CBCharacteristic *)bxp_advertisingInterval{
    return objc_getAssociatedObject(self, &bxp_advertisingInterval);
}

- (CBCharacteristic *)bxp_radioTxPower{
    return objc_getAssociatedObject(self, &bxp_radioTxPower);
}

- (CBCharacteristic *)bxp_advertisedTxPower{
    return objc_getAssociatedObject(self, &bxp_advertisedTxPower);
}

- (CBCharacteristic *)bxp_lockState{
    return objc_getAssociatedObject(self, &bxp_lockState);
}

- (CBCharacteristic *)bxp_unlock{
    return objc_getAssociatedObject(self, &bxp_unlock);
}

- (CBCharacteristic *)bxp_publicECDHKey{
    return objc_getAssociatedObject(self, &bxp_publicECDHKey);
}

- (CBCharacteristic *)bxp_eidIdentityKey{
    return objc_getAssociatedObject(self, &bxp_eidIdentityKey);
}

- (CBCharacteristic *)bxp_advSlotData{
    return objc_getAssociatedObject(self, &bxp_advSlotData);
}

- (CBCharacteristic *)bxp_factoryReset{
    return objc_getAssociatedObject(self, &bxp_factoryReset);
}

- (CBCharacteristic *)bxp_remainConnectable{
    return objc_getAssociatedObject(self, &bxp_remainConnectable);
}

- (CBCharacteristic *)bxp_deviceType {
    return objc_getAssociatedObject(self, &bxp_deviceTypeKey);
}

- (CBCharacteristic *)bxp_slotType {
    return objc_getAssociatedObject(self, &bxp_slotTypeKey);
}

- (CBCharacteristic *)bxp_disconnectListen {
    return objc_getAssociatedObject(self, &bxp_disconnectListenKey);
}

- (CBCharacteristic *)bxp_battery{
    return objc_getAssociatedObject(self, &bxp_battery);
}

- (CBCharacteristic *)bxp_threeSensor {
    return objc_getAssociatedObject(self, &bxp_threeSensorKey);
}

- (CBCharacteristic *)bxp_temperatureHumidity {
    return objc_getAssociatedObject(self, &bxp_temperatureHumidityKey);
}

- (CBCharacteristic *)bxp_recordTH {
    return objc_getAssociatedObject(self, &bxp_recordTHKey);
}

- (CBCharacteristic *)bxp_lightSensor {
    return objc_getAssociatedObject(self, &bxp_lightSensorKey);
}

- (CBCharacteristic *)bxp_lightStatus {
    return objc_getAssociatedObject(self, &bxp_lightStatusKey);
}

- (CBCharacteristic *)bxp_customWrite{
    return objc_getAssociatedObject(self, &bxp_customWrite);
}

- (CBCharacteristic *)bxp_customNotify{
    return objc_getAssociatedObject(self, &bxp_customNotify);
}

- (CBCharacteristic *)bxp_modeID{
    return objc_getAssociatedObject(self, &bxp_modeID);
}

- (CBCharacteristic *)bxp_firmware{
    return objc_getAssociatedObject(self, &bxp_firmware);
}

- (CBCharacteristic *)bxp_productionDate{
    return objc_getAssociatedObject(self, &bxp_productionDate);
}

- (CBCharacteristic *)bxp_hardware{
    return objc_getAssociatedObject(self, &bxp_hardware);
}

- (CBCharacteristic *)bxp_software{
    return objc_getAssociatedObject(self, &bxp_software);
}

- (CBCharacteristic *)bxp_vendor{
    return objc_getAssociatedObject(self, &bxp_vendor);
}

#pragma mark - private method
- (void)bxp_updateEddystoneCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_capabilitiesUUID]]) {
            objc_setAssociatedObject(self, &bxp_capabilities, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_activeSlotUUID]]){
            objc_setAssociatedObject(self, &bxp_activeSlot, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisingIntervalUUID]]){
            objc_setAssociatedObject(self, &bxp_advertisingInterval, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_radioTxPowerUUID]]){
            objc_setAssociatedObject(self, &bxp_radioTxPower, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisedTxPowerUUID]]){
            objc_setAssociatedObject(self, &bxp_advertisedTxPower, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lockStateUUID]]){
            objc_setAssociatedObject(self, &bxp_lockState, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_unlockUUID]]){
            objc_setAssociatedObject(self, &bxp_unlock, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_publicECDHKeyUUID]]){
            objc_setAssociatedObject(self, &bxp_publicECDHKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_eidIdentityKeyUUID]]){
            objc_setAssociatedObject(self, &bxp_eidIdentityKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advSlotDataUUID]]){
            objc_setAssociatedObject(self, &bxp_advSlotData, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_factoryResetUUID]]){
            objc_setAssociatedObject(self, &bxp_factoryReset, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_remainConnectableUUID]]){
            objc_setAssociatedObject(self, &bxp_remainConnectable, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)bxp_updateCustomCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_writeUUID]]) {
            objc_setAssociatedObject(self, &bxp_customWrite, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_notifyUUID]]){
            objc_setAssociatedObject(self, &bxp_customNotify, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_deviceTypeUUID]]) {
            objc_setAssociatedObject(self, &bxp_deviceTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_slotTypeUUID]]) {
            objc_setAssociatedObject(self, &bxp_slotTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_batteryUUID]]) {
            objc_setAssociatedObject(self, &bxp_battery, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_disconnectListenUUID]]) {
            objc_setAssociatedObject(self, &bxp_disconnectListenKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [self setNotifyValue:YES forCharacteristic:characteristic];
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_threeSensorUUID]]) {
            objc_setAssociatedObject(self, &bxp_threeSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_temperatureHumidityUUID]]) {
            objc_setAssociatedObject(self, &bxp_temperatureHumidityKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_recordTHUUID]]) {
            objc_setAssociatedObject(self, &bxp_recordTHKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lightSensorUUID]]) {
            objc_setAssociatedObject(self, &bxp_lightSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lightStatusUUID]]) {
            objc_setAssociatedObject(self, &bxp_lightStatusKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (void)bxp_updateDeviceInfoCharacteristic:(CBService *)service{
    if (!service) {
        return;
    }
    NSArray *charactList = [service.characteristics mutableCopy];
    for (CBCharacteristic *characteristic in charactList) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_modeIDUUID]]){
            //产品型号
            objc_setAssociatedObject(self, &bxp_modeID, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_firmwareUUID]]){
            //固件版本
            objc_setAssociatedObject(self, &bxp_firmware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_productionDateUUID]]){
            //生产日期
            objc_setAssociatedObject(self, &bxp_productionDate, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_hardwareUUID]]){
            //硬件版本
            objc_setAssociatedObject(self, &bxp_hardware, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_softwareUUID]]){
            //软件版本
            objc_setAssociatedObject(self, &bxp_software, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_vendorUUID]]){
            //厂商自定义
            objc_setAssociatedObject(self, &bxp_vendor, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (BOOL)bxp_serviceSuccess{
    if (!self.bxp_activeSlot || !self.bxp_advertisingInterval
        || !self.bxp_radioTxPower || !self.bxp_advertisedTxPower || !self.bxp_lockState
        || !self.bxp_unlock || !self.bxp_advSlotData || !self.bxp_factoryReset) {
        return NO;
    }
    return YES;
}

- (BOOL)bxp_customServiceSuccess{
    if (!self.bxp_customNotify || !self.bxp_customWrite || !self.bxp_deviceType || !self.bxp_slotType || !self.bxp_disconnectListen || !self.bxp_battery) {
        return NO;
    }
    return YES;
}

- (BOOL)bxp_deviceInfoServiceSuccess{
    if (!self.bxp_vendor || !self.bxp_modeID || !self.bxp_hardware || !self.bxp_firmware || !self.bxp_software
        || !self.bxp_productionDate) {
        return NO;
    }
    return YES;
}

@end
