//
//  MKBXPPeripheral.m
//  tempasdfjasd
//
//  Created by aa on 2020/9/26.
//

#import "MKBXPPeripheral.h"

#import "CBPeripheral+MKAdd.h"

#import "MKBXPService.h"

@implementation MKBXPPeripheral

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:eddyStoneConfigServiceUUID],  //eddyStone通用配置服务
                          [CBUUID UUIDWithString:iBeaconConfigServiceUUID],  //iBeacon配置服务
                          [CBUUID UUIDWithString:deviceInfoServiceUUID],     //系统信息(软件版本、硬件版本等)
                          [CBUUID UUIDWithString:dfuServiceUUID]]; //DFU
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:eddyStoneConfigServiceUUID]]) {
            NSArray *list = @[[CBUUID UUIDWithString:capabilitiesUUID],
                              [CBUUID UUIDWithString:activeSlotUUID],
                              [CBUUID UUIDWithString:advertisingIntervalUUID],
                              [CBUUID UUIDWithString:radioTxPowerUUID],
                              [CBUUID UUIDWithString:advertisedTxPowerUUID],
                              [CBUUID UUIDWithString:lockStateUUID],
                              [CBUUID UUIDWithString:unlockUUID],
                              [CBUUID UUIDWithString:publicECDHKeyUUID],
                              [CBUUID UUIDWithString:eidIdentityKeyUUID],
                              [CBUUID UUIDWithString:advSlotDataUUID],
                              [CBUUID UUIDWithString:factoryResetUUID],
                              [CBUUID UUIDWithString:remainConnectableUUID]];
            [self.peripheral discoverCharacteristics:list forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:iBeaconConfigServiceUUID]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:iBeaconWriteUUID],
                                         [CBUUID UUIDWithString:iBeaconNotifyUUID],
                                         [CBUUID UUIDWithString:deviceTypeUUID],
                                         [CBUUID UUIDWithString:slotTypeUUID],
                                         [CBUUID UUIDWithString:batteryUUID],
                                         [CBUUID UUIDWithString:disconnectListenUUID],
                                         [CBUUID UUIDWithString:threeSensorUUID],
                                         [CBUUID UUIDWithString:temperatureHumidityUUID],
                                         [CBUUID UUIDWithString:recordTHUUID]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:deviceInfoServiceUUID]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:modeIDUUID],
                                         [CBUUID UUIDWithString:firmwareUUID],
                                         [CBUUID UUIDWithString:productionDateUUID],
                                         [CBUUID UUIDWithString:hardwareUUID],
                                         [CBUUID UUIDWithString:softwareUUID],
                                         [CBUUID UUIDWithString:vendorUUID]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral connectSuccess];
}

- (void)setNil {
    [self.peripheral setNil];
}

@end
