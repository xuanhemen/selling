//
//  SLProjectModel.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLProjectModel.h"

@implementation SLProjectModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"numberID" : @"id",
             @"time":@"dealtime",
             @"money":@"amount"
             };
}


@end
