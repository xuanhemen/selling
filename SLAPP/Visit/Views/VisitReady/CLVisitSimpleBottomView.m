//
//  CLVisitSimpleBottomView.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "CLVisitSimpleBottomView.h"

@implementation CLVisitSimpleBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)configUI{
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.tag = 1000;
    [_leftBtn setBackgroundColor:kgreenColor];
    [_leftBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _leftBtn.titleLabel.font = kFont_Big;
    [self addSubview:_leftBtn];
    
    
    _leftBtn.frame  = CGRectMake(0,0, kScreenWidth/2.0-0.5,self.frame.size.height);
    
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kScreenWidth/2.0+0.5, 0, kScreenWidth/2.0-0.5,self.frame.size.height);
    _rightBtn.tag = 1001;
    [_rightBtn setBackgroundColor:kgreenColor];
    [_rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _rightBtn.titleLabel.font = kFont_Big;
    [self addSubview:_rightBtn];
    
    
    [_leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame  = CGRectMake(0,0, kScreenWidth,self.frame.size.height);
    [_finishBtn setBackgroundColor:kgreenColor];
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _finishBtn.titleLabel.font = kFont_Big;
    [self addSubview:_finishBtn];
    _finishBtn.tag = 1002;
    [_finishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _finishBtn.hidden = true;
}


-(void)btnClick:(UIButton *)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(bottomClickWithView:Tag:)]) {
        BOOL isChange = [_delegate bottomClickWithView:self Tag:btn.tag-1000];
        
    }
}

@end
