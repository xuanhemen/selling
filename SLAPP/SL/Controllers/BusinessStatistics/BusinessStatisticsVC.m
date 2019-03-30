//
//  BusinessStatisticsVC.m
//  SLAPP
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "BusinessStatisticsVC.h"
#import "QFProjectNavBar.h"
#import "QFHeader.h"
#import "BusinessStatisticsTopView.h"
#import "BusinessStatisticsRankingTopView.h"
#import "SLAPP-Swift.h"
#import "QFChooseDateView.h"
#import "QFPopupView.h"
#import "PDateChooseView.h"
#import "QFMaskView.h"
#define kTopViewHeight 550
#define kTopViewHeightRight 460
@interface BusinessStatisticsVC ()<UITableViewDelegate,UITableViewDataSource,QFPopupViewDelegate,QFMaskViewDelegate>
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)UITableView *leftTable;
@property(nonatomic,strong)UITableView *rightTable;
@property(nonatomic,strong)NSDictionary *currentData;
@property(nonatomic,strong)NSDictionary *currentDataRight;


@property(nonatomic,assign)BOOL isLeft;
//统计
@property (nonatomic,strong) QFChooseDateView *chooseDateViewLeft;
//排行
@property (nonatomic,strong) QFChooseDateView *chooseDateViewRight;

@property(nonatomic ,strong) BusinessStatisticsTopView *topLeft;

@property(nonatomic ,strong) BusinessStatisticsRankingTopView *topRight;
@property (nonatomic,strong) QFMaskView *maskView;

@property (nonatomic,strong) QFPopupView *popupViewLeft;
@property (nonatomic,strong) QFPopupView *popupViewRight;

@property(nonatomic,strong)NSMutableArray *leftDataArray;
@property(nonatomic,strong)NSMutableArray *rightDataArray;


@property (nonatomic,strong) NSString *group_typeL;//分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
@property (nonatomic,strong) NSString *group_sort_typeL;//排序类型（asc 正序desc倒序）
@property (nonatomic,strong) NSString *group_fieldL;//排序字段(edittime更新时间 create_time创建时间 analyse_update_time分析时间 dealtime完成时间 trade_name行业 name名称 amount金额)




@property (nonatomic,strong) NSString *group_typeR;//分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
@property (nonatomic,strong) NSString *group_sort_typeR;//排序类型（asc 正序desc倒序）
@property (nonatomic,strong) NSString *group_fieldR;//排序字段(edittime更新时间 create_time创建时间 analyse_update_time分析时间 dealtime完成时间 trade_name行业 name名称 amount金额)
@end

@implementation BusinessStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.group_typeL = @"";
    self.group_fieldL = @"";
    self.group_sort_typeL = @"";
    
    self.group_typeR = @"";
    self.group_fieldR = @"";
    self.group_sort_typeR = @"";
    
    
    [self configUI];
    self.maskView = [[QFMaskView alloc] initWithFrame:CGRectMake(0,QFTopHeight, kScreenWidth, kScreenHeight-QFTopHeight)];
    self.maskView.delegate = self;
    [self.view addSubview:self.maskView];
    
    _leftDataArray = [NSMutableArray array];
    _rightDataArray = [NSMutableArray array];
    [self configData:nil :nil :nil :nil :nil];
    [self configRankData:nil :nil :nil :nil :nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.view.backgroundColor = [UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)configUI{
    
    _isLeft = YES;
    QFProjectNavBar *nav = [[QFProjectNavBar alloc] init];
    [nav uiConfig];
//    nav.searchButton.hidden = true;
    nav.addButton.hidden = true;
    [nav.searchButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    nav.listLabel.text = @"商机统计";
    nav.statisticalLabel.text = @"商机排行";
    [self.view addSubview:nav];
    [nav addBack];
    __weak typeof(self) weakSelf = self;
    nav.backBtnClick = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:true];
    };
    nav.searchButtonBlock = ^{
        
        weakSelf.maskView.hidden = true;
        [weakSelf addDate];
        
    };
    
    nav.changeViewBlock = ^(BOOL isList) {
        weakSelf.maskView.hidden = true;
        if (isList) {
            weakSelf.isLeft = YES;
            [weakSelf.backScrollView setContentOffset:CGPointMake(0, 0)];
        }else{
            weakSelf.isLeft = NO;
            [weakSelf.backScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
        }
        
        
    };
    
   
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,kNav_height,kScreenWidth, kMain_screen_height_px-kNav_height)];
    _backScrollView.scrollEnabled = NO;
    [_backScrollView setContentSize:CGSizeMake(kScreenWidth*2, 0)];
    
    [self.view addSubview:_backScrollView];
    
    
   
    
    _leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kMain_screen_height_px-kNav_height)];
    [_backScrollView addSubview:_leftTable];
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    
    UIView *eView = [[UIView alloc] init];
    _leftTable.tableFooterView = eView;
    _rightTable = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth,0, kScreenWidth,kMain_screen_height_px-kNav_height)];
    [_backScrollView addSubview:_rightTable];
    _rightTable.tableFooterView = eView;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    
    _chooseDateViewLeft = [[QFChooseDateView alloc] initWithType:0 andFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    _chooseDateViewLeft.currentSelect = 1;
    [_chooseDateViewLeft configUI];
    _chooseDateViewLeft.block = ^(NSString *week, NSString *month, NSString *quarter, NSString *year) {
        NSLog(@"周：%@,月：%@,季度：%@,年：%@",week,month,quarter,year);
//        weakSelf.custom_timeString = nil;
//        weakSelf.monthString = month;
//        weakSelf.quarterString = quarter;
//        weakSelf.yearString = year;
//        [weakSelf configData];
        [weakSelf configData:year :month :quarter :week :nil];
    };
    
    
    
    _chooseDateViewRight = [[QFChooseDateView alloc] initWithType:0 andFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    _chooseDateViewRight.currentSelect = 1;
    [_chooseDateViewRight configUI];
    _chooseDateViewRight.block = ^(NSString *week, NSString *month, NSString *quarter, NSString *year) {
        NSLog(@"周：%@,月：%@,季度：%@,年：%@",week,month,quarter,year);
        //        weakSelf.custom_timeString = nil;
        //        weakSelf.monthString = month;
        //        weakSelf.quarterString = quarter;
        //        weakSelf.yearString = year;
//        [weakSelf configData:year :month :quarter :week :nil];
        [weakSelf configRankData:year :month :quarter :week :nil];
    };
    
    
    
    _popupViewLeft = [[QFPopupView alloc] initWithFrame:CGRectMake(0,kTopViewHeight-80, kScreenWidth, 50)];
    _popupViewLeft.delegate = self;
     [_popupViewLeft configUI];
    
    
    _popupViewRight = [[QFPopupView alloc] initWithFrame:CGRectMake(0,kTopViewHeightRight-80, kScreenWidth, 50)];
    _popupViewRight.delegate = self;
     [_popupViewRight configUI];
    
     _topLeft = [[BusinessStatisticsTopView alloc] init];
     _topRight =  [[BusinessStatisticsRankingTopView alloc] init];
    
    
    UIView *topViewL = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeight)];
    UIView *topViewR = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopViewHeightRight)];
  
    topViewL.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    topViewR.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    
    
    [topViewL addSubview:_chooseDateViewLeft];
    [topViewL addSubview:_topLeft];
    [topViewL addSubview:_popupViewLeft];
    [topViewL bringSubviewToFront:_chooseDateViewLeft];
    _leftTable.tableHeaderView = topViewL;
    
    
    [topViewR addSubview:_chooseDateViewRight];
    [topViewR addSubview:_topRight];
    [topViewR addSubview:_popupViewRight];
    [topViewR addSubview:_chooseDateViewRight];
    _rightTable.tableHeaderView = topViewR;
    
    
    _topLeft.select = ^(NSMutableArray *selectArray) {
        DLog(@"%@",selectArray);
        
        [weakSelf reloadDateLeft];
    };
    
}





-(void)configData:(NSString *)y :(NSString *)m :(NSString *)q :(NSString *)w :(NSString *)custom{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if([y isNotEmpty]){
        params[@"year"] = y;
    }
    if([m isNotEmpty]){
        params[@"month"] = m;
    }
    if([q isNotEmpty]){
        params[@"quarter"] = q;
    }
    if([w isNotEmpty]){
        params[@"week"] = w;
    }
    
    if([custom isNotEmpty]){
        params[@"custom_time"] = custom;
    }
    
    UserModel *model = UserModel.getUserModel;
    params[@"token"] = model.token;
    [self showProgress];
    [LoginRequest getPostWithMethodName:p_business_statistics params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        
        
        weakSelf.chooseDateViewLeft.thisYear = [NSString stringWithFormat:@"%@",a[@"this_year"]];
        weakSelf.chooseDateViewLeft.thisMonth = [NSString stringWithFormat:@"%@",a[@"this_month"]];
        weakSelf.chooseDateViewLeft.thisQuarter = [NSString stringWithFormat:@"%@",a[@"this_quarter"]];
        weakSelf.chooseDateViewLeft.thisWeek = [NSString stringWithFormat:@"%@",a[@"this_week"]];
        
        weakSelf.currentData = a;
        weakSelf.topLeft.data = weakSelf.currentData[@"list"];
        [weakSelf showDismiss];
        [weakSelf reloadDateLeft];
    }];
}




-(void)configRankData:(NSString *)y :(NSString *)m :(NSString *)q :(NSString *)w :(NSString *)custom{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if([y isNotEmpty]){
        params[@"year"] = y;
    }
    if([m isNotEmpty]){
        params[@"month"] = m;
    }
    if([q isNotEmpty]){
        params[@"quarter"] = q;
    }
    if([w isNotEmpty]){
        params[@"week"] = w;
    }
    
    if([custom isNotEmpty]){
        params[@"custom_time"] = custom;
    }
    
    UserModel *model = UserModel.getUserModel;
    params[@"token"] = model.token;
    [self showProgress];
    [LoginRequest getPostWithMethodName:p_business_ranking params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
      
        DLog(@"%@",a);
        weakSelf.chooseDateViewRight.thisYear = [NSString stringWithFormat:@"%@",a[@"this_year"]];
        weakSelf.chooseDateViewRight.thisMonth = [NSString stringWithFormat:@"%@",a[@"this_month"]];
        weakSelf.chooseDateViewRight.thisQuarter = [NSString stringWithFormat:@"%@",a[@"this_quarter"]];
        weakSelf.chooseDateViewRight.thisWeek = [NSString stringWithFormat:@"%@",a[@"this_week"]];
        
        weakSelf.currentDataRight = a;
        weakSelf.topRight.data = weakSelf.currentDataRight;
        [weakSelf showDismiss];
        [weakSelf reloadDateRight];
    }];
}






-(void)refresh{
    
    
}



#pragma mark - pop-up 代理
- (void)qf_sortButtonClick{
    
    if (self.isLeft) {
        UIView *view = self.leftTable.tableHeaderView;
        
        [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.leftTable.contentOffset.y-40-30 andIsLeft:YES];
        DLog(@"%f--%f",view.frame.size.height,self.leftTable.contentOffset.y)
    }else{
        UIView *view = self.rightTable.tableHeaderView;
        [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.rightTable.contentOffset.y-40-30 andIsLeft:YES];
    }
    
}
- (void)qf_segButtonClick{
    if (self.isLeft) {
    
    UIView *view = self.leftTable.tableHeaderView;
    [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.leftTable.contentOffset.y-40-30 andIsLeft:NO];
    }else{
        UIView *view = self.rightTable.tableHeaderView;
        [self.maskView qf_showMaskViewWithHeight:view.frame.size.height-self.rightTable.contentOffset.y-40-30 andIsLeft:NO];
    }
}
- (void)qf_selectInView:(QFMaskView *)view{
    
    if (self.isLeft) {
        if (view.isLeftTable) {
            self.popupViewLeft.sortLabel.text = view.leftArray[view.leftSelectIndex][1];
            self.group_fieldL = view.leftArray[view.leftSelectIndex][0];
            if (view.isLeftSelectDown == YES) {
                self.group_sort_typeL = @"desc";
                self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
            }else{
                self.group_sort_typeL = @"asc";
                self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_up"];
            }
        }else{
            self.popupViewLeft.segLabel.text = view.rightArray[view.rightSelectIndex][1];
            self.group_typeL = view.rightArray[view.rightSelectIndex][0];
        }
        [self reloadDateLeft];
    }else{
        
        if (view.isLeftTable) {
            self.popupViewRight.sortLabel.text = view.leftArray[view.leftSelectIndex][1];
            self.group_fieldR = view.leftArray[view.leftSelectIndex][0];
            if (view.isLeftSelectDown == YES) {
                self.group_sort_typeR = @"desc";
                self.popupViewRight.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
            }else{
                self.group_sort_typeR = @"asc";
                self.popupViewRight.sortDownImageView.image = [UIImage imageNamed:@"p_menu_up"];
            }
        }else{
            self.popupViewRight.segLabel.text = view.rightArray[view.rightSelectIndex][1];
            self.group_typeR = view.rightArray[view.rightSelectIndex][0];
        }
        [self reloadDateRight];
        
    }
    
    
}



-(void)addDate{
    kWeakS(weakSelf);
    PDateChooseView *pDate = [[PDateChooseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].delegate.window addSubview:pDate];
    pDate.result = ^(NSString *timerStr) {
        
        if (weakSelf.isLeft) {
            [weakSelf configData:nil :nil :nil :nil :timerStr];
        }else{
            [weakSelf configRankData:nil :nil :nil :nil :timerStr];
        }
        
    };
}


- (void)reloadDateLeft{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.group_typeL forKey:@"group"];
    [params setObject:self.group_sort_typeL forKey:@"sort_type"];
    [params setObject:self.group_fieldL forKey:@"field"];
    if ([self.currentData[@"list"] isNotEmpty]) {
        if ([self.topLeft.selectArray containsObject:@"只统计未关单"]) {
            [params setObject:self.currentData[@"list"][@"only_ongoing_pro"][@"list"] forKey:@"project_ids"];
        }else{
            [params setObject:self.currentData[@"list"][@"all_ongoing_pro"][@"list"] forKey:@"project_ids"];
        }
    }
//    [params setObject:@"9558,9560,9561,9562,9579,9584,9555" forKey:@"project_ids"];
    if(![params[@"project_ids"] isNotEmpty]){
        [self.leftDataArray removeAllObjects];
        [self.leftTable  reloadData];
        return;
    }
//    NSLog(@"请求的数据%@",params);
    [params setObject:[UserModel getUserModel].token forKey:@"token"];
    
    kWeakS(weakSelf);
    [self showOCProgress];
    
    
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.sorted_content" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        //        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        
        
        NSArray *fulldata = a[@"data"];
        [self.leftDataArray removeAllObjects];
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            [dict setObject:@"0" forKey:@"isShow"];
            [self.leftDataArray addObject:dict];
        }
        [weakSelf.leftTable  reloadData];
        
    }];
}


- (void)reloadDateRight{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:self.group_typeR forKey:@"group"];
    [params setObject:self.group_sort_typeR forKey:@"sort_type"];
    [params setObject:self.group_fieldR forKey:@"field"];
    


    NSString *ids  = @"";
    if ([self.currentDataRight[@"graph_new"] isNotEmpty]) {
        
        for (NSDictionary *sub in self.currentDataRight[@"graph_new"]) {
            if (![ids isEqualToString:@""]) {
                ids = [ids stringByAppendingString:@","];
            }
            ids = [ids stringByAppendingString:sub[@"pro_ids"]];
        }
    }
    
    if(![ids isNotEmpty]){
        [self.rightDataArray removeAllObjects];
        [self.rightTable  reloadData];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[ids componentsSeparatedByString:@","]];
    [array removeObjectsInArray:@[@""]];
    ids = [array componentsJoinedByString:@","];
    [params setObject:ids forKey:@"project_ids"];
    
//    if(![params[@"project_ids"] isNotEmpty]){
//        [self.rightDataArray removeAllObjects];
//        [self.rightTable  reloadData];
//        return;
//    }
    
    
    [params setObject:[UserModel getUserModel].token forKey:@"token"];
    
    kWeakS(weakSelf);
    [self showOCProgress];
    
    
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.sorted_content" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        //        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        
        
        NSArray *fulldata = a[@"data"];
        [self.rightDataArray removeAllObjects];
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            [dict setObject:@"0" forKey:@"isShow"];
            [self.rightDataArray addObject:dict];
        }
        [weakSelf.rightTable  reloadData];
        
    }];
}





#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTable) {
        return self.leftDataArray.count;
    }else{
        
        return self.rightDataArray.count;
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTable) {
        NSDictionary *dict = self.leftDataArray[section];
        NSArray *array = dict[@"pro_list"];
        if ([dict[@"isShow"] integerValue]==0) {
            return 0;
        }else{
            return array.count;
        }
    }else{
        
        NSDictionary *dict = self.rightDataArray[section];
        NSArray *array = dict[@"pro_list"];
        if ([dict[@"isShow"] integerValue]==0) {
            return 0;
        }else{
            return array.count;
        }
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _leftTable) {
        NSString *cellId = @"HYProjectCell";
        HYProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectCell" owner:self options:nil] lastObject];
        }
        NSDictionary *dict = self.leftDataArray[indexPath.section];
        NSArray *array = dict[@"pro_list"];
        [cell setViewModelWithDictWithDict:array[indexPath.row]];
        return cell;
    }else{
        
        NSString *cellId = @"HYProjectCell";
        HYProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectCell" owner:self options:nil] lastObject];
        }
        NSDictionary *dict = self.rightDataArray[indexPath.section];
        NSArray *array = dict[@"pro_list"];
        [cell setViewModelWithDictWithDict:array[indexPath.row]];
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTable) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *proList = self.leftDataArray[indexPath.section][@"pro_list"];
        NSDictionary *dict = proList[indexPath.row];
        PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectVCWithId:dict[@"id"]];
    }else{
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *proList = self.rightDataArray[indexPath.section][@"pro_list"];
        NSDictionary *dict = proList[indexPath.row];
        PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectVCWithId:dict[@"id"]];
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTable) {
        HYProjectHeaderView *view = [[HYProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [view.showBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.showBtn.tag = section+200;
        NSDictionary *dict = self.leftDataArray[section];
        [view setViewModelWithDict:dict];
        return view;
    }else{
        
        HYProjectHeaderView *view = [[HYProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [view.showBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.showBtn.tag = section+200;
        NSDictionary *dict = self.rightDataArray[section];
        [view setViewModelWithDict:dict];
        return view;
        
    }
    
    
    
}
- (void)headerButtonClick:(UIButton *)sender{
    
    if (self.isLeft) {
        NSDictionary *dict = self.leftDataArray[sender.tag-200];
        if ([dict[@"isShow"] integerValue]==0) {
            [dict setValue:@"1" forKey:@"isShow"];
        }else{
            [dict setValue:@"0" forKey:@"isShow"];
        }
        [self.leftDataArray replaceObjectAtIndex:sender.tag-200 withObject:dict];
        [self.leftTable reloadData];
    }else{
        
        NSDictionary *dict = self.rightDataArray[sender.tag-200];
        if ([dict[@"isShow"] integerValue]==0) {
            [dict setValue:@"1" forKey:@"isShow"];
        }else{
            [dict setValue:@"0" forKey:@"isShow"];
        }
        [self.rightDataArray replaceObjectAtIndex:sender.tag-200 withObject:dict];
        [self.rightTable reloadData];
        
    }
    
    
}


@end
