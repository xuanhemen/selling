//
//  HYNewProjectVC.m
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYNewProjectVC.h"
#import <Masonry/Masonry.h>
#import "UIView+NIB.h"
#import "SLAPP-Swift.h"
#import "HYSelectClientVC.h"
#import "PGDatePickManager.h"
#import "HYChooseProductVC.h"
#import "HYProductModel.h"
#import "HYBaseRequest.h"

@interface HYNewProjectVC ()<HYTopViewDelegate>
@property (nonatomic,strong)NSArray *productArray;

@property (nonatomic,assign)BOOL isDetailBack;

@end

@implementation HYNewProjectVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"新增项目";
        self.isDetailBack = NO;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isDetailBack == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.clientModel != nil) {//通过客户进来 限制选择客户
        if (![self.clientModel.modifiTag isEqual: @"1"]) {
            self.baseInfoView.clientButton.enabled = NO;
            self.baseInfoView.clientField.enabled = NO;
            self.baseInfoView.tradeField.enabled = NO;
            self.baseInfoView.tradeButton.enabled = NO;
        }
        
        self.baseInfoView.clientID = self.clientModel.Id;
        self.baseInfoView.tradeID = self.clientModel.trade_id;
        self.baseInfoView.clientField.text = self.clientModel.name;
        self.baseInfoView.tradeField.text = self.clientModel.trade_name;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 界面
- (void)configUI{
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight-40)];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self addBaseInfoView];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-40, kScreenWidth*0.5, 40)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor grayColor];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth*0.5);
        make.height.mas_equalTo(39);
    }];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, kScreenHeight-40, kScreenWidth*0.5, 40)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.backgroundColor = UIColorFromRGB(0x30b475);
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth*0.5);
        make.height.mas_equalTo(39);
    }];
    
}

- (void)addBaseInfoView{
    self.baseInfoView = [HYNewProjectTopView loadBundleNib];
    self.baseInfoView.frame = CGRectMake(0, 0, kScreenWidth, 480);
    self.baseInfoView.delegate = self;
    [self.scrollView addSubview:self.baseInfoView];
    
    self.scrollHeight = 480;
    self.scrollView.contentSize = CGSizeMake(0, self.scrollHeight);
}
#pragma mark - HYTopViewDelegate

- (void)hy_topViewTradeButtonClick:(HYNewProjectTopView *)topView {
    kWeakS(weakSelf);
    ChooseTradeVC *vc = [ChooseTradeVC new];
    vc.result = ^(TradeModel * tradeModel) {
        weakSelf.baseInfoView.tradeID = tradeModel.index_id;
        weakSelf.baseInfoView.tradeField.text = [NSString stringWithFormat:@"%@-%@",tradeModel.parent_name,tradeModel.name];
        
        self.clientModel.trade_id = tradeModel.index_id;
        self.clientModel.trade_name = [NSString stringWithFormat:@"%@-%@",tradeModel.parent_name,tradeModel.name];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hy_topViewClientButtonClick:(HYNewProjectTopView *)topView{
    kWeakS(weakSelf);
    
    HYSelectClientVC *vc = [[HYSelectClientVC alloc] init];
    vc.action = ^(HYClientModel *clientModel) {
        weakSelf.baseInfoView.clientField.text = clientModel.name;
        weakSelf.baseInfoView.clientID = clientModel.Id;
        weakSelf.baseInfoView.tradeID = clientModel.trade_id;
        weakSelf.baseInfoView.tradeField.text = clientModel.trade_name;
        
        self.clientModel.Id = clientModel.Id;
        self.clientModel.name = clientModel.name;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)hy_topViewProductButtonClick:(HYNewProjectTopView *)topView{
    //产品
    kWeakS(weakSelf);
    HYChooseProductVC *vc = [[HYChooseProductVC alloc] init];
    vc.action = ^(NSArray *modelArray) {
        NSMutableArray *array = [NSMutableArray array];
        CGFloat money = 0;
        for (HYProductModel *model in modelArray) {
            [array addObject:[NSString stringWithFormat:@"%@(%@)",model.name,model.amount.isNotEmpty?model.amount:@"0"]];
            money = money + [model.amount floatValue];
        }
        weakSelf.baseInfoView.productField.text = [array componentsJoinedByString:@","];
        weakSelf.baseInfoView.contractField.text = [NSString stringWithFormat:@"%.1f(万)",money];
        weakSelf.productArray = modelArray;
    };
    [vc.selectArray addObjectsFromArray:self.productArray];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)hy_topViewDateButtonClick:(HYNewProjectTopView *)topView{
    //日期
    kWeakS(weakSelf);
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        NSLog(@"dateComponents = %@", dateComponents);
        NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",dateComponents.year,dateComponents.month,dateComponents.day];
        weakSelf.baseInfoView.dateField.text = dateString;
    };
    [self presentViewController:datePickManager animated:YES completion:nil];
}



#pragma mark - 完成提交数据
/****  响应事件  ****/
- (void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBtnClick{
    if (!self.baseInfoView.projectField.text.isNotEmpty){
        [self toastWithText:@"项目名不能为空" andDruation:1];
        return;
    }
    
    if (!self.baseInfoView.clientField.text.isNotEmpty){
        [self toastWithText:@"客户名不能为空" andDruation:1];
        return;
    }
    NSMutableArray * product_line = [NSMutableArray array];
    if (self.productArray!=nil&&self.productArray.count>0) {
        for (HYProductModel *model in self.productArray) {
            NSString *priceString = @"0";
            if (model.amount.isNotEmpty) {
                priceString = model.amount;
            }else if (model.price.isNotEmpty){
                priceString = model.price;
            }
            [product_line addObject:@{@"id":model.Id,@"products":model.name,@"price":priceString}];
        }
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:product_line options:0 error:&error];
    UserModel *model = [UserModel getUserModel];
    
    
    NSString *birthdayString = @"";
    if ([self.baseInfoView.dateField.text toString].length>0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *birthdayDate = [dateFormatter dateFromString:[self.baseInfoView.dateField.text toString]];
        birthdayString = [NSString stringWithFormat:@"%f",[birthdayDate timeIntervalSince1970]];
    }
    
    
    
    NSString *amountString = [self.baseInfoView.contractField.text toString];
    if (amountString.length>0) {
        amountString = [amountString substringWithRange:NSMakeRange(0, amountString.length-3)];
    }
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                   @{
                                     @"name":[self.baseInfoView.projectField.text toString],
                                     @"client_id":[self.baseInfoView.clientID toString],
                                     @"client_name":[self.baseInfoView.clientField.text toString],
                                     @"trade_id":[self.baseInfoView.tradeID toString],
                                     @"trade_name":[self.baseInfoView.tradeField.text toString],
                                     @"deps_name":[self.baseInfoView.depField.text toString],
                                     @"product_line":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                                     @"amount":amountString,
                                     @"down_payment":[self.baseInfoView.performanceField.text toString],
                                     @"dealtime":birthdayString,
                                     @"partners":@"",
                                     @"observer":@"",
                                     @"contacts":@"",
                                     @"token":model.token
                                     }];
    
    NSString *methodName = @"pp.project.add_projects";
    
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:methodName Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectVCWithId:[result[@"data"] toString]];
        weakSelf.isDetailBack = YES;
        [self.delegate jumpCancelVC];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}



@end
