//
//  QFTimeLineVC.h
//  SLAPP
//
//  Created by qwp on 2018/7/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "SDBaseTableViewController.h"
#import <MJRefresh/MJRefresh.h>
@class ProjectSituationModel;
@class SDTimeLineCellModel;
@interface QFTimeLineVC : SDBaseTableViewController
@property (nonatomic ,strong)ProjectSituationModel *model;
@property (nonatomic, copy)NSString *contactId;
@property (nonatomic, copy)NSString *contactName;
@property (nonatomic, copy)NSString *clientId;
- (void)configData;
- (void)getMsgNum;
-(SDTimeLineCellModel *)getFollowupDetailModel:(NSDictionary *)dic;
@end
