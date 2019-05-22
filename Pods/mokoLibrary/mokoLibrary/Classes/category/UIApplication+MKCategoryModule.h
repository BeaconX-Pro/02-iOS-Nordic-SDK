//
//  UIApplication+MKCategoryModule.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MKCategoryModule)

+ (void)skipToHome;

/**
 手机是否安装了某个应用

 @param appKey 应用的key
 @return YES:NO
 */
+ (BOOL)applicationInstall:(NSString *)appKey;

/**
 获取当前手机系统语言环境

 @return language
 */
+ (NSString *)currentSystemLanguage;

@end
