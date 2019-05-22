//
//  MKDateFormatter.h
//  MKHomePage
//
//  Created by aa on 2018/9/26.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDateFormatter : NSObject

/**
 获取yyyy-MM-dd格式的formatter
 
 @return formatter
 */
+ (NSDateFormatter *)formatterWithYMD;

/**
 获取当前系统时间，
 
 @return 时间字符串
 */
+ (NSString *)getCurrentSystemTime;

/**
 获取yyyy-MM-dd格式的日期
 
 @param timeString yyyy-MM-dd格式的字符串
 @return NSDate
 */
+ (NSDate *)getDateWithString:(NSString *)timeString;

/**
 获取yyyy-MM-dd-HH-mm格式的formatter
 
 @return formatter
 */
+ (NSDateFormatter *)formmaterWithYMDHM;

/**
 获取yyyy-MM-dd-HH-mm格式的日期
 
 @param timeString yyyy-MM-dd-HH-mm格式的字符串
 @return NSDate
 */
+ (NSDate *)getDateYMDHMWithString:(NSString *)timeString;

+ (NSInteger)getUserAgeWithDateOfBirth:(NSInteger)birthYear;

/**
 对于本地数据库，存储的日期格式都是年-月-日，计算两个日期之间的天数
 
 @param startTime 开始日期
 @param endTime 结束日期
 @return 天数
 */
+ (NSInteger)getNumberOfDaysBetween:(NSString *)startTime and:(NSString *)endTime;
/**
 对于本地数据库，存储的日期格式都是年-月-日，计算两个日期之间的周数
 
 @param startTime 开始日期
 @param endTime 结束日期
 @return 周数
 */
+ (NSInteger)getNumberOfWeeksBetween:(NSString *)startTime and:(NSString *)endTime;
/**
 判断startDate和当前手机系统时间之间的年数
 
 @param startDate startDate
 @return 年数
 */
+ (NSInteger)getYearCountWithStartDate:(NSString *)startDate;

/**
 判断两个日期之间的时间间隔(天数)
 
 @param sourceDate 基准日期字符串，yyyy-MM-dd
 @param devDate 比较的日期字符串，yyyy-MM-dd
 @return devDate跟sourceDate之间的间隔
 */
+ (NSInteger)dateIntervalWithSourceDate:(NSString *)sourceDate devDate:(NSString *)devDate;

/**
 根据传入的时间戳生成对应的日期
 
 @param timestamp 时间戳
 @return 日期
 */
+(NSDate *)getDateWithInterval:(long long)timestamp;

/**
 根据日期生成时间戳
 
 @return 时间戳，ms级
 */
+ (long long)getTimeIntervalSince1970Millisecond:(NSDate *)date;

/**
 根据传入的年-月-日来获取未来many天或者是过去many天的日期
 
 @param sourceDateString 源日期，必须是yyyy-MM-dd格式这种格式
 @param many 多少天
 @param next YES:下一天日期，NO:上一天日期
 @return 转换后的日期，yyyy-MM-dd格式
 */
+ (NSString *)getDateString:(NSString *)sourceDateString many:(NSInteger)many lastOrNext:(BOOL)next;

/**
 根据传过来的日期，判断是周几
 
 @param dateString 时间格式必须是yyyy-MM-dd
 @return 返回对应的星期几
 */
+ (NSInteger)getWeekInfoWithDateString:(NSString *)dateString;

/**
 获取dateString所在月的所有日期
 
 @param dateString 目标日期
 @param type 日期类型
 @return 整月包含的日期信息
 */
+ (NSArray *)getMonthBeginAndEndWithDateString:(NSString *)dateString NSCalendarUnit:(NSCalendarUnit)type;

/**
 根据formatter类型比较两个日期
 
 @param date1 date1
 @param date2 date2
 @return -1:date2 > date1,0:date1 = date2,1:date1 > date2
 */
+ (NSInteger )compareDate:(NSDate *)date1 withDate:(NSDate *)date2;

@end
