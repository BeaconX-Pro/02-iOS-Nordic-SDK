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
#import "MKEddystoneAdopter.h"
#import "MKEddystoneDefines.h"

#define centralManager [MKBXPCentralManager shared]

@implementation MKBXPInterface (MKConfig)

+ (void)setBXPNewPassword:(NSString *)newPassword
         originalPassword:(NSString *)originalPassword
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (![MKEddystoneAdopter isPassword:newPassword] || ![MKEddystoneAdopter isPassword:originalPassword]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    //写入0x00加上16字节新的密码（用户要对新的密码进行加密，然后发送，加密的密钥是旧的密码，也就是当前密码），发送之后，设备变为LOCKED状态。
    NSString *oldTempString = @"";
    for (NSInteger i = 0; i < originalPassword.length; i ++) {
        int asciiCode = [originalPassword characterAtIndex:i];
        oldTempString = [oldTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *oldPasswordData = [MKEddystoneAdopter stringToData:oldTempString];
    NSString *newTempString = @"";
    for (NSInteger i = 0; i < newPassword.length; i ++) {
        int asciiCode = [newPassword characterAtIndex:i];
        newTempString = [newTempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *newPasswordData = [MKEddystoneAdopter stringToData:newTempString];
    Byte byte[16] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    NSData *oldSupplyData = [NSData dataWithBytes:byte length:(16 - oldPasswordData.length)];
    NSData *newSupplyData = [NSData dataWithBytes:byte length:(16 - newPasswordData.length)];
    
    NSMutableData *oldData = [[NSMutableData alloc] init];
    [oldData appendData:oldPasswordData];
    [oldData appendData:oldSupplyData];
    
    NSMutableData *newData = [[NSMutableData alloc] init];
    [newData appendData:newPasswordData];
    [newData appendData:newSupplyData];
    
    NSData *encryptData = [MKEddystoneAdopter AES128EncryptWithSourceData:newData keyData:oldData];
    if (!MKValidData(encryptData) || encryptData.length != 16) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSMutableData *commandData = [[NSMutableData alloc] init];
    Byte headerB[1] = {0x00};
    [commandData appendData:[NSData dataWithBytes:headerB length:1]];
    [commandData appendData:encryptData];
    [centralManager addTaskWithTaskID:MKBXPSetLockStateOperation
                          commandData:[MKEddystoneAdopter hexStringFromData:commandData]
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
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *advPower = [MKEddystoneAdopter hexStringFromSignedNumber:advTxPower];
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
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
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
    if (![MKEddystoneAdopter isNameSpace:nameSpace] || ![MKEddystoneAdopter isInstanceID:instanceID]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
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
    if (![MKEddystoneAdopter checkUrlContent:urlContent]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
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
    NSString *urlString = [MKEddystoneAdopter fetchUrlStringWithHeader:tempHeader urlContent:urlContent];
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
    if (major < 0 || major > 65535 || minor < 0 || minor > 65535 || ![MKEddystoneAdopter isUUIDString:uuid]) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
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
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:commandString
                       characteristic:centralManager.peripheral.advSlotData
                         successBlock:sucBlock
                         failureBlock:failedBlock];
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
    if (!ValidStr(deviceName) || deviceName.length > 20) {
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
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
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)setBXPThreeAxisAdvData:(BOOL)advertising
                      sucBlock:(void (^)(id returnData))sucBlock
                   failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:MKBXPSetAdvSlotDataOperation
                          commandData:(advertising ? @"60" : @"ff")
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
        [MKEddystoneAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [self fetchThreeAxisDataRate:dataRate];
    NSString *ag = [self fetchThreeAxisDataAG:acceleration];
    NSString *sen = [NSString stringWithFormat:@"%1lx",(unsigned long)sensitivity];
    if (sen.length == 1) {
        sen = [@"0" stringByAppendingString:sen];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea210003",rate,ag,sen];
    [centralManager addTaskWithTaskID:MKBXPSetThreeAxisParamsOperation
                          commandData:commandString
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

@end
