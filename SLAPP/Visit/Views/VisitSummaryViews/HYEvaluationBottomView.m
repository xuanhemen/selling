//
//  HYEvaluationBottomView.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYEvaluationBottomView.h"

@implementation HYEvaluationBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    _leftBtn = [UIButton new];
    _rightBtn = [UIButton new];
    
    [self addSubview:_leftBtn];
    [self addSubview:_rightBtn];
    
    kWeakS(weakSelf);
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.right.equalTo(weakSelf.mas_centerX).offset(-0.5);
        make.height.mas_offset(49);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.left.equalTo(weakSelf.mas_centerX).offset(0.5);
        make.height.mas_offset(49);
    }];
    
    _leftBtn.titleLabel.font = kFont(14);
    _rightBtn.titleLabel.font = kFont(14);
    
    [_leftBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    _leftBtn.backgroundColor = [UIColor grayColor];
    _rightBtn.backgroundColor = kgreenColor;
    _leftBtn.enabled = NO;
    
    _leftBtn.tag = 1000;
    _rightBtn.tag = 1001;
    
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.btnClick) {
        self.btnClick(btn.tag-1000);
    }
    
}

-(void)reSet{
    [_leftBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    _leftBtn.backgroundColor = [UIColor grayColor];
    _rightBtn.backgroundColor = kgreenColor;
    _leftBtn.enabled = NO;
}
@end
