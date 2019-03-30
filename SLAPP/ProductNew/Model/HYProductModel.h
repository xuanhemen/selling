//
//  HYProductModel.h
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFBaseModel.h"

@interface HYProductModel : QFBaseModel

@property (nonatomic,strong)NSString *Id;
@property (nonatomic,strong)NSString *name;//         名称
@property (nonatomic,strong)NSString *parentid;
//该字段由海瑞添加，数据库不需要存任何数据，只是在做界面显示时做一个层级的记录
@property (nonatomic,strong)NSString *level;
@property (nonatomic,strong)NSArray *child;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *price;

@end
