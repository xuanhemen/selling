//
//  HYProjectAnalysisVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYProjectAnalysisVC.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "QFHeader.h"
#import "HYProjectAnalysisCell.h"
#import "HYProjectListVC.h"

@interface HYProjectAnalysisVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIView    *noDataView;
@end

@implementation HYProjectAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目分析";
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

- (void)configUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [addButton setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.noDataView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.noDataView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    [self configNodataView];
}

- (void)configNodataView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.noDataView.frame.size.height/6, kScreenWidth, kScreenWidth/750*543)];
    imageView.image = [UIImage imageNamed:@"qf_nodataImage.png"];
    [self.noDataView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/5*1.5, imageView.frame.origin.y+imageView.frame.size.height, kScreenWidth/5*2, kScreenWidth*0.4/25*6)];
    button.backgroundColor = UIColorFromRGB(0x6AB372);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"浏览项目" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.noDataView addSubview:button];
    
    
}
- (void)dataInit{
    
    __weak HYProjectAnalysisVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.logicAnalyse.pro_analyse_list" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:result[@"data"]];
        [weakSelf.tableView reloadData];
        if (weakSelf.dataArray.count==0) {
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.noDataView.hidden = YES;
        }
        NSLog(@"项目分析 -- %@",result);
        
    } fail:^(NSDictionary *result) {
    }];
}

- (void)addButtonClick:(UIButton *)sender{
    HYProjectListVC *vc = [[HYProjectListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"HYProjectAnalysisCell";
    HYProjectAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectAnalysisCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell setCellDataWithDictinoary:dict];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:dict[@"project_id"]]; 
}




@end
