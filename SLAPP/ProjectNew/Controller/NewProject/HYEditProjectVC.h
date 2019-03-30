//
//  HYEditProjectVC.h
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYNewProjectVC.h"
#import "HYNewProjectTopView.h"
#import "HYProjectModel.h"


typedef void(^EditNeedRefreshAction)(void);

@interface HYEditProjectVC : HYNewProjectVC


@property (nonatomic,strong) HYProjectModel *model;

@property (nonatomic,copy)EditNeedRefreshAction needUpdate;

- (void)configDataWithModel:(HYProjectModel *)hy_model;

@end
