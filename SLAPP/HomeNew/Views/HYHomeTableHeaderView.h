//
//  HYHomeTableHeaderView.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHomeModel.h"


@interface HYHomeTableHeaderView : UIView

typedef void(^HYButtonAction)(HomeRemindModel *model);

@property(nonatomic,strong)UIView *backView;

//数据源
@property(nonatomic,strong)NSArray *list;
@property (nonatomic,copy)HYButtonAction action;

@end


@interface HYHomeTableHeaderViewLab : UIView
//个数
@property(nonatomic,strong)UILabel *top;
//名称
@property(nonatomic,strong)UILabel *bottom;
@property(nonatomic,strong)UIView *line;



@end
