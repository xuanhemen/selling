//
//  SLRealContactModel.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLRealContactModel.h"

@implementation SLRealContactModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.isSelect = NO;
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
