    //
//  HYHomeClientVC.m
//  SLAPP
//
//  Created by yons on 2018/10/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeClientVC.h"
#import <YBPopupMenu/YBPopupMenu.h>
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "QFCustomerDetailVC.h"

@interface HYHomeClientVC ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic,strong) NSMutableArray *clientList;
@property (nonatomic,strong) UITableView *tableView;



@end

@implementation HYHomeClientVC
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
    //self.navigationItem.rightBarButtonItems = @[rightBarBtn,searchItem];
    
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
        for (int i=0; i<self.clientList.count; i++) {
            NSMutableDictionary *newDictinory = [[NSMutableDictionary alloc] initWithDictionary:self.clientList[i]];
            [newDictinory setObject:@"0" forKey:@"isShow"];
            [self.clientList replaceObjectAtIndex:i withObject:newDictinory];
        }
    }else{
        for (int i=0; i<self.clientList.count; i++) {
            NSMutableDictionary *newDictinory = [[NSMutableDictionary alloc] initWithDictionary:self.clientList[i]];
            [newDictinory setObject:@"1" forKey:@"isShow"];
            [self.clientList replaceObjectAtIndex:i withObject:newDictinory];
        }
    }
    [self.tableView reloadData];
}

- (void)searchButtonClick:(UIButton*)sender{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.from = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)rightClick:(UIButton *)btn{
    __weak HYHomeClientVC *weakSelf = self;
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
    
    __weak HYHomeClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
   
    
    NSString *urlString = @"pp.clientContact.sorted_content_client";
    if (!self.isHomeCome) {
//        urlString = @"pp.clientContact.client";
        urlString = @"pp.clientContact.client_list";
    }
    else{
        if (![self.listString isNotEmpty]) {
            return;
        }
        
    }
     [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlString Params:@{@"token":model.token,@"client_ids":self.listString} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
        NSLog(@"客户列表:%@",result);
        [weakSelf.clientList removeAllObjects];
        
        NSArray *fulldata = result[@"data"];
        
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            [dict setObject:@"1" forKey:@"isShow"];
            [weakSelf.clientList addObject:dict];
        }
        
        [weakSelf.tableView reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}




#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.clientList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.clientList[section];
    NSArray *array = dict[@"list"];
    if ([dict[@"isShow"] integerValue]==0) {
        return 0;
    }else{
        return array.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HYProjectHeaderView *view = [[HYProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [view.showBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    view.showBtn.tag = section+200;
    NSDictionary *dict = self.clientList[section];
    
    [view setViewClientModelWithDict:dict];
    return view;
    
}
- (void)headerButtonClick:(UIButton *)sender{
    NSDictionary *dict = self.clientList[sender.tag-200];
    if ([dict[@"isShow"] integerValue]==0) {
        [dict setValue:@"1" forKey:@"isShow"];
    }else{
        [dict setValue:@"0" forKey:@"isShow"];
    }
    [self.clientList replaceObjectAtIndex:sender.tag-200 withObject:dict];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIde = @"CustomerCell";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    NSArray *array = self.clientList[indexPath.section][@"list"];
    NSDictionary *dic = array[indexPath.row];
    
    cell.lbCustomerName.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
    cell.lbContacts.text = [NSString stringWithFormat:@"%@",dic[@"contact"]];
    cell.headerImage.image = [UIImage imageNamed:@"head"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    cell.red.hidden = [dic[@"msg_count"] integerValue] + [dic[@"fo_count"] integerValue] == 0;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = self.clientList[indexPath.section][@"list"];
    NSDictionary *dic = array[indexPath.row];
    
    __weak HYHomeClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    
    [self showProgressWithStr:@"获取客户信息中..."];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.client_one" Params:@{@"token":model.token,@"id":dic[@"id"]} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSLog(@"客户详情:%@",result);
        
        CustomDetailViewController *vc = [[UIStoryboard storyboardWithName:@"CustomPool" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomDetailViewController"];
        vc.isPublicSea = NO;
        vc.customIdString = dic[@"id"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
//        QFCustomerDetailVC *vc = [[QFCustomerDetailVC alloc] init];
//        vc.clientId = dic[@"id"];
//        vc.needUpdate = ^(NSString *a) {
//            [weakSelf clentRes];
//        };
//        //        vc.needUpdate = ^{
//        //            [weakSelf clentRes];
//        //        };
//        vc.modelDic = result;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}

@end

