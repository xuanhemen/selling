//
//  HYHomeModel.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeModel.h"

@implementation HYHomeModel

+ (NSDictionary *)mj_objectClassInArray{
    
        return @{
           @"list":@"HomeRemindModel",
           @"remind":@"HYHomeContentModel"
           };
}

@end


@implementation HomeRemindModel 

@end

@implementation HYHomeContentModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"list":@"HYHomeContentDetailModel"
             };
}


@end

@implementation HYHomeContentDetailModel

@end
