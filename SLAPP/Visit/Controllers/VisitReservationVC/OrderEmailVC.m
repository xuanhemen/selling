//
//  OrderEmailVC.m
//  拜访罗盘
//
//  Created by harry on 16/7/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "OrderEmailVC.h"
#import "MailConfigVC.h"


@interface OrderEmailVC ()

@end

@implementation OrderEmailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self configData];
}

-(void)configUI
{
    self.title = @"通过邮件预约";
//    if ([MemberAuthDataOperation hasAuthorityWithC:@"Smtp" Action:@"edit"]) {
//
        [self setRightBtnWithTitle:@"邮箱设置"];
//    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.emailText.typingAttributes = attributes;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.sendBtn setBackgroundColor:kgreenColor];
}

-(void)configData
{
//    self.SendToUserText.text = self.visitModel.contactModel.name;
    
//    Visit_mailModel * mailModel =  self.visitModel.visit_mailModel.firstObject;
//    if ([mailModel isNotEmpty])
//    {
//        self.SendToUserText.text = mailModel.sendMail;
//        self.emailText.text = mailModel.sendBody;
//        self.copytoText.text = mailModel.sendCC;
//    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today= [formatter stringFromDate:[NSDate date]];
    if (self.isSummarytemp) {
        self.title = @"总结邮件";
      self.timeText.text = [NSString stringWithFormat:@"%@ 总结",today];
    }
    else
    {
    self.timeText.text = [NSString stringWithFormat:@"%@ 预约",today];
    }
    

    if (![_emailText.text isNotEmpty])
    {
        _emailText.text = _emailBodyStr;
    }
}

-(void)rightClick:(UIButton *)btn
{
    MailConfigVC *vc = [[MailConfigVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)sendBtnclick:(id)sender
{
    
    
    
    if (![_SendToUserText.text isNotEmpty])
    {
        [self toastWithText:@"收件人不能为空"];
        return;
    }
    if (![_emailText.text isNotEmpty])
    {
        [self toastWithText:@"邮件内容不能为空"];
        return;
    }
    
    
    if (![_timeText.text isNotEmpty])
    {
        [self toastWithText:@"邮件标题不能为空"];
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定将邮件发送给%@吗？",_SendToUserText.text] preferredStyle:UIAlertControllerStyleAlert];

 
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    kWeakS(weakSelf);
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf beginSend];

    }];

 
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [appRootVC presentViewController:alertController animated:YES completion:nil];

    
   
    
}

-(void)beginSend
{
    kWeakS(weakSelf);
    [self showProgressWithStr:@"正在发送..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [HYBaseRequest getPostWithMethodName:kVisit_SendType Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf sendMailWith:result];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf toastWithText:@"获取邮箱设置失败，请再次点击发送按钮" andDruation:5];
    }];


}

-(void)sendMailWith:(NSDictionary *)dic
{
    kWeakS(weakSelf);
    if (![dic[@"sendType"] isNotEmpty] || [dic[@"sendType"] integerValue] == 2) {
        
        if (![dic[@"sendType"] isNotEmpty]) {
           [weakSelf dismissProgress];
            [self addAlertViewWithTitle:@"温馨提示" message:@"使用系统邮件发送" actionTitles:@[@"发送",@"取消"] okAction:^(UIAlertAction *action) {
                [weakSelf showProgressWithStr:@"正在发送..."];
                [weakSelf sendWithXSLP:dic];

            } cancleAction:^(UIAlertAction *action) {

            }];
        }else{
           [self sendWithXSLP:dic];
        }
        
        
    }
    else{
        
        kWeakS(weakSelf);
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"smtp_url"] = dic[@"smtp_url"];
        params[@"mark"] =[NSString stringWithFormat:@"%@",dic[@"sendType"]]  ;
        params[@"port"] = dic[@"port"];
        params[@"myMail"] =dic[@"userMail"] ;
        params[@"mailPass"] = dic[@"userPass"];
        params[@"sendMail"] = self.SendToUserText.text;
        
        params[@"sendCC"] = self.copytoText.text;
        params[@"visit_id"] = _visitId;
//        Visit_mailModel *model = [self.visitModel.visit_mailModel objectsWhere:@"catalog == 'reservation'"].firstObject;
        params[@"sendTitle"] = self.timeText.text;
        params[@"sendBody"] =self.emailText.text;
        if (self.isSummarytemp) {
            params[@"catalog"] = @"summary";
        }
        else
        {
            params[@"catalog"] = @"reservation";   //预约
        }
        
        [weakSelf sendWithParams:params];
    }
    
}


/**
 向服务器发送

 @param params <#params description#>
 */
-(void)sendWithParams:(NSDictionary *)params{
    
    [HYBaseRequest getPostWithMethodName:kVisit_SendMail Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [self dismissWithSuccess:@"发送成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSDictionary *result) {
        [self dissmissWithError];
        [self toastWithText:@"发送失败" andDruation:5];
    }];
    
}

-(void)sendWithXSLP:(NSDictionary *)dic{
    kWeakS(weakSelf);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"smtp_url"] = dic[@"smtp.163.com"];
    
    //Mark 2 系统   1用户自己
    
    params[@"mark"] = @"2"  ;
    params[@"port"] = dic[@"port"];
    params[@"myMail"] =dic[@"userMail"] ;
    params[@"mailPass"] = dic[@"userPass"];
    params[@"sendMail"] = self.SendToUserText.text;
    
    params[@"sendCC"] = self.copytoText.text;
    params[@"visit_id"] = _visitId;
//    Visit_mailModel *model = [self.visitModel.visit_mailModel objectsWhere:@"catalog == 'reservation'"].firstObject;
   params[@"sendTitle"] = self.timeText.text;
    params[@"sendBody"] =self.emailText.text;
    if (self.isSummarytemp) {
        params[@"catalog"] = @"summary";
    }
    else
    {
        params[@"catalog"] = @"reservation";   //预约
    }
   [weakSelf sendWithParams:params];

    
}

@end
