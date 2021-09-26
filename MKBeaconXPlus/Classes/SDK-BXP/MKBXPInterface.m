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
#define peripheral [MKBXPCentralManager shared].peripheral

@implementation MKBXPInterface

+ (void)bxp_readDeviceTypeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadDeviceTypeOperation
                           characteristic:peripheral.bxp_deviceType
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readMacAddresWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea200000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadMacAddressOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readModeIDWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadModeIDOperation
                           characteristic:peripheral.bxp_modeID
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadSoftwareOperation
                           characteristic:peripheral.bxp_software
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadFirmwareOperation
                           characteristic:peripheral.bxp_firmware
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadHardwareOperation
                           characteristic:peripheral.bxp_hardware
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadProductionDateOperation
                           characteristic:peripheral.bxp_productionDate
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readVendorWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadVendorOperation
                           characteristic:peripheral.bxp_vendor
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readBatteryWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadBatteryOperation
                           characteristic:peripheral.bxp_battery
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readConnectEnableStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadConnectEnableOperation
                           characteristic:peripheral.bxp_remainConnectable
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadSlotTypeOperation
                           characteristic:peripheral.bxp_slotType
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readRadioTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadRadioTxPowerOperation
                           characteristic:peripheral.bxp_radioTxPower
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvSlotDataOperation
                           characteristic:peripheral.bxp_advSlotData
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readAdvTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvTxPowerOperation
                           characteristic:peripheral.bxp_advertisedTxPower
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadAdvertisingIntervalOperation
                           characteristic:peripheral.bxp_advertisingInterval
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea210000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadThreeAxisParamsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readHTSamplingRateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea230000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadHTSamplingRateOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readHTStorageConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea220000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadHTStorageConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readDeviceTimeWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea250000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadDeviceTimeOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readTriggerConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea290000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readButtonPowerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea280000";
    [centralManager addTaskWithTaskID:mk_bxp_taskReadButtonPowerStatusOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readLightSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxp_taskReadLightSensorStatusOperation
                           characteristic:peripheral.bxp_lightStatus
                                 sucBlock:sucBlock
                              failedBlock:failedBlock];
}

+ (void)bxp_readLEDTriggerStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskReadLEDTriggerStatusOperation
                          commandData:@"ea470000"
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_readResetBeaconByButtonStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskReadResetBeaconByButtonStatusOperation
                          commandData:@"ea480000"
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

@end
