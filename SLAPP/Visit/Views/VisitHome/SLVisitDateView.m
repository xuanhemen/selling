//
//  SLVisitDateView.m
//  拜访罗盘
//
//  Created by 樊瑞 on 16/6/24.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "SLVisitDateView.h"
#import "Masonry.h"

#define kBtnHeight 30
#define kBtnWidth 50

//显示当前时间的view 导航栏下面
@implementation SLVisitDateView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        //
        _lbDate = [[UILabel alloc] init];
        
        [self addSubview:_lbDate];
        
        [_lbDate mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(0);
            
            make.centerY.mas_equalTo(0);
            
        }];
        
        _lbDate.font = kFont(17);
        
        _lbDate.textColor = kgreenColor;
        
        _lbDate.textAlignment = NSTextAlignmentCenter;
        
        
        
        
        //
        _btnCurrentDate = [[UIButton alloc] init];
        
        [self addSubview:_btnCurrentDate];
        
        [_btnCurrentDate mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.mas_equalTo(CGSizeMake(kBtnWidth, kBtnHeight));
            
            make.centerY.mas_equalTo(0);
            
            make.right.mas_equalTo(-5);
            
        }];
        
        _weekDate =[[UILabel alloc] init];
        _weekDate.font = kFont(17);
        _weekDate.textColor = kgreenColor;
        _weekDate.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_weekDate];
        
        kWeakS(weakSelf);
        [_weekDate mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.mas_equalTo(CGSizeMake(kBtnWidth, kBtnHeight));
            
            make.centerY.mas_equalTo(0);
            
            make.right.mas_equalTo(weakSelf.btnCurrentDate.mas_left);
            
        }];
        
        [_btnCurrentDate setTitleColor:kgreenColor forState:UIControlStateNormal];
        
        _btnCurrentDate.titleLabel.font = kFont(14);
        
    }

    return self;
}


@end
