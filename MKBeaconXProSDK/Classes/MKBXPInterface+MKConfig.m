//
//  MKBXPInterface+MKConfig.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPInterface+MKConfig.h"
#import "CBPeripheral+MKAdd.h"
#import "MKBXPCentralManager.h"
#import "MKBXPEnumeration.h"
#import "MKBXPTaskOperation.h"
#import "MKBXPOperationIDDefines.h"
#import "MKBXPAdopter.h"
#import "MKBXPDefines.h"

#define centralManager [MKBXPCentralManager shared]

@implementation MKBXPInterface (MKConfig)

+ (void)setBXPNewPassword:(NSString *)newPassword
         originalPassword:(NSString *)originalPassword
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter isPassword:newPassword] || ![MKBXPAdopter isPassword:originalPassword]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    //写入0x00加上16字节新的密码（用户要对新的密码进行加密，然后发送，加密的密钥是旧的密码，也就是当前密码），发送之后，设备变为LOCKED状态。
    NSString *oldTempString = @"";
    for (NSInteger i = 0; i < originalPassword.length; i ++) {
        int asciiCode = [originalPassword characterAtIndex:i];
        oldTempString = [oldTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *oldPasswordData = [MKBXPAdopter stringToData:oldTempString];
    NSString *newTempString = @"";
    for (NSInteger i = 0; i < newPassword.length; i ++) {
        int asciiCode = [newPassword characterAtIndex:i];
        newTempString = [newTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *newPasswordData = [MKBXPAdopter stringToData:newTempString];
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
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSMutableData *commandData = [[NSMutableData alloc] init];
    Byte headerB[1] = {0x00};
    [commandData appendData:[NSData dataWithBytes:headerB length:1]];
    [commandData appendData:encryptData];
    [centralManager addTaskWithTaskID:MKBXPSetLockStateOperation
                          commandData:[MKBXPAdopter hexStringFromData:commandData]
                       characteristic:centralManager.peripheral.lockState
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)BXPFactoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetFactoryResetOperation
                          commandData:@"0b"
                       characteristic:centralManager.peripheral.factoryReset
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPLockState:(MKBXPLockState)lockState
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"00";
    if (lockState == MKBXPLockStateOpen) {
        commandString = @"01";
    }else if (lockState == MKBXPLockStateUnlockAutoMaticRelockDisabled){
        commandString = @"02";
    }
    [centralManager addTaskWithTaskID:MKBXPSetLockStateOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.lockState
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPPowerOffWithSucBlockWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetPowerOffOperation
                          commandData:@"ea260000"
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPConnectStatus:(BOOL)connectEnable
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetConnectEnableOperation
                          commandData:(connectEnable ? @"01" : @"00")
                       characteristic:centralManager.peripheral.remainConnectable
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPActiveSlot:(bxpActiveSlotNo)slotNo
                sucBlock:(void (^)(id returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *slotNumber = [self fetchSlotNumber:slotNo];
    [centralManager addTaskWithTaskID:MKBXPSetActiveSlotOperation
                          commandData:slotNumber
                       characteristic:centralManager.peripheral.activeSlot
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPAdvTxPower:(NSInteger)advTxPower
                sucBlock:(void (^)(id returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (advTxPower < -100 || advTxPower > 20) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *advPower = [MKBXPAdopter hexStringFromSignedNumber:advTxPower];
    [centralManager addTaskWithTaskID:MKBXPSetAdvTxPowerOperation
                          commandData:advPower
                       characteristic:centralManager.peripheral.advertisedTxPower
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPRadioTxPower:(slotRadioTxPower)power
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [self fetchTxPower:power];
    [centralManager addTaskWithTaskID:MKBXPSetRadioTxPowerOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.radioTxPower
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPAdvInterval:(NSInteger)interval
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *advInterval = [NSString stringWithFormat:@"%1lx",(unsigned long)(interval * 100)];
    if (advInterval.length == 2) {
        advInterval = [@"00" stringByAppendingString:advInterval];
    }else if (advInterval.length == 3) {
        advInterval = [@"0" stringByAppendingString:advInterval];
    }
    [centralManager addTaskWithTaskID:MKBXPSetAdvertisingIntervalOperation
                          commandData:advInterval
                       characteristic:centralManager.peripheral.advertisingInterval
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTLMAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:@"20"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPUIDAdvDataWithNameSpace:(NSString *)nameSpace
                           instanceID:(NSString *)instanceID
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter isNameSpace:nameSpace] || ![MKBXPAdopter isInstanceID:instanceID]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"00",nameSpace,instanceID];
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPURLAdvData:(urlHeaderType )urlHeader
              urlContent:(NSString *)urlContent
                sucBlock:(void (^)(id returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKBXPAdopter checkUrlContent:urlContent]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *header = @"";
    NSString *tempHeader = @"";
    if (urlHeader == urlHeaderType1) {
        header = @"00";
        tempHeader = @"http://www.";
    }else if (urlHeader == urlHeaderType2){
        header = @"01";
        tempHeader = @"https://www.";
    }else if (urlHeader == urlHeaderType3){
        header = @"02";
        tempHeader = @"http://";
    }else if (urlHeader == urlHeaderType4){
        header = @"03";
        tempHeader = @"https://";
    }
    NSString *urlString = [MKBXPAdopter fetchUrlStringWithHeader:tempHeader urlContent:urlContent];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"10",header,urlString];
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPiBeaconAdvDataWithMajor:(NSInteger)major
                                minor:(NSInteger)minor
                                 uuid:(NSString *)uuid
                             sucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (major < 0 || major > 65535 || minor < 0 || minor > 65535 || ![MKBXPAdopter isUUIDString:uuid]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *majorHex = [NSString stringWithFormat:@"%1lx",(unsigned long)major];
    if (majorHex.length == 1) {
        majorHex = [@"000" stringByAppendingString:majorHex];
    }else if (majorHex.length == 2){
        majorHex = [@"00" stringByAppendingString:majorHex];
    }else if (majorHex.length == 3){
        majorHex = [@"0" stringByAppendingString:majorHex];
    }
    NSString *minorHex = [NSString stringWithFormat:@"%1lx",(unsigned long)minor];
    if (minorHex.length == 1) {
        minorHex = [@"000" stringByAppendingString:minorHex];
    }else if (minorHex.length == 2){
        minorHex = [@"00" stringByAppendingString:minorHex];
    }else if (minorHex.length == 3){
        minorHex = [@"0" stringByAppendingString:minorHex];
    }
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"50",uuid,majorHex,minorHex];
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation commandData:commandString characteristic:centralManager.peripheral.advSlotData successBlock:^(id  _Nonnull returnData) {
        [NSThread sleepForTimeInterval:0.1f];
        if (sucBlock) {
            sucBlock(returnData);
        }
    } failureBlock:failedBlock];
}

+ (void)setBXPNODATAAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:@"ff"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPDeviceInfoAdvDataWithDeviceName:(NSString *)deviceName
                                     sucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (!deviceName || deviceName.length > 20) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"40" stringByAppendingString:tempString];
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:^(id  _Nonnull returnData) {
                             [NSThread sleepForTimeInterval:0.1f];
                             if (sucBlock) {
                                 sucBlock(returnData);
                             }
                         } failureBlock:failedBlock];
}

+ (void)setBXPThreeAxisAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:@"60"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

/**
 设置当前通道为温湿度数据通道
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPHTAdvDataWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:@"70"
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPThreeAxisDataParams:(threeAxisDataRate)dataRate
                     acceleration:(threeAxisDataAG)acceleration
                      sensitivity:(NSInteger)sensitivity
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (sensitivity < 7 || sensitivity > 255) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [self fetchThreeAxisDataRate:dataRate];
    NSString *ag = [self fetchThreeAxisDataAG:acceleration];
    NSString *sen = [NSString stringWithFormat:@"%1lx",(unsigned long)sensitivity];
    if (sen.length == 1) {
        sen = [@"0" stringByAppendingString:sen];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea310003",rate,ag,sen];
    [centralManager addTaskWithTaskID:MKBXPSetThreeAxisParamsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPDeviceTime:(id <MKBXPDeviceTimeProtocol>)protocol
                sucBlock:(void (^)(id returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validTimeProtocol:protocol]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *hexTime = [self getTimeString:protocol];
    if (!MKValidStr(hexTime)) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ea350006" stringByAppendingString:hexTime];
    [centralManager addTaskWithTaskID:MKBXPSetDeviceTimeOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPHTStorageConditions:(id <MKBXPHTStorageConditionsProtocol>)protocol
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (![self validHTStorageConditionsProtocol:protocol]) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [self fetchHTStorageConditionsCommand:protocol];
    if (!MKValidStr(commandString)) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    [centralManager addTaskWithTaskID:MKBXPSetHTStorageConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPHTSamplingRate:(NSInteger)rate
                    sucBlock:(void (^)(id returnData))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (rate < 1 || rate > 65535) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rateString = [NSString stringWithFormat:@"%1lx",(unsigned long)rate];
    if (rateString.length == 1) {
        rateString = [@"000" stringByAppendingString:rateString];
    }else if (rateString.length == 2) {
        rateString = [@"00" stringByAppendingString:rateString];
    }else if (rateString.length == 3) {
        rateString = [@"0" stringByAppendingString:rateString];
    }
    NSString *commandString = [@"ea330002" stringByAppendingString:rateString];
    [centralManager addTaskWithTaskID:MKBXPSetHTSamplingRateOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsNoneWithSuccessBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea39000100";
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsWithTemperature:(BOOL)above
                                   temperature:(NSInteger)temperature
                              startAdvertising:(BOOL)start
                                      sucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (temperature < -20 || temperature > 90) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
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
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsWithHudimity:(BOOL)above
                                   humidity:(NSInteger)humidity
                           startAdvertising:(BOOL)start
                                   sucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (humidity < 0 || humidity > 100) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
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
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsWithDoubleTap:(NSInteger)time
                                       start:(BOOL)start
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock{
    if (time < 0 || time > 65535) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%1lx",(unsigned long)time];
    if (timeString.length == 1) {
        timeString = [@"000" stringByAppendingString:timeString];
    }else if (timeString.length == 2) {
        timeString = [@"00" stringByAppendingString:timeString];
    }else if (timeString.length == 3) {
        timeString = [@"0" stringByAppendingString:timeString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000403",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsWithTripleTap:(NSInteger)time
                                       start:(BOOL)start
                                    sucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%1lx",(unsigned long)time];
    if (timeString.length == 1) {
        timeString = [@"000" stringByAppendingString:timeString];
    }else if (timeString.length == 2) {
        timeString = [@"00" stringByAppendingString:timeString];
    }else if (timeString.length == 3) {
        timeString = [@"0" stringByAppendingString:timeString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000404",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPTriggerConditionsWithMoves:(NSInteger)time
                                   start:(BOOL)start
                                sucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 0 || time > 65535) {
        [MKBXPAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%1lx",(unsigned long)time];
    if (timeString.length == 1) {
        timeString = [@"000" stringByAppendingString:timeString];
    }else if (timeString.length == 2) {
        timeString = [@"00" stringByAppendingString:timeString];
    }else if (timeString.length == 3) {
        timeString = [@"0" stringByAppendingString:timeString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea39000405",timeString,(start ? @"01" : @"02")];
    [centralManager addTaskWithTaskID:MKBXPSetTriggerConditionsOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)deleteBXPRecordHTDatasWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPDeleteRecordHTDataOperation
                          commandData:@"ea240000"
                       characteristic:centralManager.peripheral.iBeaconWrite
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

#pragma mark - private method
+ (NSString *)fetchSlotNumber:(bxpActiveSlotNo)slotNo{
    switch (slotNo) {
        case bxpActiveSlot1:
            return @"00";
        case bxpActiveSlot2:
            return @"01";
        case bxpActiveSlot3:
            return @"02";
        case bxpActiveSlot4:
            return @"03";
        case bxpActiveSlot5:
            return @"04";
        case bxpActiveSlot6:
            return @"05";
    }
}

+ (NSString *)fetchTxPower:(slotRadioTxPower)radioPower{
    switch (radioPower) {
        case slotRadioTxPower4dBm:
            return @"04";
            
        case slotRadioTxPower3dBm:
            return @"03";
            
        case slotRadioTxPower0dBm:
            return @"00";
            
        case slotRadioTxPowerNeg4dBm:
            return @"fc";
            
        case slotRadioTxPowerNeg8dBm:
            return @"f8";
            
        case slotRadioTxPowerNeg12dBm:
            return @"f4";
            
        case slotRadioTxPowerNeg16dBm:
            return @"f0";
            
        case slotRadioTxPowerNeg20dBm:
            return @"ec";
            
        case slotRadioTxPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)fetchThreeAxisDataRate:(threeAxisDataRate)dataRate {
    switch (dataRate) {
        case threeAxisDataRate1hz:
            return @"00";
        case threeAxisDataRate10hz:
            return @"01";
        case threeAxisDataRate25hz:
            return @"02";
        case threeAxisDataRate50hz:
            return @"03";
        case threeAxisDataRate100hz:
            return @"04";
    }
}

+ (NSString *)fetchThreeAxisDataAG:(threeAxisDataAG)ag {
    switch (ag) {
        case threeAxisDataAG0:
            return @"00";
        case threeAxisDataAG1:
            return @"01";
        case threeAxisDataAG2:
            return @"02";
        case threeAxisDataAG3:
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
        return nil;
    }
    
    unsigned long yearValue = protocol.year - 2000;
    NSString *yearString = [NSString stringWithFormat:@"%1lx",yearValue];
    if (yearString.length == 1) {
        yearString = [@"0" stringByAppendingString:yearString];
    }
    NSString *monthString = [NSString stringWithFormat:@"%1lx",(long)protocol.month];
    if (monthString.length == 1) {
        monthString = [@"0" stringByAppendingString:monthString];
    }
    NSString *dayString = [NSString stringWithFormat:@"%1lx",(long)protocol.day];
    if (dayString.length == 1) {
        dayString = [@"0" stringByAppendingString:dayString];
    }
    NSString *hourString = [NSString stringWithFormat:@"%1lx",(long)protocol.hour];
    if (hourString.length == 1) {
        hourString = [@"0" stringByAppendingString:hourString];
    }
    NSString *minString = [NSString stringWithFormat:@"%1lx",(long)protocol.minutes];
    if (minString.length == 1) {
        minString = [@"0" stringByAppendingString:minString];
    }
    NSString *secString = [NSString stringWithFormat:@"%1lx",(long)protocol.seconds];
    if (secString.length == 1) {
        secString = [@"0" stringByAppendingString:secString];
    }
    return [NSString stringWithFormat:@"%@%@%@%@%@%@",yearString,monthString,dayString,hourString,minString,secString];
}

+ (BOOL)validHTStorageConditionsProtocol:(id <MKBXPHTStorageConditionsProtocol>)protocol {
    if (!protocol) {
        return NO;
    }
    if (protocol.condition == HTStorageConditionsT) {
        if (protocol.temperature < 0 || protocol.temperature > 1000) {
            return NO;
        }
    }
    if (protocol.condition == HTStorageConditionsH) {
        if (protocol.humidity < 0 || protocol.humidity > 1000) {
            return NO;
        }
    }
    if (protocol.condition == HTStorageConditionsTH) {
        if (protocol.temperature < 0 || protocol.temperature > 1000) {
            return NO;
        }
        if (protocol.humidity < 0 || protocol.humidity > 1000) {
            return NO;
        }
    }
    if (protocol.condition == HTStorageConditionsTime) {
        if (protocol.time < 1 || protocol.time > 255) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)fetchHTStorageConditionsCommand:(id<MKBXPHTStorageConditionsProtocol>)protocol {
    if (protocol.condition == HTStorageConditionsT) {
        NSString *temper = [NSString stringWithFormat:@"%1lx",(long)(protocol.temperature)];
        if (temper.length == 1) {
            temper = [@"000" stringByAppendingString:temper];
        }else if (temper.length == 2) {
            temper = [@"00" stringByAppendingString:temper];
        }else if (temper.length == 3) {
            temper = [@"0" stringByAppendingString:temper];
        }
        return [@"ea32000300" stringByAppendingString:temper];
    }
    if (protocol.condition == HTStorageConditionsH) {
        NSString *humi = [NSString stringWithFormat:@"%1lx",(long)(protocol.humidity)];
        if (humi.length == 1) {
            humi = [@"000" stringByAppendingString:humi];
        }else if (humi.length == 2) {
            humi = [@"00" stringByAppendingString:humi];
        }else if (humi.length == 3) {
            humi = [@"0" stringByAppendingString:humi];
        }
        return [@"ea32000301" stringByAppendingString:humi];
    }
    if (protocol.condition == HTStorageConditionsTH) {
        NSString *temper = [NSString stringWithFormat:@"%1lx",(long)(protocol.temperature)];
        if (temper.length == 1) {
            temper = [@"000" stringByAppendingString:temper];
        }else if (temper.length == 2) {
            temper = [@"00" stringByAppendingString:temper];
        }else if (temper.length == 3) {
            temper = [@"0" stringByAppendingString:temper];
        }
        NSString *humi = [NSString stringWithFormat:@"%1lx",(long)(protocol.humidity)];
        if (humi.length == 1) {
            humi = [@"000" stringByAppendingString:humi];
        }else if (humi.length == 2) {
            humi = [@"00" stringByAppendingString:humi];
        }else if (humi.length == 3) {
            humi = [@"0" stringByAppendingString:humi];
        }
        return [NSString stringWithFormat:@"%@%@%@",@"ea32000502",temper,humi];
    }
    if (protocol.condition == HTStorageConditionsTime) {
        NSString *time = [NSString stringWithFormat:@"%1lx",(long)protocol.time];
        if (time.length == 1) {
            time = [@"0" stringByAppendingString:time];
        }
        return [@"ea32000203" stringByAppendingString:time];
    }
    return @"";
}

+ (void)delaySuccessMethod:(void (^)(id returnData))sucBlock returnData:(id)returnData{
    if (sucBlock) {
        sucBlock(returnData);
    }
}

@end
