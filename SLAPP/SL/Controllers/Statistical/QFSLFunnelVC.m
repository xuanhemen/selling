//
//  QFSLFunnelVC.m
//  SLAPP
//
//  Created by qwp on 2018/8/6.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFSLFunnelVC.h"
#import "QFHeader.h"
#import "QFChooseDateView.h"
#import "QFFunnelView.h"
#import "QFPopupView.h"
#import "QFMaskView.h"
#import "SLAPP-Swift.h"
#import "PDateChooseView.h"
#import "HYProjectCell.h"
@interface QFSLFunnelVC ()<UITableViewDelegate,UITableViewDataSource,QFPopupViewDelegate,QFMaskViewDelegate,QFFunnelViewDelegate>{
    
    
}
@property (nonatomic,strong) NSString *monthString;
@property (nonatomic,strong) NSString *quarterString;
@property (nonatomic,strong) NSString *yearString;
@property (nonatomic,strong) NSString *custom_timeString;
@property (nonatomic,strong) QFChooseDateView *chooseDateView;
@property (nonatomic,strong) UITableView    *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) QFPopupView *popupView;
@property (nonatomic,strong) QFMaskView *maskView;
@property (nonatomic,strong) QFFunnelView *funnelView;

@property (nonatomic,strong) NSString *group_type;//分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
@property (nonatomic,strong) NSString *group_sort_type;//排序类型（asc 正序desc倒序）
@property (nonatomic,strong) NSString *group_field;//排序字段(edittime更新时间 create_time创建时间 analyse_update_time分析时间 dealtime完成时间 trade_name行业 name名称 amount金额)

@end

@implementation QFSLFunnelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"销售漏斗";
    self.monthString = @"";
    self.quarterString = nil;
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy"];
    self.yearString = [f stringFromDate:[NSDate date]];
    
    self.custom_timeString = nil;
    self.group_type = @"";
    self.group_field = @"";
    self.group_sort_type = @"";
    
    self.dataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
    [self reloadDate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configUI{
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    UIView *tableViewheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth-60-30-15)/1000*867+30+30+50+60)];
    
    self.funnelView = [[QFFunnelView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, (kScreenWidth-60-30-15)/1000*867+30+30)];
    self.funnelView.delegate = self;
    [tableViewheaderView addSubview:self.funnelView];
    
    
    self.chooseDateView = [[QFChooseDateView alloc] initWithType:1 andFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    self.chooseDateView.currentSelect = 2;
    [self.chooseDateView configUI];
    __weak QFSLFunnelVC *weakSelf = self;
    self.chooseDateView.block = ^(NSString *week, NSString *month, NSString *quarter, NSString *year) {
        NSLog(@"周：%@,月：%@,季度：%@,年：%@",week,month,quarter,year);
        weakSelf.custom_timeString = nil;
        weakSelf.monthString = month;
        weakSelf.quarterString = quarter;
        weakSelf.yearString = year;
        [weakSelf configData];
    };
    [tableViewheaderView addSubview:self.chooseDateView];
    
    
    self.popupView = [[QFPopupView alloc] initWithFrame:CGRectMake(0, tableViewheaderView.frame.size.height-50, kScreenWidth, 50)];
    self.popupView.delegate = self;
    [tableViewheaderView addSubview:self.popupView];
    
    [self.popupView configUI];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewheaderView.frame.size.height-1, kScreenWidth, 1)];
    line.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [tableViewheaderView addSubview:line];
    
    
    
    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.tableHeaderView = tableViewheaderView;
    [self.view addSubview:self.table];
    
    //table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(reloadDate))
    //self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80))
    
    

    
    self.maskView = [[QFMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight)];
    self.maskView.delegate = self;
    [self.view addSubview:self.maskView];
    
    UIButton *button = [[UIButton  alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addDate) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)addDate{
    kWeakS(weakSelf);
    PDateChooseView *pDate = [[PDateChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].delegate.window addSubview:pDate];
    pDate.result = ^(NSString *timerStr) {
        weakSelf.custom_timeString = timerStr;
        weakSelf.monthString = nil;
        weakSelf.quarterString = nil;
        weakSelf.yearString = nil;
        [weakSelf configData];
        
    };
}

- (void)reloadDate{
    if (![self.funnelView.project_ids isNotEmpty]) {
        [self.dataArray removeAllObjects];
        [self.table reloadData];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:self.group_type forKey:@"group"];
    [params setObject:self.group_sort_type forKey:@"sort_type"];
    [params setObject:self.group_field forKey:@"field"];
    [params setObject:self.funnelView.project_ids forKey:@"project_ids"];
    NSLog(@"请求的数据%@",params);
    [params setObject:[UserModel getUserModel].token forKey:@"token"];
    
    __weak QFSLFunnelVC *weakSelf = self;
    [self showOCProgress];
    
    
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.sorted_content" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        //        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        
        
        NSArray *fulldata = a[@"data"];
        [self.dataArray removeAllObjects];
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            [dict setObject:@"0" forKey:@"isShow"];
            [self.dataArray addObject:dict];
        }
        [weakSelf.table  reloadData];
        
    }];
}
- (void)configData{
    
    UserModel *model = UserModel.getUserModel;
    
    
    __weak QFSLFunnelVC *weakSelf = self;
    [self showOCProgress];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.monthString) {
        [params setObject:self.monthString forKey:@"month"];
    }
    if (self.quarterString) {
        [params setObject:self.quarterString forKey:@"quarter"];
    }
    if (self.yearString) {
        [params setObject:self.yearString forKey:@"year"];
    }
    if (self.custom_timeString) {
        [params setObject:self.custom_timeString forKey:@"custom_time"];
    }
    [params setObject:model.token forKey:@"token"];
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.project_funnel" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
//        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"获取漏斗:%@",a);
        
        weakSelf.chooseDateView.thisYear = [NSString stringWithFormat:@"%@",a[@"this_year"]];
        weakSelf.chooseDateView.thisMonth = [NSString stringWithFormat:@"%@",a[@"this_month"]];
        weakSelf.chooseDateView.thisQuarter = [NSString stringWithFormat:@"%@",a[@"this_quarter"]];
        [self.funnelView funnelDataArray:a[@"graph"]];
       
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArray[section];
    NSArray *array = dict[@"pro_list"];
    if ([dict[@"isShow"] integerValue]==0) {
        return 0;
    }else{
        return array.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"HYProjectCell";
    HYProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *array = dict[@"pro_list"];
    [cell setViewModelWithDictWithDict:array[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *proList = self.dataArray[indexPath.section][@"pro_list"];
    NSDictionary *dict = proList[indexPath.row];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:dict[@"id"]];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HYProjectHeaderView *view = [[HYProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [view.showBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    view.showBtn.tag = section+200;
    NSDictionary *dict = self.dataArray[section];
    [view setViewModelWithDict:dict];
    return view;
    
}
- (void)headerButtonClick:(UIButton *)sender{
    NSDictionary *dict = self.dataArray[sender.tag-200];
    if ([dict[@"isShow"] integerValue]==0) {
        [dict setValue:@"1" forKey:@"isShow"];
    }else{
        [dict setValue:@"0" forKey:@"isShow"];
    }
    [self.dataArray replaceObjectAtIndex:sender.tag-200 withObject:dict];
    [self.table reloadData];
}

#pragma mark - pop-up 代理
- (void)qf_sortButtonClick{
    UIView *view = self.table.tableHeaderView;
    [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.table.contentOffset.y-40-10 andIsLeft:YES];
}
- (void)qf_segButtonClick{
    UIView *view = self.table.tableHeaderView;
    [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.table.contentOffset.y-40-10 andIsLeft:NO];
}
- (void)qf_selectInView:(QFMaskView *)view{
    if (view.isLeftTable) {
        self.popupView.sortLabel.text = view.leftArray[view.leftSelectIndex][1];
        self.group_field = view.leftArray[view.leftSelectIndex][0];
        if (view.isLeftSelectDown == YES) {
            self.group_sort_type = @"desc";
            self.popupView.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
        }else{
            self.group_sort_type = @"asc";
            self.popupView.sortDownImageView.image = [UIImage imageNamed:@"p_menu_up"];
        }
    }else{
        self.popupView.segLabel.text = view.rightArray[view.rightSelectIndex][1];
        self.group_type = view.rightArray[view.rightSelectIndex][0];
    }
    [self reloadDate];
}
- (void)qf_funnelViewDataChange{
    [self reloadDate];
}
@end
