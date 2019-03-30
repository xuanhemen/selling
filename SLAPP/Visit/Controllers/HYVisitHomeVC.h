//
//  HYVisitHomeVC.h
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseVC.h"
@class ProjectSituationModel;
@interface HYVisitHomeVC : HYBaseVC
@property(nonatomic,strong)ProjectSituationModel *proSituationModel;


/**
 是否是跳转进来    数据源会不一样
 */
@property(nonatomic,assign)BOOL isHome;
//首页跳转传入的拜访id
@property(nonatomic,copy)NSString *visitIds;
@end
