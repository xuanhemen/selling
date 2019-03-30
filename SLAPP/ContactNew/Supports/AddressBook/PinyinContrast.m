//
//  PinyinContrast.m
//  NewYunDrive
//
//  Created by qwp on 2017/8/18.
//  Copyright © 2017年 祁伟鹏. All rights reserved.
//

#import "PinyinContrast.h"

@implementation PinyinContrast
+ (BOOL)contrastWithStringA:(NSString *)strA andStringB:(NSString *)strB{
    NSLog(@"对比:%@---%@",strA,strB);
    //将字符串拼音转为数组 “zhi shen” 转为 ["zhi","shen"]
    NSArray *strAArray = [strA componentsSeparatedByString:@" "];
    NSArray *strBArray = [strB componentsSeparatedByString:@" "];
    for (int i=0; i<strAArray.count; i++) {
        NSString *subStrA = strAArray[i];
        NSString *subStrB = strBArray[i];
        BOOL subSame = YES;
        //判断i音相似度
        if ([@"XIYIJIQIBIMIDITINILIPIZHICHISHIRIZICISI" rangeOfString:subStrA].length>0&&[@"XIYIJIQIBIMIDITINILIPIZHICHISHIRIZICISI" rangeOfString:subStrB].length) {
             subSame = [self subContrastIWithString1:subStrA andString2:subStrB];
        }
        //判断ANG与AN
        if (([subStrA rangeOfString:@"ANG"].length>0||[subStrB rangeOfString:@"ANG"].length>0)&&([subStrA rangeOfString:@"UANG"].length==0||[subStrB rangeOfString:@"UANG"].length==0)) {
            if (![subStrA rangeOfString:@"ANG"].length||![subStrB rangeOfString:@"ANG"].length) {
                subSame = NO;
            }
        }
        //判断ENG与EN
        if ([subStrA rangeOfString:@"EN"].length>0) {
            subSame = [self subContrastENGWithString1:subStrA andString2:subStrB];
        }
        //判断ING与IN
        if ([subStrA rangeOfString:@"ING"].length>0||[subStrB rangeOfString:@"ING"].length>0) {
            if (![subStrA rangeOfString:@"ING"].length||![subStrB rangeOfString:@"ING"].length) {
                subSame = NO;
            }
        }
        //判断YE音
        if ([subStrA rangeOfString:@"YE"].length>0||[subStrB rangeOfString:@"YE"].length>0) {
            if (![subStrA rangeOfString:@"YE"].length||![subStrB rangeOfString:@"YE"].length) {
                subSame = NO;
            }
        }
        
        
        
        NSLog(@"子对比结果:%@---%@--%d",subStrA,subStrB,subSame);
        if (subSame == NO) {
            return NO;
        }
    }
    return YES;
}


+ (BOOL)subContrastIWithString1:(NSString *)s1 andString2:(NSString *)s2{
    NSString *a1 =@"ZHICHISHIRIZICISI";
    NSString *a2 =@"XIYIJIQIBIMIDITINILIPI";
    if ([a1 rangeOfString:s1].length>0&&[a1 rangeOfString:s2].length>0) {
        return YES;
    }
    if ([a2 rangeOfString:s1].length>0&&[a2 rangeOfString:s2].length>0) {
        return YES;
    }
    return NO;
}


+ (BOOL)subContrastENGWithString1:(NSString *)s1 andString2:(NSString *)s2{
    
    if ([s1 rangeOfString:@"ENG"].length>0||[s2 rangeOfString:@"ENG"].length>0) {
        int i = 0;
        if ([s1 rangeOfString:@"ENG"].length>0) {
            i = i+1;
        }
        if ([s2 rangeOfString:@"ENG"].length>0) {
            i = i+3;
        }
        
        if (i == 4) {
            return YES;
        }else if(i == 1){
            s1 = [s1 substringWithRange:NSMakeRange(0, s1.length-3)];
            s2 = [s2 substringWithRange:NSMakeRange(0, s2.length-2)];
        }else{
            s2 = [s2 substringWithRange:NSMakeRange(0, s2.length-3)];
            s1 = [s1 substringWithRange:NSMakeRange(0, s1.length-2)];
        }
        if ([s1 rangeOfString:@"H"].length>0&&![s1 hasPrefix:@"H"]) {
            s1 = [s1 stringByReplacingOccurrencesOfString:@"H" withString:@""];
        }
        if ([s2 rangeOfString:@"H"].length>0&&![s2 hasPrefix:@"H"]) {
            s2 = [s2 stringByReplacingOccurrencesOfString:@"H" withString:@""];
        }
        if ([s1 isEqualToString:s2]) {
            return YES;
        }else{
            return NO;
        }
        return YES;
    }
    return YES;
}


@end
