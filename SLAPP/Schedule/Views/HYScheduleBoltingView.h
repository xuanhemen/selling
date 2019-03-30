//
//  HYScheduleBoltingView.h
//  SLAPP
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBoltingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HYScheduleBoltingView : UIView
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HYBoltingModel *model;
//选中返回
@property(nonatomic,copy)void (^result)(HYDepMemberModel *depModel,HYScheduleListModel *selectSchedulemodel);

/**
 把历史选中的赋值

 @param depModel 部门或者成员
 @param selectSchedulemodel 日程
 */
-(void)configWithSelectDepModel:(HYDepMemberModel *)depModel AndSelectScheduleModel:(HYScheduleListModel *)selectSchedulemodel;
@end

NS_ASSUME_NONNULL_END
