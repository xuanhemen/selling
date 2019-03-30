//
//  HYRaderCell.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarChartHeaderView.h"
#import "HYVisitEvaluationDelegate.h"
@interface HYRaderCell : UITableViewCell
@property(nonatomic,strong)RadarChartHeaderView *radar;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)EvaluateType type;
@end
