//
//  HYHomeTopBtn.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeTopBtn.h"

@implementation HYHomeTopBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:19];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat kScale = 0.8;
    
    CGFloat x = 0;
    CGFloat y = contentRect.size.height *kScale;
    CGFloat width = contentRect.size.width;
    CGFloat height = contentRect.size.height * (1-kScale);
    return CGRectMake(x, y, width, height);
    
}

@end
