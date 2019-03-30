//
//  HYClientBottomButton.m
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYClientBottomButton.h"
#import <Masonry/Masonry.h>

@interface HYClientBottomButton()

@end

@implementation HYClientBottomButton

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andBlock:(HYClientBottomButtonAction)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.action = block;
        [self configUIWithTitle:title];
    }
    return self;
}

- (void)configUIWithTitle:(NSString *)title{
    
    __weak HYClientBottomButton *weakSelf = self;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
    }];
    
    self.redView = [[UILabel alloc] init];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.layer.cornerRadius = 4;
    self.redView.clipsToBounds = YES;
    self.redView.hidden = YES;
    self.redView.text = @"";
    self.redView.textColor = [UIColor whiteColor];
    self.redView.textAlignment = NSTextAlignmentCenter;
    self.redView.font = [UIFont systemFontOfSize:7];
    [self.redView sizeToFit];
    [self addSubview:self.redView];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(0);
        make.bottom.equalTo(weakSelf.titleLabel.mas_top).mas_offset(4);
        make.height.mas_equalTo(8);
        make.width.mas_greaterThanOrEqualTo(8);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)buttonClick{
    if (self.action) {
        self.action(self);
    }
}
- (void)setRedViewWithNum:(NSInteger)num{
    if (num == -1) {
        self.redView.hidden = YES;
    }else{
        self.redView.hidden = NO;
        if (num == 0) {
            self.redView.text = @"";
        }else{
            if (num > 99) {
                self.redView.text = @" 99+ ";
            }else{
                self.redView.text = [NSString stringWithFormat:@"%ld",num];
            }
        }
    }
    
    
}
@end
