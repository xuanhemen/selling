//
//  SLStringFunc.m
//  SLAPP
//
//  Created by 董建伟 on 2019/1/15.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import "SLStringFunc.h"

@implementation SLStringFunc

+ (NSString *)stringUTF8WithStr:(NSString *)string {
    NSString * str = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return str;
}
@end
