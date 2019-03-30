//
//  VisitReportCell.h
//  CLApp
//
//  Created by xslp on 16/11/2.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VisitReportCellBottomView.h"
#import "HYVisitReportModel.h"
@interface VisitReportCell : UITableViewCell
@property(nonatomic,strong) VisitReportCellBottomView *bottomView;
@property (copy, nonatomic) HYVisitReportModel *model;

@property(copy,nonatomic)void(^bottomClickWithTag)(NSInteger tag);

@end
