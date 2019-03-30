//
//  QFCheckView.m
//  SLAPP
//
//  Created by qwp on 2018/8/1.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFCheckView.h"
#import <Masonry/Masonry.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


@interface QFCheckView(){
    
    
}
@property (nonatomic,strong)UIColor *defaultColor;
@property (nonatomic,strong)UIColor *selectColor;

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *checkImageView;
@property (nonatomic,assign)CGRect rect;
@end

@implementation QFCheckView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.rect = frame;
        [self configDefaultCheckView];
    }
    return self;
}

- (void)configDefaultCheckView{
    
    self.isCheck = NO;
    self.defaultColor = UIColorFromRGB(0xE2E2E2);
    self.selectColor = UIColorFromRGB(0x4EAE65);
    
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
        
    }];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = self.defaultColor.CGColor;
    self.backView.layer.cornerRadius = 2;
    self.backView.clipsToBounds = YES;
    
    self.checkImageView = [[UIImageView alloc] init];
    [self addSubview:self.checkImageView];
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.bottom.mas_equalTo(0);
    }];
    self.checkImageView.image = [UIImage imageNamed:@"QFCheckDefaultImage"];
    self.checkImageView.hidden = YES;
    
    UIButton *button = [[UIButton alloc] init];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.right.bottom.mas_equalTo(0);
    }];
    [button addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

- (void)checkButtonClick:(UIButton *)sender{
    if (self.isCheck == NO) {
        self.backView.layer.borderColor = self.selectColor.CGColor;
        self.checkImageView.hidden = NO;
    }else{
        self.backView.layer.borderColor = self.defaultColor.CGColor;
        self.checkImageView.hidden = YES;
    }
    self.isCheck = !self.isCheck;
    if (self.checkBlock != nil) {
        self.checkBlock(self.isCheck,self);
    }
}

- (void)check{
    [self checkButtonClick:nil];
}
@end
