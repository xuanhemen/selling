//
//  SLScheduleModel.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheduleModel.h"

@implementation SLScheduleModel


-(instancetype)init{
    self = [super init];
    if (self) {
        _isSelect = NO;
    }
    return self;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end
