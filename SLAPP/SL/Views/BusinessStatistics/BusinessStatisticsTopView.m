//
//  BusinessStatisticsTopView.m
//  SLAPP
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "BusinessStatisticsTopView.h"
#import "QFHeader.h"

#define btnHeight  30
#define BSTopViewHeight  380
@interface BusinessStatisticsTopView()<AAChartViewDidFinishLoadDelegate>

@property(nonatomic,strong)UIButton *topBtn;
@property(nonatomic,strong)UIButton *bottomBtn;
@property(nonatomic,strong)NSArray *topTitle;
@property(nonatomic,strong)NSArray *bottomTitle;

//商机统计 all_ongoing_pro所有项目   only_ongoing_pro未关单的   addition新增  accumulation累计
@end
@implementation BusinessStatisticsTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,70, kScreenWidth, BSTopViewHeight);
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    _selectArray = [NSMutableArray array];
    _topTitle = @[@"数量",@"合同额",@"预计/实际业绩"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0+i*80,0,i<2 ?80:140, btnHeight);
        [btn setImage:[UIImage imageNamed:@"pCheckNomal"] forState:UIControlStateNormal];
        if( i == 0 ){
            [btn setImage:[UIImage imageNamed:@"pCheckSelect"] forState:UIControlStateNormal];
            [self.selectArray addObject:_topTitle[i]];
            _topBtn = btn;
        }
        [btn setTitle:_topTitle[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
    _bottomTitle = @[@"新增数",@"累计数",@"只统计未关单"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i< 2 ? 0+i*80 : kScreenWidth-150,BSTopViewHeight-btnHeight,i<2 ?80:140, btnHeight);
        [btn setImage:[UIImage imageNamed:@"pCheckNomal"] forState:UIControlStateNormal];
        if( i == 0 ){
            [btn setImage:[UIImage imageNamed:@"pCheckSelect"] forState:UIControlStateNormal];
             [self.selectArray addObject:_bottomTitle[i]];
            _bottomBtn = btn;
        }
        [btn setTitle:_bottomTitle[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.kEchartView = [[PYZoomEchartsView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, BSTopViewHeight-btnHeight*2)];
    NSMutableArray *newges = [NSMutableArray arrayWithArray:_kEchartView.gestureRecognizers];
    for (int i =0; i<[newges count]; i++) {
        [_kEchartView removeGestureRecognizer:[newges objectAtIndex:i]];
    }
    [self addSubview:_kEchartView];
}

-(void)btnClick:(UIButton *)btn{
    if ([_topTitle containsObject:btn.titleLabel.text]){
        if(_topBtn != btn){
            [_topBtn setImage:[UIImage imageNamed:@"pCheckNomal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pCheckSelect"] forState:UIControlStateNormal];
            [_selectArray removeObject:_topBtn.titleLabel.text];
             [_selectArray addObject:btn.titleLabel.text];
            _topBtn = btn;
        }
    }
    
    if ([_bottomTitle containsObject:btn.titleLabel.text]){
        
        if([btn.titleLabel.text isEqualToString:@"只统计未关单"]){
            if ([_selectArray containsObject:@"只统计未关单"]){
                 [_selectArray removeObject:btn.titleLabel.text];
                [btn setImage:[UIImage imageNamed:@"pCheckNomal"] forState:UIControlStateNormal];
            }else{
                [_selectArray addObject:btn.titleLabel.text];
                [btn setImage:[UIImage imageNamed:@"pCheckSelect"] forState:UIControlStateNormal];
            }
            if(_select){
                _select(_selectArray);
            }
        }
        else if(_bottomBtn != btn){
            [_bottomBtn setImage:[UIImage imageNamed:@"pCheckNomal"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"pCheckSelect"] forState:UIControlStateNormal];
            [_selectArray removeObject:_bottomBtn.titleLabel.text];
            [_selectArray addObject:btn.titleLabel.text];
            _bottomBtn = btn;
        }
    }
    
    [self configData];
}



-(void)setData:(NSDictionary *)data{
    _data = data;
    [self configData];
}



-(void)configData{
    
    if (_data.count>0){
        if ([_selectArray containsObject:@"只统计未关单"]){
            NSArray *array = [self getSecondData:_data[@"only_ongoing_pro"]];
            [self configModelData:array];
        }else{
            NSArray *array = [self getSecondData:_data[@"all_ongoing_pro"]];
            [self configModelData:array];
        }
        
    }
    
}

-(NSArray *)getSecondData:(NSDictionary *)dic{
    if ([_selectArray containsObject:@"新增数"]){
        return dic[@"addition"];
    }else{
        return dic[@"accumulation"];
    }
}

-(void)configModelData:(NSArray *)array{
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSMutableArray *legNameArray = [NSMutableArray array];
    
    EChartDataModel *eModel = [[EChartDataModel alloc] init];
    
    for (NSDictionary *dic in array) {
        NSMutableArray *showArray = [NSMutableArray array];
        EChartDataModel *eSubModel = [[EChartDataModel alloc] init];
        eSubModel.name = [NSString stringWithFormat:@"%@",dic[@"name"]];
        [legNameArray addObject:[NSString stringWithFormat:@"%@",dic[@"name"]]];
        NSMutableArray *showNameArray = [NSMutableArray array];
        for (NSDictionary *subDic in dic[@"list"]) {
            
            if ([_selectArray containsObject:@"数量"]){
                [showArray addObject:subDic[@"count"]];
                
            }else if ([_selectArray containsObject:@"合同额"]){
                [showArray addObject:subDic[@"amount"]];
                
            }else{
                
                [showArray addObject:subDic[@"down_payment"]];
            }
            [showNameArray addObject:subDic[@"name"]];
            
        }
        eSubModel.dataArray = showArray;
        eSubModel.xArray = showNameArray;
        [modelArray addObject:eSubModel];
    }
    
    if (modelArray.count > 0) {
        eModel.dataArray = modelArray;
        eModel.legendArray = legNameArray;
        EChartDataModel *subModel = modelArray[0];
        eModel.xArray = subModel.xArray;
    }
    [self refreshWithArray:eModel];
}


-(void)refreshWithArray:(EChartDataModel *)eModel{
    
    
    PYOption *option = [[PYOption alloc]init];
    option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
        tooltip.triggerEqual(PYTooltipTriggerAxis);
    }])
   
    .colorEqual(@[@"#5dce56",@"#1096c1",@"#a1e9d9",@"#edce6f"])
    .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
        legend.dataEqual(eModel.legendArray);
    }])
    .gridEqual([PYGrid initPYGridWithBlock:^(PYGrid *grid) {
        grid.xEqual(@60).x2Equal(@70);
    }])
    .calculableEqual(NO)
    .addXAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeCategory)
        .boundaryGapEqual(@NO).addDataArr(eModel.xArray);
    }])
    .addYAxis([PYAxis initPYAxisWithBlock:^(PYAxis *axis) {
        axis.typeEqual(PYAxisTypeValue)
        ;
    }]);
    
    for (EChartDataModel *sModel in eModel.dataArray) {
        option.addSeries([PYCartesianSeries initPYCartesianSeriesWithBlock:^(PYCartesianSeries *series) {
            series.stackEqual(@"总量")
            .nameEqual(sModel.name)
            .typeEqual(PYSeriesTypeLine)
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *normal) {
                    normal.areaStyleEqual([PYAreaStyle initPYAreaStyleWithBlock:^(PYAreaStyle *areaStyle) {
                        areaStyle.typeEqual(PYAreaStyleTypeDefault);
                    }]);
                }]);
            }])
            .dataEqual(sModel.dataArray);
        }]);
    }
    
    
    [_kEchartView setOption:option];
    [_kEchartView loadEcharts];
    
    
    
    
    
    
    

    
}







- (void)AAChartViewDidFinishLoad{
    
    
}
@end



@implementation EChartDataModel

@end
