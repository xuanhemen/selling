//
//  HYHomeProjectListVC.m
//  SLAPP
//
//  Created by yons on 2018/10/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeProjectListVC.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "QFHeader.h"

#import "HYNewProjectVC.h"
#import <MJRefresh/MJRefresh.h>
#import "HYProjectCell.h"
#import "HYProjectHeaderView.h"

@interface HYHomeProjectListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView    *noDataView;

@property (nonatomic,strong) NSString *group_type;//分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
@property (nonatomic,strong) NSString *group_sort_type;//排序类型（asc 正序desc倒序）
@property (nonatomic,strong) NSString *group_field;//排序字段(edittime更新时间 create_time创建时间 analyse_update_time分析时间 dealtime完成时间 trade_name行业 name名称 amount金额)

@end

@implementation HYHomeProjectListVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.projectIds = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"项目列表";
   
    self.group_type = @"user";
    self.group_field = @"desc";
    self.group_sort_type = @"edittime";
    self.dataArray = [NSMutableArray array];
    
    
    [self configUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dataInit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    kWeakS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf dataInit];
    }];
    
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [addButton setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    //self.navigationItem.rightBarButtonItems = @[searchItem,item];
    
    self.noDataView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.noDataView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    [self configNodataView];
    
    
    [self fenzuButtonConfig];
    
}
//一键开合按钮
- (void)fenzuButtonConfig{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, self.tableView.frame.origin.y+self.tableView.frame.size.height-60-QFTabBarHeight, 50, 50)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"hebingfenzu.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"zhangkaifenzu.png"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(fenzuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)fenzuButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        for (int i=0; i<self.dataArray.count; i++) {
            NSMutableDictionary *newDictinory = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
            [newDictinory setObject:@"0" forKey:@"isShow"];
            [self.dataArray replaceObjectAtIndex:i withObject:newDictinory];
        }
    }else{
        for (int i=0; i<self.dataArray.count; i++) {
            NSMutableDictionary *newDictinory = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[i]];
            [newDictinory setObject:@"1" forKey:@"isShow"];
            [self.dataArray replaceObjectAtIndex:i withObject:newDictinory];
        }
    }
    [self.tableView reloadData];
}
- (void)configNodataView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.noDataView.frame.size.height/5, kScreenWidth, kScreenWidth/750*543)];
    imageView.image = [UIImage imageNamed:@"qf_nodataImage.png"];
    [self.noDataView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/5*1.5, imageView.frame.origin.y+imageView.frame.size.height, kScreenWidth/5*2, kScreenWidth*0.4/25*6)];
    button.backgroundColor = UIColorFromRGB(0x6AB372);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"列表" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.noDataView addSubview:button];
    
    
}
- (void)dataInit{
    
    __weak HYHomeProjectListVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    if (![self.projectIds isNotEmpty]){
        return;
    }
    
    NSDictionary *params = @{@"token":model.token,
                             @"group":@"user",
                             @"sort_type":@"desc",
                             @"field":@"edittime",
                             @"project_ids":self.projectIds
                             };
    
    NSString *urlString = @"pp.projectStatistics.sorted_content";
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlString Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
        NSArray *fulldata = result[@"data"];
        [weakSelf.dataArray removeAllObjects];
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            [dict setObject:@"1" forKey:@"isShow"];
            [weakSelf.dataArray addObject:dict];
        }
        
        [weakSelf.tableView  reloadData];
        NSLog(@"项目列表 -- %@",result);
        
    } fail:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)addButtonClick:(UIButton *)sender{
    HYNewProjectVC *vc = [[HYNewProjectVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)searchButtonClick:(UIButton *)sender{
    SearchViewController *vc = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *proList = self.dataArray[indexPath.section][@"pro_list"];
    NSDictionary *dict = proList[indexPath.row];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:dict[@"id"]];
}



@end