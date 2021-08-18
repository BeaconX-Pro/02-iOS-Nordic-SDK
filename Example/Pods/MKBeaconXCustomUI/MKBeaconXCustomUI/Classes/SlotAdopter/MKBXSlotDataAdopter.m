//
//  MKBXSlotDataAdopter.m
//  MKBeaconXProTLA_Example
//
//  Created by aa on 2021/7/30.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSlotDataAdopter.h"

#import "MKMacroDefines.h"

@implementation MKBXSlotDataAdopter

+ (mk_bx_slotFrameType)fetchSlotFrameType:(NSString *)type {
    if (!ValidStr(type) || [type isEqualToString:@"ff"]) {
        return mk_bx_slotFrameTypeNull;
    }
    if ([type isEqualToString:@"00"]) {
        return mk_bx_slotFrameTypeUID;
    }
    if ([type isEqualToString:@"10"]) {
        return mk_bx_slotFrameTypeURL;
    }
    if ([type isEqualToString:@"20"]) {
        return mk_bx_slotFrameTypeTLM;
    }
    if ([type isEqualToString:@"40"]) {
        return mk_bx_slotFrameTypeInfo;
    }
    if ([type isEqualToString:@"50"]) {
        return mk_bx_slotFrameTypeBeacon;
    }
    if ([type isEqualToString:@"60"]) {
        return mk_bx_slotFrameTypeThreeASensor;
    }
    if ([type isEqualToString:@"70"]) {
        return mk_bx_slotFrameTypeTHSensor;
    }
    return mk_bx_slotFrameTypeNull;
}

+ (NSString *)getExpansionHex:(NSString *)expansion {
    if (!ValidStr(expansion)) {
        return @"";
    }
    if ([expansion isEqualToString:@".com/"]) {
        return @"00";
    }
    if ([expansion isEqualToString:@".org/"]){
        return @"01";
    }
    if ([expansion isEqualToString:@".edu/"]){
        return @"02";
    }
    if ([expansion isEqualToString:@".net/"]){
        return @"03";
    }
    if ([expansion isEqualToString:@".info/"]){
        return @"04";
    }
    if ([expansion isEqualToString:@".biz/"]){
        return @"05";
    }
    if ([expansion isEqualToString:@".gov/"]){
        return @"06";
    }
    if ([expansion isEqualToString:@".com"]){
        return @"07";
    }
    if ([expansion isEqualToString:@".org"]){
        return @"08";
    }
    if ([expansion isEqualToString:@".edu"]){
        return @"09";
    }
    if ([expansion isEqualToString:@".net"]){
        return @"0a";
    }
    if ([expansion isEqualToString:@".info"]){
        return @"0b";
    }
    if ([expansion isEqualToString:@".biz"]){
        return @"0c";
    }
    if ([expansion isEqualToString:@".gov"]){
        return @"0d";
    }
    return @"";
}

+ (NSString *)getUrlscheme:(char)hexChar {
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
            return @"";
    }
}

+ (NSString *)getEncodedString:(char)hexChar {
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

@end
