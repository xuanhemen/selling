//
//  HYGetVisitSummaryModel.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYGetVisitSummaryModel.h"

@implementation HYGetVisitSummaryModel

-(NSArray *)rightTitles{
    
    if (!self.auth) {
        return @[];
    }
    NSMutableArray *titleArray = [NSMutableArray array];
    [titleArray addObject:@"发送总结"];
    if ([self.status integerValue] == 1) {
        if ([self.auth.readyreport integerValue] == 1) {
            [titleArray addObject:@"准备报告"];
        }
        
        if ([self.auth.sumreport integerValue] == 1) {
            [titleArray addObject:@"总结报告"];
        }
        
//        if ([self.auth.reopen integerValue] == 1) {
//            [titleArray addObject:@"重新打开"];
//        }
        
        if ([self.auth.del integerValue] == 1) {
            [titleArray addObject:@"删除"];
        }
        
    }
    else{
//        if ([self.auth.complete integerValue] == 1) {
//            [titleArray addObject:@"完成"];
//        }
//        
        if ([self.auth.yuyue integerValue] == 1) {
            [titleArray addObject:@"预约"];
        }
        
        if ([self.auth.del integerValue] == 1) {
            [titleArray addObject:@"删除"];
        }
        
        
        if ([self.auth.readyreport integerValue] == 1) {
            [titleArray addObject:@"准备报告"];
        }
    }
    
    
    return titleArray;
}


@end


@implementation HYAuthModel

@end
