//
//  HYVisitActionTypeVC.h
//  SLAPP
//
//  Created by apple on 2018/12/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseVC.h"
@class ProjectPlanStarModel;
@interface HYVisitActionTypeVC : HYBaseVC
@property(nonatomic,copy)NSString *proId;
@property(nonatomic,copy)void(^starViewClick)(ProjectPlanStarModel * model);
@end
