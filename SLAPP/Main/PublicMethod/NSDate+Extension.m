//
//  NSDate+Extension.m
//  CLApp
//
//  Created by rms on 17/1/9.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
/**
 * 判断是否是今年
 *
 *  @param target 代表需要与当前时间进行对比的nsdate对象
 */
+ (BOOL)isThisYearWithTarget:(NSDate *)target{
    //取到当前时间
    NSDate *currentDate = [NSDate date];
    
    //初始化一个只提取年份的格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    //取出两个时间的年份的字符串
    NSString *currentYear = [formatter stringFromDate:currentDate];
    NSString *targetYear = [formatter stringFromDate:target];
    
    return [currentYear isEqualToString:targetYear];
}



/**
 *  判断是否今天
 *
 *  @param target 代表需要与当前时间进行对比的nsdate对象
 *
 *  @return
 */
+ (BOOL)isTodayWithTarget:(NSDate *)target{
    //取到当前时间
    NSDate *currentDate = [NSDate date];
    
    //初始化一个只提取年份的格式化器
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    //取出两个时间的年月日的字符串
    NSString *currentResult = [formatter stringFromDate:currentDate];
    NSString *targetResult = [formatter stringFromDate:target];
    
    //对比两个字符串是否一样
    return [currentResult isEqualToString:targetResult];
}




/**
 *  判断是否是昨天
 *
 *  @param target <#target description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isYesterdayWithTarget:(NSDate *)target{
    
    //取到当前时间
    NSDate *currentDate = [NSDate date];
    //                2015-10-10 10:10:00     微博的创建时间
    //                2015-10-11 10:10:00
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    //先转成string
    //2015-10-10 微博的创建时间
    //2015-10-11 当前
    NSString *createStr = [formatter stringFromDate:target];
    NSString *currentStr = [formatter stringFromDate:currentDate];
    
    
    //                2015-10-10      微博的创建时间
    //                2015-10-11
    NSDate *createD = [formatter dateFromString:createStr];
    NSDate *currentD = [formatter dateFromString:currentStr];
    
    return ([currentD timeIntervalSinceDate:createD] == 3600 * 24);
}


/**
 *  判断是否是昨天
 *
 *  @param target <#target description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isYesterdayWithTarget2:(NSDate *)target{
    
    //取到当前时间
    NSDate *currentDate = [NSDate date];
    //                2015-10-10 10:10:00     微博的创建时间
    //                2015-10-11 10:10:00
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    
    //先转成string
    //2015-10-10 微博的创建时间
    //2015-10-11 当前
    NSString *createStr = [formatter stringFromDate:target];
    NSString *currentStr = [formatter stringFromDate:currentDate];
    
    
    //                2015-10-10      微博的创建时间
    //                2015-10-11
    NSDate *createD = [formatter dateFromString:createStr];
    NSDate *currentD = [formatter dateFromString:currentStr];
    
    
    //取出当前日历对象
    NSCalendar *canlendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [canlendar components:NSCalendarUnitDay fromDate:createD toDate:currentD options:0];
    
    return components.day == 1;
    //    return ([currentD timeIntervalSinceDate:createD] == 3600 * 24);
}


@end
