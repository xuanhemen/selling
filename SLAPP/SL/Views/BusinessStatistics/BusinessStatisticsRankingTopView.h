//
//  BusinessStatisticsRankingTopView.h
//  SLAPP
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAGlobalMacro.h"
#import "AAChartKit.h"
@interface BusinessStatisticsRankingTopView : UIView
@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;
@property(nonatomic,strong)NSDictionary *data;
@end
