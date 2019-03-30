//
//  HYVisitDetailViewModel.m
//  SLAPP
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitDetailViewModel.h"
#import "HYVisitDetailModel.h"
@implementation HYVisitDetailViewModel




- (NSArray *)sectionImages{
    if (!_sectionImages) {
        return @[@"detail_basedetail_ico",@"detail_expect_ico",@"detail_action_ico",@"detail_reason_ico",@"detail_unknown_ico",@"detail_special_advantage_ico"];
    }
    return _sectionImages;
}

- (NSArray *)sectionTitles{
    if (!_sectionTitles) {
        return @[@"基本信息",@"认知期望",@"行动承诺",@"约见理由",@"未知清单",@"优势清单"];
    }
    return _sectionTitles;
}


-(NSArray *)configWithJason:(NSDictionary *)dic{
    
    if ([dic[@"auth"] isNotEmpty]) {
        self.authModel = [HYAuthModel mj_objectWithKeyValues:dic[@"auth"]];
    }
    self.comment_count = [dic[@"comment_count"] toString];
    self.visitStatus = [dic[@"status"] toString];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSString *str in self.sectionTitles)
    {
        if ([str isEqualToString:@"基本信息"])
        {
            [self configJBXXWith:dataArray AndJason:dic sectionName:str];
        }
        else if ([str isEqualToString:@"认知期望"])
        {
            [self configExpectWith:dataArray AndJason:dic sectionName:str];
        }
        else if ([str isEqualToString:@"行动承诺"])
        {
            [self configActionWith:dataArray AndJason:dic sectionName:str];
        }
        else if ([str isEqualToString:@"约见理由"])
        {
            [self configReasonWith:dataArray AndJason:dic sectionName:str];
        }
        else if ([str isEqualToString:@"未知清单"])
        {
            [self configUnknownWith:dataArray AndJason:dic sectionName:str];
        }
        else if ([str isEqualToString:@"优势清单"])
        {
            [self configSpecialAdvantageWith:dataArray AndJason:dic sectionName:str];
        }
        
    }
    
    return dataArray;
    
}

-(void)configJBXXWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    
    NSArray *titleArray = @[@"项目：",@"客户：",@"拜访时间：",@"行动类型：",@"拜访对象：",@"我方参与人员："];
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    for (NSString * str in titleArray) {
        HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
        model.sectionName = sectionName;
        model.left = str;
        
        if ([str isEqualToString:@"项目："]) {
            model.content = [dic[@"project_name"] toString];
        }
        
        if ([str isEqualToString:@"客户："]) {
            model.content = [dic[@"client_name"] toString];
        }
        
        if ([str isEqualToString:@"拜访时间："]) {
            model.content = [dic[@"visit_date"] toString];
        }
        
        if ([str isEqualToString:@"拜访对象："]) {
            model.content = [dic[@"visit_contacts"] toString];
        }
        
        if ([str isEqualToString:@"我方参与人员："]) {
            model.content = [dic[@"ouruser"] toString];
        }
        
        if ([str isEqualToString:@"行动类型："]) {
            model.content = [dic[@"actiontypename"] toString];
        }
        
        [subArray addObject:model];
    }
    [array addObject:subArray];
}

-(void)configExpectWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
    model.sectionName = sectionName;
    model.left = @"";
    NSDictionary *subDic = dic[@"readyinfo"][@"expect"];
    model.content = [subDic[@"content"] toString];
    [subArray addObject:model];
    [array addObject:subArray];
}

-(void)configActionWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
    model.sectionName = sectionName;
    model.left = @"";
    NSDictionary *subDic = dic[@"readyinfo"][@"actionpromise"];
    model.bestContent = [subDic[@"content"] toString];
    model.lowestContent = [subDic[@"des"] toString];
    
    [subArray addObject:model];
    [array addObject:subArray];
    
}

-(void)configReasonWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
    model.sectionName = sectionName;
    model.left = @"";
    NSDictionary *subDic = dic[@"readyinfo"][@"visitreason"];
    model.content = [subDic[@"content"] toString];
    [subArray addObject:model];
    [array addObject:subArray];
}

-(void)configUnknownWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
    model.sectionName = sectionName;
    model.left = @"";
    NSDictionary *subDic = dic[@"readyinfo"][@"unknownlist"];
    model.content = [subDic[@"content"] toString];
    [subArray addObject:model];
    [array addObject:subArray];
}

-(void)configSpecialAdvantageWith:(NSMutableArray *)array AndJason:(NSDictionary *)dic sectionName:(NSString *)sectionName{
    NSMutableArray *subArray = [[NSMutableArray alloc] init];
    HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
    model.sectionName = sectionName;
    model.left = @"";
    NSDictionary *subDic = dic[@"readyinfo"][@"specialadvantage"];
    model.content = [subDic[@"content"] toString];
    [subArray addObject:model];
    [array addObject:subArray];
}


-(NSArray *)rightTitles{
    
    if (!self.authModel) {
        return @[];
    }
    NSMutableArray *titleArray = [NSMutableArray array];
    [titleArray addObject:@"发送总结"];
    if ([self.visitStatus integerValue] == 1) {
        if ([self.authModel.readyreport integerValue] == 1) {
            [titleArray addObject:@"准备报告"];
        }
        
        if ([self.authModel.sumreport integerValue] == 1) {
            [titleArray addObject:@"总结报告"];
        }
        
        if ([self.authModel.reopen integerValue] == 1) {
            [titleArray addObject:@"重新打开"];
        }
        
        if ([self.authModel.del integerValue] == 1) {
            [titleArray addObject:@"删除"];
        }
        
    }
    else{
        if ([self.authModel.complete integerValue] == 1) {
            [titleArray addObject:@"完成"];
        }
        
        if ([self.authModel.yuyue integerValue] == 1) {
            [titleArray addObject:@"预约"];
        }
        
        if ([self.authModel.del integerValue] == 1) {
            [titleArray addObject:@"删除"];
        }
        
        
        if ([self.authModel.readyreport integerValue] == 1) {
            [titleArray addObject:@"准备报告"];
        }
    }
    
    
    return titleArray;
}


@end
