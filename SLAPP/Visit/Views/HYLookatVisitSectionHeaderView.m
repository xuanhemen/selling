//
//  HYLookatVisitSectionHeaderView.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookatVisitSectionHeaderView.h"

@implementation HYLookatVisitSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *lineView = [UIView new];
        _content = [UILabel new];
        
        lineView.backgroundColor = kgreenColor;
        
        [self addSubview:lineView];
        [self addSubview:_content];
        
        _content.textColor = kgreenColor;
        _content.font = kFont(14);
        kWeakS(weakSelf);
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(2);
            make.left.mas_equalTo(15);
            make.centerY.equalTo(weakSelf);
        }];
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-15);
            make.bottom.top.mas_equalTo(0);
        }];
        
    }
    return self;
}




@end
