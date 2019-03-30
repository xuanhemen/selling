//
//  PicView.m
//  CLApp
//
//  Created by rms on 17/1/5.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "PicView.h"
#import "ChatKeyBoardMacroDefine.h"
@implementation PicView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
    }
    return self;
}

-(void)setPicsArr:(NSArray *)picsArr{

    _picsArr = picsArr;
     [self addChildViews];
}
-(void)addChildViews{

    CGFloat imgMargin = 10;
    CGFloat imgW = (MAIN_SCREEN_WIDTH - 4 * imgMargin)/3;
    CGFloat btnW = 30;
    self.contentSize = CGSizeMake((imgW +imgMargin) * self.picsArr.count + imgMargin, self.frame.size.height);
   
    for (UIView *childView in self.subviews) {
        [childView removeFromSuperview];
    }
    for (int i = 0; i < self.picsArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgMargin * (i + 1) + imgW * i , 5, imgW, self.frame.size.height - 2 * 5)];
        imgView.tag = 20 + i;
        imgView.image = self.picsArr[i];
        [self addSubview:imgView];
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(imgMargin * (i + 1) + imgW * i + (imgW - btnW), 5, btnW, btnW)];
        delBtn.tag = 10 + i;
        [delBtn addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
        [self addSubview:delBtn];
    }
    
}
-(void)delBtnClick:(UIButton *)sender{

    if (self.deleteBtnClickBlock) {
        self.deleteBtnClickBlock(sender);
    }
}
@end
