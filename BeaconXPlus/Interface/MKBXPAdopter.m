//
//  MKBXPAdopter.m
//  EddystoneSDK
//
//  Created by aa on 2018/8/9.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKBXPAdopter.h"
#import <CommonCrypto/CommonCryptor.h>
#import "MKBXPDefines.h"

static NSString * const MKCustomErrorDomain = @"com.moko.eddystoneSDKDomain";

@implementation MKBXPAdopter

#pragma mark - blocks
+ (NSError *)getErrorWithCode:(MKCustomErrorCode)code message:(NSString *)message{
    NSError *error = [[NSError alloc] initWithDomain:MKCustomErrorDomain
                                                code:code
                                            userInfo:@{@"errorInfo":message}];
    return error;
}

+ (void)operationCentralBlePowerOffBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKBlueDisable message:@"mobile phone bluetooth is currently unavailable"];
            block(error);
        }
    });
}

+ (void)operationConnectFailedBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKConnectedFailed message:@"Connect Failed"];
            block(error);
        }
    });
}

+ (void)operationDisconnectedErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKPeripheralDisconnected message:@"the current connection device is in disconnect"];
            block(error);
        }
    });
}

+ (void)operationCharacteristicErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKCharacteristicError message:@"characteristic error"];
            block(error);
        }
    });
}

+ (void)operationRequestDataErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKRequestPeripheralDataError message:@"request data error"];
            block(error);
        }
    });
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKParamsError message:@"input parameter error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKSetParamsError message:@"set parameter error"];
            block(error);
        }
    });
}

+ (void)operationPasswordErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKBeaconPasswordError message:@"password error"];
            block(error);
        }
    });
}

+ (void)operationLockedErrorBlock:(void (^)(NSError *error))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKEddystoneLocked message:@"The device is locked"];
            block(error);
        }
    });
}

+ (void)operationCannotReconnectErrorBlock:(void (^)(NSError *errro))block{
    moko_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:MKEddystoneCannotReconnect message:@"Is connection, cannot undertake a new connection"];
            block(error);
        }
    });
}

#pragma mark -

+ (BOOL)isPassword:(NSString *)password{
    if (!MKValidStr(password) || password.length > 16) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkDeviceName:(NSString *)deviceName{
    NSString *regex = @"^[a-zA-Z0-9_]{8}$$";
    NSPredicate *namePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [namePre evaluateWithObject:deviceName];
}

+ (BOOL)checkUrl:(NSString *)url{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}

+ (BOOL)isNameSpace:(NSString *)nameSpace{
    NSString *regex = @"^[a-fA-F0-9]{20}$$";
    NSPredicate *nameSpacePre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [nameSpacePre evaluateWithObject:nameSpace];
}

+ (BOOL)isInstanceID:(NSString *)instanceID{
    NSString *regex = @"^[a-fA-F0-9]{12}$$";
    NSPredicate *instanceIDPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [instanceIDPre evaluateWithObject:instanceID];
}

+ (BOOL)isUUIDString:(NSString *)uuid{
    NSString *uuidPatternString = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:uuidPatternString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:uuid
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, uuid.length)];
    return (numberOfMatches > 0);
}

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range{
    if (!MKValidStr(content)) {
        return 0;
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return 0;
    }
    return strtoul([[content substringWithRange:range] UTF8String],0,16);
}

+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range{
    if (!MKValidStr(content)) {
        return @"";
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return @"";
    }
    NSInteger decimalValue = strtoul([[content substringWithRange:range] UTF8String],0,16);
    return [NSString stringWithFormat:@"%ld",(long)decimalValue];
}

+ (NSData *)stringToData:(NSString *)dataString{
    if (!MKValidStr(dataString)) {
        return nil;
    }
    if (!(dataString.length % 2 == 0)) {
        //必须是偶数个字符才是合法的
        return nil;
    }
    Byte bytes[255] = {0};
    NSInteger count = 0;
    for (int i =0; i < dataString.length; i+=2) {
        NSString *strByte = [dataString substringWithRange:NSMakeRange(i,2)];
        unsigned long red = strtoul([strByte UTF8String],0,16);
        Byte b =  (Byte) ((0xff & red) );//( Byte) 0xff&iByte;
        bytes[i/2+0] = b;
        count ++;
    }
    NSData * data = [NSData dataWithBytes:bytes length:count];
    return data;
}

+ (NSString *)hexStringFromData:(NSData *)sourceData{
    if (!MKValidData(sourceData)) {
        return nil;
    }
    Byte *bytes = (Byte *)[sourceData bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[sourceData length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

/**
 AES加密

 @param sourceData 要加密的数据
 @param keyData keyData
 @return data
 */
+ (NSData*)AES128EncryptWithSourceData:(NSData *)sourceData keyData:(NSData *)keyData{
    if (!MKValidData(keyData) || keyData.length != 16) {
        return nil;
    }
    NSMutableData *mutableData = [NSMutableData dataWithData:sourceData];
    
    NSUInteger dataLength = [mutableData length];
    int excess = dataLength % 16;
    if(excess) {
        int padding = 16 - excess;
        [mutableData increaseLengthBy:padding];
        dataLength += padding;
    }
    NSMutableData *returnData = [[NSMutableData alloc] init];
    int bufferSize = 16;
    int start = 0;
    int i = 0;
    while(start < dataLength)
        {
        i++;
        void *buffer = malloc(bufferSize);
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                              kCCAlgorithmAES128, 0,
                                              keyData.bytes,
                                              kCCKeySizeAES128,
                                              NULL,
                                              [[mutableData subdataWithRange:NSMakeRange(start, bufferSize)] bytes], bufferSize,
                                              buffer,
                                              bufferSize,
                                              &numBytesDecrypted);
        if (cryptStatus == kCCSuccess) {
            NSData *piece = [NSData dataWithBytes:buffer length:numBytesDecrypted];
            [returnData appendData:piece];
        }
        free(buffer);
        start += bufferSize;
        }
    return returnData;
}

+ (NSString *)getUrlscheme:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @"http://www.";
        case 0x01:
            return @"https://www.";
        case 0x02:
            return @"http://";
        case 0x03:
            return @"https://";
        default:
            return nil;
    }
}

+ (NSString *)getEncodedString:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @".com/";
        case 0x01:
            return @".org/";
        case 0x02:
            return @".edu/";
        case 0x03:
            return @".net/";
        case 0x04:
            return @".info/";
        case 0x05:
            return @".biz/";
        case 0x06:
            return @".gov/";
        case 0x07:
            return @".com";
        case 0x08:
            return @".org";
        case 0x09:
            return @".edu";
        case 0x0a:
            return @".net";
        case 0x0b:
            return @".info";
        case 0x0c:
            return @".biz";
        case 0x0d:
            return @".gov";
        default:
            return [NSString stringWithFormat:@"%c", hexChar];
    }
}

+ (NSData *)fetchKeyToUnlockWithPassword:(NSString *)password randKey:(NSData *)randKey{
    if (!MKValidStr(password) || password.length > 16 || !MKValidData(randKey) || randKey.length != 16) {
        return nil;
    }
    Byte byte[16] = {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
    NSString *tempString = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSData *passwordData = [self stringToData:tempString];
    NSData *supplement = [NSData dataWithBytes:byte length:(16 - passwordData.length)];
    NSMutableData *aesKeyData = [[NSMutableData alloc] init];
    [aesKeyData appendData:passwordData];
    [aesKeyData appendData:supplement];
    NSData *encryptData = [self AES128EncryptWithSourceData:randKey keyData:aesKeyData];
    return encryptData;
}

+ (BOOL)checkUrlContent:(NSString *)urlContent{
    if (!MKValidStr(urlContent)) {
        return NO;
    }
    NSArray *contentList = @[@".com/",@".org/",@".edu/",@".net/",@".info/",@".biz/",@".gov/",@".com",@".org",@".edu",@".net",@".info",@".biz",@".gov"];
    return ![contentList containsObject:urlContent];
}

+ (NSString *)fetchUrlStringWithHeader:(NSString *)urlHeader urlContent:(NSString *)urlContent{
    NSString *url = [urlHeader stringByAppendingString:urlContent];
    if ([self checkUrl:url]) {
        //合法的url
        return [self getUrlIllegalContent:urlContent];
    }
    //如果不合法
    if (urlContent.length > 17 || urlContent.length < 2) {
        return nil;
    }
    NSString *content = @"";
    for (NSInteger i = 0; i < urlContent.length; i ++) {
        int asciiCode = [urlContent characterAtIndex:i];
        content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    return content;
}

+ (NSString *)hexStringFromSignedNumber:(NSInteger)number {
    NSString *tempNumber = [NSString stringWithFormat:@"%lX", (long)number];
    if (tempNumber.length == 1) {
        tempNumber = [@"0" stringByAppendingString:tempNumber];
    }
    NSData *data = [self stringToData:tempNumber];
    NSData *resultData = [data subdataWithRange:NSMakeRange(data.length - 1, 1)];
    return [self hexStringFromData:resultData];
}

+ (NSNumber *)signedHexTurnString:(NSString *)content{
    if (!content) {
        return nil;
    }
    NSData *tempData = [self stringToData:content];
    NSInteger lenth = [tempData length];
    NSString *maxHexString = [self headString:@"F" trilString:@"F" strLenth:lenth];
    NSString *centerHexString = [self headString:@"8" trilString:@"0" strLenth:lenth];
    if ([[self numberHexString:content] longLongValue] - [[self numberHexString:centerHexString] longLongValue] < 0) {
        return [self numberHexString:content];
    }
    unsigned long long maxValue = [[self numberHexString:content] longLongValue];
    unsigned long long minValue = [[self numberHexString:maxHexString] longLongValue];
    return [NSNumber numberWithLongLong:(maxValue - minValue - 1)];
}

+ (NSString *)deviceTime:(NSString *)content {
    NSString *year = [NSString stringWithFormat:@"%ld",(long)([MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(0, 2)] + 2000)];
    NSString *month = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    NSString *day = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    NSString *hour = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    NSString *minutes = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 2)];
    if (minutes.length == 1) {
        minutes = [@"0" stringByAppendingString:minutes];
    }
    NSString *sec = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
    if (sec.length == 1) {
        sec = [@"0" stringByAppendingString:sec];
    }
    return [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",year,month,day,hour,minutes,sec];
}

#pragma mark - private method
+ (NSString *)getUrlIllegalContent:(NSString *)urlContent{
    if (!MKValidStr(urlContent)) {
        return nil;
    }
    NSArray *tempList = [urlContent componentsSeparatedByString:@"."];
    if (!MKValidArray(tempList)) {
        return nil;
    }
    NSString *content = @"";
    NSString *expansion = [self getExpansionHex:[@"." stringByAppendingString:[tempList lastObject]]];
    if (!MKValidStr(expansion)) {
        //如果不是符合官方要求的后缀名，判断长度是否小于2，如果是小于2则认为错误，否则直接认为符合要求
        //如果不是符合官方要求的后缀名，判断长度是否大于17，如果是大于17则认为错误，否则直接认为符合要求
        if (urlContent.length > 17 || urlContent.length < 2) {
            return nil;
        }
        for (NSInteger i = 0; i < urlContent.length; i ++) {
            int asciiCode = [urlContent characterAtIndex:i];
            content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
        }
    }else{
        NSString *tempString = @"";
        for (NSInteger i = 0; i < tempList.count - 1; i ++) {
            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@".%@",tempList[i]]];
        }
        tempString = [tempString substringFromIndex:1];
        if (tempString.length > 16 || tempString.length < 1) {
            return nil;
        }
        for (NSInteger i = 0; i < tempString.length; i ++) {
            int asciiCode = [tempString characterAtIndex:i];
            content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
        }
        content = [content stringByAppendingString:expansion];
    }
    return content;
}

/**
 根据后缀名返回写入数据时候的hex
 
 @param expansion 后缀名
 @return hex
 */
+ (NSString *)getExpansionHex:(NSString *)expansion{
    if (!MKValidStr(expansion)) {
        return nil;
    }
    if ([expansion isEqualToString:@".com/"]) {
        return @"00";
    }else if ([expansion isEqualToString:@".org/"]){
        return @"01";
    }else if ([expansion isEqualToString:@".edu/"]){
        return @"02";
    }else if ([expansion isEqualToString:@".net/"]){
        return @"03";
    }else if ([expansion isEqualToString:@".info/"]){
        return @"04";
    }else if ([expansion isEqualToString:@".biz/"]){
        return @"05";
    }else if ([expansion isEqualToString:@".gov/"]){
        return @"06";
    }else if ([expansion isEqualToString:@".com"]){
        return @"07";
    }else if ([expansion isEqualToString:@".org"]){
        return @"08";
    }else if ([expansion isEqualToString:@".edu"]){
        return @"09";
    }else if ([expansion isEqualToString:@".net"]){
        return @"0a";
    }else if ([expansion isEqualToString:@".info"]){
        return @"0b";
    }else if ([expansion isEqualToString:@".biz"]){
        return @"0c";
    }else if ([expansion isEqualToString:@".gov"]){
        return @"0d";
    }else{
        return nil;
    }
}

+ (NSString *)fetchTxPowerWithContent:(NSString *)content{
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    NSString *power = @"";
    if ([content isEqualToString:@"04"]) {
        power = @"4dBm";
    }else if ([content isEqualToString:@"03"]){
        power = @"3dBm";
    }else if ([content isEqualToString:@"00"]){
        power = @"0dBm";
    }else if ([content isEqualToString:@"fc"]){
        power = @"-4dBm";
    }else if ([content isEqualToString:@"f8"]){
        power = @"-8dBm";
    }else if ([content isEqualToString:@"f4"]){
        power = @"-12dBm";
    }else if ([content isEqualToString:@"f0"]){
        power = @"-16dBm";
    }else if ([content isEqualToString:@"ec"]){
        power = @"-20dBm";
    }else if ([content isEqualToString:@"d8"]){
        power = @"-40dBm";
    }
    return power;
}

+ (NSNumber *)fetchRSSIWithContent:(NSData *)contentData{
    const unsigned char *cData = [contentData bytes];
    unsigned char *data;
    // Malloc advertise data for char*
    data = malloc(sizeof(unsigned char) * contentData.length);
    NSAssert(data, @"failed to malloc");
    for (int i = 0; i < contentData.length; i++) {
        data[i] = *cData++;
    }
    unsigned char txPowerChar = *data;
    if (txPowerChar & 0x80) {
        return [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
    }
    else {
        return [NSNumber numberWithInt:txPowerChar];
    }
}

// 16进制转10进制
+ (NSNumber *) numberHexString:(NSString *)aHexString {
    if (nil == aHexString) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    return hexNumber;
}

+ (NSString *)headString:(NSString *)headStr trilString:(NSString *)trilStr strLenth:(NSInteger)lenth {
    if (!headStr || !trilStr) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithFormat:@"0x%@", headStr];
    for (int i = 0; i < lenth * 2 - 1; i++)
    {
        [string appendString:trilStr];
    }
    return string;
}

@end
