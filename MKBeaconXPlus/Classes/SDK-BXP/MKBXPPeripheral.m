//
//  MKBXPPeripheral.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPPeripheral.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPService.h"

@interface MKBXPPeripheral ()

@property (nonatomic, strong)CBPeripheral *peripheral;

@end

@implementation MKBXPPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        self.peripheral = peripheral;
    }
    return self;
}

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:bxp_configServiceUUID],  //bxp通用配置服务
                          [CBUUID UUIDWithString:bxp_customServiceUUID],  //custom配置服务
                          [CBUUID UUIDWithString:bxp_deviceServiceUUID]]; //设备信息服务
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_configServiceUUID]]) {
            NSArray *list = @[[CBUUID UUIDWithString:bxp_capabilitiesUUID],
                              [CBUUID UUIDWithString:bxp_activeSlotUUID],
                              [CBUUID UUIDWithString:bxp_advertisingIntervalUUID],
                              [CBUUID UUIDWithString:bxp_radioTxPowerUUID],
                              [CBUUID UUIDWithString:bxp_advertisedTxPowerUUID],
                              [CBUUID UUIDWithString:bxp_lockStateUUID],
                              [CBUUID UUIDWithString:bxp_unlockUUID],
                              [CBUUID UUIDWithString:bxp_publicECDHKeyUUID],
                              [CBUUID UUIDWithString:bxp_eidIdentityKeyUUID],
                              [CBUUID UUIDWithString:bxp_advSlotDataUUID],
                              [CBUUID UUIDWithString:bxp_factoryResetUUID],
                              [CBUUID UUIDWithString:bxp_remainConnectableUUID]];
            [self.peripheral discoverCharacteristics:list forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_customServiceUUID]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:bxp_writeUUID],
                                         [CBUUID UUIDWithString:bxp_notifyUUID],
                                         [CBUUID UUIDWithString:bxp_deviceTypeUUID],
                                         [CBUUID UUIDWithString:bxp_slotTypeUUID],
                                         [CBUUID UUIDWithString:bxp_batteryUUID],
                                         [CBUUID UUIDWithString:bxp_disconnectListenUUID],
                                         [CBUUID UUIDWithString:bxp_threeSensorUUID],
                                         [CBUUID UUIDWithString:bxp_temperatureHumidityUUID],
                                         [CBUUID UUIDWithString:bxp_recordTHUUID],
                                         [CBUUID UUIDWithString:bxp_lightSensorUUID],
                                         [CBUUID UUIDWithString:bxp_lightStatusUUID]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:bxp_deviceServiceUUID]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:bxp_modeIDUUID],
                                         [CBUUID UUIDWithString:bxp_firmwareUUID],
                                         [CBUUID UUIDWithString:bxp_productionDateUUID],
                                         [CBUUID UUIDWithString:bxp_hardwareUUID],
                                         [CBUUID UUIDWithString:bxp_softwareUUID],
                                         [CBUUID UUIDWithString:bxp_vendorUUID]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral bxp_updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral bxp_updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral bxp_connectSuccess];
}

- (void)setNil {
    [self.peripheral bxp_setNil];
}

@end
