//
//  HYProductModel.m
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYProductModel.h"

@implementation HYProductModel

- (void)setChild:(NSArray *)child{
    _child = nil;
    if (child ==nil ||child.count==0) {
        _child = @[];
    }else{
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in child) {
            HYProductModel *subModel = [[HYProductModel alloc] initWithDictionary:dict];
            [array addObject:subModel];
        }
        _child = array;
    }
}

@end
