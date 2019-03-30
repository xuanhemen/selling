//
//  HYLookatVisitViewModel.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookatVisitViewModel.h"
#import "HYVisitDetailModel.h"
@implementation HYLookatVisitViewModel


- (NSArray *)sectionTitles{
    if (!_sectionTitles) {
        return @[@"客户的认知期望",@"通过拜访，希望客户想向我承诺如下行动",@"您将向客户提出以下问题",@"为了满足客户期望和需求，你将呈现如下优势......"];
    }
    return _sectionTitles;
}


-(NSArray *)configWithJason:(NSDictionary *)dic{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i< self.sectionTitles.count; i++)
    {
        if (i == 1) {
            HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
            
            model.lowestContent = [dic[@"actionpromise"][@"des"] toString];
            model.bestContent = [dic[@"actionpromise"][@"content"] toString];
            model.sectionName = self.sectionTitles[i];
            [dataArray addObject:@[model]];
        }else if (i == 0){
            HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
            model.content = [dic[@"expect"][@"content"] toString];
            model.sectionName = self.sectionTitles[i];
            [dataArray addObject:@[model]];
        }else if (i == 2){
            HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
            model.content = [dic[@"unknownlist"][@"content"] toString];
            model.sectionName = self.sectionTitles[i];
            [dataArray addObject:@[model]];
        }else{
            HYVisitDetailModel *model = [[HYVisitDetailModel alloc] init];
            model.content = [dic[@"specialadvantage"][@"content"] toString];;
            model.sectionName = self.sectionTitles[i];
            [dataArray addObject:@[model]];
        }
        
    }
    
    
    
    
    return dataArray;
    
}

@end
