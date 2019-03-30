//
//  NSString+AttributedString.h
//  SLAPP
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AttributedString)
+(NSMutableAttributedString *)configAttributedStrAll:(NSString *)allStr subStr:(NSString *)subStr allColor:(UIColor *)allColor subColor:(UIColor *)subColor font:(UIFont *)font lineSpace:(float)lineSpace;

+(NSAttributedString *)htmlStr:(NSString *)htmlStr;

/**
 对字符串base64编码
 
 @param string <#string description#>
 @return <#return value description#>
 */
+ (NSString *)base64EncodeString:(NSString *)string;

/**
 对字符串base64解码
 
 @param string <#string description#>
 @return <#return value description#>
 */
+ (NSString *)base64DecodeString:(NSString *)string;

@end
