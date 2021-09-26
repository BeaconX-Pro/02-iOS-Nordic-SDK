//
//  MKBXPInterface+MKBXPConfig.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "CBPeripheral+MKBXPAdd.h"
#import "MKBXPCentralManager.h"
#import "MKBXPOperationID.h"
#import "MKBXPAdopter.h"

#define centralManager [MKBXPCentralManager shared]
#define peripheral [MKBXPCentralManager shared].peripheral

@implementation MKBXPInterface (MKBXPConfig)

+ (void)bxp_configNewPassword:(NSString *)newPassword
             originalPassword:(NSString *)originalPassword
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter isPassword:newPassword] || ![MKBXPAdopter isPassword:originalPassword]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    //写入0x00加上16字节新的密码（用户要对新的密码进行加密，然后发送，加密的密钥是旧的密码，也就是当前密码），发送之后，设备变为LOCKED状态。
    NSString *oldTempString = @"";
    for (NSInteger i = 0; i < originalPassword.length; i ++) {
        int asciiCode = [originalPassword characterAtIndex:i];
        oldTempString = [oldTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *oldPasswordData = [MKBLEBaseSDKAdopter stringToData:oldTempString];
    NSString *newTempString = @"";
    for (NSInteger i = 0; i < newPassword.length; i ++) {
        int asciiCode = [newPassword characterAtIndex:i];
        newTempString = [newTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *newPasswordData = [MKBLEBaseSDKAdopter stringToData:newTempString];
    Byte byte[16] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    NSData *oldSupplyData = [NSData dataWithBytes:byte length:(16 - oldPasswordData.length)];
    NSData *newSupplyData = [NSData dataWithBytes:byte length:(16 - newPasswordData.length)];
    
    NSMutableData *oldData = [[NSMutableData alloc] init];
    [oldData appendData:oldPasswordData];
    [oldData appendData:oldSupplyData];
    
    NSMutableData *newData = [[NSMutableData alloc] init];
    [newData appendData:newPasswordData];
    [newData appendData:newSupplyData];
    
    NSData *encryptData = [MKBXPAdopter AES128EncryptWithSourceData:newData keyData:oldData];
    if (!MKValidData(encryptData) || encryptData.length != 16) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSMutableData *commandData = [[NSMutableData alloc] init];
    Byte headerB[1] = {0x00};
    [commandData appendData:[NSData dataWithBytes:headerB length:1]];
    [commandData appendData:encryptData];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigLockStateOperation
                          commandData:[MKBLEBaseSDKAdopter hexStringFromData:commandData]
                       characteristic:peripheral.bxp_lockState
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_factoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigFactoryResetOperation
                          commandData:@"0b"
                       characteristic:peripheral.bxp_factoryReset
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configLockState:(mk_bxp_lockState)lockState
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"00";
    if (lockState == mk_bxp_lockStateOpen) {
        commandString = @"01";
    }else if (lockState == mk_bxp_lockStateUnlockAutoMaticRelockDisabled){
        commandString = @"02";
    }
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigLockStateOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_lockState
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configPowerOffWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigPowerOffOperation
                          commandData:@"ea260000"
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configConnectStatus:(BOOL)connectEnable
                       sucBlock:(void (^)(id returnData))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigConnectEnableOperation
                          commandData:(connectEnable ? @"01" : @"00")
                       characteristic:peripheral.bxp_remainConnectable
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configActiveSlot:(mk_bxp_activeSlotNo)slotNo
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *slotNumber = [self fetchSlotNumber:slotNo];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigActiveSlotOperation
                          commandData:slotNumber
                       characteristic:peripheral.bxp_activeSlot
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configAdvTxPower:(NSInteger)advTxPower
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (advTxPower < -100 || advTxPower > 20) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *advPower = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:advTxPower];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvTxPowerOperation
                          commandData:advPower
                       characteristic:peripheral.bxp_advertisedTxPower
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configRadioTxPower:(mk_bxp_slotRadioTxPower )power
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [self fetchTxPower:power];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigRadioTxPowerOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_radioTxPower
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configAdvInterval:(NSInteger)interval
                     sucBlock:(void (^)(id returnData))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *advInterval = [MKBLEBaseSDKAdopter fetchHexValue:(interval * 100) byteLen:2];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvertisingIntervalOperation
                          commandData:advInterval
                       characteristic:peripheral.bxp_advertisingInterval
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTLMAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:@"20"
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configUIDAdvDataWithNameSpace:(NSString *)nameSpace
                               instanceID:(NSString *)instanceID
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter isNameSpace:nameSpace] || ![MKBXPAdopter isInstanceID:instanceID]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"00",nameSpace,instanceID];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configURLAdvData:(mk_bxp_urlHeaderType )urlHeader
                  urlContent:(NSString *)urlContent
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter checkUrlContent:urlContent]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *header = @"";
    NSString *tempHeader = @"";
    if (urlHeader == mk_bxp_urlHeaderType1) {
        header = @"00";
        tempHeader = @"http://www.";
    }else if (urlHeader == mk_bxp_urlHeaderType2){
        header = @"01";
        tempHeader = @"https://www.";
    }else if (urlHeader == mk_bxp_urlHeaderType3){
        header = @"02";
        tempHeader = @"http://";
    }else if (urlHeader == mk_bxp_urlHeaderType4){
        header = @"03";
        tempHeader = @"https://";
    }
    NSString *urlString = [MKBXPAdopter fetchUrlStringWithHeader:tempHeader urlContent:urlContent];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"10",header,urlString];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configiBeaconAdvDataWithMajor:(NSInteger)major
                                    minor:(NSInteger)minor
                                     uuid:(NSString *)uuid
                                 sucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (major < 0 || major > 65535 || minor < 0 || minor > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(uuid) || uuid.length != 32) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    for (NSInteger i = 0; i < 16; i ++) {
        NSString *tempHex = [uuid substringWithRange:NSMakeRange(i * 2, 2)];
        if (![MKBLEBaseSDKAdopter checkHexCharacter:tempHex]) {
            [self operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *majorHex = [MKBLEBaseSDKAdopter fetchHexValue:major byteLen:2];
    NSString *minorHex = [MKBLEBaseSDKAdopter fetchHexValue:minor byteLen:2];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"50",uuid,majorHex,minorHex];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation commandData:commandString characteristic:peripheral.bxp_advSlotData sucBlock:^(id  _Nonnull returnData) {
        [NSThread sleepForTimeInterval:0.1f];
        if (sucBlock) {
            sucBlock(returnData);
        }
    } failedBlock:failedBlock];
}

+ (void)bxp_configNODATAAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:@"ff"
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configDeviceInfoAdvDataWithDeviceName:(NSString *)deviceName
                                         sucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!deviceName || deviceName.length > 20) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"40" stringByAppendingString:tempString];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_advSlotData
                         sucBlock:^(id  _Nonnull returnData) {
                             [NSThread sleepForTimeInterval:0.1f];
                             if (sucBlock) {
                                 sucBlock(returnData);
                             }
                         } failedBlock:failedBlock];
}

+ (void)bxp_configThreeAxisAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:@"60"
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configHTAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigAdvSlotDataOperation
                          commandData:@"70"
                       characteristic:peripheral.bxp_advSlotData
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configThreeAxisDataParams:(mk_bxp_threeAxisDataRate)dataRate
                         acceleration:(mk_bxp_threeAxisDataAG)acceleration
                          sensitivity:(NSInteger)sensitivity
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (sensitivity < 1 || sensitivity > 255) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [self fetchThreeAxisDataRate:dataRate];
    NSString *ag = [self fetchThreeAxisDataAG:acceleration];
    NSString *sen = [MKBLEBaseSDKAdopter fetchHexValue:sensitivity byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea310003",rate,ag,sen];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigThreeAxisParamsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configDeviceTime:(id <MKBXPDeviceTimeProtocol>)protocol
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validTimeProtocol:protocol]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *hexTime = [self getTimeString:protocol];
    if (!MKValidStr(hexTime)) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ea350006" stringByAppendingString:hexTime];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigDeviceTimeOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configHTStorageConditions:(id <MKBXPHTStorageConditionsProtocol>)protocol
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validHTStorageConditionsProtocol:protocol]) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [self fetchHTStorageConditionsCommand:protocol];
    if (!MKValidStr(commandString)) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigHTStorageConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configHTSamplingRate:(NSInteger)rate
                        sucBlock:(void (^)(id returnData))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rate < 1 || rate > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rateString = [MKBLEBaseSDKAdopter fetchHexValue:rate byteLen:2];
    NSString *commandString = [@"ea330002" stringByAppendingString:rateString];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigHTSamplingRateOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsNoneWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea39000100";
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithTemperature:(BOOL)above
                                       temperature:(NSInteger)temperature
                                  startAdvertising:(BOOL)start
                                          sucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (temperature < -20 || temperature > 90) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [NSString stringWithFormat:@"%lX", (long)(temperature * 10)];
    if (tempString.length == 1) {
        tempString = [@"000" stringByAppendingString:tempString];
    }else if (tempString.length == 2) {
        tempString = [@"00" stringByAppendingString:tempString];
    }else if (tempString.length == 3) {
        tempString = [@"0" stringByAppendingString:tempString];
    }else if (tempString.length > 4) {
        tempString = [tempString substringWithRange:NSMakeRange(tempString.length - 4, 4)];
    }
    NSString *aboveString = (above ? @"01" : @"02");
    NSString *advertising = (start ? @"01" : @"02");
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea39000501",aboveString,tempString,advertising];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithHudimity:(BOOL)above
                                       humidity:(NSInteger)humidity
                               startAdvertising:(BOOL)start
                                       sucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (humidity < 0 || humidity > 100) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = [NSString stringWithFormat:@"%lX", (long)(humidity * 10)];
    if (tempString.length == 1) {
        tempString = [@"000" stringByAppendingString:tempString];
    }else if (tempString.length == 2) {
        tempString = [@"00" stringByAppendingString:tempString];
    }else if (tempString.length == 3) {
        tempString = [@"0" stringByAppendingString:tempString];
    }else if (tempString.length > 4) {
        tempString = [tempString substringWithRange:NSMakeRange(tempString.length - 4, 4)];
    }
    NSString *aboveString = (above ? @"01" : @"02");
    NSString *advertising = (start ? @"01" : @"02");
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea39000502",aboveString,tempString,advertising];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithDoubleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000403",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithTripleTap:(NSInteger)time
                                           start:(BOOL)start
                                        sucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000404",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithMoves:(NSInteger)time
                                       start:(BOOL)start
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000405",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configTriggerConditionsWithAmbientLightDetected:(NSInteger)time
                                                      start:(BOOL)start
                                                   sucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [self operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea39000506",timeString,(time == 0) ? @"00" : @"01",(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigTriggerConditionsOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_deleteBXPRecordHTDatasWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskDeleteRecordHTDataOperation
                          commandData:@"ea240000"
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configButtonPowerStatus:(BOOL)isOn
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea38000101" : @"ea38000100");
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigButtonPowerStatusOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_clearLightSensorDatasWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:mk_bxp_taskDeleteRecordLightSensorDataOperation
                          commandData:@"ea460000"
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configLEDTriggerStatus:(BOOL)isOn
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea57000101" : @"ea57000100");
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigLEDTriggerStatusOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

+ (void)bxp_configResetBeaconByButtonStatus:(BOOL)isOn
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea58000101" : @"ea58000100");
    [centralManager addTaskWithTaskID:mk_bxp_taskConfigResetBeaconByButtonStatusOperation
                          commandData:commandString
                       characteristic:peripheral.bxp_customWrite
                             sucBlock:sucBlock
                          failedBlock:failedBlock];
}

#pragma mark - private method
+ (NSString *)fetchSlotNumber:(mk_bxp_activeSlotNo)slotNo{
    switch (slotNo) {
        case mk_bxp_activeSlot1:
            return @"00";
        case mk_bxp_activeSlot2:
            return @"01";
        case mk_bxp_activeSlot3:
            return @"02";
        case mk_bxp_activeSlot4:
            return @"03";
        case mk_bxp_activeSlot5:
            return @"04";
        case mk_bxp_activeSlot6:
            return @"05";
    }
}

+ (NSString *)fetchTxPower:(mk_bxp_slotRadioTxPower)radioPower{
    switch (radioPower) {
        case mk_bxp_slotRadioTxPower4dBm:
            return @"04";
            
        case mk_bxp_slotRadioTxPower3dBm:
            return @"03";
            
        case mk_bxp_slotRadioTxPower0dBm:
            return @"00";
            
        case mk_bxp_slotRadioTxPowerNeg4dBm:
            return @"fc";
            
        case mk_bxp_slotRadioTxPowerNeg8dBm:
            return @"f8";
            
        case mk_bxp_slotRadioTxPowerNeg12dBm:
            return @"f4";
            
        case mk_bxp_slotRadioTxPowerNeg16dBm:
            return @"f0";
            
        case mk_bxp_slotRadioTxPowerNeg20dBm:
            return @"ec";
            
        case mk_bxp_slotRadioTxPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)fetchThreeAxisDataRate:(mk_bxp_threeAxisDataRate)dataRate {
    switch (dataRate) {
        case mk_bxp_threeAxisDataRate1hz:
            return @"00";
        case mk_bxp_threeAxisDataRate10hz:
            return @"01";
        case mk_bxp_threeAxisDataRate25hz:
            return @"02";
        case mk_bxp_threeAxisDataRate50hz:
            return @"03";
        case mk_bxp_threeAxisDataRate100hz:
            return @"04";
    }
}

+ (NSString *)fetchThreeAxisDataAG:(mk_bxp_threeAxisDataAG)ag {
    switch (ag) {
        case mk_bxp_threeAxisDataAG0:
            return @"00";
        case mk_bxp_threeAxisDataAG1:
            return @"01";
        case mk_bxp_threeAxisDataAG2:
            return @"02";
        case mk_bxp_threeAxisDataAG3:
            return @"03";
    }
}

+ (BOOL)validTimeProtocol:(id <MKBXPDeviceTimeProtocol>)protocol{
    if (!protocol) {
        return NO;
    }
    if (protocol.year < 2000 || protocol.year > 2099) {
        return NO;
    }
    if (protocol.month < 1 || protocol.month > 12) {
        return NO;
    }
    if (protocol.day < 1 || protocol.day > 31) {
        return NO;
    }
    if (protocol.hour < 0 || protocol.hour > 23) {
        return NO;
    }
    if (protocol.minutes < 0 || protocol.minutes > 59) {
        return NO;
    }
    if (protocol.seconds < 0 || protocol.seconds > 59) {
        return NO;
    }
    return YES;
}

+ (NSString *)getTimeString:(id <MKBXPDeviceTimeProtocol>)protocol{
    if (!protocol) {
        return @"";
    }
    
    unsigned long yearValue = protocol.year - 2000;
    NSString *yearString = [MKBLEBaseSDKAdopter fetchHexValue:yearValue byteLen:1];
    NSString *monthString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.month byteLen:1];
    NSString *dayString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.day byteLen:1];
    NSString *hourString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.hour byteLen:1];
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minutes byteLen:1];
    NSString *secString = [MKBLEBaseSDKAdopter fetchHexValue:protocol.seconds byteLen:1];
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minString,secString];
}

+ (BOOL)validHTStorageConditionsProtocol:(id <MKBXPHTStorageConditionsProtocol>)protocol {
    if (!protocol) {
        return NO;
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsT) {
        if (protocol.temperature < 0 || protocol.temperature > 1000) {
            return NO;
        }
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsH) {
        if (protocol.humidity < 0 || protocol.humidity > 1000) {
            return NO;
        }
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsTH) {
        if (protocol.temperature < 0 || protocol.temperature > 1000) {
            return NO;
        }
        if (protocol.humidity < 0 || protocol.humidity > 1000) {
            return NO;
        }
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsTime) {
        if (protocol.time < 1 || protocol.time > 255) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)fetchHTStorageConditionsCommand:(id<MKBXPHTStorageConditionsProtocol>)protocol {
    if (protocol.condition == mk_bxp_HTStorageConditionsT) {
        NSString *temper = [MKBLEBaseSDKAdopter fetchHexValue:protocol.temperature byteLen:2];
        return [@"ea32000300" stringByAppendingString:temper];
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsH) {
        NSString *humi = [MKBLEBaseSDKAdopter fetchHexValue:protocol.humidity byteLen:2];
        return [@"ea32000301" stringByAppendingString:humi];
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsTH) {
        NSString *temper = [MKBLEBaseSDKAdopter fetchHexValue:protocol.temperature byteLen:2];
        NSString *humi = [MKBLEBaseSDKAdopter fetchHexValue:protocol.humidity byteLen:2];
        return [NSString stringWithFormat:@"%@%@%@",@"ea32000502",temper,humi];
    }
    if (protocol.condition == mk_bxp_HTStorageConditionsTime) {
        NSString *time = [MKBLEBaseSDKAdopter fetchHexValue:protocol.time byteLen:1];
        return [@"ea32000203" stringByAppendingString:time];
    }
    return @"";
}

+ (void)delaySuccessMethod:(void (^)(id returnData))sucBlock returnData:(id)returnData{
    if (sucBlock) {
        sucBlock(returnData);
    }
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-999 message:@"Params error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block{
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [MKBLEBaseSDKAdopter getErrorWithCode:-10001 message:@"Set parameter error"];
            block(error);
        }
    });
}

@end
