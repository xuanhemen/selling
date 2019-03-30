//
//  UIColor+Function.m
//  MOS
//
//  Created by 董建伟 on 2017/5/23.
//  Copyright © 2017年 Beijing tai chi HuaQing information systems co., LTD. All rights reserved.
//

#import "UIColor+Function.h"

@implementation UIColor (Function)
+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}
//+(UIColor *)colorWithRGB:(NSString *)string
//{
//    float red = strtoul([[string substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16);
//    float green = strtoul([[string substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16);
//    float blue = strtoul([[string substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16);
//    NSLog(@"红%f,绿色%f,蓝色%f",red,green,blue);
//    return COLOR(red, green, blue, 1);
//}

@end
