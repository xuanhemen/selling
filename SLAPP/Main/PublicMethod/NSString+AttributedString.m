//
//  NSString+AttributedString.m
//  SLAPP
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

+(NSMutableAttributedString *)configAttributedStrAll:(NSString *)allStr subStr:(NSString *)subStr allColor:(UIColor *)allColor subColor:(UIColor *)subColor font:(UIFont *)font lineSpace:(float)lineSpace{
    
    
    NSRange range = NSMakeRange(0, allStr.length);
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    NSRange subRange = [allStr rangeOfString:subStr];
    [aStr addAttribute:NSForegroundColorAttributeName value:allColor range:range];
    [aStr addAttribute:NSForegroundColorAttributeName value:subColor range:subRange];
    [aStr addAttribute:NSFontAttributeName value:font range:range];
    if (lineSpace > 0) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpace;
        [aStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    }
    
    return aStr;
}


//static func htmlStr(htmlStr:String)->(NSAttributedString){
//    do {
//        let str = String.init(format: "<span style= color:white>%@<span", htmlStr)
//        return try NSAttributedString.init(data: str.data(using: String.Encoding.unicode)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//    } catch{
//        DLog(error)
//    }
//    return NSAttributedString.init(string: "")
//}


+(NSAttributedString *)htmlStr:(NSString *)htmlStr{
    NSString * str = [NSString stringWithFormat:@"<span style= color:white>%@<span",htmlStr];
    
   NSMutableAttributedString *atr =  [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    NSRange range = NSMakeRange(0, atr.length);
    [atr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    return atr;
    
}



+ (NSString *)base64EncodeString:(NSString *)string{
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (NSString *)base64DecodeString:(NSString *)string
{
    if (!string) {
        return @"";
    }
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!data){
        return @"";
    }
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

@end
