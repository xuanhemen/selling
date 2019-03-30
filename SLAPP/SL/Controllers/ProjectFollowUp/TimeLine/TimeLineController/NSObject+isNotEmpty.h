//
//  NSObject+isNotEmpty.h
//  SalesCompetition
//
//  Created by 吕海瑞 on 16/7/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (isNotEmpty)
/**
 *  判断一个对象是否为空
 *
 *  @return 不为空返回Yes
 */
- (BOOL)isNotEmpty;



/**
 转成String
 */
- (NSString *)toString;




/**
 *  toast 提醒
 *
 *  @param toastText 需要提醒的文字
 *  @param druation  要展示的时间长度
 */
- (void)toastWithText:(NSString *)toastText andDruation:(float)druation;


/**
 *  toast 提醒 （默认展示时间为 2s）
 *
 *  @param toastText 需要提醒的文字
 */
- (void)toastWithText:(NSString *)toastText;


/**
 *  显示网络加载状态（不带文字）
 */
- (void)showOCProgress;


/**
 *  显示网络加载状态 （带提醒文字）
 *
 *  @param statusStr 要提醒的文字
 */
- (void)showProgressWithStr:(NSString *)statusStr;

/**
 *  取消显示网络加载状态
 */
- (void)showDismiss;

/**
 *  加载失败  取消网络加载状态
 */
- (void)showDismissWithError;

/**
 *  加载成功  取消网络加载状态
 */
- (void)dismissWithSuccess:(NSString *)str;




@end
