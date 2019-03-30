//
//  UIColor+Function.h
//  MOS
//
//  Created by 董建伟 on 2017/5/23.
//  Copyright © 2017年 Beijing tai chi HuaQing information systems co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Function)

+(UIColor *)colorWithRGBHex:(UInt32)hex;
+(UIColor *)colorWithHexString:(NSString *)stringToConvert;
//+(UIColor *)colorWithRGB:(NSString *)string;

@end
