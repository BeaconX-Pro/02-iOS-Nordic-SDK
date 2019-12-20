//
//  MKDateFormatter.m
//  MKHomePage
//
//  Created by aa on 2018/9/26.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKDateFormatter.h"

@implementation MKDateFormatter

+ (NSDateFormatter *)formatterWithYMD{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    return formatter;
}

+ (NSString *)getCurrentSystemTime{
    NSDateFormatter *formatter = [self formatterWithYMD];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 获取yyyy-MM-dd格式的日期
 
 @param timeString yyyy-MM-dd格式的字符串
 @return NSDate
 */
+ (NSDate *)getDateWithString:(NSString *)timeString{
    return [[self formatterWithYMD] dateFromString:timeString];
}

/**
 获取yyyy-MM-dd-HH-mm格式的formatter
 
 @return formatter
 */
+ (NSDateFormatter *)formmaterWithYMDHM{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    return formatter;
}

/**
 获取yyyy-MM-dd-HH-mm格式的日期
 
 @param timeString yyyy-MM-dd-HH-mm格式的字符串
 @return NSDate
 */
+ (NSDate *)getDateYMDHMWithString:(NSString *)timeString{
    return [[self formmaterWithYMDHM] dateFromString:timeString];
}

+ (NSInteger)getUserAgeWithDateOfBirth:(NSInteger)birthYear{
    NSString *currentTime = [self getCurrentSystemTime];
    NSArray *currentTimeList = [currentTime componentsSeparatedByString:@"-"];
    NSInteger age = [currentTimeList[0] integerValue] - birthYear;
    return age;
}

/**
 判断startDate和当前手机系统时间之间的年数
 
 @param startDate startDate
 @return 年数
 */
+ (NSInteger)getYearCountWithStartDate:(NSString *)startDate{
    NSArray * currentTimeList = [[self getCurrentSystemTime] componentsSeparatedByString:@"-"];
    NSArray * startTimeList = [startDate componentsSeparatedByString:@"-"];
    NSInteger yearCount = [currentTimeList[0] integerValue] - [startTimeList[0] integerValue] + 1;
    return yearCount;
}

/**
 对于本地数据库，存储的日期格式都是年-月-日，计算两个日期之间的天数
 
 @param startTime 开始日期
 @param endTime 结束日期
 @return 天数
 */
+ (NSInteger)getNumberOfDaysBetween:(NSString *)startTime and:(NSString *)endTime{
    NSDate *startDate = [self getDateWithString:startTime];
    NSDate *endDate = [self getDateWithString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    if (time < 0) {
        return 0;
    }
    NSInteger count = (((NSUInteger)time) / (3600 * 24)) + 1;
    return count;
}

/**
 对于本地数据库，存储的日期格式都是年-月-日，计算两个日期之间的周数
 
 @param startTime 开始日期
 @param endTime 结束日期
 @return 周数
 */
+ (NSInteger)getNumberOfWeeksBetween:(NSString *)startTime and:(NSString *)endTime{
    NSInteger startWeek = [self getWeekInfoWithDateString:startTime];
    NSInteger endWeek = [self getWeekInfoWithDateString:endTime];
    NSInteger dayNum = [self getNumberOfDaysBetween:startTime and:endTime];
    dayNum = dayNum + (startWeek - 1);
    
    dayNum = dayNum + (7 - endWeek);
    NSLog(@"当前相差%f周",(dayNum / 7.f));
    return (dayNum / 7);
}

+ (void)commonDateProcess{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"'公元前/后:'G  '年份:'u'='yyyy'='yy '季度:'q'='qqq'='qqqq '月份:'M'='MMM'='MMMM '今天是今年第几周:'w '今天是本月第几周:'W  '今天是今年第几天:'D '今天是本月第几天:'d '星期:'c'='ccc'='cccc '上午/下午:'a '小时:'h'='H '分钟:'m '秒:'s '毫秒:'SSS  '这一天已过多少毫秒:'A  '时区名称:'zzzz'='vvvv '时区编号:'Z "];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
}

/**
 判断两个日期之间的时间间隔(天数)
 
 @param sourceDate 基准日期字符串，yyyy-MM-dd
 @param devDate 比较的日期字符串，yyyy-MM-dd
 @return devDate跟sourceDate之间的间隔
 */
+ (NSInteger)dateIntervalWithSourceDate:(NSString *)sourceDate devDate:(NSString *)devDate{
    NSDate *source = [self getDateWithString:sourceDate];
    NSDate *dev = [self getDateWithString:devDate];
    NSTimeInterval time = [source timeIntervalSinceDate:dev];
    return ((NSInteger)time)/(3600*24);
}

/**
 根据传入的时间戳生成对应的日期
 
 @param timestamp 时间戳
 @return 日期
 */
+(NSDate *)getDateWithInterval:(long long)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
}

/**
 根据日期生成时间戳
 
 @return 时间戳，ms级
 */
+ (long long)getTimeIntervalSince1970Millisecond:(NSDate *)date{
    if (!date) {
        return 0;
    }
    long long timeInterval = (long long)[date timeIntervalSince1970];
    return timeInterval*1000;
}

/**
 根据传入的年-月-日来获取未来many天或者是过去many天的日期
 
 @param sourceDateString 源日期，必须是yyyy-MM-dd格式这种格式
 @param many 多少天
 @param next YES:下一天日期，NO:上一天日期
 @return 转换后的日期，yyyy-MM-dd格式
 */
+ (NSString *)getDateString:(NSString *)sourceDateString
                       many:(NSInteger)many
                 lastOrNext:(BOOL)next{
    NSString * timeStr = @"";
    NSInteger parameter = 1;
    if (!next) {
        parameter = -1;
    }
    NSTimeInterval time = parameter * many * 24*60*60;//many天
    
    NSDate *lastDate = [self getDateWithString:sourceDateString];
    NSDate * nextDate = [lastDate dateByAddingTimeInterval:time];
    timeStr = [[self formatterWithYMD] stringFromDate:nextDate];
    return timeStr;
}

/**
 根据传过来的日期，判断是周几
 
 @param dateString 时间格式必须是yyyy-MM-dd
 @return 返回对应的星期几
 */
+ (NSInteger)getWeekInfoWithDateString:(NSString *)dateString{
    if (!dateString || ![dateString isKindOfClass:[NSString class]] || dateString.length == 0) {
        return 0;
    }
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    
    if (!dateArr || dateArr.count != 3) {
        return 0;
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:[dateArr[2] integerValue]];
    [comps setMonth:[dateArr[1] integerValue]];
    [comps setYear:[dateArr[0] integerValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday
                                                       fromDate:date];
    NSInteger weekday = [weekdayComponents weekday];
    switch (weekday) {
        case 1:
            return 7;
        case 2:
            return 1;
        case 3:
            return 2;
        case 4:
            return 3;
        case 5:
            return 4;
        case 6:
            return 5;
        case 7:
            return 6;
    }
    
    return 0;
}

/**
 获取dateString所在月的所有日期
 
 @param dateString 目标日期
 @param type 日期类型
 @return 整月包含的日期信息
 */
+ (NSArray *)getMonthBeginAndEndWithDateString:(NSString *)dateString NSCalendarUnit:(NSCalendarUnit)type{
    
    if (!dateString || ![dateString isKindOfClass:[NSString class]] || dateString.length == 0) {
        return nil;
    }
    
    NSDate *lastDate = [self getDateWithString:dateString];
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:type
                          startDate:&beginDate
                           interval:&interval
                            forDate:lastDate];
    //分别修改为 NSDayCalendarUnit NSMonthCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSString *beginString = [[self formatterWithYMD] stringFromDate:beginDate];
    NSString *endString = [[self formatterWithYMD] stringFromDate:endDate];
    
    
    NSMutableArray * dateArr = [[NSMutableArray alloc] init];
    [dateArr addObject:beginString];
    
    NSInteger tempCount = 0;
    if (type == NSCalendarUnitWeekOfMonth) {
        tempCount = 6;
    }
    else if (type == NSCalendarUnitMonth){
        NSArray * beginDateArr = [beginString componentsSeparatedByString:@"-"];
        NSArray * endDateArr = [endString componentsSeparatedByString:@"-"];
        tempCount = [[endDateArr objectAtIndex:2] integerValue] - [[beginDateArr objectAtIndex:2] integerValue];
    }
    NSString *sysDate = [self getCurrentSystemTime];
    for (NSInteger i = 0; i < tempCount; i ++) {
        beginString = [self getDateString:beginString
                                     many:1
                               lastOrNext:YES];
        NSInteger compareResult = [self compareDate:[self getDateWithString:sysDate]
                                           withDate:[self getDateWithString:beginString]];
        if (compareResult == -1) {
            break;
        }
        [dateArr addObject:beginString];
    }
    
    return [dateArr copy];
    
}

/**
 根据formatter类型比较两个日期
 
 @param date1 date1
 @param date2 date2
 @return -1:date2 > date1,0:date1 = date2,1:date1 > date2
 */
+ (NSInteger )compareDate:(NSDate *)date1 withDate:(NSDate *)date2{
    if (![date1 isKindOfClass:[NSDate class]]
        || ![date2 isKindOfClass:[NSDate class]]) {
        return 0;
    }
    
    NSComparisonResult compareResult = [date1 compare:date2];
    if (compareResult == NSOrderedAscending) {
        //date2 > date1
        return -1;
    }else if (compareResult == NSOrderedDescending){
        //date1 > date2
        return 1;
    }else if (compareResult == NSOrderedSame){
        //date1 = date2
        return 0;
    }
    return 0;
}

@end
