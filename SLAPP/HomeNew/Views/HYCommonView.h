//
//  HYCommonView.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHomeModel.h"
#import "HYHomeView.h"

@class HYHomeTableHeaderView;
//普通员工显示的界面
@interface HYCommonView : UIView<UITableViewDelegate,UITableViewDataSource>
/**
 按钮点击block 目前用tag  如果可配置需要用key
 */
@property(nonatomic,copy)void(^btnClick)(NSInteger tag,NSString *key);

@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)HYHomeModel *model;

//首页顶端显示界面
@property(nonatomic,strong)HYHomeView *top;

//客户  项目   拜访  个数显示的界面
@property(nonatomic,strong)HYHomeTableHeaderView *head;


//cell 点击查看block
@property(nonatomic,copy)void (^clickCellWithModel)(HYHomeContentDetailModel *model);

@property(nonatomic,copy)void (^clickHeadWithModel)(HomeRemindModel *model);
@end
