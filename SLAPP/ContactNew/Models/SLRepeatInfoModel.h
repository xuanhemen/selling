//
//  SLRepeatInfoModel.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLRepeatInfoModel : NSObject
/** 联系人id */
@property(nonatomic,copy)NSString *numberID;
/** 联系人姓名 */
@property(nonatomic,copy)NSString *name;
/** 联系人电话 */
@property(nonatomic,copy)NSString *phone;
/** 联系人邮箱 */
@property(nonatomic,copy)NSString *email;
/** 联系人QQ */
@property(nonatomic,copy)NSString *qq;
/** 联系人微信 */
@property(nonatomic,copy)NSString *wechat;
/** 联系人生日 */
@property(nonatomic,copy)NSString *birthday;
/** 联系人性别 */
@property(nonatomic,copy)NSString *sex;
/** 联系人备注 */
@property(nonatomic,copy)NSString *more;
/** 联系人客户名称 */
@property(nonatomic,copy)NSString *client_name;
/** 是否可合并 */
@property(nonatomic,copy)NSString *jurisdiction;
/** 联系人客户id */
@property(nonatomic,copy)NSString *client_id;
/** 职务 */
@property(nonatomic,copy)NSString *position_name;
/** 部门 */
@property(nonatomic,copy)NSString *dep;

@end
