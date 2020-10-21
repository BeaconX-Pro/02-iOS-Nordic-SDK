//
//  NSString+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "NSString+MKAdd.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MKAdd)

+ (CGSize)sizeWithText:(NSString *)text andFont:(UIFont *)font andMaxSize:(CGSize)maxSize{
    CGSize expectedLabelSize = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:0];
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    expectedLabelSize = [text boundingRectWithSize:maxSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes context:nil].size;
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

+ (CGFloat)getSpaceLabelHeightWithText:(NSString *)text lineSpeace:(CGFloat)lineSpace withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineSpace;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic
                                     context:nil].size;
    return size.height;
}

- (BOOL)regularExpressions:(NSString *)regex{
    if (!regex || ![regex isKindOfClass:[NSString class]] || regex.length == 0 || self.length == 0) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isUUIDNumber{
    NSString *uuidPattern = @"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:uuidPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                       options:kNilOptions
                                                         range:NSMakeRange(0, self.length)];
    return (numberOfMatches > 0);
}

- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     * 虚拟号码：177
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    //虚拟号码
    NSString *XNHM = @"^1(77)\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    NSPredicate *regextestXNHM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",XNHM];
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)
        || ([regextestXNHM evaluateWithObject:self] == YES)
        || ([regextestPHS evaluateWithObject:self] == YES))
        {
        return YES;
        }
    else
        {
        return NO;
        }
}

@end
