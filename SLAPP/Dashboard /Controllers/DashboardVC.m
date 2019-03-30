//
//  DashboardVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "DashboardVC.h"
#import "StatisticalListView.h"
#import "QFHeader.h"
#import "QFSLFunnelVC.h"
#import "BusinessStatisticsVC.h"
#import "QFRiskAnalysisVC.h"
#import "BottleneckAnalysisVC.h"
#import "SLAPP-Swift.h"
@interface DashboardVC ()

@property (nonatomic,strong) StatisticalListView  *statisticalView;

@end

@implementation DashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self UIConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面
- (void)UIConfig{
    
    self.title = @"仪表盘";
    
    __weak DashboardVC *weakSelf = self;
    
    self.statisticalView = [[StatisticalListView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.statisticalView.statisticalBlock = ^(NSInteger index) {
        switch (index) {
            case 0:{//销售漏斗
                QFSLFunnelVC *funnelVC = [[QFSLFunnelVC alloc] init];
                funnelVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:funnelVC animated:YES];
            }break;
            case 1:{//商机统计
                BusinessStatisticsVC *statisticsVC = [[BusinessStatisticsVC alloc] init];
                statisticsVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:statisticsVC animated:YES];
            }break;
            case 2:{//风险分析
                QFRiskAnalysisVC *riskAnalysisVC = [[QFRiskAnalysisVC alloc] init];
                riskAnalysisVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:riskAnalysisVC animated:YES];
            }break;
            case 3:{//瓶颈分析
                BottleneckAnalysisVC *bottleneckAnalysisVC = [[BottleneckAnalysisVC alloc] init];
            bottleneckAnalysisVC.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:bottleneckAnalysisVC animated:YES];
            }break;
            case 4:{
                ToViewOtherPerformanceVC *vc = [[ToViewOtherPerformanceVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }break;
            default:
                break;
        }
        
    };
    [self.view addSubview:self.statisticalView];
    
}
@end
