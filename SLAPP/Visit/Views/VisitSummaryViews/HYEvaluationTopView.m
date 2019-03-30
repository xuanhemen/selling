//
//  HYEvaluationTopView.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYEvaluationTopView.h"

@implementation HYEvaluationTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    self.backgroundColor = [UIColor whiteColor];
    _iconImage = [UIImageView new];
    _num = [UILabel new];
    _typetitle = [UILabel new];
    _qType = [UILabel new];
    _content = [UILabel new];
    _iconImage.image = [UIImage imageNamed:@"evaluate_title"];
    
    [self addSubview:_content];
    [self addSubview:_num];
    [self addSubview:_typetitle];
    [self addSubview:_qType];
    [self addSubview:_iconImage];
    
    
    _qType.text = @"【单选题】";
    _qType.font = kFont(14);
     _num.font = kFont(14);
     _typetitle.font = kFont(14);
    _content.font = kFont(14);
    
    _qType.textColor = kOrangeColor;
    _num.textAlignment = NSTextAlignmentRight;
    kWeakS(weakSelf);
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    
    [_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
    }];
    
    [_typetitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImage.mas_right).offset(10);
        make.right.equalTo(weakSelf.num.mas_left);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(15);
    }];
    
    [_qType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(15);
//        make.width.mas_equalTo(70);
        make.top.equalTo(weakSelf.iconImage.mas_bottom).offset(10);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.qType.mas_right).offset(5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(weakSelf.qType);
    }];
    
}

@end
