//
//  NSString+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//*************************************正则表达式******************************************************
static NSString *const isRealNumbers = @"[0-9]*";           //是否是纯数字
static NSString *const isChinese = @"[\u4e00-\u9fa5]+";     //是否是汉字
static NSString *const isLetter = @"[a-zA-Z]*";             //是否是字母
static NSString *const isLetterOrRealNumbers = @"[a-zA-Z0-9]*"; //是否是数字或者字母
static NSString *const isHexadecimal = @"[a-fA-F0-9]*";     //  是否是16进制字符
static NSString *const isIPAddress = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
"([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
"([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";                        //是否是IP地址
static NSString *const isUrl = @"[a-zA-z]+://[^\\s]*";      //是否是Url

@interface NSString (MKAdd)

+ (CGSize)sizeWithText:(NSString *)text
               andFont:(UIFont *)font
            andMaxSize:(CGSize)maxSize;

/**
 计算富文本字体高度

 @param text 内容
 @param lineSpace 行高
 @param font 字体
 @param width 字体所占宽度
 @return 富文本高度
 */
+ (CGFloat)getSpaceLabelHeightWithText:(NSString *)text
                            lineSpeace:(CGFloat)lineSpace
                              withFont:(UIFont*)font
                             withWidth:(CGFloat)width;

/**
 正则表达式的判断

 @param regex 正则
 @return YES:符合要求，NO:不符合要求
 */
- (BOOL)regularExpressions:(NSString *)regex;
- (BOOL)isMobileNumber;
- (BOOL)isUUIDNumber;

@end
