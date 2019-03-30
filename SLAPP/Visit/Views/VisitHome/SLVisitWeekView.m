//
//  SLVisitDayView.m
//  拜访罗盘
//
//  Created by 王静帅 on 16/5/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "SLVisitWeekView.h"

#define kWeekTopHeight 35
#define kLeftMargin 80
#define kWeekTopWith [UIScreen mainScreen].bounds.size.width - kLeftMargin*2
@interface SLVisitWeekView ()
@end

//周视图
@implementation SLVisitWeekView
#pragma mark - 初始化入口
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI {
    //1. weekTop
    [self addSubview:self.weekTop];
    
    //2. srollTitle
    [self addSubview:self.scrollTitle];
}
#pragma mark - getters
- (WJSTitleView *)weekTop {
    if (!_weekTop) {
        CGRect rect = CGRectMake(kLeftMargin, 0, kWeekTopWith, kWeekTopHeight);
        _weekTop = [[WJSTitleView alloc] initWithFrame:rect];
    }
    return _weekTop;
}
- (WJSScrollTitle *)scrollTitle {
    if (!_scrollTitle) {
        CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, kWeekTopHeight, screenWith, self.bounds.size.height - kWeekTopHeight);
        _scrollTitle = [[WJSScrollTitle alloc] initWithFrame:rect];
        _scrollTitle.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        //btn宽
        _scrollTitle.buttonWidth = screenWith/7;
    
    }
    return _scrollTitle;
}
@end
