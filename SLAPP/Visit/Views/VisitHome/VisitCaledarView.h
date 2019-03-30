//
//  VisitCaledarView.h
//  CLApp
//
//  Created by xslp_ios on 16/8/23.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JTCalendar.h"
#import <JTCalendar/JTCalendar.h>
#import "SLVisitDateView.h"
#import "SLVisitWeekView.h"
#import "SLVisitMonthView.h"
#import "TimeMethod.h"

@interface VisitCaledarView : UIView<JTCalendarDelegate,WJSScrollTitleDelegate,WJSTitleViewDelegate,WJSScrollViewMonthDelegate>

@property(nonatomic, strong) SLVisitDateView *vwDateDay;
@property(nonatomic, strong) SLVisitDateView *vwDateWeek;
@property(nonatomic, strong) SLVisitDateView *vwDateMonth;

/** 周视图 */
@property(nonatomic, strong) SLVisitWeekView *visitWeek;
/** 月视图 */
@property(nonatomic, strong)  SLVisitMonthView *visitMoth;
//计时器
@property(nonatomic, strong) TimeMethod *timeMethod;

- (NSString *)strWithDate:(NSDate *)date withRange:(NSRange)range;

//@property (strong, nonatomic)  TMFitler *vwFilter;//筛选下拉
//
//@property (strong, nonatomic)  NoDataView *visitNoDataView;//拜访数据源为空时给个提示
//本日本周本月按钮点击事件
- (void)clickCurrentDateWithSender:(UIButton *)sender;
@end
