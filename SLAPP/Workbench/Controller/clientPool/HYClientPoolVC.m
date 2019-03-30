//
//  HYClientPoolVC.m
//  SLAPP
//
//  Created by yons on 2018/10/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

// *****************客户公海池**********************
#import "HYClientPoolVC.h"
#import "QFHeader.h"
#import "UIView+NIB.h"
#import "HYClientPoolCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "LCActionSheet.h"
#import "HYNewClientVC.h"

@interface HYClientPoolVC ()<UITableViewDelegate,UITableViewDataSource,LCActionSheetDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selectArray;

@end

@implementation HYClientPoolVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.selectArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部公海客户";
    [self UIConfig];
   
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)UIConfig{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,0,kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadData)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(49);
    }];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *recycleBtn = [[UIButton alloc] init];
    recycleBtn.backgroundColor = UIColorFromRGB(0xea7c28);
    [recycleBtn setTitle:@"回收站" forState:UIControlStateNormal];
    [recycleBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    recycleBtn.layer.cornerRadius = 5;
    recycleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    recycleBtn.clipsToBounds = YES;
    [recycleBtn addTarget:self action:@selector(recycleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:recycleBtn];
    [recycleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(70);
    }];
    
    UIButton *actionBtn = [[UIButton alloc] init];
    [actionBtn setTitle:@"操作" forState:UIControlStateNormal];
    [actionBtn setTitleColor:UIColorFromRGB(0x4eae66) forState:UIControlStateNormal];
    actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [actionBtn addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:actionBtn];
    [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    
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
- (void)reloadData{
    kWeakS(weakSelf);
    
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.client.client_international_waters_list" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.selectArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:result[@"list"]];;
        [weakSelf.tableView reloadData];
    } fail:^(NSDictionary *result) {
    }];
    
    
}
#pragma mark - 列表
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HYClientPoolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYClientPoolCell"];
    if (cell == nil) {
        cell = [HYClientPoolCell loadBundleNib];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameLabel.text = [dict[@"name"] toString];
    cell.backNumLabel.text = [dict[@"send_back_count"] toString];
    cell.reasonLabel.text = [dict[@"reason"] toString];
    cell.dateLabel.text = [dict[@"addtime_str"] toString];
    cell.indexPath = indexPath;
    kWeakS(weakSelf);
    cell.action = ^(HYClientPoolCell *sender) {
        NSDictionary *currentDict = weakSelf.dataArray[sender.indexPath.row];
        BOOL isExist = NO;
        for (NSDictionary *selectDict in self.selectArray) {
            if ([dict[@"id"] isEqualToString:selectDict[@"id"]]) {
                isExist = YES;
            }
        }
        if (isExist) {
            [weakSelf.selectArray removeObject:currentDict];
            sender.statusImageView.image = [UIImage imageNamed:@"qf_select_statusdefault"];
        }else{
            [weakSelf.selectArray addObject:currentDict];
            sender.statusImageView.image = [UIImage imageNamed:@"qf_select_statuschooses"];
        }
    };
    
    BOOL isExist = NO;
    for (NSDictionary *selectDict in self.selectArray) {
        if ([dict[@"id"] isEqualToString:selectDict[@"id"]]) {
            isExist = YES;
        }
    }
    if (isExist == YES) {
        cell.statusImageView.image = [UIImage imageNamed:@"qf_select_statuschooses"];
    }else{
        cell.statusImageView.image = [UIImage imageNamed:@"qf_select_statusdefault"];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
#pragma mark - actionSheet
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 10001) {
        NSLog(@"%ld",buttonIndex);
        if (buttonIndex == 0) {
            HYNewClientVC *vc = [[HYNewClientVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (buttonIndex == 1) {
            
        }
        if (buttonIndex == 2) {
            
        }
    }
    
}

#pragma mark - 按钮响应
- (void)recycleButtonClick:(UIButton *)button{
    
}
- (void)actionButtonClick:(UIButton *)button{
    
}
- (void)rightClick:(UIButton *)button{
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"创建客户" buttonTitles:@[@"手动新建",@"扫名片",@"选择相册中的名片"] redButtonIndex:-1 delegate:self];
    sheet.tag = 10001;
    [sheet show];
    
}
- (void)searchButtonClick:(UIButton *)button{
    
}
@end
