//
//  BusinessStatisticsRankingTopView.m
//  SLAPP
//
//  Created by apple on 2018/8/9.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "BusinessStatisticsRankingTopView.h"
#import "QFHeader.h"

@interface BusinessStatisticsRankingTopView()
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,strong)UIButton *topBtn;
@property(nonatomic,strong)NSArray *topTitle;
@end

@implementation BusinessStatisticsRankingTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,70, kScreenWidth, 280);
        [self configUI];
        self.backgroundColor = [UIColor whiteColor];
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
        btn.frame = CGRectMake(0+i*80,0,i<2 ?80:140, 30);
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
    
    
    self.aaChartView = [[AAChartView alloc]init];
    self.aaChartView.frame = CGRectMake(0, 30, kScreenWidth, 280-30);
//    self.aaChartView.delegate = self;
    //    self.aaChartView.scrollEnabled = NO;//禁用 AAChartView 滚动效果
    //    设置aaChartVie 的内容高度(content height)
    self.aaChartView.contentHeight = 280-30;
    //    设置aaChartVie 的内容宽度(content  width)
    self.aaChartView.contentWidth = kScreenWidth;
    [self addSubview:self.aaChartView];

}
- (void)AAChartViewDidFinishLoad{
    
    
}


-(void)setData:(NSDictionary *)data{
    _data = data;
    [self configData];
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
    
    
    [self configData];
}


-(void)configData{
    
    kWeakS(weakSelf);
    if(![_data[@"graph_new"] isNotEmpty]){
        return;
    }
    NSMutableArray *array  = [NSMutableArray arrayWithArray:_data[@"graph_new"]];
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = obj1;
        NSDictionary *dic2 = obj2;
        NSArray * sub1 = dic1[@"list"];
         NSArray * sub2 = dic2[@"list"];
        
        if ([weakSelf.selectArray containsObject:@"数量"]){
            
            return [[sub1 valueForKeyPath:@"@sum.num"] floatValue] > [[sub2 valueForKeyPath:@"@sum.num"] floatValue];
//            [valueArray addObject:subDic[@"num"]];
            
        }else if ([weakSelf.selectArray containsObject:@"合同额"]){
            return [[sub1 valueForKeyPath:@"@sum.amount"] floatValue] > [[sub2 valueForKeyPath:@"@sum.amount"] floatValue];
//            [valueArray addObject:subDic[@"amount"]];
        }else{
//            [valueArray addObject:subDic[@"down_payment"]];
            return [[sub1 valueForKeyPath:@"@sum.down_payment"] floatValue] > [[sub2 valueForKeyPath:@"@sum.down_payment"] floatValue];
        }
        
        
    }];
    
    
    NSMutableArray *fArray = [NSMutableArray array];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        if ([dic[@"ranking_realname"] isNotEmpty]) {
            [nameArray addObject:[NSString stringWithFormat:@"%@",dic[@"ranking_realname"]]];
        }else{
            [nameArray addObject:@"*"];
        }
        
        NSArray *subArray = dic[@"list"];
        for (int i = 0; i< [subArray count]; i++)
        {
            NSDictionary *subDic = subArray[i];
            if (fArray.count != subArray.count) {
                NSMutableArray *valueArray = [NSMutableArray array];
                
                if ([_selectArray containsObject:@"数量"]){
                    [valueArray addObject:subDic[@"num"]];
                    
                }else if ([_selectArray containsObject:@"合同额"]){
                    [valueArray addObject:subDic[@"amount"]];
                }else{
                    [valueArray addObject:subDic[@"down_payment"]];
                }
                [fArray addObject:valueArray];
            }else{
                if ([_selectArray containsObject:@"数量"]){
                    [fArray[i] addObject:subDic[@"num"]];
                }else if ([_selectArray containsObject:@"合同额"]){
                    [fArray[i] addObject:subDic[@"amount"]];
                }else{
                    [fArray[i] addObject:subDic[@"down_payment"]];
                }
            }
            
        }
    }
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    
    for (int i = 0;i<fArray.count ;i++) {
        NSArray *sarray = fArray[i];
        NSDictionary *sDic = array.firstObject[@"list"][i];
        AASeriesElement *model = [[AASeriesElement alloc] init];
        model.dataSet(sarray);
        model.nameSet(sDic[@"name"]);
        [modelArray addObject:model];
    }
    [self refresh:modelArray name:nameArray];
}



-(void)refresh:(NSArray *)array name:(NSArray *)name{
    
    self.aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeBar)//图表类型
    .titleSet(@"")//图表主标题
    .subtitleSet(@"")//图表副标题
    //    .yAxisLineWidthSet(@0)//Y轴轴线线宽为0即是隐藏Y轴轴线
    .colorsThemeSet(@[@"#4bc2e3",@"#edce6f",@"#4b84e3",])//设置主体颜色数组
    .yAxisTitleSet(@"")//设置 Y 轴标题
    //    .tooltipValueSuffixSet(@"℃")//设置浮动提示框单位后缀
    .backgroundColorSet(@"#ffffff")
    .yAxisGridLineWidthSet(@0)//y轴横向分割线宽度为0(即是隐藏分割线)
    .seriesSet(array);
//    .seriesSet(@[
//                 AAObject(AASeriesElement)
//                 .nameSet(@"2017")
//                 .dataSet(@[@7.0, @6.9, @9.5, @14.5, @18.2, @21.5, @25.2, @26.5, @23.3, @18.3, @13.9, @9.6]),
//                 AAObject(AASeriesElement)
//                 .nameSet(@"2018")
//                 .dataSet(@[@0.2, @0.8, @5.7, @11.3, @17.0, @22.0, @24.8, @24.1, @20.1, @14.1, @8.6, @2.5]),
//                 AAObject(AASeriesElement)
//                 .nameSet(@"2019")
//                 .dataSet(@[@0.9, @0.6, @3.5, @8.4, @13.5, @17.0, @18.6, @17.9, @14.3, @9.0, @3.9, @1.0]),
//                 AAObject(AASeriesElement)
//                 .nameSet(@"2020")
//                 .dataSet(@[@3.9, @4.2, @5.7, @8.5, @11.9, @15.2, @17.0, @16.6, @14.2, @10.3, @6.6, @4.8]),
//                 ]
//               );
    _aaChartModel.stacking = AAChartStackingTypeNormal;
    self.aaChartModel.categories = name;
    [self.aaChartView aa_drawChartWithChartModel:_aaChartModel];
    
    
}


@end
