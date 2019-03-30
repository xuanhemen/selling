//
//  TimeMethod.m
//  CLApp
//
//  Created by xslp_ios on 16/8/10.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "TimeMethod.h"

@implementation TimeMethod

-(instancetype)initWithDate:(NSDate *)date{
    self = [super init];
    if (self) {
        [self reSetWithDate:date];
    }
    return self;
}

-(void)reSetWithDate:(NSDate *)date{
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    
    self.firstDayTimeOfWeek = [TimeMethod firstDayTimeOfWeek:date];
    self.firstDayTimeOfMonth = [TimeMethod firstDayTimeOfMonth:date];
    self.firstDayTimeOfQuarter = [TimeMethod firstDayTimeOfQuarter:date];
    self.firstDayTimeOfYear = [TimeMethod firstDayTimeOfYear:date];
    self.endDayTimeOfWeek = self.firstDayTimeOfWeek + 7*60*60*24-1;
    NSArray * array = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    if ([array containsObject:[NSString stringWithFormat:@"%ld",[comp month]]]) {
        self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 31*60*60*24-1;
    }else if([comp month] == 2){
        if([comp year]%100 == 0){
            if (([comp year]%400 == 0)) {
                self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 29*60*60*24-1;
                self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 91*60*60*24-1;
            }else{
                self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 28*60*60*24-1;
                self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 90*60*60*24-1;
            }
        }else if ([comp year]%4 == 0){
            self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 29*60*60*24-1;
            self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 91*60*60*24-1;
        }else{
            self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 28*60*60*24-1;
            self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 90*60*60*24-1;
        }
    }else{
        self.endDayTimeOfMonth = self.firstDayTimeOfMonth + 30*60*60*24-1;
    }
    if ([comp month] == 1 || [comp month] == 3) {
        {
            if([comp year]%100 == 0){
                if (([comp year]%400 == 0)) {
                    self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 91*60*60*24-1;
                }else{
                    self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 90*60*60*24-1;
                }
            }else if ([comp year]%4 == 0){
                self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 91*60*60*24-1;
            }else{
                self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 90*60*60*24-1;
            }
        }
    }else if([comp month]/3 == 1){
        self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 91*60*60*24-1;
    }else if([comp month] != 2){
        self.endDayTimeOfQuarter = self.firstDayTimeOfQuarter + 92*60*60*24-1;
    }
    if([comp year]%100 == 0){
        if (([comp year]%400 == 0)) {
            self.endDayTimeOfYear = self.firstDayTimeOfYear + 366*60*60*24-1;
        }else{
            self.endDayTimeOfYear = self.firstDayTimeOfYear + 365*60*60*24-1;
        }
    }else if ([comp year]%4 == 0){
        self.endDayTimeOfYear = self.firstDayTimeOfYear + 366*60*60*24-1;
    }else{
        self.endDayTimeOfYear = self.firstDayTimeOfYear + 365*60*60*24-1;
    }
}

+(NSInteger)firstDayTime:(NSDate *)date withDiff:(NSInteger)diff{
    
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    
    // 得到几号
    NSInteger day = [comp day];
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    [comp setDay:day + diff];
    NSDate *firstDay= [calendar dateFromComponents:comp];
    
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return firstDay.timeIntervalSince1970;
}

+(NSInteger)firstDayTimeOfWeek:(NSDate *)date{
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:3];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
//    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff;
    if (weekDay == 1) {
        firstDiff = -7;
    }else{
        firstDiff = 2 - weekDay;
    }
    
    return [self firstDayTime:date withDiff:firstDiff];
}

+(NSInteger)firstDayTimeOfQuarter:(NSDate *)date{
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitQuarter
                                         fromDate:now];
    // 得到几号
    NSInteger day = [comp day];
    NSInteger month = [comp month];
    NSInteger quarter = month%3==0?month/3-1:month/3;
    NSArray * array = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    
    for (int i = (int)quarter*3 + 1; i < month ; i++) {
        if ([array containsObject:[NSString stringWithFormat:@"%d",i]]) {
            day += 31;
        }else if(i == 2){
            if([comp year]%100 == 0){
                if (([comp year]%400 == 0)) {
                    day += 29;
                }else{
                    day += 28;
                }
            }else if ([comp year]%4 == 0){
                day += 29;
            }else{
                day += 28;
            }
        }else{
            day += 30;
        }
    }
    return [self firstDayTime:date withDiff:-day+1];
}

+(NSInteger)firstDayTimeOfMonth:(NSDate *)date{
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    // 得到几号
    NSInteger day = [comp day];
    
    return [self firstDayTime:date withDiff:-day+1];
}

+(NSInteger)firstDayTimeOfYear:(NSDate *)date{
    NSDate *now;
    if (date) {
        now = date;
    }else{
        now = [NSDate date];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:now];
    // 得到几号
    NSInteger day = [comp day];
    NSInteger month = [comp month];
    NSArray * array = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    
    for (int i = 1; i < month ; i++) {
        if ([array containsObject:[NSString stringWithFormat:@"%d",i]]) {
            day += 31;
        }else if(i == 2){
            if([comp year]%100 == 0){
                if (([comp year]%400 == 0)) {
                    day += 29;
                }else{
                    day += 28;
                }
            }else if ([comp year]%4 == 0){
                day += 29;
            }else{
                day += 28;
            }
        }else{
            day += 30;
        }
    }
    return [self firstDayTime:date withDiff:-day+1];
}


+(NSString *)dateAndWeekStringFromTime:(NSInteger)time{
    NSString * dataStr;
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    switch (weekDay) {
        case 1:
            dataStr = [currentDateStr stringByAppendingString:@"  星期日"];
            break;
        case 2:
            dataStr = [currentDateStr stringByAppendingString:@"  星期一"];
            break;
        case 3:
            dataStr = [currentDateStr stringByAppendingString:@"  星期二"];
            break;
        case 4:
            dataStr = [currentDateStr stringByAppendingString:@"  星期三"];
            break;
        case 5:
            dataStr = [currentDateStr stringByAppendingString:@"  星期四"];
            break;
        case 6:
            dataStr = [currentDateStr stringByAppendingString:@"  星期五"];
            break;
        case 7:
            dataStr = [currentDateStr stringByAppendingString:@"  星期六"];
            break;
            
        default:
            break;
    }
    return dataStr;
}
//-(void)setSelectBetween:(NSArray *)selectBetween{
////    NSTimeZone *zone = [NSTimeZone systemTimeZone];
////    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];
////    _selectBetween = @[@([(NSNumber *)selectBetween[0] integerValue]-interval),@([(NSNumber *)selectBetween[1] integerValue]-interval - 1)];
//    _selectBetween = selectBetween;
//}
-(NSArray *)selectBetween{
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[self.selectBetween[0] integerValue]];
    NSLog(@"时间是%@",@[[NSDate dateWithTimeIntervalSince1970:[_selectBetween[0] integerValue]],[NSDate dateWithTimeIntervalSince1970:[_selectBetween[1] integerValue]]]);
    return _selectBetween;
}


/**
 *  今天的起始时间
 *
 *  @return 今天起始时间的时间戳
 */
+(NSInteger)todayStartTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *str  = [formatter stringFromDate:[NSDate date]];
    NSDate *beginDate = [formatter dateFromString:str];
    return  beginDate.timeIntervalSince1970;
}


/**
 *  上季度的起始时间
 *
 *  @return 上季度起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastQuarter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *str  = [formatter stringFromDate:[NSDate date]];
    NSString *year = [str substringToIndex:4];
    NSRange range = NSMakeRange(5, 2);
    NSString *month = [str substringWithRange:range];
    NSMutableString *lastQuarterStr = [[NSMutableString alloc]init];
    switch (([month integerValue]-1)/3) {
        case 0:
        {
            [lastQuarterStr appendString:[NSString stringWithFormat:@"%ld-10-01 00:00:00",[year integerValue]-1]];
        }
            break;
        case 1:
        {
           [lastQuarterStr appendString:[NSString stringWithFormat:@"%@-01-01 00:00:00",year]];
        }
            break;

        case 2:
        {
            [lastQuarterStr appendString:[NSString stringWithFormat:@"%@-04-01 00:00:00",year]];
        }
            break;

        case 3:
        {
            [lastQuarterStr appendString:[NSString stringWithFormat:@"%@-07-01 00:00:00",year]];
        }
            break;

        default:
            break;
    }
    
    NSDate *lastDate = [formatter dateFromString:lastQuarterStr];
    return [self firstDayTimeOfQuarter:lastDate];
}


/**
 *  上月起始时间
 *
 *  @return 上月起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *str  = [formatter stringFromDate:[NSDate date]];
    NSString *year = [str substringToIndex:4];
    NSRange range = NSMakeRange(5, 2);
    NSString *month = [str substringWithRange:range];
    NSMutableString *lastQuarterStr = [[NSMutableString alloc]init];
    
    if ([month integerValue]==1)
    {
      [lastQuarterStr appendString:[NSString stringWithFormat:@"%ld-12-01 00:00:00",[year integerValue]-1]];
    }
    else
    {
    [lastQuarterStr appendString:[NSString stringWithFormat:@"%@-%ld-01 00:00:00",year,[month integerValue]-1]];
    }
     NSDate *lastDate = [formatter dateFromString:lastQuarterStr];
    return [self firstDayTimeOfMonth:lastDate];
}


/**
 *  去年起始时间
 *
 *  @return 返回去年起始时间时间戳
 */
+(NSInteger)firstDayTimeOfLastQYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *str  = [formatter stringFromDate:[NSDate date]];
    NSString *year = [str substringToIndex:4];
    NSMutableString *lastQuarterStr = [[NSMutableString alloc]init];
    [lastQuarterStr appendString:[NSString stringWithFormat:@"%ld-01-01 00:00:00",[year integerValue]-1]];
    NSDate *lastDate = [formatter dateFromString:lastQuarterStr];
    return [self firstDayTimeOfYear:lastDate];
}


/**
 获取某一年的时间段
 @param year 年 2018
 @return 返回时间段
 */
+ (NSArray *)configTimeWithYear:(NSString *)year{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSMutableString *currentStr = [[NSMutableString alloc]init];
    [currentStr appendString:[NSString stringWithFormat:@"%@-01-01 00:00:00",year]];
    NSDate *currentDate = [formatter dateFromString:currentStr];
    
    
    NSMutableString *nextStr = [[NSMutableString alloc]init];
    [nextStr appendString:[NSString stringWithFormat:@"%ld-01-01 00:00:00",[year integerValue]+1]];
    NSDate *nextDate = [formatter dateFromString:nextStr];
    return @[@([self firstDayTimeOfYear:currentDate]),@([self firstDayTimeOfYear:nextDate]-1)];
}


@end
