//
//  HYVisitDetailSectionHeaderView.m
//  SLAPP
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitDetailSectionHeaderView.h"

@implementation HYVisitDetailSectionHeaderView

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
    
    _img_icon = [UIImageView new];
    [self addSubview:_img_icon];
    
    
    
    _content = [UILabel new];
    [self addSubview:_content];
    
    _upDownBtn = [UIButton new];
    [self addSubview:_upDownBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btn];
    
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [btn addTarget:self action:@selector(upDownClick) forControlEvents:UIControlEventTouchUpInside];
    
    _editBtn = [UIButton new];
    [self addSubview:_editBtn];
    _editBtn.hidden = YES;
    [_upDownBtn setImage:[UIImage imageNamed:@"chooseDown"] forState:UIControlStateNormal];
//    [_upDownBtn setImage:[UIImage imageNamed:@"chooseDown"] forState:UIControlStateSUIControlStateNormalelected];
    
    kWeakS(weakSelf);
    [_img_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.centerY.equalTo(weakSelf);
    }];
    
    
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.mas_equalTo(-50);
         make.size.mas_equalTo(CGSizeMake(60, 30));
         make.centerY.equalTo(weakSelf);
    }];
    
    [_editBtn setTitle:@"修改" forState:UIControlStateNormal];
    [_editBtn setTitleColor:HexColor(@"FF8D3A") forState:UIControlStateNormal];
    _editBtn.titleLabel.font = kFont(15);
    _editBtn.layer.borderColor = HexColor(@"FF8D3A").CGColor;
    _editBtn.layer.borderWidth = 0.5;
    _editBtn.layer.cornerRadius = 15;
    _editBtn.layer.masksToBounds = YES;
    
    [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.img_icon.mas_right).offset(10);
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(weakSelf.editBtn.mas_left).offset(-10);
    }];
    
  
    [_upDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(weakSelf);
    }];
    
    [_upDownBtn addTarget:self action:@selector(upDownClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)upDownClick{
    if (_upDownBtnClick) {
        _upDownBtnClick(_content.text);
    }
    
}

- (void)editClick{
    if (_editBtnClick) {
        _editBtnClick();
    }
}

@end
