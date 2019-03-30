//
//  HYProjectGroupModel.m
//  SLAPP
//
//  Created by fank on 2019/1/3.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import "HYProjectGroupModel.h"
#import <MJExtension/MJExtension.h>

@implementation HYProjectGroupModel

MJCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isShow = @"1";
    }
    return self;
}

@end
