//
//  NSObject+isNotEmpty.m
//  SalesCompetition
//
//  Created by 吕海瑞 on 16/7/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "NSObject+isNotEmpty.h"
#import <Toast/UIView+Toast.h>
#import <SVProgressHUD/SVProgressHUD.h>
@implementation NSObject (isNotEmpty)

- (BOOL)isNotEmpty
{
    return !(self == nil
             || [self isKindOfClass:[NSNull class]]
             || ([self respondsToSelector:@selector(length)]
                 && [(NSData *)self length] == 0)
             || ([self respondsToSelector:@selector(count)]
                 && [(NSArray *)self count] == 0));
    
}


/**
 转成String
 
 */
- (NSString *)toString{
    if ([self isNotEmpty]) {
        return  [NSString stringWithFormat:@"%@",self];
    }else{
        return @"";
    }
    
}




/**
 *  toast 提醒
 *
 *  @param toastText 需要提醒的文字
 *  @param druation  要展示的时间长度
 */
- (void)toastWithText:(NSString *)toastText andDruation:(float)druation
{
    CGPoint point = [UIApplication sharedApplication].delegate.window.center;
    NSValue *value = [NSValue valueWithCGPoint:point];
    CSToastStyle *style = [[CSToastStyle alloc]initWithDefaultStyle];
//    style.backgroundColor = [UIColor orangeColor];
    [[UIApplication sharedApplication].delegate.window makeToast:toastText duration:druation position:value style:style];
}


/**
 *  toast 提醒 （默认展示时间为 2s）
 *
 *  @param toastText 需要提醒的文字
 */
- (void)toastWithText:(NSString *)toastText
{
    [self toastWithText:toastText andDruation:2.0];
}






/**
 *  显示网络加载状态（不带文字）
 */
- (void)showOCProgress
{
    
    [self configSVP];
    [SVProgressHUD show];
}


/**
 *  显示网络加载状态 （带提醒文字）
 *
 *  @param statusStr 要提醒的文字
 */
- (void)showProgressWithStr:(NSString *)statusStr
{
    [self configSVP];
    [SVProgressHUD showWithStatus:statusStr];
}

/**
 *  取消显示网络加载状态
 */
- (void)showDismiss
{
    [SVProgressHUD dismiss];
}

/**
 *  加载失败  取消网络加载状态
 */
- (void)showDismissWithError
{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
    [SVProgressHUD dismissWithDelay:0.5];
}


/**
 *  加载成功  取消网络加载状态
 */
- (void)dismissWithSuccess:(NSString *)str
{
    [SVProgressHUD showSuccessWithStatus:str];
    [SVProgressHUD dismissWithDelay:0.5];
}


-(void)configSVP
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//    [SVProgressHUD setForegroundColor:kNavBarBGColor];
}










@end
