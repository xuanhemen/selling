//
//  HYNewClientVC.m
//  SLAPP
//
//  Created by qwp on 2018/11/23.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYNewClientVC.h"
#import "LCActionSheet.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "HYSelectCompanyVC.h"

@interface HYNewClientVC ()<LCActionSheetDelegate>{
    
}

@property (nonatomic,strong)NSMutableArray *constantArray;
@property (nonatomic,strong)NSMutableArray *moreNametArray;
@property (nonatomic,strong)TradeModel *tradeModel;
@property (nonatomic,strong)NSMutableArray *clientPoolArray;
@property (nonatomic,strong)NSString *poolId;
@end

@implementation HYNewClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clientPoolArray = [NSMutableArray array];
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{
    
    self.title = @"创建客户";
    
    self.numHeight.constant = 0;
    self.faxHeight.constant = 0;
    self.emailHeight.constant = 0;
    self.urlHeight.constant = 0;
    self.codeHeight.constant = 0;
    self.moneyHeight.constant = 0;
    self.remarkHeight.constant = 0;
    
    
    self.constantArray = [NSMutableArray arrayWithArray:@[self.numHeight,self.faxHeight,self.emailHeight,self.urlHeight,self.codeHeight,self.moneyHeight,self.remarkHeight]];
    self.moreNametArray = [NSMutableArray arrayWithArray:@[@"人员数",@"传真",@"邮箱",@"网址",@"邮政编码",@"注册资本",@"备注"]];
    
    
    kWeakS(weakSelf);
    CustomerShareCell *shareView = [[CustomerShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    shareView.frame = CGRectMake(0, 0, kScreenWidth, 170);
    __block CustomerShareCell *sView = shareView;
    shareView.frameHeightChanged = ^(CGFloat height) {
        sView.frame = CGRectMake(0, 0, kScreenWidth, height);
        weakSelf.shareHeight.constant = height;
    };
    [self.shareView addSubview:shareView];
    
    
    
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
}

#pragma mark - 按钮
- (void)saveButtonClick{

    if (![[self.clientField.text toString] isNotEmpty]) {
        [self toastWithText:@"客户名称不能为空" andDruation:0.5];
        return;
    }
    if (self.tradeModel == nil) {
        [self toastWithText:@"请选择客户行业" andDruation:0.5];
        return;
    }
    if (![self.poolId isNotEmpty]) {
        [self toastWithText:@"请选择客户所属公海池" andDruation:0.5];
        return;
    }
    
    UserModel *model = [UserModel getUserModel];
    NSString *url = @"pp.client.client_international_waters_add";
    NSDictionary *params = @{
@"client_name":[self.clientField.text toString],    //客户名称
@"trade_id":[self.tradeModel.index_id toString],    //行业id
@"trade_name":[self.tradeModel.name toString],      //行业名称
@"phone":[self.mobileField.text toString],          //客户联系方式
@"staff_number":[self.memberNumField.text toString],//人员数
@"fax":[self.faxField.text toString],               //传真
@"email":[self.emailField.text toString],           //邮箱
@"url":[self.urlField.text toString],               //网址
@"registered_capital":[self.moneyField.text toString],//注册资金
@"postcode":[self.codeField.text toString],         //邮编
@"site":[self.addressField.text toString],          //地址
@"client_details":[self.remarkField.text toString], //备注
@"province":@"",
@"city":@"",
@"area":@"",
@"gonghai_id":[self.poolId toString],
@"gonghai_name":[self.belongField.text toString],   //所属公海池
@"token":model.token                             };
    
    
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:url Params:params showToast:YES Success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSDictionary *result) {
    }];
    
}
- (IBAction)moreButtonClick:(id)sender {
    LCActionSheet *actionSheet = [[LCActionSheet alloc] initWithTitle:@"添加更多信息" buttonTitles:self.moreNametArray redButtonIndex:-1 delegate:self];
    actionSheet.tag = 1001;
    [actionSheet show];
    
}
- (IBAction)clientNameButtonClick:(id)sender {
    kWeakS(weakSelf);
    HYSelectCompanyVC *vc = [[HYSelectCompanyVC alloc] init];
    vc.selectBlock = ^(NSString *companyName) {
        weakSelf.clientField.text = [NSString stringWithFormat:@"%@",companyName];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tradeButtonClick:(id)sender {
    kWeakS(weakSelf);
    ChooseTradeVC *vc = [[ChooseTradeVC alloc] init];
    vc.result = ^(TradeModel * tradeModel) {
        weakSelf.tradeModel = tradeModel;
        weakSelf.tradeField.text = [NSString stringWithFormat:@"%@-%@",tradeModel.parent_name,tradeModel.name];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)belongButtonClick:(id)sender {
    
    kWeakS(weakSelf);
    
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.client.get_client_gonghai" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        NSLog(@"%@",result);
        [weakSelf.clientPoolArray removeAllObjects];
        [weakSelf.clientPoolArray addObjectsFromArray:result[@"data"]];
        NSMutableArray *nameArray = [NSMutableArray array];
        for (NSDictionary *dict in weakSelf.clientPoolArray) {
            //dict[@"id"]
            [nameArray addObject:dict[@"name"]];
        }
        if (nameArray.count>0) {
            LCActionSheet *actionSheet = [[LCActionSheet alloc] initWithTitle:@"选择所属公海池" buttonTitles:nameArray redButtonIndex:-1 delegate:weakSelf];
            actionSheet.tag = 1002;
            [actionSheet show];
        }
        
    } fail:^(NSDictionary *result) {
    }];
    
}
- (IBAction)areaButtonClick:(id)sender {
}


#pragma mark - actionSheet
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001) {
        if (buttonIndex != self.constantArray.count) {
            NSLayoutConstraint *constraint = self.constantArray[buttonIndex];
            constraint.constant = 50;
            [self.moreNametArray removeObjectAtIndex:buttonIndex];
            [self.constantArray removeObjectAtIndex:buttonIndex];
            
            if (self.moreNametArray.count == 0) {
                self.moreButtonHeight.constant = 0;
            }
        }
        
    }
    
    if (actionSheet.tag == 1002) {
        NSDictionary *dict = self.clientPoolArray[buttonIndex];
        self.belongField.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.poolId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    }
    
}

#pragma mark - 数据请求

@end
