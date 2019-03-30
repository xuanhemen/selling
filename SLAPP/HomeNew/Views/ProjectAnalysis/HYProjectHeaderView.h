//
//  HYProjectHeaderView.h
//  SLAPP
//
//  Created by yons on 2018/9/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYProjectHeaderView : UIView
@property (nonatomic,strong) UIButton *showBtn;
- (void)setViewModelWithDict:(NSDictionary *)dict;
- (void)setViewClientModelWithDict:(NSDictionary *)dict;

@end
