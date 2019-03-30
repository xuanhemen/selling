//
//  HYVisitAnalyseModel.m
//  SLAPP
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitAnalyseModel.h"

@implementation HYVisitAnalyseModel

+ (NSDictionary *)mj_objectClassInArray{
    
//    @property(nonatomic,strong)NSArray *coach;
//    @property(nonatomic,strong)NSArray *contact_info;
//    @property(nonatomic,strong)NSArray *engagement;
//    @property(nonatomic,strong)NSArray *feedback;
//    @property(nonatomic,strong)NSArray *orgresult;
//    @property(nonatomic,strong)NSArray *personalwin;
//    @property(nonatomic,strong)NSArray *support;
    
    return @{
             @"coach":@"HYVisitAnalyseSubModel",
             @"engagement":@"HYVisitAnalyseSubModel",
             @"feedback":@"HYVisitAnalyseSubModel",
             @"orgresult":@"HYVisitAnalyseSubModel",
             @"personalwin":@"HYVisitAnalyseSubModel",
             @"support":@"HYVisitAnalyseSubModel",
             @"contact_info":@"HYVisitAnalyseContactInfoModel"
             };
}

@end


@implementation HYVisitAnalyseContactInfoModel

@end


@implementation HYVisitAnalyseSubModel

@end


