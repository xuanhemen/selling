//
//  FitlerRightCell.h
//  CLApp
//
//  Created by harry on 2017/5/22.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitFitterModel.h"
typedef void (^btnclick)() ;

@interface FitlerRightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *arrowsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,copy)btnclick click;

@property(nonatomic,strong)HYVisitFitterSubModel *model;


/**
 是否隐藏选择按钮

 @param isHidden <#isHidden description#>
 */
-(void)isHiddenMarkView:(BOOL)isHidden;

/**
 是否显示箭头

 @param isShow bool 是否显示
 */
-(void)isShowArrow:(BOOL)isShow;


/**
 右侧箭头点击响应

 @param click 点击响应block
 */
-(void)arrowClick:(btnclick)click;


/**
 显示返回箭头
 */
-(void)showback;
@end
