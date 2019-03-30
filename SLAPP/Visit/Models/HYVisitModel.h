//
//  HYVisitModel.h
//  SLAPP
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ProjectPlanStarModel;
@interface HYVisitModel : NSObject
@property(nonatomic,strong)NSString *client_id;
@property(nonatomic,strong)NSString *client_name;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *project_id;
@property(nonatomic,strong)NSString *project_name;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *visit_contacts;
@property(nonatomic,strong)NSString *visit_date;
@property(nonatomic,assign)double timeStamp;

@property(nonatomic,strong)ProjectPlanStarModel *starModel;


/**
 修改的时候用到
 */
@property(nonatomic,strong)NSDictionary *editVisitResult;


/**
 获取我方参与   只有修改用

 @return <#return value description#>
 */
-(NSArray *)oursMember;

/**
 获取拜访对象  只有修改用

 @return <#return value description#>
 */
-(NSArray *)visitersMember;
@end
