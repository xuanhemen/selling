//
//  HYAddVisitVC.h
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseVC.h"
#import "HYVisitModel.h"
@class ProjectSituationModel;

@interface HYAddVisitVC : HYBaseVC
@property(nonatomic,strong)HYVisitModel *visitModel;


//项目下新建拜访用到
@property(nonatomic,strong)ProjectSituationModel *proModel;

@end
