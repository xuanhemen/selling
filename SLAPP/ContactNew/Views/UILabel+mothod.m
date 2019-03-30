//
//  UILabel+mothod.m
//  YouYinCall
//
//  Created by ios on 16/9/1.
//  Copyright © 2016年 北京信通网赢科技发展有限公司. All rights reserved.
//

#import "UILabel+mothod.h"
#import <CoreText/CoreText.h>

@implementation UILabel (mothod)

-(void)changeAlignmentRightandLeft
{
    
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size;
    
    CGFloat margin = (self.frame.size.width - textSize.width)/(self.text.length-1);
    NSNumber * number = [NSNumber numberWithFloat:margin];
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributeString addAttribute:(id)kCTKernAttributeName value:number range:NSMakeRange(0, self.text.length-1)];
    self.attributedText = attributeString;
}
-(void)labelAlightLeftAndRightWithWidth:(CGFloat)labelWidth
{
    //自适应高度
    CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine| NSStringDrawingUsesFontLeading  attributes:@{NSFontAttributeName :self.font} context:nil].size;
    CGFloat margin = (labelWidth - textSize.width)/(self.text.length - 1);
    NSNumber *number = [NSNumber numberWithFloat:margin];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:self.text];
    //字间距 :NSKernAttributeName
    [attribute addAttribute:NSKernAttributeName value:number range:NSMakeRange(0, self.text.length - 1)];
    self.attributedText = attribute;
    
}
//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect.size.height;
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

@end
