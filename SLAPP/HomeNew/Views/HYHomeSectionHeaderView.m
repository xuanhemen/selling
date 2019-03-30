//
//  HYHomeSectionHeaderView.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeSectionHeaderView.h"

@implementation HYHomeSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [self addSubview:_iconImage];
    
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 5,100, 30)];
    _titleLab.text = @"待办事项";
     _titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
   // _titleLab.font = kBoldFont(18);
    [self addSubview:_titleLab];
}
/*
 UIFontWeightUltraLight  - 超细字体
 UIFontWeightThin  - 纤细字体
 UIFontWeightLight  - 亮字体
 UIFontWeightRegular  - 常规字体
 UIFontWeightMedium  - 介于Regular和Semibold之间
 UIFontWeightSemibold  - 半粗字体
 UIFontWeightBold  - 加粗字体
 UIFontWeightHeavy  - 介于Bold和Black之间
 UIFontWeightBlack  - 最粗字体(理解)
 */

@end
