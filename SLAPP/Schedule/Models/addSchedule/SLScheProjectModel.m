//
//  SLScheProjectModel.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheProjectModel.h"

@implementation SLScheProjectModel

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
