//
//  VisitCaledarView.m
//  CLApp
//
//  Created by xslp_ios on 16/8/23.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "VisitCaledarView.h"


#define kCalendarMenuViewHeight 35
#define kCalendarContentViewHeightShort 85
/** 周视图和月视图的高 */
#define kHeight 120

@implementation VisitCaledarView{
    JTHorizontalCalendarView *calendarContentView;//日历内容视图 这个是水平滑动切换的
    JTCalendarManager *calendarManager;//日历管理类
    JTCalendarDayView *lastSelectedDayView;
    
    NSInteger week;
    NSInteger month;
    
    //点击了本日 本周 和 本月 要显示的字符串
    NSString *strDay;
    NSDate *todayDate;
    NSDate *minDate;
    NSDate *maxDate;
    NSDate *dateSelected;
    NSMutableDictionary *eventsByDate;
    NSDate *selectedDayDate;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLbDate];
        [self initCalandarView];
        [self visitCalendar];
        [self addSubview:self.visitWeek];
        
        [self addSubview:self.visitMoth];
        self.timeMethod = [[TimeMethod alloc]initWithDate:nil];
    }
    return self;
}
/**
 *  画日视图界面
 */
- (void)initCalandarView{
    
    calendarManager = [JTCalendarManager new];
    
    calendarManager.delegate = self;
    
    calendarManager.settings.weekModeEnabled = YES;
    
    calendarContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(0, kCalendarMenuViewHeight, kScreenWidth, kCalendarContentViewHeightShort)];
    
    calendarContentView.backgroundColor = kGrayColor;
    
    //[self addSubview:_calendarMenuView];
    
    [self addSubview:calendarContentView];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    //    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [calendarManager setContentView:calendarContentView];
    
    [calendarManager setDate:todayDate];
}

/**
 *  左右滑动能到的最小的和最大月份
 */
- (void)createMinAndMaxDate
{
    todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    minDate = [calendarManager.dateHelper addToDate:todayDate months:-12];
    
    // Max date will be 2 month after today
    maxDate = [calendarManager.dateHelper addToDate:todayDate months:12];
}

- (void)initLbDate{
    
    _vwDateDay = [[SLVisitDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCalendarMenuViewHeight)];
    
    [self addSubview:_vwDateDay];
    
    NSDate *date = [NSDate date];
    
    NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 10)];
    NSString *weekStr = [self weekdayStringFromDate:date];
    _vwDateDay.lbDate.text = [NSString stringWithFormat:@"%@  %@",str,weekStr];
    
    strDay = str;
    
    //        __vwDateDay.weekDate.text = [self weekdayStringFromDate:date];
    [_vwDateDay.btnCurrentDate setTitle:@"今天" forState:UIControlStateNormal];
    
    [_vwDateDay.btnCurrentDate addTarget:self action:@selector(clickCurrentDateWithSender:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark- 日历的方法
- (void)visitCalendar{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    calendar.timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    calendar.firstWeekday = 0;
    
    NSInteger unitFlags = NSCalendarUnitWeekOfYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitQuarter | NSCalendarUnitEra| NSCalendarUnitYear;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    //    NSInteger year = [comps year];
    //
    //    NSInteger quarter = [calendar ordinalityOfUnit:NSQuarterCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
    
    //_quarter = quarter;
    
    month = [comps month];
    
    week = [comps weekOfYear];
    
    
    //    NSInteger day = [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit: NSMonthCalendarUnit forDate:date];
    //
    //    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    
    //NSRange weekRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
    
    //_dayRange = range;
    
    //DLog(@"年: %ld,季度: %ld,月份 :%ld,几号 :%ld,本月第一天 :%lu,本月多少天 :%lu",year,quarter,(long)month,(long)day,(unsigned long)range.location,(unsigned long)range.length);
    
}


#pragma mark - JTCalendarDelegate delegate - Page mangement
- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    
    return label;
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        
        dateFormatter.locale = calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        
        label.textColor = [UIColor blackColor];
        
        label.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    }
    
    return view;
}

#pragma mark- 日视图的准备
// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    dayView.hidden = NO;
    
    // Other month
    //    if([dayView isFromAnotherMonth]){
    //        dayView.hidden = NO;
    //        //dayView.circleView.hidden = NO;
    ////        dayView.circleView.backgroundColor = kBlueColor;
    ////        dayView.dotView.backgroundColor = kColorRGB(135, 135, 135);
    ////        dayView.textLabel.textColor = [UIColor whiteColor];
    //    }
    //    // Today
    //    else
    
    if([calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor =HexColor(@"#f3900f");
        //        dayView.circleView.backgroundColor = kColorRGB(210, 57, 63);
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = HexColor(@"#42be5e");
        dayView.dotView.backgroundColor = kColorRGB(135, 135, 135);
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

#pragma mark- 点击了某一天后执行的动画效果 点击方法

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    dateSelected = dayView.date;
    
    selectedDayDate = dayView.date;
    
    lastSelectedDayView = dayView;
    
    NSString *str = [self strWithDate:dayView.date withRange:NSMakeRange(0, 10)];
    //    NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 10)];
    NSString *weekStr = [self weekdayStringFromDate:dayView.date];
    _vwDateDay.lbDate.text = [NSString stringWithFormat:@"%@  %@",str,weekStr];
    [self selectDBDataWithDateStr:str];
    //    self.timeMethod = [[TimeMethod alloc] initWithDate:dayView.date];
    NSInteger startTime = ((NSInteger)[dayView.date timeIntervalSince1970]/(60*60*24) + 1)*60*60*24 - 60*60*8;
    self.timeMethod.selectBetween = @[@(startTime),@(startTime+60*60*24-1)];
    // Animation for the circleView
    kWeakS(weakSelf);
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![calendarManager.dateHelper date:calendarContentView.date isTheSameMonthThan:dayView.date]){
        
        if([calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            //[_calendarContentView loadNextPageWithAnimation];
        }
        
        else{
            //[_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}


- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    
    //    view.circleRatio = .8;
    //    view.dotRatio = 1. / .9;
    
    return view;
}


#pragma mark - JTCalendarDelegate CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [calendarManager.dateHelper date:date isEqualOrAfter:minDate andEqualOrBefore:maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //        NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //        NSLog(@"Previous page loaded");
}

#pragma mark- 处理日期和时间用于比较 日视图的月视图
- (NSString *)strWithDate:(NSDate *)date withRange:(NSRange)range{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    strDate = [strDate substringWithRange:range];
    
    //DLog(@"%@",strDate);
    
    return strDate;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

#pragma mark- 本日 本周 本月 点击方法
- (void)clickCurrentDateWithSender:(UIButton *)sender{
    
    NSDate *date = [NSDate date];
    
    [self resetSearch];
    
    if ([sender.superview isEqual:_vwDateDay]) {
        
        NSLog(@"点击了本日");
        
        NSString *strDate = [self strWithDate:date withRange:NSMakeRange(0, 10)];
        NSString *weekStr = [self weekdayStringFromDate:date];
        
        [self selectDBDataWithDateStr:strDate];
        
        
        NSInteger startTime = ((NSInteger)[date timeIntervalSince1970]/(60*60*24))*60*60*24 - 60*60*8;
        self.timeMethod.selectBetween = @[@(startTime),@(startTime+60*60*24-1)];
        
        [calendarManager setDate:todayDate];
        
        if (![calendarManager.dateHelper date:lastSelectedDayView.date isTheSameDayThan:date] ) {
            
            lastSelectedDayView.circleView.hidden = YES;
            
            lastSelectedDayView.textLabel.textColor = [UIColor blackColor];
        }
        
        _vwDateDay.lbDate.text = [NSString stringWithFormat:@"%@  %@",strDate,weekStr];
        
    }
    else if ([sender.superview isEqual:_vwDateWeek]){
        
        NSLog(@"点击了本周");
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSInteger unitFlags = NSCalendarUnitWeekOfYear | NSCalendarUnitQuarter;
        
        NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSInteger curentWeek = [comps weekOfYear];
        
        NSString *str = [NSString stringWithFormat:@"'%ld'",(long)curentWeek - 1];
        
        [self.timeMethod reSetWithDate:date];
        self.timeMethod.selectBetween = @[@(self.timeMethod.firstDayTimeOfWeek),@(self.timeMethod.endDayTimeOfWeek)];
        
        [self selectDBDataWithWeekStr:str];
        
        _visitWeek.scrollTitle.contentOffset = CGPointMake(kScreenWidth / 7 * (curentWeek - 1), 0);

        _vwDateWeek.lbDate.text = [self getMonthBeginAndEndWith:date];
        
    }else if ([sender.superview isEqual:_vwDateMonth]){
        
        NSLog(@"点击了本月");
        
        NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 7)];
        
        [self selectDBDataWithDateStr:str];
        
        NSString *strMonth = [self strWithDate:date withRange:NSMakeRange(5, 2)];
        
        [self.timeMethod reSetWithDate:date];
        self.timeMethod.selectBetween = @[@(self.timeMethod.firstDayTimeOfMonth),@(self.timeMethod.endDayTimeOfMonth)];
        
        //DLog(@"%ld",(long)strMonth.integerValue);
        
        _visitMoth.scrllMonth.contentOffset = CGPointMake(kScreenWidth / 3 * (strMonth.integerValue - 1), 0);
        //
        _vwDateMonth.lbDate.text = str;
        
    }
    
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    
    if(!dateFormatter){
        
        dateFormatter = [NSDateFormatter new];
        
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(eventsByDate[key] && [eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

//重置筛选条件的按钮点击事件
- (void)resetSearch
{
    //    if (visitNoDataView != nil)
    //    {
    //        [visitNoDataView removeFromSuperview];
    //        visitNoDataView = nil;
    //        isSift = NO;
    //    }
    //
    //
    //    dicResult = nil;
    //    [self changeFitterColor];
    //    if (btnDay.selected == YES) {
    //
    //        DLog(@"%@",_lastDayOrMonthStr)
    //
    //        [self selectDBDataWithDateStr:_lastDayOrMonthStr];
    //
    //    }else if (_btnWeek.selected == YES){
    //
    //        DLog(@"%@",_lastWeekStr);
    //
    //        [self selectDBDataWithWeekStr:_lastWeekStr];
    //
    //    }else if (_btnMonth.selected == YES){
    //
    //        DLog(@"%@",_lastDayOrMonthStr)
    //
    //        [self selectDBDataWithDateStr:_lastDayOrMonthStr];
    //
    //    }
    
}

#pragma mark - DBMethod 月视图和日视图
- (void)selectDBDataWithDateStr:(NSString *)dateStr{
    //    //清除上一次日期的选择 重新配置数据源
    //    if (_dataSource.count > 0) {
    //
    //        [_dataSource removeAllObjects];
    //    }
    //
    //    //    NSString *sql = @"SELECT visit.id,visit.status,visit.client_id, contact.name AS visitObject, visit.visit_date, project.name AS project_name, project.id AS project_id, member_corp.realname AS visitPersonInCharge FROM visit LEFT JOIN project ON visit.project_id = project.id LEFT JOIN member_corp ON visit.userid = member_corp.userid LEFT JOIN contact ON visit.visit_role = contact.id WHERE project.id IS NOT NULL";
    //
    //    NSString *strMonth = @"'%Y-%m'";
    //
    //    NSString *strDay = @"'%Y-%m-%d'";
    //
    //    NSString *strDate = [NSString stringWithFormat:@"'%@'",dateStr];
    //
    //    NSString *sql = [NSString string];
    //
    //    _lastDayOrMonthStr = dateStr;
    //
    //    if (dateStr.length == 10) {
    //
    //        sql = [NSString stringWithFormat:@"SELECT visit.id,visit.status,visit.client_id, contact.name AS visitObject, visit.visit_date, project.name AS project_name, project.id AS project_id, member_corp.realname AS visitPersonInCharge FROM visit LEFT JOIN project ON visit.project_id = project.id LEFT JOIN member_corp ON visit.userid = member_corp.userid LEFT JOIN contact ON visit.visit_role = contact.id WHERE project.id IS NOT NULL and strftime(%@, datetime(visit_date, 'unixepoch', 'localtime')) = %@ order by visit_date DESC",strDay,strDate];
    //
    //        _sqlAll = sql;
    //
    //        [self selectVisitDelayCountWithDateFormat:strDay strDate:strDate strCurrentTime:_strCurrentTime];
    //        //
    //        [self selectVisitPrepareCountWithDateFormat:strDay strDate:strDate strCurrentTime:_strCurrentTime];
    //        //
    //        [self selectVisitCompleteCountWithDateFormat:strDay strDate:strDate];
    //
    //
    //    }else if (dateStr.length == 7){
    //
    //        sql = [NSString stringWithFormat:@"SELECT visit.id,visit.status,visit.client_id, contact.name AS visitObject, visit.visit_date, project.name AS project_name, project.id AS project_id, member_corp.realname AS visitPersonInCharge FROM visit LEFT JOIN project ON visit.project_id = project.id LEFT JOIN member_corp ON visit.userid = member_corp.userid LEFT JOIN contact ON visit.visit_role = contact.id WHERE project.id IS NOT NULL and strftime(%@, datetime(visit_date, 'unixepoch', 'localtime')) = %@ order by visit_date DESC",strMonth,strDate];
    //
    //        _sqlAll = sql;
    //
    //        [self selectVisitDelayCountWithDateFormat:strMonth strDate:strDate strCurrentTime:_strCurrentTime];
    //
    //        [self selectVisitPrepareCountWithDateFormat:strMonth strDate:strDate strCurrentTime:_strCurrentTime];
    //
    //        [self selectVisitCompleteCountWithDateFormat:strMonth strDate:strDate];
    //
    //    }
    //    [self refresh];
}

#pragma mark - 添加周视图和月视图的自定义view
- (SLVisitWeekView *)visitWeek {
    if (!_visitWeek) {
        CGRect rect = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        _visitWeek = [[SLVisitWeekView alloc] initWithFrame:rect];
        _visitWeek.backgroundColor = [UIColor whiteColor];
        _visitWeek.hidden = YES;
        _visitWeek.scrollTitle.titlesdelegate = self;
        _visitWeek.weekTop.delegate = self;
        
        _visitWeek.weekTop.hidden = YES;
        
        _vwDateWeek = [[SLVisitDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCalendarMenuViewHeight)];
        
        [self addSubview:_vwDateWeek];
        
        //__vwDateDay.lbDate.text = str;
        
        [_vwDateWeek.btnCurrentDate setTitle:@"本周" forState:UIControlStateNormal];
        
        [_vwDateWeek.btnCurrentDate addTarget:self action:@selector(clickCurrentDateWithSender:) forControlEvents:UIControlEventTouchUpInside];
        
        [_visitWeek addSubview:_vwDateWeek];
        
        [_vwDateWeek mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kCalendarMenuViewHeight));
            
            make.top.mas_equalTo(0);
            
        }];
        
        //MARK: - 假数据入口^=^没有假数据,自己计算第几周
        NSMutableArray *arrWeekM = [[NSMutableArray alloc] initWithCapacity:15];
        
        for (int i = 1; i < 55; i++) {
            
            NSString *weekStr = [NSString stringWithFormat:@"%zd周",i];
            
            [arrWeekM addObject:weekStr];
        }
        
        [arrWeekM replaceObjectAtIndex:week - 1 withObject:@"本周"];
        if(week !=1)
        [arrWeekM replaceObjectAtIndex:week - 2 withObject:@"上周"];
        
        [arrWeekM replaceObjectAtIndex:week  withObject:@"下周"];
        
        //        _visitWeek.scrollTitle.intergerMiddle = curentWeek;
        [_visitWeek.scrollTitle setupWithTitleArray:arrWeekM.copy];
        
    }
    return _visitWeek;
}
- (SLVisitMonthView *)visitMoth {
    if (!_visitMoth) {
        CGRect rect = CGRectMake(0, 0, self.bounds.size.width, kHeight);
        _visitMoth = [[SLVisitMonthView alloc] initWithFrame:rect];
        _visitMoth.backgroundColor = [UIColor whiteColor];
        _visitMoth.hidden = YES;
        _visitMoth.scrllMonth.titlesdelegate = self;
        
        _visitMoth.monthTop.hidden = YES;
        
        _vwDateMonth = [[SLVisitDateView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCalendarMenuViewHeight)];
        
        [_vwDateMonth.btnCurrentDate setTitle:@"本月" forState:UIControlStateNormal];
        
        [_vwDateMonth.btnCurrentDate addTarget:self action:@selector(clickCurrentDateWithSender:) forControlEvents:UIControlEventTouchUpInside];
        
        [_visitMoth addSubview:_vwDateMonth];
        
        [_vwDateMonth mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, kCalendarMenuViewHeight));
            
            make.top.mas_equalTo(0);
            
        }];
        
        //MARK: - 设置数组,存放12个月
        NSMutableArray *arrMonthM = [[NSMutableArray alloc] initWithCapacity:15];
        for (int i = 0; i < 12; i++) {
            NSString *month1 = [NSString stringWithFormat:@"%zd月",i+1];
            [arrMonthM addObject:month1];
        }
        if (month == 1 || month == 12) {
            for (int i = 0; i < 12; i++) {
                NSString *month1 = [NSString stringWithFormat:@"%zd月",i+1];
                [arrMonthM addObject:month1];
            }
        }
        if(month == 1){
            month = 13;
        }
        [arrMonthM replaceObjectAtIndex:month - 1 withObject:@"本月"];
        
        [arrMonthM replaceObjectAtIndex:month - 2 withObject:@"上月"];
        
        [arrMonthM replaceObjectAtIndex:month  withObject:@"下月"];
        
        [_visitMoth.scrllMonth setupWithTitleArray:arrMonthM.copy];
        //设置代理
        _visitMoth.monthTop.delegate = self;
    }
    return _visitMoth;
}

// visitWeek.scrollTitle.delegate
- (void)scrollviewShouldScollByTitleScollview:(NSInteger)page {
    
    NSLog(@"点击了第%zd周",page);
    
    if(_visitWeek.hidden == NO){
        
        NSString *str = [NSString stringWithFormat:@"'%ld'",(long)page - 1];
        
        //DLog(@"%@",str);
        
        [self selectDBDataWithWeekStr:str];
        
    }
    
    
    NSDate *date =[NSDate date];
    
    NSInteger intervalNum = page - week;
    
    NSDate *intervalDate = [date dateByAddingTimeInterval:60*60*24*7 * intervalNum ];
    
    [self.timeMethod reSetWithDate:intervalDate];
    self.timeMethod.selectBetween = @[@(self.timeMethod.firstDayTimeOfWeek),@(self.timeMethod.endDayTimeOfWeek)];
    
    _vwDateWeek.lbDate.text = [self getMonthBeginAndEndWith:intervalDate];
    
}

//visitMonth.scroll.delegate
- (void)scrollMonthShouldScollByTitleScollview:(NSInteger)page {
    
    NSLog(@"点击了第%zd月",page);
    NSDate *date = [NSDate date];
    NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 5)];
//    if (_visitMoth.hidden == NO)
//    {
    
        //        NSDate *date = [NSDate date];
        
        //        NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 5)];
        
        if (page < 10) {
            
            str = [str stringByAppendingFormat:@"0%ld",(long)page];
        }else if (page>12){
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:31*24*60*60];
            
            str = [self strWithDate:date withRange:NSMakeRange(0, 5)];
            str = [str stringByAppendingFormat:@"%ld",(long)page - 12];
        }else{
            
            str = [str stringByAppendingFormat:@"%ld",(long)page];
        }
        
        //DLog(@"%@",str);
        
        [self selectDBDataWithDateStr:str];
//    }
    
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //    NSString *monthStr;
    //
    //    if (page < 10) {
    //
    //        monthStr = [NSString stringWithFormat:@"0%ld",(long)page];
    //    }else if (page>12){
    //        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:31*24*60*60];
    //
    //        monthStr = [self strWithDate:date withRange:NSMakeRange(0, 5)];
    //        monthStr = [monthStr stringByAppendingFormat:@"%ld",(long)page - 12];
    //    }else{
    //
    //        monthStr = [NSString stringWithFormat:@"%ld",page];
    //    }
    //
    //    NSDate *date = [NSDate date];
    //
    //    NSString *str = [[myDateFormatter stringFromDate:date] substringWithRange:NSMakeRange(0, 4)];
    //
    //    //DLog(@"%@",str);
    //
    //    str = [str stringByAppendingString:[NSString stringWithFormat:@"-%@-01",monthStr]];
    str = [str stringByAppendingString:@"-01"];
    //DLog(@"%@",str);
    
    NSDate *selectDate = [myDateFormatter dateFromString:str];
    
    double interval = 0;
    
    NSDate *beginDate = nil;
    
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    
    
    [self.timeMethod reSetWithDate:selectDate];
    self.timeMethod.selectBetween = @[@(self.timeMethod.firstDayTimeOfMonth),@(self.timeMethod.endDayTimeOfMonth)];
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:selectDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    //    }else {
    //        return;
    //    }
    //    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    //    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    
    //NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    //NSString *strMonth = [NSString stringWithFormat:@"%@ - %@",beginString,endString];
    
    //__vwDateMonth.lbDate.text = strMonth;
    
    NSString *mStr = [beginString substringWithRange:NSMakeRange(0, beginString.length - 3)];
    
    _vwDateMonth.lbDate.text = mStr;
    
    //DLog(@"%@",s);
    
}

// MARK: 本周,上周,下周,本月,上月,下月
- (void)onClickBtn:(UIButton *)button {
    
    if (self.visitWeek.hidden == NO && self.visitMoth.hidden == YES) {
        //周数
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSInteger unitFlags = NSCalendarUnitWeekOfYear | NSCalendarUnitQuarter;
        
        NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
        
        NSInteger curentWeek = [comps weekOfYear];
        
        switch (button.tag) {
            case 0:
                NSLog(@"点击了上周");
                self.visitWeek.scrollTitle.lastWeek = curentWeek - 1;
                break;
            case 1:
                self.visitWeek.scrollTitle.week = curentWeek;
                NSLog(@"点击了本周");
                break;
            case 2:
                self.visitWeek.scrollTitle.nextWeek = curentWeek + 1;
                NSLog(@"点击了下周");
                break;
                
            default:
                break;
        }
    } else {
        //月数
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM"];
        NSString *currentMonth = [dateFormatter stringFromDate:date];
        
        //        NSString *str = [self strWithDate:date withRange:NSMakeRange(0, 7)];
        
        switch (button.tag) {
            case 0:
                self.visitMoth.scrllMonth.lastMonth = currentMonth.intValue - 1;
                NSLog(@"点击了上月");
                break;
            case 1:
            {
                self.visitMoth.scrllMonth.lastMonth = currentMonth.intValue;
                
                //[self selectDBDataWithDateStr:str];
                
                NSLog(@"点击了本月");
            }
                break;
            case 2:
                self.visitMoth.scrllMonth.lastMonth = currentMonth.intValue + 1;
                NSLog(@"点击了下月");
                break;
            default:
                break;
        }
    }
    
}

- (NSString *)getMonthBeginAndEndWith:(NSDate *)newDate{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    //    }else {
    //        return;
    //    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *s = [NSString stringWithFormat:@"%@ - %@",beginString,endString];
    
    return s;
}

#pragma mark- 数据库选择用于周视图
- (void)selectDBDataWithWeekStr:(NSString *)weekStr{
    
    //    if (_dataSource.count > 0) {
    //
    //        [_dataSource removeAllObjects];
    //    }
    //
    //    _lastWeekStr = weekStr;
    //
    //    NSString *sql = [NSString stringWithFormat:@"SELECT visit.id,visit.status,visit.client_id, contact.name AS visitObject, visit.visit_date, project.name AS project_name, project.id AS project_id, member_corp.realname AS visitPersonInCharge FROM visit LEFT JOIN project ON visit.project_id = project.id LEFT JOIN member_corp ON visit.userid = member_corp.userid LEFT JOIN contact ON visit.visit_role = contact.id WHERE project.id IS NOT NULL and strftime(%@, datetime(visit_date, 'unixepoch', 'localtime')) = %@ order by visit_date DESC",@"'%W'",weekStr];
    //
    //    _sqlAll = sql;
    //    [self refresh];
    //    [self selectVisitDelayCountWithDateFormat:@"'%W'" strDate:weekStr strCurrentTime:_strCurrentTime];
    //
    //    [self selectVisitPrepareCountWithDateFormat:@"'%W'" strDate:weekStr strCurrentTime:_strCurrentTime];
    //
    //    [self selectVisitCompleteCountWithDateFormat:@"'%W'" strDate:weekStr];
    //
    //    NSMutableArray *array = [[SLUtils sharedInstance].dataBaseHelper excuteQeuryBySQL:sql entityName:@"visitmodel"];
    //
    //    _dataSource = [NSMutableArray arrayWithArray:array];
    //
    //    if (_dataSource.count) {
    //
    //        [SLUtils sharedInstance].visitDataSource = [NSMutableArray arrayWithArray:_dataSource];
    //    }
    //
    //    [self imgPromptWithNoData];
    //
    //    _isSift = NO;
    //
    //    [_tvVisit reloadData];
    
}


@end
