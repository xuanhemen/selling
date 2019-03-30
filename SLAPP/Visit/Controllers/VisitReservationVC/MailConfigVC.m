//
//  MailConfigVC.m
//  CLApp
//
//  Created by 吕海瑞 on 16/9/3.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "MailConfigVC.h"


@interface MailConfigVC ()
@property(nonatomic,strong)UIButton *tempBtn;
@end

@implementation MailConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMailConfig];
}

-(void)configDataWith:(NSDictionary *)dic
{
    if (![dic[@"smtp_url"] isNotEmpty])
    {
        //为空只能用系统的
        self.mineBtn.enabled = NO;
        self.bottomView.hidden = YES;
        self.sysBtn.selected = YES;
        self.tempBtn = self.sysBtn;
        
    }
    else
    {
        if ([dic[@"sendtype"] integerValue] == 2) {
            self.bottomView.hidden = YES;
            self.sysBtn.selected = YES;
            self.tempBtn = self.sysBtn;
        }else{
            self.bottomView.hidden = false;
            self.mineBtn.selected = YES;
            self.sysBtn.selected = NO;
            self.tempBtn = self.mineBtn;
        }
        
//        NSString *smtpstr = dic[@"smtp_url"];
//        self.stmpMail.text = [NSString stringWithFormat:@"@%@",[smtpstr substringFromIndex:5]];
//        self.stmpMail.backgroundColor = [UIColor greenColor];
//        NSString *mailStr = dic[@"userMail"];
//        mailStr =[mailStr stringByReplacingOccurrencesOfString:self.stmpMail.text withString:@""];
        self.mailUserName.text = [dic[@"email"] toString];
        self.mailOassword.text = [dic[@"epass"] toString];
        

    }

}


-(void)getMailConfig
{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kVisit_SendType Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf configDataWith:result];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf toastWithText:@"获取邮箱配置失败" andDruation:5];
    }];
    
   
}


-(void)configUI
{
    self.title = @"邮箱配置";
    
    [self.mineBtn setImage:[UIImage imageNamed:@"changeStage"] forState:UIControlStateNormal];
    [self.mineBtn setImage:[UIImage imageNamed:@"changeStage_selected"] forState:UIControlStateSelected];
    
    [self.sysBtn setImage:[UIImage imageNamed:@"changeStage"] forState:UIControlStateNormal];
    [self.sysBtn setImage:[UIImage imageNamed:@"changeStage_selected"] forState:UIControlStateSelected];

//    self.mineBtn.selected = YES;
//    self.tempBtn = self.mineBtn;
//    self.bottomView.hidden = NO;
    
    self.mailOassword.secureTextEntry = YES;
    [self setRightBtnWithTitle:@"保存"];
}

-(void)rightClick:(UIButton *)btn
{
   
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.tempBtn.tag !=1000)
    {
       params[@"mark"] = @"2";
    }
    else
    {
        if (![self.mailUserName.text isNotEmpty]) {
            [self toastWithText:@"邮箱地址不能为空"];
            return;
        }
        
        if (![self.mailOassword.text isNotEmpty]) {
            [self toastWithText:@"邮箱密码不能为空"];
            return;
        }
        
        params[@"mark"] = @"1";
        params[@"umail"] =[NSString stringWithFormat:@"%@",self.mailUserName.text] ;
         params[@"upass"] = self.mailOassword.text;
    }
    
    
    kWeakS(weakSelf);
    [self showProgressWithStr:@"保存中......"];
    [HYBaseRequest getPostWithMethodName:kVisit_UpdateUserMail Params:[params addToken] showToast:false Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf toastWithText:[result[@"msg"] toString] andDruation:5];
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.tempBtn)
    {
        self.tempBtn.selected = NO;
    }
    btn.selected = !btn.selected;
    self.tempBtn = btn;
    if (self.tempBtn.tag == 1000)
    {
        self.bottomView.hidden = NO;
    }
    else
    {
    self.bottomView.hidden = YES;
    }
    
}
@end
