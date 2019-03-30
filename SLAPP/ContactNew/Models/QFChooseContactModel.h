//
//  QFChooseContactModel.h
//  SLAPP
//
//  Created by yons on 2018/10/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LJContactManager/LJPerson.h>

@interface QFChooseContactModel : NSObject

@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *name;//姓名
@property (nonatomic,strong)NSString *phone;//手机号
@property (nonatomic,strong)NSString *email;//邮箱
@property (nonatomic,strong)NSString *realname;//创建人
@property (nonatomic,strong)NSString *client_name;//客户名称
@property (nonatomic,strong)NSString *client_id;//客户id
@property (nonatomic,strong)NSString *addtime;//创建时间
@property (nonatomic,strong)NSString *position_name;//职位
@property (nonatomic,strong)NSString *have_projects;//是否有项目
@property (nonatomic,strong)NSString *dep;//部门
@property (nonatomic,strong)NSString *corpid;
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *phone_other;//其他手机号
@property (nonatomic,strong)NSString *key;//对应key
@property (nonatomic,strong)NSString *pinyin;//拼音
@property (nonatomic,strong)NSString *trade_id_one;
@property (nonatomic,strong)NSString *trade_name_one;
@property (nonatomic,strong)NSString *trade_id_two;
@property (nonatomic,strong)NSString *trade_name_two;
@property (nonatomic,strong)NSString *fo_count;
@property (nonatomic,strong)NSString *msg_count;
@property (nonatomic,strong)NSString *head;//头像
@property (nonatomic,strong)NSData *headerImage;//头像
@property (nonatomic,strong)NSString *qf_select_status;//选中状态



- (void)setAllContactModelWithDict:(NSDictionary *)dict;

- (void)setAdressContactModelWithPerson:(LJPerson *)person;

- (void)setAlreadyModelWithDict:(NSDictionary *)dict;

@end
