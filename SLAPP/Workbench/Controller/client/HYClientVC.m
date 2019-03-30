//
//  HYContactVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYClientVC.h"
#import <YBPopupMenu/YBPopupMenu.h>
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "QFCustomerDetailVC.h"

@interface HYClientVC ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic,strong) NSMutableArray *clientList;
@property (nonatomic,strong) UITableView *tableView;



@end

@implementation HYClientVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isHomeCome = NO;
        self.listString = @"";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self configUI];
    [self dataInit];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clentRes];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - base
- (void)configUI{
    
    self.title = @"客户";
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,0,kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(clentRes)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn,searchItem];
}
- (void)searchButtonClick:(UIButton*)sender{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.from = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightClick:(UIButton *)btn{
    __weak HYClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    
   
    [HYBaseRequest getPostWithMethodName:@"pp.user.loginer_message" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        UserModel *userModel = [UserModel getUserModel];
        userModel.is_root = [NSString stringWithFormat:@"%@",result[@"is_root"]];
        userModel.depId = [NSString stringWithFormat:@"%@",result[@"dep_id"]];
        [userModel saveUserModel];
        
        AddCustomerVC *vc = [[AddCustomerVC alloc] init];
        vc.needUpdate = ^{
            [weakSelf clentRes];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)dataInit{
    self.clientList = [NSMutableArray array];
}
- (void)clentRes{
    
    __weak HYClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    
    NSString *urlString = @"pp.clientContact.sorted_content_client";
    if (!self.isHomeCome) {
//        urlString = @"pp.clientContact.client";
        urlString = @"pp.clientContact.client_list";
    }
    
    
    [HYBaseRequest getPostWithMethodName:urlString Params:@{@"token":model.token,@"client_ids":self.listString} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"客户列表:%@",result);
        [weakSelf.clientList removeAllObjects];
        [weakSelf.clientList addObjectsFromArray:result[@"data"]];
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
    return self.clientList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIde = @"CustomerCell";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    cell.lbCustomerName.text = [NSString stringWithFormat:@"%@",self.clientList[indexPath.row][@"name"]];
    cell.lbContacts.text = [NSString stringWithFormat:@"%@",self.clientList[indexPath.row][@"contact"]];
    cell.headerImage.image = [UIImage imageNamed:@"head"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dic = self.clientList[indexPath.row];
    cell.red.hidden = [dic[@"msg_count"] integerValue] + [dic[@"fo_count"] integerValue] == 0;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak HYClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    
    [self showProgressWithStr:@"获取客户信息中..."];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.client_one" Params:@{@"token":model.token,@"id":self.clientList[indexPath.row][@"id"]} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSLog(@"客户详情:%@",result);
        
        QFCustomerDetailVC *vc = [[QFCustomerDetailVC alloc] init];
        vc.needUpdate = ^(NSString *a) {
            [weakSelf clentRes];
        };
        vc.clientId = weakSelf.clientList[indexPath.row][@"id"];
//        vc.needUpdate = ^{
//            [weakSelf clentRes];
//        };
        vc.modelDic = result;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}
@end
