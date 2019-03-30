//
//  QFRiskAnalysisVC.m
//  SLAPP
//
//  Created by qwp on 2018/8/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFRiskAnalysisVC.h"
#import "QFHeader.h"
#import "QFChooseDateView.h"
#import "SLAPP-Swift.h"
#import "QFRiskHeaderView.h"
#import "ProRiskListVC.h"
@interface QFRiskAnalysisVC ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic,strong) NSString *weekString;
@property (nonatomic,strong) NSString *monthString;
@property (nonatomic,strong) NSString *quarterString;
@property (nonatomic,strong) NSString *yearString;
@property (nonatomic,strong) NSString *custom_timeString;
@property (nonatomic,strong) QFChooseDateView *chooseDateView;
@property (nonatomic,strong) UITableView    *table;
@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) QFRiskHeaderView *riskView;

@end

@implementation QFRiskAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"风险分析";
    self.monthString = @"";
    self.weekString = nil;
    self.quarterString = nil;
    self.yearString = nil;
    self.custom_timeString = nil;
    
    self.dataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configUI{
    __weak QFRiskAnalysisVC *weakSelf = self;
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth-60-30-15)/1000*867+30+50+60)];
    
    self.riskView = [[QFRiskHeaderView alloc] initWithFrame:CGRectMake(15, 50, kScreenWidth-30, 300)];
    [self.tableHeaderView addSubview:self.riskView];
    
  
    self.riskView.clickIds = ^(NSString *ids) {
        //现在不做跳转  没有反数据
        ProRiskListVC *vc = [[ProRiskListVC alloc] init];
        vc.ids = ids;
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    
    
    self.chooseDateView = [[QFChooseDateView alloc] initWithType:0 andFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    self.chooseDateView.currentSelect = 1;
    [self.chooseDateView configUI];
    self.chooseDateView.block = ^(NSString *week, NSString *month, NSString *quarter, NSString *year) {
        NSLog(@"周：%@,月：%@,季度：%@,年：%@",week,month,quarter,year);
        weakSelf.custom_timeString = nil;
        weakSelf.weekString = week;
        weakSelf.monthString = month;
        weakSelf.quarterString = quarter;
        weakSelf.yearString = year;
        [weakSelf configData];
    };
    [self.tableHeaderView addSubview:self.chooseDateView];
    
    

    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.tableHeaderView = self.tableHeaderView;
    [self.view addSubview:self.table];
    
    //table.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(reloadDate))
    //self.table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80))
    
}

- (void)addDataToRiskView:(NSArray *)array{
    CGFloat height = [self.riskView configUIWithData:array];
    CGRect riskFrame = self.riskView.frame;
    riskFrame.size.height = height;
    self.riskView.frame = riskFrame;
    
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, height+riskFrame.origin.y+10);
    [self.table reloadData];
    
}


- (void)configData{
    
    UserModel *model = UserModel.getUserModel;
    
    
    __weak QFRiskAnalysisVC *weakSelf = self;
    [self showOCProgress];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.weekString) {
        [params setObject:self.weekString forKey:@"week"];
        if ([weakSelf.chooseDateView.thisWeek isEqualToString:weakSelf.weekString]) {
            weakSelf.riskView.tipLabel.text = @"本周丢单的项目中，主要存在着如下风险：";
        }else{
            weakSelf.riskView.tipLabel.text = @"上一周丢单的项目中，主要存在着如下风险：";
        }
    }
    if (self.monthString) {
        [params setObject:self.monthString forKey:@"month"];
        if ([weakSelf.chooseDateView.thisMonth isEqualToString:weakSelf.monthString]) {
            weakSelf.riskView.tipLabel.text = @"本月丢单的项目中，主要存在着如下风险：";
        }else{
            weakSelf.riskView.tipLabel.text = @"上一月丢单的项目中，主要存在着如下风险：";
        }
    }
    if (self.quarterString) {
        [params setObject:self.quarterString forKey:@"quarter"];
        if ([weakSelf.chooseDateView.thisQuarter isEqualToString:weakSelf.quarterString]) {
            weakSelf.riskView.tipLabel.text = @"本季度丢单的项目中，主要存在着如下风险：";
        }else{
            weakSelf.riskView.tipLabel.text = @"上一季度丢单的项目中，主要存在着如下风险：";
        }
    }
    if (self.yearString) {
        [params setObject:self.yearString forKey:@"year"];
        if ([weakSelf.chooseDateView.thisYear isEqualToString:weakSelf.yearString]) {
            weakSelf.riskView.tipLabel.text = @"本年丢单的项目中，主要存在着如下风险：";
        }else{
            weakSelf.riskView.tipLabel.text = @"上一年丢单的项目中，主要存在着如下风险：";
        }
    }
    if (self.custom_timeString) {
        [params setObject:self.custom_timeString forKey:@"custom_time"];
    }
    [params setObject:model.token forKey:@"token"];
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.risk_analysis" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        //        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"获取风险分析:%@",a);
        
        weakSelf.chooseDateView.thisYear = [NSString stringWithFormat:@"%@",a[@"this_year"]];
        weakSelf.chooseDateView.thisMonth = [NSString stringWithFormat:@"%@",a[@"this_month"]];
        weakSelf.chooseDateView.thisQuarter = [NSString stringWithFormat:@"%@",a[@"this_quarter"]];
        weakSelf.chooseDateView.thisWeek = [NSString stringWithFormat:@"%@",a[@"this_week"]];
        
        [weakSelf addDataToRiskView:a[@"graph"]];
        
        NSArray *prolist = a[@"pro_list"];
        [weakSelf.dataArray removeAllObjects];
        if (prolist&&prolist.count>0) {
            [weakSelf.dataArray addObjectsFromArray:prolist];
        }
        [weakSelf.table reloadData];
        
    }];
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"HYProjectCell";
    HYProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell setViewModelWithDictWithDict:dict];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:dict[@"id"]];
}

@end
