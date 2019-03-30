//
//  CardView.h
//  CLApp
//
//  Created by xslp on 16/8/4.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL(^MyBlock)(NSInteger);
@interface CardView : UIView
/**
 *  按钮点击的block回调
 */
@property (copy, nonatomic)  MyBlock btnClickBlock;
/**
 *  正常文字颜色  默认为黑色
 */
@property (strong, nonatomic) UIColor *titleNormalColor;
/**
 *  选中文字颜色 默认为绿色
 */
@property (strong, nonatomic) UIColor *titleSelectColor;
/**
 *  底部线的颜色 默认为绿色
 */
@property (strong, nonatomic) UIColor *bottomLineNormalColor;
/**
 *  创建子控件
 *
 *  @param titleArr 标题数组
 */
-(void)creatBtnsWithTitles:(NSArray *)titleArr;


-(void)configSelectWith:(NSInteger)tag;

-(void)selectActionWithTag:(NSInteger)tag;

-(NSInteger)currentTag;

@end
