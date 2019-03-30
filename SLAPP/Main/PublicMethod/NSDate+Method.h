//
//  NSDate+Method.h
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Method)


/**
 获取某个月的起始时间戳和结束时间戳

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSArray *)getMonthBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:(NSDate *)date;



/**
 获取某天的起始时间戳和结束时间错

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSArray *)getDayBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:(NSDate *)date;

/**
 获取某天的起始时间戳

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSTimeInterval)getDayBeginTimeIntervalWithDate:(NSDate *)date;


/**
 获取某天的结束时间戳

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSTimeInterval)getDayEndTimeIntervalWithDate:(NSDate *)date;




/**
 获取某个月的天数
 
 @param date 传入一个时间
 @return 返回天数
 */
+ (NSInteger)getNumberOfDaysWithDate:(NSDate *)date;



/**
 根据时间戳获取今天是周几
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getWeekDayFordate:(NSTimeInterval)date;




/**
 根据时间戳获取当前的时，分
 HH:mm
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleHHmmWithTime:(NSTimeInterval)date;


/**
 根据时间戳获取时间  YYYY-MM-DD

 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleYMDWithTime:(NSTimeInterval)date;


/**
 根据时间戳获取时间  YYYY-MM
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleYMWithTime:(NSTimeInterval)date;



/**
 根据时间戳获取时间  YYYY-MM
 
 @param date <#date description#>
 @return <#return value description#>
 */
+ (NSString *)getDateStyleDayWithTime:(NSTimeInterval)date;


/**
 获取某个日期的下一个月

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSDate *)nextMonthWithDate:(NSDate *)date;



/**
 获取某个日期的上一个月

 @param date <#date description#>
 @return <#return value description#>
 */
+(NSDate *)lastMonthWithDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
