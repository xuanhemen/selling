//
//  RadarChartHeaderView.m
//  CLApp
//
//  Created by xslp on 16/9/6.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "RadarChartHeaderView.h"
#import "SLAPP-Swift.h"
#import "HYSelectEvaluationModel.h"

#define BgColor [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1]

@interface RadarChartHeaderView ()<ChartViewDelegate,IChartAxisValueFormatter>
@property (nonatomic, strong) RadarChartView *radarChartView;
@property (nonatomic, strong) RadarChartData *data;
@property (strong, nonatomic) NSMutableArray *xVals;

@end
@implementation RadarChartHeaderView

#pragma mark - 初始化入口

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)configUI{
    self.backgroundColor = BgColor;
    kWeakS(weakSelf);
    //创建雷达图对象
    self.radarChartView = [[RadarChartView alloc] init];
    self.radarChartView.backgroundColor = BgColor;
    [self addSubview:self.radarChartView];
    [self.radarChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(weakSelf.frame.size.width, weakSelf.frame.size.height));
        make.center.mas_equalTo(weakSelf);
    }];
    self.radarChartView.delegate = self;
    self.radarChartView.noDataText = @"暂无数据";
    self.radarChartView.chartDescription.text = @"";//描述
    self.radarChartView.rotationEnabled = YES;//是否允许转动
    self.radarChartView.highlightPerTapEnabled = YES;//是否能被选中
    
    //雷达图线条样式
    self.radarChartView.webLineWidth = 0.5;//主干线线宽
    self.radarChartView.webColor = HexColor(@"c2ccd0");//主干线线宽
    self.radarChartView.innerWebLineWidth = 0.375;//边线宽度
    self.radarChartView.innerWebColor = HexColor(@"c2ccd0");//边线颜色
    self.radarChartView.webAlpha = 1;//透明度
    
    self.radarChartView.legend.verticalAlignment = ChartLegendVerticalAlignmentTop;
    self.radarChartView.legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    self.radarChartView.legend.orientation = ChartLegendOrientationVertical;
    self.radarChartView.legend.form = ChartLegendFormSquare;
    self.radarChartView.legend.formSize = 10;
    self.radarChartView.legend.textColor = HexColor(@"057748");
    self.radarChartView.xAxis.valueFormatter = self;
    //设置 xAxi
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:10];//字体
    xAxis.labelTextColor = HexColor(@"057748");//颜色
    xAxis.labelPosition = XAxisLabelPositionBothSided;
    xAxis.wordWrapEnabled = YES;
    xAxis.labelWidth = 200;
    //    xAxis.drawLabelsEnabled = YES;
    //    xAxis.xOffset = 0.0;
    //    xAxis.yOffset = 0.0;
    //设置 yAxis
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    //最大最小值会影响层数,这样设置显示5层
    yAxis.axisMinimum = 0.0;//最小值
    yAxis.axisMaximum = 3.5;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label
    yAxis.labelCount = 5;// label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:9];// label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    yAxis.labelPosition = YAxisLabelPositionOutsideChart;
    //为雷达图提供数据
    self.radarChartView.data = self.data;
    [self.radarChartView renderer];
    
    //设置动画
    [self.radarChartView animateWithYAxisDuration:0.1f];

}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count == 0) {
        return;
    }
    
    
    self.xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (HYSelectSubEvaluationModel *model in dataArray) {
         double evaluateVal = [[model.val toString] doubleValue];
        RadarChartDataEntry *entry = [[RadarChartDataEntry alloc]initWithValue:evaluateVal];
        [yVals insertObject:entry atIndex:0];
        [self.xVals insertObject:model.text atIndex:0];
    }
    
    RadarChartDataSet *set = [[RadarChartDataSet alloc] initWithValues:yVals label: self.type == effect ?@"效果评估":@"信任评估"];
    set.lineWidth = 0.5;//数据折线线宽
    [set setColor:HexColor(@"ff8936")];//数据折线颜色
    set.drawFilledEnabled = YES;//是否填充颜色
    set.fillColor = HexColor(@"ff8936");//填充颜色
    set.fillAlpha = 0.25;//填充透明度
    set.drawValuesEnabled = YES;//是否绘制显示数据(得分)
    set.valueFont = [UIFont systemFontOfSize:9];//字体
    set.valueTextColor = [UIColor grayColor];//颜色
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set]];
    self.data = data;
    
    [self configUI];
}




- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * _Nonnull)highlight{
//    NSLog(@"chartValueSelected");
}
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
//    NSLog(@"chartValueNothingSelected");
}
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
//    NSLog(@"chartScaled");
}
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
//    NSLog(@"chartTranslated");
}
#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return self.xVals[(int) value % self.xVals.count];
}
@end
