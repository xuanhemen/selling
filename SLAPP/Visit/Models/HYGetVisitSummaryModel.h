//
//  HYGetVisitSummaryModel.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//
#import <MJExtension/MJExtension.h>
#import <Foundation/Foundation.h>
@class HYAuthModel;
@interface HYGetVisitSummaryModel : NSObject
@property(nonatomic,strong)NSString *agreement;
@property(nonatomic,strong)NSString *nextplan;
@property(nonatomic,strong)NSString *obtainpromise;
@property(nonatomic,strong)NSString *unknownlist;
@property(nonatomic,strong)NSString *visitworry;
@property(nonatomic,strong)NSString *visit_contacts;
@property(nonatomic,strong)NSString *status; //状态
@property(nonatomic,strong)HYAuthModel *auth;

//权限可处理的标题
@property(nonatomic,strong)NSArray *rightTitles;

@property(nonatomic,strong)NSArray *rightImages;
@end

@interface HYAuthModel :NSObject
@property(nonatomic,strong)NSString *complete;
@property(nonatomic,strong)NSString *del;
@property(nonatomic,strong)NSString *edit;
@property(nonatomic,strong)NSString *look;
@property(nonatomic,strong)NSString *readyreport;
@property(nonatomic,strong)NSString *reopen;
@property(nonatomic,strong)NSString *sendsum;
@property(nonatomic,strong)NSString *yuyue;
@property(nonatomic,strong)NSString *sumreport;
@end
