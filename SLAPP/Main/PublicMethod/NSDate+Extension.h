//
//  NSDate+Extension.h
//  CLApp
//
//  Created by rms on 17/1/9.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 * 判断是否是今年
 *
 *  @param target 代表需要与当前时间进行对比的nsdate对象
 */
+ (BOOL)isThisYearWithTarget:(NSDate *)target;


/**
 *  判断是否今天
 *
 *  @param target 代表需要与当前时间进行对比的nsdate对象
 *
 *  @return
 */
+ (BOOL)isTodayWithTarget:(NSDate *)target;


/**
 *  判断是否是昨天
 *
 *  @param target <#target description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isYesterdayWithTarget:(NSDate *)target;


/**
 *  判断是否是昨天
 *
 *  @param target <#target description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)isYesterdayWithTarget2:(NSDate *)target;



@end
