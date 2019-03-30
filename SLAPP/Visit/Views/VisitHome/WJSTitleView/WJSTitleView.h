//
//  WJSTitleView.m
//  WJSTtitle
//
//  Created by 王静帅 on 16/3/10.
//  Copyright © 2016年 rxb. All rights reserved.
//

#import <UIKit/UIKit.h>
//Waring: - 设置btn的属性,请到.m文件中,在getters方法里修改就可!

@protocol WJSTitleViewDelegate <NSObject>
/// 代理方法-只负责实现按钮的监听事件
///
/// @param button 显示的三个按钮
@optional
- (void)onClickBtn:(UIButton *)button;

@end
/// 方便复用,现将三个btn暴露出来
@interface WJSTitleView : UIView
/** 左侧btn */
@property(nonatomic, strong) UIButton *leftBtn;
/** 中间btn */
@property(nonatomic, strong) UIButton *middleBtn;
/** 右侧btn */
@property(nonatomic, strong) UIButton *rightBtn;

/** 代理 */
@property(nonatomic, weak)  id<WJSTitleViewDelegate> delegate;

@end
