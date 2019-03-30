//
//  HYBoltingDepAndMemberView.h
//  SLAPP
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBoltingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HYBoltingDepAndMemberView : UIView
//存放 部门
@property(nonatomic,strong)NSArray *depArray;
//存放 人员
@property(nonatomic,strong)NSArray *memberArray;

@property(nonatomic,strong)HYBoltingModel *model;

@property(nonatomic,strong)HYDepMemberModel *selectModel;

@property(nonatomic,copy)void (^result)(HYDepMemberModel *selectModel);
@end

NS_ASSUME_NONNULL_END
