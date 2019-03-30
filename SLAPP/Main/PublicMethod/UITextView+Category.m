//
//  UITextView+Category.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "UITextView+Category.h"

@implementation UITextView (Category)

- (void)configInputStyle{
    
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 4;
//    self.font = kFont_Middle;
    self.textColor = [UIColor darkTextColor];
    
}

@end
