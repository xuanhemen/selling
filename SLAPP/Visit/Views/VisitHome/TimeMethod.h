//
//  TimeMethod.h
//  CLApp
//
//  Created by xslp_ios on 16/8/10.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间方法类
 */
@interface TimeMethod : NSObject

@property (nonatomic)NSInteger firstDayTimeOfWeek;
@property (nonatomic)NSInteger endDayTimeOfWeek;
@property (nonatomic)NSInteger firstDayTimeOfMonth;
@property (nonatomic)NSInteger endDayTimeOfMonth;
@property (nonatomic)NSInteger firstDayTimeOfQuarter;
@property (nonatomic)NSInteger endDayTimeOfQuarter;
@property (nonatomic)NSInteger firstDayTimeOfYear;
@property (nonatomic)NSInteger endDayTimeOfYear;
@property (strong,nonatomic)NSArray *selectBetween;

-(instancetype)initWithDate:(NSDate *)date;

-(void)reSetWithDate:(NSDate *)date;


/**
 获取某一年的时间段

 @param year 年  2018
 @return 返回时间段
 */
+ (NSArray *)configTimeWithYear:(NSString *)year;
/**
 *  获取一周第一天最小时间点时间戳
 *
 *  @param date 预计算时间，如果为空则为系统当前时间
 *
 *  @return 一周第一天最小时间点时间戳
 */
+(NSInteger)firstDayTimeOfWeek:(NSDate *)date;
/**
 *  获取一月第一天最小时间点时间戳
 *
 *  @param date 预计算时间，如果为空则为系统当前时间
 *
 *  @return 一月第一天最小时间点时间戳
 */
+(NSInteger)firstDayTimeOfMonth:(NSDate *)date;
/**
 *  获取一季第一天最小时间点时间戳
 *
 *  @param date 预计算时间，如果为空则为系统当前时间
 *
 *  @return 一季第一天最小时间点时间戳
 */
+(NSInteger)firstDayTimeOfQuarter:(NSDate *)date;
/**
 *  获取一年第一天最小时间点时间戳
 *
 *  @param date 预计算时间，如果为空则为系统当前时间
 *
 *  @return 一年第一天最小时间点时间戳
 */
+(NSInteger)firstDayTimeOfYear:(NSDate *)date;
/**
 *  时间戳转日期和星期几字符串
 *
 *  @param time 时间戳
 *
 *  @return 时间戳对应字符串
 */
+(NSString *)dateAndWeekStringFromTime:(NSInteger)time;


/**
 *  今天的起始时间
 *
 *  @return 今天起始时间的时间戳
 */
+(NSInteger)todayStartTime;


/**
 *  上季度的起始时间
 *
 *  @return 上季度起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastQuarter;

/**
 *  上月起始时间
 *
 *  @return 上月起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastMonth;

/**
 *  去年起始时间
 *
 *  @return 返回去年起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastQYear;
@end
