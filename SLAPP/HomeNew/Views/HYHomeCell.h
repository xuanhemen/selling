//
//  HYHomeCell.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYHomeContentDetailModel;
@interface HYHomeCell : UITableViewCell
@property(nonatomic,strong)UILabel *leftLabel;
//查看按钮
@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)UILabel *contentLab;
//详情model
@property(nonatomic,strong)HYHomeContentDetailModel *model;
//cell 点击查看block
@property(nonatomic,copy)void (^clickCellWithModel)(HYHomeContentDetailModel *model);
@end
