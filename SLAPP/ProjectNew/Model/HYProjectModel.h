//
//  HYProjectModel.h
//  SLAPP
//
//  Created by yons on 2018/10/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFBaseModel.h"

@interface HYProjectModel : QFBaseModel


@property (nonatomic,strong)NSString *client_name;//客户名称
@property (nonatomic,strong)NSString *trade_name;//所属行业
@property (nonatomic,strong)NSString *name;//项目名称
@property (nonatomic,strong)NSString *productStr;//产品
@property (nonatomic,strong)NSString *amount;//合同额
@property (nonatomic,strong)NSString *down_payment;//预计实现业绩（万）
@property (nonatomic,strong)NSString *dateStr;//预计成交时间
@property (nonatomic,strong) NSString *deps_name;//部门名称


@property (nonatomic,strong)NSString *client_id;//客户id
@property (nonatomic,strong)NSString *trade_id;
@property (nonatomic,strong)NSString *trade_parent_id;
@property (nonatomic,assign)NSInteger timerIntStr;//日期


@property (nonatomic,strong) NSString *projectId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSArray *alreadyProductArray;
@property (nonatomic,strong) NSString *alreadyProductString;

//项目结转用到
@property(nonatomic,strong)NSString *close_status_name;
@property(nonatomic,strong)NSString *id;
@end
