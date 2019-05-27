//
//  MKBXPInterface.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPInterface.h"
#import "CBPeripheral+MKAdd.h"
#import "MKBXPCentralManager.h"
#import "MKBXPEnumeration.h"
#import "MKBXPTaskOperation.h"
#import "MKBXPOperationIDDefines.h"

#define centralManager [MKBXPCentralManager shared]

@implementation MKBXPInterface

+ (void)readBXPDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadDeviceTypeOperation
                           characteristic:centralManager.peripheral.deviceType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPMacAddresWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea200000";
    [centralManager addTaskWithTaskID:MKBXPReadMacAddressOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readBXPModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadModeIDOperation
                           characteristic:centralManager.peripheral.modeID
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadSoftwareOperation
                           characteristic:centralManager.peripheral.software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadFirmwareOperation
                           characteristic:centralManager.peripheral.firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadHardwareOperation
                           characteristic:centralManager.peripheral.hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadProductionDateOperation
                           characteristic:centralManager.peripheral.productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPVendorWithSucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadVendorOperation
                           characteristic:centralManager.peripheral.vendor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadBatteryOperation
                           characteristic:centralManager.peripheral.battery
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadConnectEnableOperation
                           characteristic:centralManager.peripheral.remainConnectable
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadSlotTypeOperation
                           characteristic:centralManager.peripheral.slotType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadRadioTxPowerOperation
                           characteristic:centralManager.peripheral.radioTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadAdvSlotDataOperation
                           characteristic:centralManager.peripheral.advSlotData
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)readBXPAdvTxPowerWithSuccessBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:MKBXPReadAdvTxPowerOperation
                           characteristic:centralManager.peripheral.advertisedTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - private method

@end
