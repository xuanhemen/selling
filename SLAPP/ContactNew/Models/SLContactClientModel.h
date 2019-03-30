//
//  SLContactClientModel.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLContactClientModel : NSObject
/** 联系人id */
@property(nonatomic,copy)NSString *contact_id;
/** 客户id */
@property(nonatomic,copy)NSString *client_id;
/** 客户名称 */
@property(nonatomic,copy)NSString *client_name;
/** 职位 */
@property(nonatomic,copy)NSString *position_name;
/** 部门 */
@property(nonatomic,copy)NSString *dep;

@end
