//
//  LikeView.h
//  CLApp
//
//  Created by rms on 17/1/12.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeView : UIView

@property(nonatomic,strong)UIButton *rightBtn;
@property (nonatomic, strong)NSArray * dataSource;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource;
@end
