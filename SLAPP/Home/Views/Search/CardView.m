//
//  CardView.m
//  CLApp
//
//  Created by xslp on 16/8/4.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "CardView.h"

#define BottomLine_Height 2.0

@interface CardView ()

@property (strong, nonatomic) UIButton *selectedBtn;

@property (strong, nonatomic) UIView *selectedBottomLine;
@end

@implementation CardView

#pragma mark - 初始化入口

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //1. 背景色
        self.backgroundColor = [UIColor whiteColor];
        self.titleNormalColor = [UIColor blackColor];
        self.titleSelectColor = kgreenColor;
        self.bottomLineNormalColor = kgreenColor;
    }
    return self;
}

-(void)creatBtnsWithTitles:(NSArray *)titleArr{

    CGFloat btnWidth = self.frame.size.width / titleArr.count;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, self.frame.size.height - BottomLine_Height);
        [self addSubview:btn];

        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.tag = i + 20;
         bottomLine.backgroundColor = self.bottomLineNormalColor;
        bottomLine.hidden = YES;
        bottomLine.frame = CGRectMake(i * btnWidth, CGRectGetMaxY(btn.frame), btnWidth, BottomLine_Height);
        [self addSubview:bottomLine];
        
        
        
       
    }
    
    [self btnClicked:[self viewWithTag:10]];

}
-(void)configSelectWith:(NSInteger)tag
{
    
    [self btnClicked:[self viewWithTag:tag]];
}


-(NSInteger)currentTag{
    
    if (self.selectedBtn) {
        return self.selectedBtn.tag;
    }
    return 10;
    
}

-(void)selectActionWithTag:(NSInteger)tag{
    
    for (UIView *view in self.subviews) {
        if (view.tag == tag && [view isKindOfClass:[UIButton class]]) {
            
            if (self.btnClickBlock) {
                self.selectedBtn = (UIButton *)view;
                self.btnClickBlock(tag);
            }
        }
    }
    
    
    
}

-(void)btnClicked:(UIButton *)sender{
    if ([self.selectedBtn isEqual:sender]) {
        UIButton *btn = [self viewWithTag:sender.tag];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
        self.selectedBottomLine.hidden = YES;
        UIView *bottomLine = [self viewWithTag:sender.tag + 10];
        bottomLine.hidden = NO;
        self.selectedBottomLine = bottomLine;
        return;
    }
    BOOL isend = NO;
    if (self.btnClickBlock) {
        [self.selectedBtn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        UIButton *btn = [self viewWithTag:sender.tag];
        [btn setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
        self.selectedBtn = btn;
        
        self.selectedBottomLine.hidden = YES;
        UIView *bottomLine = [self viewWithTag:sender.tag + 10];
        bottomLine.hidden = NO;
        self.selectedBottomLine = bottomLine;
        
        isend = self.btnClickBlock(sender.tag);
    }
    if (isend) {
        return;
    }
    
    
    
}

@end
