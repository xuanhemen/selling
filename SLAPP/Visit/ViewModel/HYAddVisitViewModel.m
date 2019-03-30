//
//  HYAddVisitViewModel.m
//  SLAPP
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYAddVisitViewModel.h"

@implementation HYAddVisitViewModel





-(NSArray *)configData;
{
    
    return @[@[@"项目",@"客户",@"拜访日期",@"行动类型"],@[@"拜访对象"],@[@"我方参与人员"]];
}


-(CGFloat)visitersHeight{
    if ([self.visiters isNotEmpty]) {
        _visitersHeight = [self getHeightwithCount:[self.visiters count]];
    }
    else{
        _visitersHeight = 70;
    }
    
    return _visitersHeight;
};

-(CGFloat)oursHeight{
    
    if ([self.ours isNotEmpty]) {
        _oursHeight = [self getHeightwithCount:[self.ours count]];
    }
    else{
        _oursHeight = 70;
    }
    
    return _oursHeight;
}

-(CGFloat)getHeightwithCount:(NSInteger)count{
    
    
    CGFloat num = count/3;
    CGFloat height = (num+1)*30 + (num+2)*5 + 30;
    return  height<70.0 ? 70.0 :height;
    
}


-(NSArray *)getVisiterIds{
    
    if ([self.visiters isNotEmpty]) {
        return [self.visiters valueForKeyPath:@"id"];
    }
    return nil;
}
-(NSArray *)getOursIds{
    if ([self.ours isNotEmpty]) {
        
        return [self.ours valueForKeyPath:@"id"];
    }
    return nil;
    
}


@end
