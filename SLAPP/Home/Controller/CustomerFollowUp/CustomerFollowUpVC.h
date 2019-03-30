//
//  CustomerFollowUpVC.h
//  SLAPP
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SDBaseTableViewController.h"
@class CustomerFollowUpModel;
@class ProjectSituationModel;
@interface CustomerFollowUpVC : SDBaseTableViewController
@property (nonatomic ,strong) ProjectSituationModel * model;
@property (nonatomic, copy)NSString *customerId;
- (void)configData;
//- (void)getMsgNum;
-(CustomerFollowUpModel *)getFollowupDetailModel:(NSDictionary *)dic;
@end
