//
//  UIApplication+MKCategoryModule.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UIApplication+MKCategoryModule.h"

@implementation UIApplication (MKCategoryModule)

+ (void)skipToHome{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                           options:@{}
                                 completionHandler:nil];
        return;
    }
    //低于10
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

+ (BOOL)applicationInstall:(NSString *)appKey{
    if (!appKey || ![appKey isKindOfClass:[NSString class]] || appKey.length == 0) {
        return NO;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appKey]]){
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)currentSystemLanguage{
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        //英文
        return @"en";
    }
    if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            // 简体中文
            return @"zh-Hans";
        } else {
            // zh-Hant\zh-HK\zh-TW,繁體中文
            return @"zh-Hant";
        }
    }
    if ([language hasPrefix:@"ja"]) {
        //日本
        return @"ja";
    }
    if ([language hasPrefix:@"cs"]) {
        //捷克
        return @"cs";
    }
    if ([language hasPrefix:@"de"]) {
        //德语
        return @"de";
    }
    if ([language hasPrefix:@"fr"]) {
        //法语
        return @"fr";
    }
    if ([language hasPrefix:@"it"]) {
        //意大利
        return @"it";
    }
    if ([language hasPrefix:@"ko"]) {
        //韩语
        return @"ko";
    }
    if ([language hasPrefix:@"es"]) {
        //西班牙
        return @"es";
    }
    if ([language hasPrefix:@"pt"]) {
        //葡萄牙
        return @"pt";
    }
    if ([language hasPrefix:@"ru"]) {
        //俄语
        return @"ru";
    }
    
    if ([language hasPrefix:@"th"]) {
        //泰语
        return @"th";
    }
    
    return @"en";
}

@end
