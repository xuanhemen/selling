//
//  QFCustomerDetailVC.m
//  SLAPP
//
//  Created by yons on 2018/9/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFCustomerDetailVC.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import <Masonry/Masonry.h>
#import "HYCustomerDetailCell.h"
#import "UIView+NIB.h"
#import "HYClientDetailFooterV.h"
#import "HYDelContactVC.h"
#import "HYClientBottomButton.h"
#import "HYClientProjectsVC.h"
#import "HYClientModel.h"

@interface QFCustomerDetailVC()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,assign) BOOL isChange;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UILabel *companyTitleLabel;
@property (nonatomic,strong) HYClientDetailFooterV *footerView;

@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) HYClientBottomButton *projectListButton;
@property (nonatomic,strong) HYClientBottomButton *followUpButton;
@property (nonatomic,strong) HYClientModel *model;


@end

@implementation QFCustomerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义一个返回按钮
    [self configBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"客户详情";
    
    NSString *save_auth = [NSString stringWithFormat:@"%@",self.modelDic[@"save_auth"]];
    if ([save_auth isEqualToString:@"1"]) {
        [self configUI];
    }
    
    self.dataArray = [NSMutableArray arrayWithArray:@[@{@"title":@"行业",@"key":@"trade"},@{@"title":@"所属",@"key":@"affiliated_pool"},@{@"title":@"地址",@"key":@"address"},@{@"title":@"项目数",@"key":@"pro_num"},@{@"title":@"项目总金额",@"key":@"pro_amount"},@{@"title":@"创建者",@"key":@"realname"},@{@"title":@"负责人",@"key":@"principal"},@{@"title":@"创建时间",@"key":@"addtime"},@{@"title":@"转手次数",@"key":@"allot_num"},@{@"title":@"退回理由",@"key":@"return_reason"}]];
    
    
    [self configDataAndUI];
    
    
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self configData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configBackItem{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0,21.0  , 21.0 )];
    
    [backBtn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem  = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.backBarButtonItem = barItem;
    
    
}
- (void)backBtnClick{
    if (self.isChange)  {
        if (self.needUpdate) {
            self.needUpdate(@"1");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)configUI{
    
    NSString *save_auth = [NSString stringWithFormat:@"%@",self.modelDic[@"save_auth"]];
    if ([save_auth isEqualToString:@"1"]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [btn setImage:[UIImage imageNamed:@"customer_edit"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
        
    }
    
}

- (void)configData{
    
    __weak QFCustomerDetailVC *weakSelf = self;
    [self showProgress];
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.client_one" Params:@{@"token":model.token,@"id":self.clientId} showToast:YES Success:^(NSDictionary *result) {
        [self dismissProgress];
        weakSelf.modelDic = result;
        weakSelf.companyTitleLabel.text = [NSString stringWithFormat:@"%@",result[@"name"]];
        
        NSArray *array = result[@"contact"];
        NSMutableArray *memberArray = [NSMutableArray array];
        if (array&&[array isKindOfClass:[NSArray class]]&&array.count>0) {
            for (int i=0; i<array.count; i++) {
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                [tempDict setObject:@"default" forKey:@"qf_member_Type"];
                [memberArray addObject:tempDict];
            }
        }
        [memberArray addObject:@{@"qf_member_Type":@"add"}];
        NSString *isDel = [NSString stringWithFormat:@"%@",result[@"del_client_contact"]];
        if ([isDel isEqualToString:@"1"]) {
            [memberArray addObject:@{@"qf_member_Type":@"minus"}];
        }
        [weakSelf.footerView refreshUIWithArray:memberArray];
        [weakSelf.tableView reloadData];
        
        [weakSelf getMsgNum];
        weakSelf.model = [[HYClientModel alloc] initWithDictionary:result];
        NSLog(@"客户详情 -- %@",result);
    } fail:^(NSDictionary *result) {
        [self dissmissWithError];
    }];
}


- (void)configDataAndUI{
    __weak QFCustomerDetailVC *weakSelf = self;
    NSString *trade_first_name = [NSString stringWithFormat:@"%@",self.modelDic[@"trade_first_name"]];
    if (!trade_first_name.isNotEmpty) {
        trade_first_name = @"";
    }else{
        NSString *trade_name = [NSString stringWithFormat:@"%@",self.modelDic[@"trade_name"]];
        if (trade_name.isNotEmpty) {
            trade_first_name = [NSString stringWithFormat:@"%@/%@",trade_first_name,trade_name];
        }
    }
    
    NSString *pro_num = [NSString stringWithFormat:@"项目数:  %@",self.modelDic[@"pro_num"]];
    NSString *pro_amount = [NSString stringWithFormat:@"项目总金额:  %@万",self.modelDic[@"pro_amount"]];
    NSString *realname = [NSString stringWithFormat:@"%@",self.modelDic[@"realname"]];
    if (!realname.isNotEmpty) {
        realname = @"";
    }
    NSString *dateString = [NSString stringWithFormat:@"%@",self.modelDic[@"addtime"]];
    if (dateString.isNotEmpty) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString floatValue]];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateStyle = kCFDateFormatterFullStyle;
        NSString *dStr = [f stringFromDate:date ];
        dateString = [NSString stringWithFormat:@"创建时间:  %@",dStr];
    }else{
        dateString = @"创建时间:  未知";
    }
    
    NSMutableArray *modelArr1 = [NSMutableArray arrayWithArray:@[
                                                                 trade_first_name,
                                                                 pro_num,
                                                                 pro_amount,
                                                                 [NSString stringWithFormat:@"创建者:  %@",realname],
                                                                 dateString
                                                                 ]];
    NSArray *array = [self configShare];
    
    for (NSString * str in array ){
        [modelArr1 insertObject:str atIndex:modelArr1.count-1];
    }
    
    
    
    NSMutableArray *modelArr2 = [NSMutableArray array];
    
    if ([self.modelDic[@"contact"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *onePer in self.modelDic[@"contact"]) {
            [modelArr2 addObject:@{@"imgurl":@"",@"name":[NSString stringWithFormat:@"%@",onePer[@"name"]],@"id":[NSString stringWithFormat:@"%@",onePer[@"id"]]}];
        }
    }
    
    
    
    
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    
    [self tableHeaderAndFooterConfig];
    
    [self configBottomButton];
    
}
- (void)configBottomButton{
    __weak QFCustomerDetailVC *weakSelf = self;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.projectListButton = [[HYClientBottomButton alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth/2-0.5, 49) andTitle:@"项目列表" andBlock:^(HYClientBottomButton *sender) {
        HYClientProjectsVC *vc = [[HYClientProjectsVC alloc] init];
        vc.clientId = [NSString stringWithFormat:@"%@",weakSelf.modelDic[@"id"]];
        vc.model = weakSelf.model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [bottomView addSubview:self.projectListButton];
    
    self.followUpButton = [[HYClientBottomButton alloc] initWithFrame:CGRectMake(kScreenWidth/2+1, 1, kScreenWidth/2-0.5, 49) andTitle:@"跟进列表" andBlock:^(HYClientBottomButton *sender) {
        CustomerFollowUpVC *vc = [[CustomerFollowUpVC alloc] init];
        vc.customerId = [NSString stringWithFormat:@"%@",weakSelf.modelDic[@"id"]];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [bottomView addSubview:self.followUpButton];
    
    
}

- (NSArray *)configShare{
    if ([[NSString stringWithFormat:@"%@",self.modelDic[@"authorization_corp"]] isEqualToString:@"1"]){
        return @[@"所属人: 本公司"];
    }else{
        
        NSMutableArray  *array = [NSMutableArray array];
        NSMutableArray  *clientArray = [NSMutableArray array];
        if ([self.modelDic[@"client_member"] isKindOfClass:[NSArray class]]) {
            NSArray *client_member = self.modelDic[@"client_member"];
            if (client_member.count > 0) {
                for (NSDictionary *a in client_member) {
                    [clientArray addObject:a[@"realname"]];
                }
                [array addObject:[NSString stringWithFormat:@"所属人: %@",[clientArray componentsJoinedByString:@","]]];
            }
            
        }
        NSMutableArray  *depArray = [NSMutableArray array];
        if ([self.modelDic[@"client_dep"] isKindOfClass:[NSArray class]]) {
            NSArray *client_dep = self.modelDic[@"client_dep"];
            if (client_dep.count > 0) {
                for (NSDictionary *a in client_dep) {
                    [depArray addObject:a[@"name"]];
                }
                [array addObject:[NSString stringWithFormat:@"所属部门: %@",[depArray componentsJoinedByString:@","]]];
            }
            
        }
        return array;
    }
}



- (void)rightClick:(UIButton *)btn{
    __weak QFCustomerDetailVC *weakSelf = self;
    AddCustomerVC *addVC = [[AddCustomerVC alloc] init];
    addVC.needUpdate = ^{
        weakSelf.isChange = YES;
        [weakSelf configData];
    };
    addVC.modelDic = self.modelDic;
    [self.navigationController pushViewController:addVC animated:YES];
    
}

// MARK: - *********** 客户跟进相关数提醒 **************


//    获取消息个数
- (void)getMsgNum{
    if (self.modelDic == nil) {
        return;
    }
    
    __weak QFCustomerDetailVC *weakSelf = self;
    
    //显示个数
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.followup.client_new_message_num" Params:@{@"token":model.token,@"id":[NSString stringWithFormat:@"%@",self.modelDic[@"id"]]} showToast:YES Success:^(NSDictionary *result) {
        if ([[NSString stringWithFormat:@"%@",result[@"new_message_num"]] integerValue]==0) {
            [weakSelf getRedNum];
        }else{
            [weakSelf.followUpButton setRedViewWithNum:[[NSString stringWithFormat:@"%@",result[@"new_message_num"]] integerValue]];
        }
    } fail:^(NSDictionary *result) {
    }];
}

- (void)getRedNum{
    __weak QFCustomerDetailVC *weakSelf = self;
    
    //显示红点
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.followup.client_red_point" Params:@{@"token":model.token,@"id":[NSString stringWithFormat:@"%@",self.modelDic[@"id"]]} showToast:YES Success:^(NSDictionary *result) {
        if ([[NSString stringWithFormat:@"%@",result[@"is_have"]] integerValue] > 0) {
            [weakSelf.followUpButton setRedViewWithNum:0];
        }
    } fail:^(NSDictionary *result) {
    }];
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"HYCustomerDetailCell";
    HYCustomerDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [HYCustomerDetailCell loadBundleNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.cellTitleLabel.text = dict[@"title"];
    cell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",self.modelDic[dict[@"key"]]];
    
    if ([dict[@"key"] isEqualToString:@"trade"]) {
        NSString *trade_first_name = [NSString stringWithFormat:@"%@",self.modelDic[@"trade_first_name"]];
        if (!trade_first_name.isNotEmpty) {
            trade_first_name = @"";
        }else{
            NSString *trade_name = [NSString stringWithFormat:@"%@",self.modelDic[@"trade_name"]];
            if (trade_name.isNotEmpty) {
                trade_first_name = [NSString stringWithFormat:@"%@/%@",trade_first_name,trade_name];
            }
        }
        cell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",trade_first_name];
    }
    if ([dict[@"key"] isEqualToString:@"addtime"]) {
        NSString *dateString = [NSString stringWithFormat:@"%@",self.modelDic[@"addtime"]];
        if (dateString.isNotEmpty) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString floatValue]];
            NSDateFormatter *f = [[NSDateFormatter alloc] init];
            f.dateStyle = kCFDateFormatterFullStyle;
            NSString *dStr = [f stringFromDate:date ];
            dateString = [NSString stringWithFormat:@"%@",dStr];
        }else{
            dateString = @"创建时间:  未知";
        }
        cell.cellDetailLabel.text = [NSString stringWithFormat:@"%@",dateString];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

#pragma mark - tableview header and footer
- (void)tableHeaderAndFooterConfig{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headerView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.tableHeaderView = headerView;
    
    self.companyTitleLabel = [[UILabel alloc] init];
    [headerView addSubview:self.companyTitleLabel];
    
    [self.companyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.companyTitleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    self.companyTitleLabel.text = @"";
    
    self.footerView = [[HYClientDetailFooterV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    [self.footerView refreshUIWithArray:@[@{@"qf_member_Type":@"add"}]];
    
    __weak QFCustomerDetailVC *weakSelf = self;
    self.footerView.action = ^(QFMemberType type, NSString *idString) {
        switch (type) {
            case QF_Default:{
                [weakSelf gotoContactWithID:idString];
            }break;
            case QF_Add:{
                
                HYAddContactVC *addContactVC = [[HYAddContactVC alloc] init];
                addContactVC.clientModel = weakSelf.model;
                [weakSelf.navigationController pushViewController:addContactVC animated:YES];
                
                
                
                
            }break;
            case QF_Minus:{
                HYDelContactVC *vc = [[HYDelContactVC alloc] init];
                vc.comeType = 0;
                vc.clientName = [NSString stringWithFormat:@"%@",weakSelf.modelDic[@"name"]];
                vc.title = @"删除客户联系人";
                vc.clientId = [NSString stringWithFormat:@"%@",weakSelf.modelDic[@"id"]];
                vc.alreadyArray = weakSelf.modelDic[@"contact"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }break;
            default:
                break;
        }
    };
    self.tableView.tableFooterView = self.footerView;
}
- (void)gotoContactWithID:(NSString *)contactId{
    
    __weak QFCustomerDetailVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgressWithStr:@"获取联系人信息中..."];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.contact_one" Params:@{@"token":model.token,@"contact_id":contactId} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        ContactDetailVC *detailVC = [[ContactDetailVC alloc] init];
        detailVC.modelDic = result;
        [self.navigationController pushViewController:detailVC animated:YES];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}


@end

