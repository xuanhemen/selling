//
//  AddressAreaModel.m
//  Shihanbainian
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Codeliu. All rights reserved.
//

#import "AddressAreaModel.h"

@implementation AddressAreaModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (instancetype)addressAreaModel:(NSDictionary *)dict
{
    AddressAreaModel *model = [[AddressAreaModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

@end
