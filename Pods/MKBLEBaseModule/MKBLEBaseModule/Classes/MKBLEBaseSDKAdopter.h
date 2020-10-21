//
//  MKBLEBaseSDKAdopter.h
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBLEBaseSDKAdopter : NSObject

+ (NSError *)getErrorWithCode:(NSInteger)code message:(NSString *)message;
+ (void)operationCentralBlePowerOffBlock:(void (^)(NSError *error))block;
+ (void)operationConnectFailedBlock:(void (^)(NSError *error))block;
+ (void)operationConnectingErrorBlock:(void (^)(NSError *error))block;
+ (void)operationProtocolErrorBlock:(void (^)(NSError *error))block;

/// 将16进制字符串content指定位置的字符串转换成10进制数字
/// @param content 16进制字符串
/// @param range 要转换的位置
+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range;

/// 将16进制字符串content指定位置的字符串转换成10进制字符串
/// @param content 16进制字符串
/// @param range 要转换的位置
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range;

/// 有符号10进制转16进制字符串
/// @param number number
+ (NSString *)hexStringFromSignedNumber:(NSInteger)number;

/**
 有符号16进制转10进制

 @param content signed number
 @return number
 */
+ (NSNumber *)signedHexTurnString:(NSString *)content;

/// 获取CRC16校验码
/// @param data data
+ (NSData *)getCrc16VerifyCode:(NSData *)data;

/// 将NSData转换成对应的16进制字符
/// @param sourceData sourceData
+ (NSString *)hexStringFromData:(NSData *)sourceData;

/// 将十六进制字符转换成对应的NSData
/// @param dataString dataString
+ (NSData *)stringToData:(NSString *)dataString;

/// 判断一个字符是否是16进制字符
/// @param character character
+ (BOOL)checkHexCharacter:(NSString *)character;

/**
 将一个字节的16进制数据转成8位2进制
 
 @param hex 需要转换的16进制数据
 @return 转换后的8位2进制数据
 */
+ (NSString *)binaryByhex:(NSString *)hex;

/// 判断一个string是否全部是ascii码
/// @param content content
+ (BOOL)asciiString:(NSString *)content;

/// 判断某个字符串是不是uuid
/// @param uuid [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
+ (BOOL)isUUIDString:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
