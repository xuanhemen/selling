//
//  RadarChartHeaderView.h
//  CLApp
//
//  Created by xslp on 16/9/6.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitEvaluationDelegate.h"
@interface RadarChartHeaderView : UIView
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)EvaluateType type;
@end
