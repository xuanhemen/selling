//
//  HYScheduleViewModel.h
//  SLAPP
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYScheduleViewModel : NSObject


/**
 获取日程列表的数据  处理好拼接到一起的
 @param date 当前月某一天的时间
 @param dataArray 网络请求回来的数据源
 @return 返回处理好的数据
 */
+(NSArray *)getScheduleListArrayWithDate:(NSDate *)date AndArray:(NSArray *)dataArray;






/**
 获取一个月的数据  按天存放到数组
 @param date 某一个月中的某天
 @param dataArray 网络请求回来的数据源
 @return 返回处理好的数据
 */
+(NSArray *)getDayListArrayWithDate:(NSDate *)date AndArray:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
