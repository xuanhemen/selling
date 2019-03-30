//
//  HYVisitDetailViewModel.h
//  SLAPP
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "HYVisitModel.h"
#import <Foundation/Foundation.h>
#import "HYGetVisitSummaryModel.h"
@interface HYVisitDetailViewModel : NSObject
//标题
@property(nonatomic,strong)NSArray *sectionTitles;
//拜访状态
@property(nonatomic,strong)NSString *visitStatus;
//权限
@property(nonatomic,strong)HYAuthModel * authModel;
//权限可处理的标题
@property(nonatomic,strong)NSArray *rightTitles;

@property(nonatomic,strong)NSArray *rightImages;

@property(nonatomic,copy)NSString *comment_count;


@property(nonatomic,strong)HYVisitModel *visitModel;


/**
 图片
 */
@property(nonatomic,strong)NSArray *sectionImages;

-(NSArray *)configWithJason:(NSDictionary *)dic;
@end
