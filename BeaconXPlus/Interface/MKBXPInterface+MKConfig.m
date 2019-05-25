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

@end
