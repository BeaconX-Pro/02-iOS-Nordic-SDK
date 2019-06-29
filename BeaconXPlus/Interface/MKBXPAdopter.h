//
//  MKBXPAdopter.h
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 自定义的错误码
 */
typedef NS_ENUM(NSInteger, MKCustomErrorCode){
    MKBlueDisable = -10000,                                     //当前手机蓝牙不可用
    MKConnectedFailed = -10001,                                 //连接外设失败
    MKPeripheralDisconnected = -10002,                          //当前外部连接的设备处于断开状态
    MKCharacteristicError = -10003,                             //特征为空
    MKRequestPeripheralDataError = -10004,                      //请求数据出错
    MKParamsError = -10005,                                     //输入的参数有误
    MKSetParamsError = -10006,                                  //设置参数出错
    MKBeaconPasswordError = -10007,                             //连接密码错误
    MKCommunicationTimeout = -10008,                             //通信超时
    MKEddystoneLocked = -10009,                                  //处于锁定状态
    MKEddystoneCannotReconnect = -10010,                         //如果正在处于连接流程，不允许新的连接
};

@interface MKBXPAdopter : NSObject
#pragma mark - block
+ (NSError *)getErrorWithCode:(MKCustomErrorCode)code message:(NSString *)message;
+ (void)operationCentralBlePowerOffBlock:(void (^)(NSError *error))block;
+ (void)operationConnectFailedBlock:(void (^)(NSError *error))block;
+ (void)operationDisconnectedErrorBlock:(void (^)(NSError *error))block;
+ (void)operationCharacteristicErrorBlock:(void (^)(NSError *error))block;
+ (void)operationRequestDataErrorBlock:(void (^)(NSError *error))block;
+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block;
+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block;
+ (void)operationPasswordErrorBlock:(void (^)(NSError *error))block;
+ (void)operationLockedErrorBlock:(void (^)(NSError *error))block;
+ (void)operationCannotReconnectErrorBlock:(void (^)(NSError *errro))block;

#pragma mark -
+ (BOOL)isPassword:(NSString *)password;
+ (BOOL)checkDeviceName:(NSString *)deviceName;
+ (BOOL)isNameSpace:(NSString *)nameSpace;
+ (BOOL)isInstanceID:(NSString *)instanceID;
+ (BOOL)isUUIDString:(NSString *)uuid;
+ (BOOL)checkUrlContent:(NSString *)urlContent;
+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range;
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range;
+ (NSData *)stringToData:(NSString *)dataString;
+ (NSString *)hexStringFromData:(NSData *)sourceData;
+ (NSData*)AES128EncryptWithSourceData:(NSData *)sourceData keyData:(NSData *)keyData;
+ (NSString *)getUrlscheme:(char)hexChar;
+ (NSString *)getEncodedString:(char)hexChar;
+ (NSData *)fetchKeyToUnlockWithPassword:(NSString *)password randKey:(NSData *)randKey;
+ (NSString *)fetchUrlStringWithHeader:(NSString *)urlHeader urlContent:(NSString *)urlContent;
+ (NSString *)fetchTxPowerWithContent:(NSString *)content;
+ (NSNumber *)fetchRSSIWithContent:(NSData *)contentData;
+ (NSString *)hexStringFromSignedNumber:(NSInteger)number;

/**
 有符号16进制转10进制

 @param content signed number
 @return number
 */
+ (NSNumber *)signedHexTurnString:(NSString *)content;
+ (NSString *)deviceTime:(NSString *)content;

@end
