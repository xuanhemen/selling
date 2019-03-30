//
//  QFMemberV.m
//  SLAPP
//
//  Created by yons on 2018/10/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFMemberV.h"

@interface QFMemberV()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *button;

@property (nonatomic,assign)CGFloat minWidth;
@end

@implementation QFMemberV

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentType = QF_Default;
        self.minWidth = 70;
        self.name = @"";
        self.image = nil;
        self.idString = @"";
    }
    return self;
}
- (CGFloat)configMinWidth:(CGFloat)minWidth{
    NSInteger cnt = kScreenWidth/self.minWidth;
    self.minWidth = kScreenWidth/(CGFloat)cnt;
    return self.minWidth;
}
- (void)configUIWithPoint:(CGPoint)point{
    
    NSInteger cnt = kScreenWidth/self.minWidth;
    self.minWidth = kScreenWidth/(CGFloat)cnt;
    
    self.frame = CGRectMake(point.x, point.y, self.minWidth, self.minWidth);
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, self.minWidth-30, self.minWidth-30)];
    if (self.currentType == QF_Default) {
        if (self.image == nil) {
            self.imageView.image = [UIImage imageNamed:@"smallHeadG"];
        }else{
            self.imageView.image = self.image;
        }
    }
    if (self.currentType == QF_Add) {
        self.imageView.image = [UIImage imageNamed:@"qfMemberAdd"];
    }
    if (self.currentType == QF_Minus) {
        self.imageView.image = [UIImage imageNamed:@"qfMemberMins"];
    }
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.imageView.frame.size.height, self.frame.size.width-10, self.frame.size.height-self.imageView.frame.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = self.name;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.titleLabel];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}
- (void)buttonClick{
    if (self.action) {
        self.action(self.currentType, self.idString);
    }
}
@end
