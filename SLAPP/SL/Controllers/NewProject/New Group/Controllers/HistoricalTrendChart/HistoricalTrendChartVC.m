//
//  HistoricalTrendChartVC.m
//  SLAPP
//
//  Created by apple on 2018/8/28.
//  Copyright © 2018年 柴进. All rights reserved.
//
#import <Masonry/Masonry.h>
#import "HistoricalTrendChartVC.h"
#import "HistoricalTrendChartView.h"
#import "HistoricalTrendBubbleView.h"
#import "SLAPP-Swift.h"
@interface HistoricalTrendChartVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *backView;
@property(nonatomic,strong)HistoricalTrendChartView *chartSupport;//支持
@property(nonatomic,strong)HistoricalTrendChartView *chartEngagement; //参与度
@property(nonatomic,strong)HistoricalTrendChartView *chartWin;//赢单
@property(nonatomic,strong)HistoricalTrendBubbleView *bubbleViewFeedback;//反馈态度
@property(nonatomic,strong)HistoricalTrendBubbleView *bubbleViewCoach;//内线

@end

@implementation HistoricalTrendChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史趋势图";
    [self configUI];
    [self configData];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    [tabVC.tab setHidden:YES];
    
}



-(void)configUI{
    
    kWeakS(weakSelf);
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNav_height, kScreenWidth, kMain_screen_height_px-kNav_height)];
    _backView.delegate = self;
    _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    
    
     _chartSupport= [[HistoricalTrendChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    [_backView addSubview:_chartSupport];
    _chartSupport.labTitle.text = @"支持度走势图";
    
    
    _chartEngagement = [[HistoricalTrendChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    [_backView addSubview:_chartEngagement];
    _chartEngagement.labTitle.text = @"参与度走势图";
    
    
   _chartWin = [[HistoricalTrendChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    [_backView addSubview:_chartWin];
    _chartWin.labTitle.text = @"赢单指数走势图";
    
    
    
   _bubbleViewCoach = [[HistoricalTrendBubbleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [_backView addSubview:_bubbleViewCoach];
    _bubbleViewCoach.labTitle.text = @"内线变化图";
    
    _bubbleViewFeedback = [[HistoricalTrendBubbleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [_backView addSubview:_bubbleViewFeedback];
    _bubbleViewFeedback.labTitle.text = @"反馈态度变化图";
    
    
    
    [_chartSupport mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(kScreenWidth-40);
        make.width.equalTo(weakSelf.backView.mas_width).offset(-20);
        make.height.mas_equalTo(300);
    }];
    
    
    
    [_chartEngagement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.chartSupport.mas_bottom).offset(10);
        make.height.mas_equalTo(300);
    }];
    
    
    [_bubbleViewFeedback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.chartEngagement.mas_bottom).offset(10);
        make.height.mas_equalTo(300);
//        make.bottom.equalTo(_backView.mas_bottom);
    }];
    
    
    
    [_bubbleViewCoach mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.bubbleViewFeedback.mas_bottom).offset(10);
        make.height.mas_equalTo(300);
        //        make.bottom.equalTo(_backView.mas_bottom);
    }];
    
    
    [_chartWin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.equalTo(weakSelf.bubbleViewCoach.mas_bottom).offset(10);
        make.height.mas_equalTo(300);
        make.bottom.equalTo(weakSelf.backView.mas_bottom);
    }];
    
    
    
    
//     bubbleView.contentSize = CGSizeMake(0, 0);
    
    
//    [bubbleView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(50*15+50);
//    }];
    
   
}





-(void)configData{
    
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = UserModel.getUserModel;
    params[@"token"] = model.token;
    params[@"project_id"] = self.proId;
    [self showProgress];
    [LoginRequest getPostWithMethodName:p_historical params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
//        DLog(@"%@",a);
        [weakSelf configWithData:a];
    }];
    
    
    
}



-(void)configWithData:(NSDictionary *)dic{
    
    NSArray *titleArray = dic[@"title"];
    float num = titleArray.count;
    
    
//    float cnum = [_dataArray[@"value"] count];
    
    
    [_bubbleViewFeedback mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(num * 50 +100);
    }];
    [_bubbleViewCoach mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(num * 50 +100);
    }];
    
    _chartSupport.titleArray = titleArray;
    _chartEngagement.titleArray = titleArray;
    _chartWin.titleArray = titleArray;
    [_chartSupport setDataArray:dic[@"support"]];
    [_chartEngagement setDataArray:dic[@"engagement"]];
    [_chartWin setDataArray:dic[@"win"]];
    _bubbleViewCoach.titleArray = titleArray;
    _bubbleViewFeedback.titleArray = titleArray;
    
    [_bubbleViewCoach setDataArray:dic[@"coach"]];
    [_bubbleViewFeedback setDataArray:dic[@"feedback"]];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
