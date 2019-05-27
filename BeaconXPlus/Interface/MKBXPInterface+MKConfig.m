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

@end
