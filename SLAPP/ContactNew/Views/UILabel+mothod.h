//
//  UILabel+mothod.h
//  YouYinCall
//
//  Created by ios on 16/9/1.
//  Copyright © 2016年 北京信通网赢科技发展有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (mothod)


-(void)changeAlignmentRightandLeft;
-(void)labelAlightLeftAndRightWithWidth:(CGFloat)labelWidth;

+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;
@end
