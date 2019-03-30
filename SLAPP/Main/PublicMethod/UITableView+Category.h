//
//  UITableView+Category.h
//  SLAPP
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <LYEmptyView/LYEmptyViewHeader.h>
@interface UITableView (Category)
/**
 table 无数据提醒
 
 @param refresh 点击刷新响应block
 */
- (void)addEmptyViewAndClickRefresh:(void (^)(void))refresh;



/**
 无数据提醒
 
 @param title 标题
 @param imageName 图片
 @param detail 详情
 @param btnTitle 刷新按钮名称
 @param refresh 刷新block
 */
- (void)addEmptyViewAndClickTitle:(NSString *)title imageName:(NSString *)imageName detail:(NSString *)detail btnTitle:(NSString *)btnTitle Refresh:(void (^)(void))refresh;



/**
 添加无数据提醒  （不带响应）
 */
- (void)addEmptyViewWithNoAction;



/**
 添加无数据提醒  （不带响应）
 @param title 无数据提醒标题
 @param imageName 图片
 @param detail 详情
 */
- (void)addEmptyViewWithNoActionTitle:(NSString *)title imageName:(NSString *)imageName detail:(NSString *)detail;

@end
