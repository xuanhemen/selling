//
//  HYClientProjectsVC.m
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYClientProjectsVC.h"
#import <Masonry/Masonry.h>
#import "HYBaseRequest.h"
#import "HYNewProjectVC.h"

#import "SLAPP-Swift.h"


@interface HYClientProjectsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation HYClientProjectsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataInit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面
- (void)configUI{
    self.title = @"项目列表";
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dataInit)];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    

    [self configBarItems];
}

- (void)configBarItems{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}
- (void)rightClick{
    
    HYNewProjectVC *vc = [[HYNewProjectVC alloc] init];
    vc.clientModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dataInit{
    kWeakS(weakSelf);
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.client_project" Params:@{@"token":model.token,@"id":self.clientId} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:result[@"data"]];
        [weakSelf.tableView reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIde = @"HYContactNewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        UIView *line = [[UIView alloc] init];
        [cell.contentView addSubview:line];
        line.backgroundColor = UIColorFromRGB(0xF2F2F2);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(0.5);
        }];
    }
    cell.textLabel.text = [self.dataArray[indexPath.row][@"name"] toString];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:[self.dataArray[indexPath.row][@"id"] toString]];
}
@end
