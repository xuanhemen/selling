//
//  SLVisitMonthView.m
//  拜访罗盘
//
//  Created by 王静帅 on 16/5/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "SLVisitMonthView.h"

#define kMonthTopHeight 35
#define kLeftMargin 80
#define kMonthTopWith [UIScreen mainScreen].bounds.size.width - kLeftMargin*2

//月视图
@implementation SLVisitMonthView
#pragma mark - 初始化入口
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    //1. monthTop
    [self addSubview:self.monthTop];
    
    //2. monthScroll
    [self addSubview:self.scrllMonth];
}
#pragma mark - getters
- (WJSTitleView *)monthTop {
    if (!_monthTop) {
        CGRect rect = CGRectMake(kLeftMargin, 0,kMonthTopWith ,kMonthTopHeight);
        _monthTop = [[ WJSTitleView alloc] initWithFrame:rect];
        [_monthTop.leftBtn setTitle:@"上月" forState:UIControlStateNormal];
        [_monthTop.middleBtn setTitle:@"本月" forState:UIControlStateNormal];
        [_monthTop.rightBtn setTitle:@"下月" forState:UIControlStateNormal];
    }
    return _monthTop;
}
- (WJSScrollViewMonth *)scrllMonth {
    if (!_scrllMonth) {
        CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, kMonthTopHeight,screenWith ,self.bounds.size.height - kMonthTopHeight);
        _scrllMonth = [[WJSScrollViewMonth alloc] initWithFrame:rect];
        
        _scrllMonth.buttonWidth = screenWith/3;
    }
    return _scrllMonth;
}
@end
