//
//  WJSTitleView.m
//  WJSTtitle
//
//  Created by 王静帅 on 16/3/10.
//  Copyright © 2016年 rxb. All rights reserved.
//

#import "WJSTitleView.h"
#import "Masonry.h"

#define lineWith 1 //分割线宽度
#define lineTopOrBottomPadding 13 //分割线上下间距
#define btnWith ((self.bounds.size.width - lineWith * 2)/3) //btn宽度

@interface WJSTitleView ()
/** 左侧线 */
@property(nonatomic, strong) UIView *leftLine;
/** 右侧线 */
@property(nonatomic, strong) UIView *rightLine;
///** 左侧btn */
//@property(nonatomic, strong) UIButton *leftBtn;
///** 中间btn */
//@property(nonatomic, strong) UIButton *middleBtn;
///** 右侧btn */
//@property(nonatomic, strong) UIButton *rightBtn;
/** 代理 */

@end
@implementation WJSTitleView

#pragma mark - 初始化入口
- (instancetype)init {
    if (self = [super init]) {
        [self setUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
#pragma mark - 控件
- (void)setUI {
    //1. leftBtn
    [self addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.bottom.equalTo(self);
        make.width.equalTo(@btnWith);
    }];
    
    //2. leftLine
    [self addSubview:self.leftLine];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(lineTopOrBottomPadding);
        make.bottom.equalTo(self).offset(-lineTopOrBottomPadding);
        make.left.equalTo(self.leftBtn.mas_right);
        make.width.equalTo(@lineWith);

    }];
    
    //3 middleBtn
    [self addSubview:self.middleBtn];
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(@btnWith);
    }];
    
    //4 rightLine
    [self addSubview:self.rightLine];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(lineTopOrBottomPadding);
        make.bottom.equalTo(self).offset(-lineTopOrBottomPadding);
        make.left.equalTo(self.middleBtn.mas_right);
        make.width.equalTo(@lineWith);
    }];
    
    //5 rightBtn
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.and.bottom.equalTo(self);
        make.width.equalTo(@btnWith);
    }];
    
}
#pragma mark - 代理方法
- (void)onClickBtn:(UIButton *)button {
    if (![self.delegate respondsToSelector:@selector(onClickBtn:)]) {
        NSLog(@"nil delegate or failed to repond method");
        return;
    }
    [self.delegate onClickBtn:button];
}
#pragma mark - getters
- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        //分割线颜色
        _leftLine.backgroundColor = kgreenColor;
    }
    return _leftLine;
}
- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        //分割线颜色
        _rightLine.backgroundColor = kgreenColor;
    }
    return _rightLine;
}
- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.tag = 0;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //事件监听
        [_leftBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //测试
        [_leftBtn setTitle:@"上周" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
        
    }
    return _leftBtn;
}
- (UIButton *)middleBtn {
    if (!_middleBtn) {
        _middleBtn = [[UIButton alloc] init];
        _middleBtn.tag = 1;
        _middleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //事件监听
        [_middleBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //测试-Red
        [_middleBtn setTitle:@"本周" forState:UIControlStateNormal];
        [_middleBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    }
    return _middleBtn;
}
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.tag = 2;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        //事件监听
        [_rightBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //测试-green
        [_rightBtn setTitle:@"下周" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
        
    }
    return _rightBtn;
}
@end
