//
//  HomePageSectionView.h
//  CLApp
//
//  Created by xslp on 16/8/4.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageSectionView : UIView
/**
 *  图像
 */
@property (strong, nonatomic) UIImageView *iconView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  是否隐藏图像 默认为NO
 */
@property (assign, nonatomic) BOOL hiddenIcon;

@end
