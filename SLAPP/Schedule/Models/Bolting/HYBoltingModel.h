//
//  HYBoltingModel.h
//  SLAPP
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYScheduleListModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HYMoreModel;
@interface HYBoltingModel : NSObject
@property(nonatomic,copy)NSString *dep_parent_id;
@property(nonatomic,copy)NSString *dep_id;
@property(nonatomic,copy)NSString *is_more;
@property(nonatomic,copy)NSString *ismanager; 
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)NSArray *dep_member;
@property(nonatomic,strong)HYMoreModel *more;
@end


@interface HYMoreModel : NSObject
@property(nonatomic,strong)NSArray *dep_list;
@property(nonatomic,strong)NSArray *member_list;
@end


@interface HYDepMemberModel : NSObject
//最上边显示的数据
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *name;
@end


@interface HYDepListModel : NSObject
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *parentid;
@property(nonatomic,copy)NSString *name;
@end


@interface HYMember_listModel : NSObject
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *head;
@property(nonatomic,copy)NSString *departmentid;
@end


NS_ASSUME_NONNULL_END
