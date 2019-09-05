//
//  MKAttributedString.m
//  MKHomePage
//
//  Created by aa on 2018/9/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKAttributedString.h"
#import <UIKit/UIKit.h>

@implementation MKAttributedString

+ (NSMutableAttributedString *)getAttributedString:(NSArray *)strings
                                             fonts:(NSArray *)fonts
                                            colors:(NSArray *)colors{
    NSString *sourceString = @"";
    for (NSString *str in strings) {
        sourceString = [sourceString stringByAppendingString:str];
    }
    if (sourceString.length == 0) {
        return nil;
    }
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:sourceString];
    CGFloat originPostion = 0;
    for (NSInteger i = 0; i < [strings count]; i ++) {
        NSString *tempString = strings[i];
        //颜色
        [resultString addAttribute:NSForegroundColorAttributeName
                             value:(id)colors[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        //字体大小
        [resultString addAttribute:NSFontAttributeName
                             value:(id)fonts[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        originPostion += tempString.length;
    }
    return resultString;
}

@end
