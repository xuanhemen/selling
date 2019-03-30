//
//  HYHomeModel.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface HYHomeModel : NSObject
@property(nonatomic,strong)NSString *company_name;
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)NSArray *remind;
@end




//待办事项等Model
@interface HYHomeContentModel : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSArray *list;
@end


@interface HYHomeContentDetailModel : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *project_id;
@property(nonatomic,strong)NSString *logic_id;
@property(nonatomic,strong)NSString *action_target;
@property(nonatomic,strong)NSString *overtime;
@property(nonatomic,strong)NSString *start_time;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *overtime_date;
@property(nonatomic,strong)NSString *type; //类型
@property(nonatomic,strong)NSString *visit_id;
//source_events 行动计划

//"id":"35114",
//"project_id":"16103",
//"logic_id":"26912",
//"action_target":"需求调研一下哦",
//"overtime":"1536940800",
//"start_time":"1536973200",
//"title":"拜访",
//"overtime_date":"后天 09:00"

@end




// MARK: - *********** 椭圆圈里的model**************
@interface HomeRemindModel : NSObject
//是否显示
@property(nonatomic,copy)NSString *exists;

@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *list;
//名称
@property(nonatomic,copy)NSString *name;
//数量
@property(nonatomic,copy)NSString *num;
@end
