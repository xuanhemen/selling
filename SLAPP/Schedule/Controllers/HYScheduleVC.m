//
//  HYScheduleVC.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleBoltingView.h"
#import "HYScheduleDayListCell.h"
#import "LTSCalendarManager.h"
#import "HYScheduleVC.h"
#import "NSDate+Method.h"
#import "HYScheduleViewModel.h"
#import "HYScheduleListModel.h"
#import "HYScheduleListDelegate.h"
#import <MJRefresh/MJRefresh.h>
#import "HYScheduleDayListDelegate.h"
#import "HYScheduleSearchVC.h"
#import "HYAddScheduleVC.h"
#import "SLNewBuildScheduleVC.h"
@interface HYScheduleVC ()<LTSCalendarEventSource>
//第三方的日历管理
@property (nonatomic,strong)LTSCalendarManager *manager;
//日历显示的列表
@property (nonatomic,strong)UITableView *table;
//点了日程显示的列表
@property (nonatomic,strong)UITableView *scheduleTable;

@property (nonatomic,strong)NSDate *scheduleLastDate;
@property (nonatomic,strong)NSDate *scheduleDate;
//日程列表代理
@property (nonatomic,strong)HYScheduleListDelegate *scheduleListDelegate;
//日历下的日程代理
@property (nonatomic,strong)HYScheduleDayListDelegate *scheduleDayListDelegate;

//记录上次请求月
@property (nonatomic,strong)NSString *lastTimeStr;
@property (nonatomic,strong)NSMutableArray *dayListArray;

//筛选
@property(nonatomic,strong)HYScheduleBoltingView *boltingView;
//选中的筛选条件  部门或者人员
@property(nonatomic,strong)HYDepMemberModel *depModel;
//选中的筛选条件  具体的日程
@property(nonatomic,strong)HYScheduleListModel *selectSchedulemodel;



@end

@implementation HYScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dayListArray = [NSMutableArray array];
    [self congigUI];
    
}


-(void)congigUI{
    self.manager = [LTSCalendarManager new];
    [LTSCalendarAppearance share].dayCircleColorToday = kgreenColor;
    [LTSCalendarAppearance share].dayBorderColorToday = kgreenColor;
    [LTSCalendarAppearance share].dayCircleColorSelected = kgreenColor;
    [LTSCalendarAppearance share].dayDotColor = [UIColor redColor];
    
    self.manager.eventSource = self;
    self.manager.weekDayView = [[LTSCalendarWeekDayView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [self.view addSubview:self.manager.weekDayView];
    
    self.manager.calenderScrollView = [[LTSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.manager.weekDayView.frame), CGRectGetWidth(self.view.frame),kScreenHeight-kNav_height-30-kTab_height)];
    [self.view addSubview:self.manager.calenderScrollView];
    
    kWeakS(weakSelf);
    _scheduleDayListDelegate = [[HYScheduleDayListDelegate alloc] initWithCellIde:@"HYScheduleDayListCell" AndAutoCellHeight:60 modelKey:@"model" AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, HYScheduleListModel *model) {
        
        SLNewBuildScheduleVC *bvc = [[SLNewBuildScheduleVC alloc]init];
        bvc.buildStyle = SLBuildStyleToView;
        bvc.numberID = model.id;
        bvc.userID = model.userid;
        bvc.freshList = ^(NSString * _Nonnull ID) {
            //编辑成功之后code
    
            [weakSelf toReloadData];
        };
        [weakSelf.navigationController pushViewController:bvc animated:YES];
        
    }];
    
    
    self.manager.calenderScrollView.tableView.delegate = _scheduleDayListDelegate;
    self.manager.calenderScrollView.tableView.dataSource = _scheduleDayListDelegate;
    
    
    _scheduleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height-49)];
    _scheduleTable.hidden = YES;
    [self.view addSubview:_scheduleTable];
    
    
    _scheduleListDelegate = [[HYScheduleListDelegate alloc] initWithCellIde:@"HYScheduleListCell" AndAutoCellHeight:60 modelKey:nil AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, HYScheduleListModel * model) {
        
        SLNewBuildScheduleVC *bvc = [[SLNewBuildScheduleVC alloc]init];
        bvc.buildStyle = SLBuildStyleToView;
        bvc.numberID = model.id;
        bvc.freshList = ^(NSString * _Nonnull ID) {
            //编辑成功之后code
            
            [weakSelf toReloadData];
        };
        [weakSelf.navigationController pushViewController:bvc animated:YES];
        
    }];
    _scheduleTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getScheduleDataIsHeaderRefresh:YES];
    }];
    
    _scheduleTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getScheduleDataIsHeaderRefresh:NO];
    }];;
    
    _scheduleTable.delegate = _scheduleListDelegate;
    _scheduleTable.dataSource = _scheduleListDelegate;
//
    
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kMain_screen_height_px-kNav_height-49, kScreenWidth, 49)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    todayBtn.frame = CGRectMake(0, 0, 50, 49);
    [todayBtn addTarget:self action:@selector(todayClick) forControlEvents:UIControlEventTouchUpInside];
    [todayBtn setTitle:@"今日" forState:UIControlStateNormal];
    [todayBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    [bottomView addSubview:todayBtn];
   
    UIButton *scheduleAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scheduleAddBtn.frame = CGRectMake((kScreenWidth-60)/2,49-60, 60, 60);
    [scheduleAddBtn addTarget:self action:@selector(scheduleAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scheduleAddBtn setImage:[UIImage imageNamed:@"scheduleAdd"] forState:UIControlStateNormal];
    [scheduleAddBtn setImage:[UIImage imageNamed:@"scheduleAdd"] forState:UIControlStateHighlighted];
    [scheduleAddBtn setImage:[UIImage imageNamed:@"scheduleAdd"] forState:UIControlStateSelected];
    [bottomView addSubview:scheduleAddBtn];
    
    
    
    UIButton *scheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scheduleBtn.frame = CGRectMake(kScreenWidth-50, 0, 50, 49);
    [scheduleBtn addTarget:self action:@selector(scheduleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [scheduleBtn setTitle:@"列表" forState:UIControlStateNormal];
    [scheduleBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    [bottomView addSubview:scheduleBtn];
    
    
 
    self.automaticallyAdjustsScrollViewInsets = false;
    //设置默认滑动选中
    //[LTSCalendarAppearance share].defaultSelected = false;
    //设置显示单周时滑动默认选中星期几
    //[LTSCalendarAppearance share].singWeekDefaultSelectedIndex = 2;
    
    [self setRightBtnsWithImages:@[@"nav_filter",@"nav_search"]];
    
}

// 该日期是否有事件
- (BOOL)calendarHaveEventWithDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    if ([_lastTimeStr isEqualToString:key]) {
        NSInteger index = [self getDayNumWith:date];
        if (index <= self.dayListArray.count) {
            return  [self.dayListArray[index-1] count];
        }
    }
    return NO;
}
//当前 选中的日期  执行的方法
- (void)calendarDidSelectedDate:(NSDate *)date {
    
    NSString *key = [[self dateFormatter] stringFromDate:date];
    self.title = key;
    [_scheduleDayListDelegate.dataArray removeAllObjects];
    if (![_lastTimeStr isEqualToString:key]) {
        [self getDayScheduleDataWithDate:date];
    }else{
        self.lastTimeStr = key;
        NSInteger index = [self getDayNumWith:date];
        if (index  <= self.dayListArray.count) {
            [self.scheduleDayListDelegate.dataArray addObjectsFromArray:self.dayListArray[index-1]];
        }
        [self.manager.calenderScrollView.tableView reloadData];
    }
    
    
    
}

- (void)calendarDidScrolledYear:(NSInteger)year month:(NSInteger)month{
//    NSLog(@"当前年份：%d,当前月份：%d",year,month);
}


/**
 获取某天的号

 @param date <#date description#>
 @return <#return value description#>
 */
-(NSInteger)getDayNumWith:(NSDate *)date{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"dd";
    return [[f stringFromDate:date] integerValue];
    
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy.MM";
    }
    
    return dateFormatter;
}








/**
 今日按钮点击
 */
-(void)todayClick{
    
    if (self.scheduleTable.isHidden) {
        [self.manager goToDate:[NSDate date]];
    }else{
        [self listToToday];
    }
}



/**
 日程列表  点击了今日后   跳转到今日的数据
 */
-(void)listToToday{
    
    
    NSArray * data = _scheduleListDelegate.dataArray;
    double todayTime = [[NSDate date] timeIntervalSince1970];
    NSIndexPath * index;
    for (int i = 0; i < data.count ; i++) {
        NSArray *array = (NSArray *)data[i];
        if (array.count) {
            HYScheduleListModel *model = array.firstObject;
            if ( [[NSDate getDateStyleYMWithTime:model.monthTime] isEqualToString:[NSDate getDateStyleYMWithTime:todayTime]]) {
                
                for (int j = 0; j < array.count ; j ++ ) {
                    
                    HYScheduleListModel *subModel = array[j];
                    if ([[NSDate getDateStyleDayWithTime:todayTime] intValue] == [subModel.showDay intValue])
                    {
                        index = [NSIndexPath indexPathForRow:j inSection:i];
                        break;
                        
                    }
                    
                }
                
                
                
            }
        }
        
    }
    
    if (index) {
        [_scheduleTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
}



/**
 日程按钮点击
 */
-(void)scheduleBtnClick:(UIButton *)btn{
     _scheduleTable.hidden = !_scheduleTable.hidden;
    if (_scheduleTable.hidden == YES) {
         [btn setTitle:@"列表" forState:UIControlStateNormal];
        self.title = _lastTimeStr;
    }else{
        [btn setTitle:@"日程" forState:UIControlStateNormal];
        self.title = @"日程";
    }
    
    [_scheduleListDelegate.dataArray removeAllObjects];
    _scheduleLastDate = nil;
    _scheduleDate = nil;
     [self getScheduleDataIsHeaderRefresh:NO];

    
}

-(void)scheduleAddBtnClick{
//    HYScheduleVC *vc = [[HYScheduleVC alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
   
    kWeakS(weakSelf);
    SLNewBuildScheduleVC *nvc = [[SLNewBuildScheduleVC alloc]init];
    nvc.buildStyle = SLBuildStyleNew;
    nvc.freshList = ^(NSString * _Nonnull ID) {
        //新建日程成功，刷新列表
        [weakSelf toReloadData];
    };
    [self.navigationController pushViewController:nvc animated:YES];
    
}


/**
 获取某一天的数据

 @param date <#date description#>
 */
-(void)getDayScheduleDataWithDate:(NSDate *)date{
    kWeakS(weakSelf);
    [self showProgress];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"query_time"] = [NSString stringWithFormat:@"%f",date.timeIntervalSince1970 ];
    [self addFitter:params];
    [HYBaseRequest getPostWithMethodName:kSearchScheduleList Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        NSString *key = [[weakSelf dateFormatter] stringFromDate:date];
        weakSelf.lastTimeStr = key;
        [weakSelf.dayListArray removeAllObjects];
        [weakSelf.scheduleDayListDelegate.dataArray removeAllObjects];
        if ([result[@"list"] isNotEmpty]) {
            NSArray * array = [HYScheduleListModel mj_objectArrayWithKeyValuesArray:result[@"list"]];
           [weakSelf.dayListArray addObjectsFromArray:[HYScheduleViewModel getDayListArrayWithDate:date AndArray:array]];
        }
        NSInteger index = [weakSelf getDayNumWith:date];
        if (index  <= weakSelf.dayListArray.count) {
            [weakSelf.scheduleDayListDelegate.dataArray addObjectsFromArray:weakSelf.dayListArray[index-1]];
        }
        
         [weakSelf.manager reloadAppearanceAndData];
        [weakSelf dismissProgress];
        [weakSelf.manager.calenderScrollView.tableView reloadData];
        
    } fail:^(NSDictionary *result) {
        
        [weakSelf dissmissWithError];
    }];
    
    
    
    
    
    
    
}




/**
 添加筛选条件

 @param params 请求参数中添加筛选条件
 */
-(void)addFitter:(NSMutableDictionary *)params{
    if ([self.depModel isNotEmpty]) {
        if ([self.depModel.key isEqualToString:@"dep"]) {
            //部门
            params[@"inquire_dep_id"] = self.depModel.id;
        }else if ([self.depModel.key isEqualToString:@"member"]){
            //人员
            params[@"inquire_member_id"] = self.depModel.id;
        }
        
    }
    
    if ([self.selectSchedulemodel isNotEmpty]) {
        //日程
        params[@"schedule_id"] = self.selectSchedulemodel.id;
    }
    
}


/**
 获取日程相关的数据
 */
-(void)getScheduleDataIsHeaderRefresh:(BOOL)isHeader{
    kWeakS(weakSelf);
    [self showProgress];
    NSDate * tempDate = nil;
    if (isHeader) {
        if (_scheduleLastDate) {
            tempDate = [NSDate lastMonthWithDate:_scheduleLastDate];
        }else{
            tempDate = [NSDate date];
        }
    }else{
        if (_scheduleDate) {
            tempDate = [NSDate nextMonthWithDate:_scheduleDate];
        }else{
            tempDate = [NSDate date];
        }
        
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"query_time"] = [NSDate getDayBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:tempDate].firstObject;
    [self addFitter:params];
    
    
    [HYBaseRequest getPostWithMethodName:kSearchScheduleList Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        
        if (isHeader) {
             weakSelf.scheduleLastDate = tempDate;
            if (!weakSelf.scheduleDate) {
                weakSelf.scheduleDate = tempDate;
            }
        }else{
             weakSelf.scheduleDate = tempDate;
            if (!weakSelf.scheduleLastDate) {
                weakSelf.scheduleLastDate = tempDate;
            }
        }
       
        [weakSelf.scheduleTable.mj_header endRefreshing];
        [weakSelf.scheduleTable.mj_footer endRefreshing];
        if ([result[@"list"] isNotEmpty]) {
            
            NSArray * array = [HYScheduleListModel mj_objectArrayWithKeyValuesArray:result[@"list"]];
            if (!isHeader) {
                [weakSelf.scheduleListDelegate.dataArray addObject:[HYScheduleViewModel getScheduleListArrayWithDate:tempDate AndArray:array]];
            }else{
                [weakSelf.scheduleListDelegate.dataArray insertObject:[HYScheduleViewModel getScheduleListArrayWithDate:tempDate AndArray:array] atIndex:0];
            }
            
        }
        
        [weakSelf dismissProgress];
        [weakSelf.scheduleTable reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf.scheduleTable.mj_header endRefreshing];
        [weakSelf.scheduleTable.mj_footer endRefreshing];
        [weakSelf dissmissWithError];
    }];
    
}


- (void)rightClick:(UIButton *)btn{
    if (btn.tag == 1000) {
        [self getBoltingData];
    }else{
        HYScheduleSearchVC *vc = [[HYScheduleSearchVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



/**
 添加筛选界面

 @param model <#model description#>
 */
-(void)toAddBoltingViewWithModel:(HYBoltingModel *)model{
     self.boltingView.model = model;
    [self.boltingView configWithSelectDepModel:_depModel AndSelectScheduleModel:_selectSchedulemodel];
     [[UIApplication sharedApplication].keyWindow addSubview:self.boltingView];
    kWeakS(weakSelf);
    self.boltingView.result = ^(HYDepMemberModel * _Nonnull depModel, HYScheduleListModel * _Nonnull selectSchedulemodel) {
        weakSelf.depModel = depModel;
        weakSelf.selectSchedulemodel = selectSchedulemodel;
        [weakSelf.boltingView removeFromSuperview];
         weakSelf.boltingView = nil;
        [weakSelf toReloadData];
    };
}



/**
 筛选条件选择后重新请求数据
 */
-(void)toReloadData{
    
    if ([self.depModel isNotEmpty] || [self.selectSchedulemodel isNotEmpty]) {
         [self setRightBtnsWithImages:@[@"nav_filter_select",@"nav_search"]];
        
    }else{
         [self setRightBtnsWithImages:@[@"nav_filter",@"nav_search"]];
        
    }
    
    [self.scheduleDayListDelegate.dataArray removeAllObjects];
    [self getDayScheduleDataWithDate:self.manager.currentSelectedDate];
    
    
    //日程列表
    _scheduleDate = nil;
    _scheduleLastDate = nil;
    [self.scheduleListDelegate.dataArray removeAllObjects];
    [self getScheduleDataIsHeaderRefresh:NO];
}



//筛选
-(HYScheduleBoltingView *)boltingView{
    if (!_boltingView){
        _boltingView = [[HYScheduleBoltingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _boltingView;
}




/**
 获取筛选条件数据
 */
-(void)getBoltingData{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"query_time"] = [NSDate getDayBeginTimeIntervalStrAndEndTimeIntervalStrWithDate:tempDate].firstObject;
    
    [HYBaseRequest getPostWithMethodName:kScheduleDepMember Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        if ([result isNotEmpty]) {
            HYBoltingModel *model = [HYBoltingModel mj_objectWithKeyValues:result];
            [weakSelf toAddBoltingViewWithModel:model];
        }
        
        [weakSelf dismissProgress];
       
        
    } fail:^(NSDictionary *result) {
       
        [weakSelf dissmissWithError];
    }];
    
}



@end
