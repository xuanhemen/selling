//
//  HistoricalTrendChartView.m
//  SLAPP
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HistoricalTrendChartView.h"
#import "PYLineDemoOptions.h"
@implementation HistoricalTrendChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    lab.text = @"";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor darkTextColor];
    [self addSubview:lab];
    _labTitle = lab;
    UILabel *topline = [[UILabel alloc]initWithFrame:CGRectMake(10, 39,kScreenWidth-20-20,0.3)];
    topline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:topline];
    
    
    self.kEchartView = [[PYZoomEchartsView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth-20,300-40)];
    NSMutableArray *newges = [NSMutableArray arrayWithArray:_kEchartView.gestureRecognizers];
    for (int i =0; i<[newges count]; i++) {
        [_kEchartView removeGestureRecognizer:[newges objectAtIndex:i]];
    }
    [self addSubview:_kEchartView];
   
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    kWeakS(weakSelf);
    NSArray *legendArray = [dataArray valueForKeyPath:@"name"];
    PYOption *option = [[PYOption alloc]init];
    option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
        tooltip.triggerEqual(PYTooltipTriggerAxis);
    }])
    .colorEqual(@[@"#5dce56",@"#1096c1",@"#a1e9d9",@"#edce6f"])
    .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
        legend.dataEqual(legendArray);
    }])
    .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
        grid.xEqual(@60).x2Equal(@70);
    }])
    .calculableEqual(NO)
    .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeCategory)
        .boundaryGapEqual(@NO).addDataArr(weakSelf.titleArray);
    }])
    .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeValue)
        ;
    }]);
    
    for (NSDictionary *sModel in _dataArray) {
        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(sModel[@"name"])
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(sModel[@"type"]);
        }]);
    }
    
    
    [_kEchartView setOption:option];
    [_kEchartView loadEcharts];
    
    
}


@end
