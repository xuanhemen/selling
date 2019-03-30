//
//  HistoricalTrendChartView.h
//  SLAPP
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"
@interface HistoricalTrendChartView : UIView
@property(nonatomic,strong)PYZoomEchartsView *kEchartView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UILabel *labTitle;
@end
