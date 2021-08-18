//
//  MKBXSlotDataAdopter.h
//  MKBeaconXProTLA_Example
//
//  Created by aa on 2021/7/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotDataAdopter : NSObject

/// 解析设备传回来的设备类型
/// @"00":UID,@"10":URL,@"20":TLM,@"40":设备信息,@"50":iBeacon,@"60":3轴加速度计,@"70":温湿度传感器,@"FF":NO DATA
/// @param type type
+ (mk_bx_slotFrameType)fetchSlotFrameType:(NSString *)type;

/**
 根据后缀名返回写入数据时候的hex
 
 @param expansion 后缀名
 @return hex
 */
+ (NSString *)getExpansionHex:(NSString *)expansion;

/// 根据设备传过来的值解析成对应的域名前缀
/// @param hexChar 0x00 : @"http://www.",   0x01 : @"https://www.",    0x02 : @""http://",    0x03 : @"https://"
+ (NSString *)getUrlscheme:(char)hexChar;


/// 根据设备传过来的值解析成对应的域名结尾
/// @param hexChar
/*
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
 */
+ (NSString *)getEncodedString:(char)hexChar;

@end

NS_ASSUME_NONNULL_END
