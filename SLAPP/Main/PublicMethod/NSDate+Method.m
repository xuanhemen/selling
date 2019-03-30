//
//  NSDate+Method.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "NSDate+Method.h"

@implementation NSDate (Method)



/**
 获取某个月的起始时间戳和结束时间戳
 
 @param date <#date description#>
 @return <#return value description#>
 */
+(NSArray *)getMonthBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:(NSDate *)date{
    
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    
    return @[[NSString stringWithFormat:@"%f",[self getDayBeginTimeIntervalWithDate:beginDate]] ,[NSString stringWithFormat:@"%f",[self getDayEndTimeIntervalWithDate:endDate]]];
}



/**
 获取某天的起始时间戳和结束时间错
 
 @param date <#date description#>
 @return <#return value description#>
 */
+(NSArray *)getDayBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:(NSDate *)date{
    
    return @[[NSString stringWithFormat:@"%f",[self getDayBeginTimeIntervalWithDate:date]] ,[NSString stringWithFormat:@"%f",[self getDayEndTimeIntervalWithDate:date]]];
    
}





/**
 获取某天的起始时间戳
 
 @param date <#date description#>
 @return <#return value description#>
 */
+(NSTimeInterval)getDayBeginTimeIntervalWithDate:(NSDate *)date{

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *str  = [formatter stringFromDate:date];
    NSDate *beginDate = [formatter dateFromString:str];
    return  beginDate.timeIntervalSince1970;

}


/**
 获取某天的结束时间戳
 
 @param date <#date description#>
 @return <#return value description#>
 */
+(NSTimeInterval)getDayEndTimeIntervalWithDate:(NSDate *)date{
    
    return [self getDayBeginTimeIntervalWithDate:date] + 60*60*24-1;
}



/**
 获取某个月的天数
 
 @param date 传入一个时间
 @return 返回天数
 */
+ (NSInteger)getNumberOfDaysWithDate:(NSDate *)date{
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                                            inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit =
                                                           forDate:date];
        return range.length;
}





/**
 获取今天是周几

 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getWeekDayFordate:(NSTimeInterval)date {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
    
}



/**
 根据时间戳获取当前的时，分
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleHHmmWithTime:(NSTimeInterval)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *str  = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    return str;
}


/**
 根据时间戳获取时间  YYYY-MM-DD
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleYMDWithTime:(NSTimeInterval)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str  = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    return str;
    
}


/**
 根据时间戳获取时间  YYYY-MM
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleYMWithTime:(NSTimeInterval)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str  = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    return str;
}


/**
 根据时间戳获取时间  YYYY-MM
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleDayWithTime:(NSTimeInterval)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    NSString *str  = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    return str;
}



+(NSDate *)nextMonthWithDate:(NSDate *)date{
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calender setFirstWeekday:2];
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setYear:0];
    [components setMonth:+1];
    [components setDay:0];
    NSDate *newdate = [calender dateByAddingComponents:components toDate:date options:0];
    return newdate;
    
}



+(NSDate *)lastMonthWithDate:(NSDate *)date{
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calender setFirstWeekday:2];
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [components setYear:0];
    [components setMonth:-1];
    [components setDay:0];
    NSDate *newdate = [calender dateByAddingComponents:components toDate:date options:0];
    return newdate;
    
}
@end
