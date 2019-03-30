//
//  UIViewController+ShowView.h
//  SLAPP
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Category.h"
@interface UIViewController (ShowView)

/**
 网络加载显示进度
 */
-(void)showProgress;

/**
 网络加载完成进度取消
 */
-(void)dismissProgress;

/**
 网络加载出现错误提醒
 */
-(void)dissmissWithError;

/**
 Toast提醒
 默认2s
 @param title 标题
 */
-(void)toastWithTitle:(NSString *)title;

/**
 Toast提醒

 @param title 标题
 @param druation 提醒时间
 */
-(void)toastWithtoastText:(NSString *)title druation:(float)druation;



@end
