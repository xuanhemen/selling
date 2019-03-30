//
//  GuideBtn.m
//  CLApp
//
//  Created by 吕海瑞 on 16/8/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#define kGuideWidthSmall 25
#define KGuideWidthBig   40

#import "GuideBtn.h"

@implementation GuideBtn

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self configUIWith:frame];
    }
    return self;
}

-(void)configUIWith:(CGRect)frame
{
    
//    self.remindLable = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-30, MAIN_SCREEN_WIDTH/7., 30)];
//    if (self.tag == 6) {
//
//    }
//    self.remindLable = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-30, MAIN_SCREEN_WIDTH/7., 30)];
//    [self.remindLable setTextColor:kNavBarBGColor];
//    self.remindLable.textAlignment = NSTextAlignmentCenter;
//    [self.remindLable setFont:[UIFont systemFontOfSize:11]];
//    [self addSubview:self.remindLable];
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    if (self.markTag == 0)
    {
        self.titleLabel.frame = CGRectMake(0,0, kGuideWidthSmall, kGuideWidthSmall);
        self.titleLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        if (self.isClicked)
        {
             self.titleLabel.backgroundColor = HexColor(@"AFBEC6");
           
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            self.titleLabel.layer.borderWidth = 0;
        }
        else
        {
            self.titleLabel.backgroundColor = [UIColor whiteColor];
            self.titleLabel.backgroundColor = HexColor(@"43be5f");
            self.titleLabel.layer.borderWidth = 1;
            self.titleLabel.layer.borderColor = [UIColor grayColor].CGColor;
            [self.titleLabel setTextColor:[UIColor whiteColor]];
        }
        
       
        
        __weak typeof(self) weakSelf = self;
        
        if (self.tag == 1000) {
//           self.remindLable.frame = CGRectMake(0,self.frame.size.height-30, MAIN_SCREEN_WIDTH/7.+60, 30);
//            [self.remindLable mas_makeConstraints:^(MASConstraintMaker *make) {
////                make.left.mas_equalTo(weakSelf);
////                make.bottom.mas_equalTo(weakSelf).offset(-5);
//
//                make.centerX.mas_equalTo(weakSelf);
//                make.bottom.mas_equalTo(weakSelf).offset(-5);
//            }];
//            self.remindLable.textAlignment = NSTextAlignmentCenter;
            
//            self.remindLable.textAlignment = NSTextAlignmentLeft;
        }else if (self.tag == 1007){
//            self.remindLable.frame = CGRectMake(MAIN_SCREEN_WIDTH/7.-110,self.frame.size.height-30, 100, 30);
//            [self.remindLable mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(weakSelf);
//                make.bottom.mas_equalTo(weakSelf).offset(-5);
//            }];
//            self.remindLable.textAlignment = NSTextAlignmentRight;
       }
        else{
        
            
//            [self.remindLable mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(weakSelf);
//                make.bottom.mas_equalTo(weakSelf).offset(-5);
//            }];
//            self.remindLable.textAlignment = NSTextAlignmentCenter;
            
        }
        
        
//        self.remindLable.hidden = YES;
    }
    else if(self.markTag == 1)
    {
        self.titleLabel.frame = CGRectMake(0,0, KGuideWidthBig, KGuideWidthBig);
        self.titleLabel.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        
        self.titleLabel.backgroundColor = HexColor(@"F77E11");
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        self.titleLabel.layer.borderWidth = 0;
//         self.remindLable.hidden = NO;
    }
    self.titleLabel.layer.cornerRadius = self.titleLabel.bounds.size.width/2.0;
    
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
       
    
}
-(void)configWithTag:(NSInteger )tag 
{
    self.markTag = tag;
    [self layoutSubviews];
    
    
}

@end
