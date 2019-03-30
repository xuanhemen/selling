//
//  UIViewController+Category.h
//  CLApp
//
//  Created by 吕海瑞 on 16/8/15.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

@property (copy,nonatomic)void (^rightBtnDidClick)();
/**
 *  设置导航右边按钮 (单个按钮)
 *
 *  @param title 按钮名称
 */
- (void)setRightBtnWithTitle:(NSString *)title;
/**
 *  设置导航右边按钮 （多个）
 *
 *  @param titleArray 多个按钮的名字
 */
- (void)setRightBtnsWithArray:(NSArray *)titleArray;

/**
 *  设置导航右边按钮 图片类型  (多个)
 *
 *  @param imageArray 要显示的图片 （传入图片名称）
 */
- (void)setRightBtnsWithImages:(NSArray *)imageArray;

/**
 *  设置导航左边按钮 图片类型  (多个)
 *
 *  @param imageArray 要显示的图片 （传入图片名称）
 */
- (void)setleftBtnsWithImages:(NSArray *)imageArray;
/**
 *  导航右边按钮点击响应事件，单个不用判断 多个判断返回按钮tag值（1000+传入数组所在下标值）
 *
 *  @param btn 返回点击的按钮
 */
- (void)rightClick:(UIButton *)btn;
/**
 *  导航左边按钮点击响应事件，单个不用判断 多个判断返回按钮tag值（2000+传入数组所在下标值）
 *
 *  @param btn 返回点击的按钮
 */
- (void)leftClick:(UIButton *)btn;

-(void)setRightBtnWith:(UIButton *)btn;
/**
 *  alert弹窗
 *
 *  @param title        标题
 *  @param message      提示信息
 *  @param actionTitles action标题
 *  @param ok           确认的回调
 *  @param cancle       取消的回调
 */
-(void)addAlertViewWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles okAction:(void (^)(UIAlertAction *  action))ok cancleAction:(void (^)(UIAlertAction *  action))cancle;
@end
