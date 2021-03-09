//
//  MKBXPInterface.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPInterface.h"

#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPCentralManager.h"
#import "MKBXPOperationID.h"

#define centralManager [MKBXPCentralManager shared]

@implementation MKBXPInterface

+ (void)bxp_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadDeviceTypeOperation
                           characteristic:centralManager.peripheral.bxp_deviceType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readMacAddresWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea200000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadMacAddressOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadModeIDOperation
                           characteristic:centralManager.peripheral.bxp_modeID
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadSoftwareOperation
                           characteristic:centralManager.peripheral.bxp_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadFirmwareOperation
                           characteristic:centralManager.peripheral.bxp_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadHardwareOperation
                           characteristic:centralManager.peripheral.bxp_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadProductionDateOperation
                           characteristic:centralManager.peripheral.bxp_productionDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readVendorWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadVendorOperation
                           characteristic:centralManager.peripheral.bxp_vendor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadBatteryOperation
                           characteristic:centralManager.peripheral.bxp_battery
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadConnectEnableOperation
                           characteristic:centralManager.peripheral.bxp_remainConnectable
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadSlotTypeOperation
                           characteristic:centralManager.peripheral.bxp_slotType
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadRadioTxPowerOperation
                           characteristic:centralManager.peripheral.bxp_radioTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvSlotDataOperation
                           characteristic:centralManager.peripheral.bxp_advSlotData
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readAdvTxPowerWithSuccessBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvTxPowerOperation
                           characteristic:centralManager.peripheral.bxp_advertisedTxPower
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readAdvIntervalWithSuccessBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvertisingIntervalOperation
                           characteristic:centralManager.peripheral.bxp_advertisingInterval
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxp_readThreeAxisDataParamsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea210000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadThreeAxisParamsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readHTSamplingRateWithSuccessBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea230000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadHTSamplingRateOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readHTStorageConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea220000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadHTStorageConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readDeviceTimeWithSuccessBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea250000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadDeviceTimeOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readTriggerConditionsWithSuccessBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea290000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxp_readButtonPowerStatusWithSuccessBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea280000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadButtonPowerStatusOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.bxp_customWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
