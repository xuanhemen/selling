//
//  HYBoltingModel.m
//  SLAPP
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYBoltingModel.h"

@implementation HYBoltingModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"list":@"HYScheduleListModel",
             @"more":@"HYMoreModel",
             @"dep_member":@"HYDepMemberModel"
             };
}

@end

@implementation HYMoreModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"dep_list":@"HYDepListModel",
             @"member_list":@"HYMember_listModel"
             };
}

@end

@implementation HYDepMemberModel

@end

@implementation HYDepListModel

@end

@implementation HYMember_listModel

@end


