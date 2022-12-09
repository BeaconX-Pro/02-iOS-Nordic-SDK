//
//  MKBLEBaseSDKAdopter.m
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/14.
//

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

@implementation MKBLEBaseSDKAdopter

+ (NSError *)getErrorWithCode:(NSInteger)code message:(NSString *)message {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BLESDK"
                                                code:code
                                            userInfo:@{@"errorInfo":message}];
    return error;
}

+ (void)operationCentralBlePowerOffBlock:(void (^)(NSError *error))block{
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:-10001 message:@"Mobile phone bluetooth is currently unavailable"];
            block(error);
        }
    });
}

+ (void)operationConnectFailedBlock:(void (^)(NSError *error))block{
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:-10001 message:@"Connect Failed"];
            block(error);
        }
    });
}

+ (void)operationConnectingErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:-10001 message:@"The devices are connectting"];
            block(error);
        }
    });
}

+ (void)operationProtocolErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:-10001 message:@"The parameters passed in must conform to the protocol"];
            block(error);
        }
    });
}

+ (void)operationParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:10001 message:@"Params error"];
            block(error);
        }
    });
}

+ (void)operationSetParamsErrorBlock:(void (^)(NSError *error))block {
    MKBLEBase_main_safe(^{
        if (block) {
            NSError *error = [self getErrorWithCode:-10001 message:@"Set parameter error"];
            block(error);
        }
    });
}

+ (NSInteger)getDecimalWithHex:(NSString *)content range:(NSRange)range{
    if (!MKValidStr(content)) {
        return 0;
    }
    for (NSInteger i = 0; i < content.length; i ++) {
        if (![self checkHexCharacter:[content substringWithRange:NSMakeRange(i, 1)]]) {
            return 0;
        }
    }
    if (range.location > content.length - 1 || range.length > content.length || (range.location + range.length > content.length)) {
        return 0;
    }
    return strtoul([[content substringWithRange:range] UTF8String],0,16);
}
+ (NSString *)getDecimalStringWithHex:(NSString *)content range:(NSRange)range{
    NSInteger decimalValue = [self getDecimalWithHex:content range:range];
    return [NSString stringWithFormat:@"%ld",(long)decimalValue];
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
    if (!MKValidStr(content)) {
        return @(0);
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

+ (NSData *)getCrc16VerifyCode:(NSData *)data{
    if (!MKValidData(data)) {
        return [NSData data];
    }
    NSInteger crcWord = 0xffff;
    Byte *dataArray = (Byte *)[data bytes];
    for (NSInteger i = 0; i < data.length; i ++) {
        Byte byte = dataArray[i];
        crcWord ^= (NSInteger)byte & 0x00ff;
        for (NSInteger j = 0; j < 8; j ++) {
            if ((crcWord & 0x0001) == 1) {
                crcWord = crcWord >> 1;
                crcWord = crcWord ^ 0xA001;
            }else{
                crcWord = (crcWord >> 1);
            }
        }
    }
    
    Byte crcL = (Byte)0xff & (crcWord >> 8);
    Byte crcH = (Byte)0xff & (crcWord);
    Byte arrayCrc[] = {crcH, crcL};
    NSData *dataCrc = [NSData dataWithBytes:arrayCrc length:sizeof(arrayCrc)];
    return dataCrc;
}

+ (NSString *)hexStringFromData:(NSData *)sourceData{
    if (!MKValidData(sourceData)) {
        return @"";
    }
    Byte *bytes = (Byte *)[sourceData bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i = 0;i < [sourceData length];i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

+ (NSData *)stringToData:(NSString *)dataString{
    if (!MKValidStr(dataString)) {
        return [NSData data];
    }
        
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([dataString length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [dataString length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [dataString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (BOOL)checkHexCharacter:(NSString *)character {
    if (!MKValidStr(character)) {
        return NO;
    }
    NSString *regex = @"[a-fA-F0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:character];
}

+ (NSString *)binaryByhex:(NSString *)hex {
    if (!MKValidStr(hex) || ![self checkHexCharacter:hex]) {
        return @"";
    }
    if (hex.length % 2 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 2 - hex.length % 2; i++) {
            [mStr appendString:@"0"];
        }
        hex = [mStr stringByAppendingString:hex];
    }
    NSDictionary *hexDic = @{
                             @"0":@"0000",@"1":@"0001",@"2":@"0010",
                             @"3":@"0011",@"4":@"0100",@"5":@"0101",
                             @"6":@"0110",@"7":@"0111",@"8":@"1000",
                             @"9":@"1001",@"A":@"1010",@"a":@"1010",
                             @"B":@"1011",@"b":@"1011",@"C":@"1100",
                             @"c":@"1100",@"D":@"1101",@"d":@"1101",
                             @"E":@"1110",@"e":@"1110",@"F":@"1111",
                             @"f":@"1111",
                             };
    NSString *binaryString = @"";
    for (int i=0; i<[hex length]; i++) {
        NSRange rage;
        rage.length = 1;
        rage.location = i;
        NSString *key = [hex substringWithRange:rage];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,
                        [NSString stringWithFormat:@"%@",[hexDic objectForKey:key]]];
        
    }
    
    return binaryString;
}

+ (BOOL)asciiString:(NSString *)content {
    NSInteger strlen = content.length;
    NSInteger datalen = [[content dataUsingEncoding:NSUTF8StringEncoding] length];
    if (strlen != datalen) {
        return NO;
    }
    return YES;
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

+ (NSString *)getHexByBinary:(NSString *)binary {
    if (!MKValidStr(binary) || ![self checkHexCharacter:binary]) {
        return @"";
    }
    NSDictionary *binaryDic = @{
        @"0000":@"0",@"0001":@"1",@"0010":@"2",
        @"0011":@"3",@"0100":@"4",@"0101":@"5",
        @"0110":@"6",@"0111":@"7",@"1000":@"8",
        @"1001":@"9",@"1010":@"A",@"1011":@"B",
        @"1100":@"C",@"1101":@"D",@"1110":@"E",
        @"1111":@"F",
    };
    
    if (binary.length % 8 != 0) {
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 8 - binary.length % 8; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    
    NSInteger totalNum = (binary.length / 8);
    
    NSString *tempString = @"";
    
    for (NSInteger j = 0; j < totalNum; j ++) {
        NSString *hex = @"";
        NSString *tempBinary = [binary substringWithRange:NSMakeRange(j * 8, 8)];
        for (int i = 0; i < tempBinary.length; i += 4) {
            NSString *key = [tempBinary substringWithRange:NSMakeRange(i, 4)];
            NSString *value = binaryDic[key];
            if (value) {
                hex = [hex stringByAppendingString:value];
            }
        }
        tempString = [tempString stringByAppendingString:hex];
    }
    
    
    return tempString;
}

+ (NSString *)fetchHexValue:(unsigned long)value byteLen:(NSInteger)len {
    if (len <= 0) {
        return @"";
    }
    NSString *valueString = [NSString stringWithFormat:@"%1lx",(unsigned long)value];
    NSInteger needLen = 2 * len - valueString.length;
    for (NSInteger i = 0; i < needLen; i ++) {
        valueString = [@"0" stringByAppendingString:valueString];
    }
    return valueString;
}

#pragma mark - private method

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
