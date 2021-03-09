//
//  NSDateFormatter+MKAdd.m
//  mokoLibrary
//
//  Created by aa on 2020/10/8.
//

#import "NSDateFormatter+MKAdd.h"
#import <objc/runtime.h>

@implementation NSDateFormatter (MKAdd)

//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Method sysMethod = class_getInstanceMethod([self class], @selector(init));
//        Method customMethod = class_getInstanceMethod([self class], @selector(mk_init));
//
//        BOOL didAddMethod = class_addMethod([self class], @selector(init), method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
//        if (didAddMethod) {
//            //如果方法已经存在，则替换
//            class_replaceMethod([self class], @selector(mk_init),
//                                method_getImplementation(sysMethod),
//                                method_getTypeEncoding(sysMethod));
//        }else{
//            //
//            method_exchangeImplementations(sysMethod, customMethod);
//        }
//    });
//}
//
//- (instancetype)mk_init{
//    [self mk_init];
//    self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
//    //语言习惯
//    NSLocale *usLocale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//    self.locale = usLocale;
//    return self;
//}

+ (NSDateFormatter *)dateFormatter
{
    return [[self alloc] init];
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (NSDateFormatter *)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
