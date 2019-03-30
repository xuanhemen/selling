//
//  HYScheduleViewModel.m
//  SLAPP
//
//  Created by apple on 2019/1/23.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleListModel.h"
#import "NSDate+Method.h"
#import "HYScheduleViewModel.h"
@implementation HYScheduleViewModel


+(NSArray *)getScheduleListArrayWithDate:(NSDate *)date AndArray:(NSArray *)dataArray{
    
    NSInteger monthCount = [NSDate getNumberOfDaysWithDate:date];
    NSMutableArray * allArray = [NSMutableArray array];
    double monthBeginTime = [[NSDate getMonthBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:date].firstObject doubleValue];
    double monthEndTime = monthBeginTime + 86400 -1;
    for (int m = 1; m <= monthCount; m ++ ){
        
        if (m != 1) {
            monthBeginTime += 86400 ;
            monthEndTime += 86400 ;
        }
        
        NSMutableArray * subArray = [NSMutableArray array];
        for (HYScheduleListModel *model in dataArray) {
            
            if (model.begin_time > monthEndTime || model.end_time < monthBeginTime) {
                //开始时间比这一天的结束时间大  就没有必要去判断了
                continue;
            }
            
             model.monthTime = monthBeginTime;
             model.showWeek = [NSDate getWeekDayFordate:monthBeginTime];
             model.showDay = [NSString stringWithFormat:@"%d",m];
            if (model.begin_time <= monthBeginTime && model.end_time >= monthEndTime) {
                HYScheduleListModel *subModel = [model mutableCopy];
                [subArray addObject:subModel];
                //跨整天
                subModel.showTime = @"全天";
            }else if (model.begin_time >= monthBeginTime && model.end_time < monthEndTime){
                 HYScheduleListModel *subModel = [model mutableCopy];
                 subModel.showTime = [NSString stringWithFormat:@"%@ - %@",[NSDate getDateStyleHHmmWithTime:model.begin_time],[NSDate getDateStyleHHmmWithTime:model.end_time]];
                [subArray addObject:subModel];
                //全部包涵
            }else if (model.begin_time > monthBeginTime && model.end_time >= monthEndTime && model.begin_time < monthEndTime){
                HYScheduleListModel *subModel = [model mutableCopy];
                subModel.showTime = [NSString stringWithFormat:@"%@ 开始",[NSDate getDateStyleHHmmWithTime:model.begin_time]] ;
                [subArray addObject:subModel];
                //起始在中间
            }else if (model.begin_time  <=  monthBeginTime && model.end_time <= monthEndTime && model.end_time > monthBeginTime){
                HYScheduleListModel *subModel = [model mutableCopy];
                subModel.showTime = [NSString stringWithFormat:@"%@ 结束",[NSDate getDateStyleHHmmWithTime:model.end_time]] ;
                [subArray addObject:subModel];
                //结束在中间
            }
        }
        if (subArray.count) {
            [allArray addObject:subArray];
        }
        
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSArray *array in allArray) {
        [resultArray addObjectsFromArray:array];
    }
    return resultArray;
}



/**
 获取一个月的数据  按天存放到数组
 @param date 某一个月中的某天
 @param dataArray 网络请求回来的数据源
 @return 返回处理好的数据
 */
+(NSArray *)getDayListArrayWithDate:(NSDate *)date AndArray:(NSArray *)dataArray{
    
    
//    for (HYScheduleListModel *model in dataArray) {
//        DLog(@"开始%@",[NSDate dateWithTimeIntervalSince1970:model.begin_time]);
//        DLog(@"结束%@",[NSDate dateWithTimeIntervalSince1970:model.end_time]);
//    }
    
    
    NSInteger monthCount = [NSDate getNumberOfDaysWithDate:date];
    NSMutableArray * allArray = [NSMutableArray array];
    double monthBeginTime = [[NSDate getMonthBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:date].firstObject doubleValue];
    double monthEndTime = monthBeginTime + 86400 -1;
    
    for (int m = 1; m <= monthCount; m ++ )
    {
        if (m != 1) {
            monthBeginTime += 86400 ;
            monthEndTime += 86400 ;
        }
       
       
        NSMutableArray * subArray = [NSMutableArray array];
        for (HYScheduleListModel *model in dataArray) {
            
//            if (m == 28) {
//
//                NSDateFormatter *f = [[NSDateFormatter alloc] init];
//                [f setDateFormat:@"yyyy-MM-dd HH:mm"];
//                DLog(@"%@开始",[NSDate dateWithTimeIntervalSince1970:monthBeginTime]);
//                DLog(@"%@结束",[NSDate dateWithTimeIntervalSince1970:monthEndTime]);
//                DLog(@"%@----%@ ----日程",[NSDate dateWithTimeIntervalSince1970:model.begin_time],[NSDate dateWithTimeIntervalSince1970:model.end_time])
//                if ([model.title isEqualToString:@"测试ios修改"]) {
//
//                }
//
//            }
            
            if (model.begin_time > monthEndTime || model.end_time < monthBeginTime) {
                //开始时间比这一天的结束时间大  就没有必要去判断了
                continue;
            }
            
            
            model.monthTime = monthBeginTime;
            model.showWeek = [NSDate getWeekDayFordate:monthBeginTime];
            model.showDay = [NSString stringWithFormat:@"%d",m];
            if (model.begin_time <= monthBeginTime && model.end_time >= monthEndTime) {
                HYScheduleListModel *subModel = [model mutableCopy];
                [subArray addObject:subModel];
                //跨整天
//                subModel.showTime = @"全天";
                subModel.showTime = @"00:00";
                subModel.showEndTime = @"24:00";
                
            }
            else if (model.begin_time >= monthBeginTime && model.end_time < monthEndTime ){
                 HYScheduleListModel *subModel = [model mutableCopy];
                subModel.showTime = [NSString stringWithFormat:@"%@",[NSDate getDateStyleHHmmWithTime:model.begin_time]];
                subModel.showEndTime = [NSString stringWithFormat:@"%@",[NSDate getDateStyleHHmmWithTime:model.end_time]];
//                model.showTime = [NSString stringWithFormat:@"%@ - %@",[NSDate getDateStyleHHmmWithTime:model.begin_time],[NSDate getDateStyleHHmmWithTime:model.end_time]];
                [subArray addObject:subModel];
                //全部包涵
            }
            else if (model.begin_time > monthBeginTime && model.end_time >= monthEndTime && model.begin_time < monthEndTime){
                HYScheduleListModel *subModel = [model mutableCopy];
//                subModel.showTime = [NSString stringWithFormat:@"%@ 开始",[NSDate getDateStyleHHmmWithTime:model.begin_time]] ;
                subModel.showTime = [NSString stringWithFormat:@"%@",[NSDate getDateStyleHHmmWithTime:model.begin_time]];
                 subModel.showEndTime = @"24:00";
                [subArray addObject:subModel];
                //起始在中间
            }else if (model.begin_time  <=  monthBeginTime && model.end_time <= monthEndTime && model.end_time > monthBeginTime){
                HYScheduleListModel *subModel = [model mutableCopy];
                subModel.showTime = @"00:00";
                subModel.showEndTime = [NSString stringWithFormat:@"%@",[NSDate getDateStyleHHmmWithTime:model.end_time]] ;
                [subArray addObject:subModel];
                //结束在中间
            }
        }
        
            [allArray addObject:subArray];
        
        
       
        
    }
    return allArray;
}





@end
