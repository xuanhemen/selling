//
//  SLRepeatInfoModel.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLRepeatInfoModel.h"
#import "MJExtension.h"
@implementation SLRepeatInfoModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"numberID":@"id"
             };
    
}
@end
