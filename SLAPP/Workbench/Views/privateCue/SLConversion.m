//
//  SLConversion.m
//  SLAPP
//
//  Created by 董建伟 on 2019/1/14.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import "SLConversion.h"

@implementation SLConversion

-(NSMutableAttributedString *)conversion:(NSString *)string andReleName:(NSString *)name reply:(NSString *)replyName
{
    
    NSMutableAttributedString * AttributedString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [string rangeOfString:name];
   
    if (replyName.length == 0) {
        range.length += 1;
    }else{
        NSRange rangeOne = [string rangeOfString:replyName];
        rangeOne.length += 1;
        [AttributedString yy_setTextHighlightRange:rangeOne color:COLOR(103, 119, 155, 1) backgroundColor:[UIColor redColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            self.releClick(1);
        }];
    }
   
    //NSLog(@"%@",range);
    [AttributedString yy_setTextHighlightRange:range color:COLOR(103, 119, 155, 1) backgroundColor:[UIColor redColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        self.releClick(0);
    }];
    
    
    return AttributedString;
}
@end
