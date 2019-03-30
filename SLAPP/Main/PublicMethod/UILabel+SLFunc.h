//
//  UILabel+SLFunc.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/28.
//  Copyright © 2019 柴进. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SLFunc)

+ (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font;
+ (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font;
@end

NS_ASSUME_NONNULL_END
