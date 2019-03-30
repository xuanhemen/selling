//
//  HomePageSectionView.m
//  CLApp
//
//  Created by xslp on 16/8/4.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "HomePageSectionView.h"

#define ICON_WIDTH 20.0
@interface HomePageSectionView ()

@end
@implementation HomePageSectionView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
       
        self.hiddenIcon = NO;
     
    }
    return self;
}

-(void)setHiddenIcon:(BOOL)hiddenIcon{

    _hiddenIcon = hiddenIcon;
    
    [self setUI];
}
-(void)setUI{
    
    //背景
    self.backgroundColor = HexColor(@"ECECEC");
    typeof(self)weakSelf = self;

    if (self.hiddenIcon) {
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.top.equalTo(weakSelf).offset(10);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.right.equalTo(weakSelf);
        }];

    }else{
        [self addSubview:self.iconView];
        [self addSubview:self.titleLabel];

        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(15);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconView.mas_right).offset(5);
            make.top.equalTo(weakSelf).offset(10);
            make.bottom.equalTo(weakSelf).offset(-10);
            make.right.equalTo(weakSelf);
        }];
    }
}


-(UIImageView *)iconView{

    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
    }
    return _iconView;
}

-(UILabel *)titleLabel{

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = HexColor(@"999999");
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}
@end
