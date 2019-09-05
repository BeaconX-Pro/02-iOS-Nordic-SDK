//
//  NSDateFormatter+MKCategoryModule.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "NSDateFormatter+MKCategoryModule.h"
#import <objc/runtime.h>

@implementation NSDateFormatter (MKCategoryModule)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sysMethod = class_getInstanceMethod([self class], @selector(init));
        Method customMethod = class_getInstanceMethod([self class], @selector(mk_init));
        
        BOOL didAddMethod = class_addMethod([self class], @selector(init), method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
        if (didAddMethod) {
            //如果方法已经存在，则替换
            class_replaceMethod([self class], @selector(mk_init),
                                method_getImplementation(sysMethod),
                                method_getTypeEncoding(sysMethod));
        }else{
            //
            method_exchangeImplementations(sysMethod, customMethod);
        }
    });
}

- (instancetype)mk_init{
    [self mk_init];
    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //语言习惯
    NSLocale *usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    self.locale = usLocale;
    return self;
}

+ (id)dateFormatter
{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
