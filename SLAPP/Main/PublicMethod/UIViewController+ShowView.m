//
//  UIViewController+ShowView.m
//  SLAPP
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "UIViewController+ShowView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Toast/Toast.h>
#import "QFHeader.h"
@implementation UIViewController (ShowView)



/**
 网络加载显示进度
 */
-(void)showProgress{
    [self configSVP];
    [SVProgressHUD showWithStatus:@"正在加载..."];
}

/**
 网络加载完成进度取消
 */
-(void)dismissProgress{
    [SVProgressHUD dismiss];
}

/**
 网络加载出现错误提醒
 */
-(void)dissmissWithError{
    [SVProgressHUD showWithStatus:@"加载失败"];
    [SVProgressHUD dismissWithDelay:0.5];
}

/**
 Toast提醒
 
 @param title 标题
 */
-(void)toastWithTitle:(NSString *)title{
    
    [self toastWithtoastText:title druation:2];
}


-(void)configSVP
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setForegroundColor:UIColorFromRGB(0x43be5f)];
    
    
}




-(void)toastWithtoastText:(NSString *)title druation:(float)druation {
    CGPoint point = [UIApplication sharedApplication].delegate.window.center;
    NSValue *value = [NSValue valueWithCGPoint:point];
    CSToastStyle *style = [[CSToastStyle alloc]initWithDefaultStyle];
    [[UIApplication sharedApplication].delegate.window makeToast:title duration:druation position:value style:style];
}



@end
