//
//  BusinessStatisticsTopView.h
//  SLAPP
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAGlobalMacro.h"
#import "AAChartKit.h"


#import "PYEchartsView.h"
#import "PYZoomEchartsView.h"
@interface BusinessStatisticsTopView : UIView
@property (nonatomic, strong) AAChartModel *aaChartModel;
@property (nonatomic, strong) AAChartView  *aaChartView;
@property(nonatomic,copy)void(^select)(NSMutableArray *selectArray);
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)PYZoomEchartsView *kEchartView;
@end


@interface EChartDataModel:NSObject
@property(nonatomic,strong)NSArray *legendArray;
@property(nonatomic,strong)NSArray *xArray;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,copy)NSString *name;
@end
