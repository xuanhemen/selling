//
//  HYEditProjectVC.m
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYEditProjectVC.h"

#import "UIView+NIB.h"
#import <Masonry/Masonry.h>
#import "SLAPP-Swift.h"
#import "HYSelectClientVC.h"
#import "PGDatePickManager.h"
#import "HYChooseProductVC.h"
#import "HYProductModel.h"
#import "HYBaseRequest.h"

@interface HYEditProjectVC ()

@property (nonatomic,strong)NSArray *productArray;
@property (nonatomic,strong)NSArray *alreadyArray;
@property (nonatomic,assign)BOOL isFirst;


@end

@implementation HYEditProjectVC
- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"修改项目";
        self.isFirst = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isFirst) {
        self.baseInfoView.projectField.text = self.model.name;
        self.baseInfoView.clientID = self.model.client_id;
        self.baseInfoView.clientField.text = self.model.client_name;
        self.baseInfoView.tradeID = self.model.trade_id;
        self.baseInfoView.tradeField.text = self.model.trade_name;
        self.baseInfoView.productField.text = self.model.productStr;
        self.baseInfoView.performanceField.text = self.model.down_payment;
        self.baseInfoView.contractField.text = self.model.amount;
        self.baseInfoView.dateField.text = self.model.dateStr;
        self.baseInfoView.depField.text = self.model.deps_name;
        self.isFirst = NO;
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configDataWithModel:(HYProjectModel *)hy_model{
    self.model = hy_model;
}

- (void)showRemindDelAndChangeProductLine{
    
    NSMutableString *lineStr = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *delStr = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *currentArray = [NSMutableArray array];
    for (NSDictionary *dict in self.model.alreadyProductArray ){
        
        NSLog(@"%@",dict);
        if ([[dict[@"status"] toString] isEqualToString:@"file"]) {
            if (![lineStr isEqualToString:@""]) {
                [lineStr appendString:@","];
            }else{
                [lineStr appendString:dict[@"products"]];
            }
            continue;
        }
        if ([[dict[@"status"] toString] isEqualToString:@"del"]) {
            if (![lineStr isEqualToString:@""]) {
                [delStr appendString:@","];
            }else{
                [delStr appendString:dict[@"products"]];
            }
            continue;
        }
        [currentArray addObject:dict];
    }
    NSMutableString *remindStr = [[NSMutableString alloc] initWithString:@""];
    if (![lineStr isEqualToString: @""]) {
        [remindStr appendString:lineStr];
        [remindStr appendString:@"产品设置已被系统管理员修改。"];
    }
    if (![delStr isEqualToString: @""]) {
        [remindStr appendString:delStr];
        [remindStr appendString:@"产品已被系统管理员删除。"];
    }
    
    if (![remindStr isEqualToString:@""]) {
        kWeakS(weakSelf);
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:remindStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.alreadyArray = [currentArray copy];
            [weakSelf showProductView];
        }];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }else{
        self.alreadyArray = [currentArray copy];
        [self showProductView];
        
    }
    
}

- (void)hy_topViewProductButtonClick:(HYNewProjectTopView *)topView{
    //产品
    if (self.productArray == nil || self.productArray.count == 0) {
        [self showRemindDelAndChangeProductLine];
    }else{
        [self showProductView];
    }
    
    
}
- (void)showProductView{
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
    NSMutableArray *a = [NSMutableArray array];
    if (self.productArray==nil || self.productArray.count==0) {
        for (NSDictionary *dict in self.alreadyArray) {
            HYProductModel *model = [[HYProductModel alloc] init];
            model.Id = dict[@"id"];
            model.amount = dict[@"price"];
            model.name = dict[@"products"];
            [a addObject:model];
        }
        self.productArray = [a copy];
    }
    [vc.selectArray addObjectsFromArray:self.productArray];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 完成提交数据
/****  响应事件  ****/
- (void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES ];
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
    NSMutableArray *a = [NSMutableArray array];
    if (self.productArray==nil) {
        if (self.model.alreadyProductArray!=nil) {
            for (NSDictionary *dict in self.model.alreadyProductArray) {
                HYProductModel *model = [[HYProductModel alloc] init];
                model.Id = dict[@"id"];
                model.amount = dict[@"price"];
                model.name = dict[@"products"];
                [a addObject:model];
            }
            self.productArray = [a copy];
        }
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
                                     @"product_line":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],
                                     @"deps_name":[self.baseInfoView.depField.text toString],
                                     @"amount":amountString,
                                     @"down_payment":[self.baseInfoView.performanceField.text toString],
                                     @"dealtime":birthdayString,
                                     @"partners":@"",
                                     @"observer":@"",
                                     @"contacts":@"",
                                     @"token":model.token
                                     }];
    
    NSString *methodName = @"pp.project.save_project";
    [params setObject:self.model.projectId forKey:@"project_id"];
    
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:methodName Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        weakSelf.needUpdate();
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}


@end
