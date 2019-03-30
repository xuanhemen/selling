//
//  HYVisitHomeVC.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "HYFitterView.h"
#import <MJExtension/MJExtension.h>
#import "HYVisitFitterModel.h"
#import <Masonry/Masonry.h>
#import "HYVisitHomeVC.h"
#import "HYVisitHomeDelegate.h"
#import "HYAddVisitVC.h"
#import "HYVisitDetailVC.h"
#import "CardView.h"
#import <JTCalendar/JTCalendar.h>
#import "VisitCaledarView.h"
#import "HYVisitHomeCell.h"
#import "HYBaseRequest.h"
#import "HYVisitModel.h"
#import "HYLookatVisitVC.h"
#import "HYSummaryVC.h"
#import "HYReservationVC.h"
#import <MJRefresh/MJRefresh.h>
#import "UITableView+Category.h"
#import "HYVisitNumView.h"
#import "HYVisitFitterModel.h"
#define kVisitCountView_Height  45.0
#define kCalendarMenuViewHeight 35.0
#define kCalendarContentViewHeightShort 85.0

@interface HYVisitHomeVC ()<HYFitterViewDelegate>
@property(nonatomic,strong)HYVisitHomeDelegate *delegate;
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)CardView *cardView;
@property(nonatomic,strong)VisitCaledarView *visitCaledarView;
@property(nonatomic,strong)HYVisitNumView *visitCountView;
@property(nonatomic,strong)HYFitterView *fitterView;
@property(nonatomic,strong)NSArray *fitterArray;



@end

@implementation HYVisitHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];

    if (_isHome) {
        [self.cardView configSelectWith:13];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.fitterView) {
        [self.fitterView removeFromSuperview];
        self.fitterView = nil;
    }
    [self configData];
}


-(void)configSX{
    
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kQueryConditon Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        NSMutableArray *data = [NSMutableArray array];
        if ([result[@"data"] isNotEmpty]) {
            data = [HYVisitFitterModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
        }
        [weakSelf dismissProgress];
        weakSelf.fitterView.allData = data;
        
        if ([weakSelf.fitterArray isNotEmpty]) {
//            将上一次选择的还原
            [weakSelf.fitterView configAlready:weakSelf.fitterArray];
        }
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        
    }];
    
    
    
}

-(void)configData{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showProgress];
    
    if ([self.visitCaledarView.timeMethod.selectBetween isNotEmpty]) {
        
        params[@"datevals"] = self.visitCaledarView.timeMethod.selectBetween.firstObject;
        params[@"datevale"] = self.visitCaledarView.timeMethod.selectBetween.lastObject;
        
    }else{
        if (!_isHome) {
            NSDate *date = [[NSDate alloc] init];
            NSInteger startTimer = [self getZeroWithTimeInterverl:date.timeIntervalSince1970];
            params[@"datevals"] = @(startTimer);
            params[@"datevale"] = @(startTimer+60*60*24-1);
        }else{
            //0 表示全部  首页进来默认选中全部
            params[@"datevals"] = @(0);
            params[@"datevale"] = @(0);
        }
        
    }
    
    if ([[self configFitterParams] isNotEmpty]) {
        params[@"searchkeyval"] = [self configFitterParams];
    }
    
    NSString * urlStr = @"";
    if (_isHome) {
        
         params[@"ids"] = _visitIds;
        urlStr = kGetIdsList;
    }else{
        urlStr = kVisit_list;
    }
    
    [HYBaseRequest getPostWithMethodName:urlStr Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf.delegate.dataArray removeAllObjects];
        if ([result[@"list"] isNotEmpty]) {
            [weakSelf.delegate.dataArray addObjectsFromArray:[HYVisitModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
        }
        DLog(@"%@",result);
        [weakSelf.visitCountView refreshWithResult:result];
        [weakSelf.table reloadData];
        [weakSelf dismissProgress];
        [weakSelf.table.mj_header endRefreshing];
    } fail:^(NSDictionary *result) {
        
         [weakSelf.visitCountView refreshWithResult:[NSDictionary new]];
        [weakSelf.table.mj_header endRefreshing];
        [weakSelf showDismissWithError];
    }];
}


-(void)configUI{
//    self.title = @"拜访列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTopViews];
    [self setRightBtnsWithImages:@[@"nav_add",@"nav_filter"]];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_table];
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kCalendarContentViewHeightShort + kCalendarMenuViewHeight + kVisitCountView_Height + 10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kNav_height+49);
    } ];
    UIView *nilview = [[UIView alloc] init];
    _table.tableFooterView = nilview;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[HYVisitHomeCell class] forCellReuseIdentifier:@"HYVisitHomeCell"];
    
    _delegate = [[HYVisitHomeDelegate alloc] initWithCellIde:@"HYVisitHomeCell" AndAutoCellHeight:0 modelKey:nil AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, HYVisitModel * model) {
        HYVisitDetailVC *vc = [[HYVisitDetailVC alloc] init];
        vc.visit_id = model.id;
        [weakSelf.navigationController pushViewController:vc animated:true];
    }];
    
    _delegate.configCell = ^(HYVisitHomeCell *cell ,NSIndexPath *index) {
        
        cell.bottomClickWithKey = ^(NSString *key, HYVisitModel *model) {
            
            if ([key isEqualToString:@"查看"]) {
                
                HYLookatVisitVC *vc = [[HYLookatVisitVC alloc] init];
                vc.visit_id = model.id;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }else if ([key isEqualToString:@"总结"]){
                
                
                HYSummaryVC *vc = [[HYSummaryVC alloc] init];
                vc.visit_id = model.id;
                [weakSelf.navigationController pushViewController:vc animated:true];
                
            }else if ([key isEqualToString:@"预约"]){
                HYReservationVC *vc = [[HYReservationVC alloc] init];
                vc.isReservation = true;
                vc.visitId = model.id;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }else if ([key isEqualToString:@"准备"]){
                
                HYVisitDetailVC *vc = [[HYVisitDetailVC alloc] init];
                vc.visit_id = model.id;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }
            
            
        };
        
    };
    
//     _delegate.dataArray = @[@"",@"",@"",@""];
    _table.delegate = _delegate;
    _table.dataSource = _delegate;
    [_table reloadData];
    
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
    
    [_table addEmptyViewAndClickRefresh:^{
        [weakSelf configData];
    }];
}






-(void)addTopViews{
    
    
    _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, 200, 42)];
    _cardView.backgroundColor = [UIColor clearColor];
    _cardView.titleNormalColor = [UIColor whiteColor];
    _cardView.titleSelectColor = kgreenColor;
    
    kWeakS(weakSelf);
    _cardView.btnClickBlock = ^BOOL(NSInteger btnTag) {
        [weakSelf configCardClickWithTah:btnTag];
        return false;
    };
    
    
    
    [_cardView creatBtnsWithTitles:@[@"按日",@"按周",@"按月",@"全部"]];
  
    
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc] initWithCustomView:_cardView];
    self.navigationItem.leftBarButtonItems = @[left1,left2];
    
    
    
    [self addCaledarView];
    
    _visitCountView = [[HYVisitNumView alloc]initWithFrame:CGRectMake(0, kCalendarContentViewHeightShort + kCalendarMenuViewHeight, kScreenWidth, kVisitCountView_Height)];
    _visitCountView.isVisitHome = YES;
    [self.view addSubview:_visitCountView];
    
}


- (double)getZeroWithTimeInterverl:(NSTimeInterval) timeInterval
{
    NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
    dateFomater.dateFormat = @"yyyy年MM月dd日";
    NSString *original = [dateFomater stringFromDate:originalDate];
    NSDate *ZeroDate = [dateFomater dateFromString:original];
    return [ZeroDate timeIntervalSince1970];
}



-(void)configCardClickWithTah:(NSInteger)btnTag{
    
    self.visitCaledarView.hidden = false;
    if (btnTag != 13) {
        [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(kCalendarContentViewHeightShort + kCalendarMenuViewHeight + kVisitCountView_Height + 10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            
        }];
        
         self.visitCountView.frame = CGRectMake(0, kCalendarContentViewHeightShort + kCalendarMenuViewHeight, kScreenWidth, kVisitCountView_Height);
       
    }
    
    
    NSDate *date = [NSDate date];
    switch (btnTag) {
        case 10:
        {
            
//            NSInteger startTimer = date.timeIntervalSince1970 - 60 * 60 * 8;
           
            NSInteger startTimer = [self getZeroWithTimeInterverl:date.timeIntervalSince1970];
            
            self.visitCaledarView.timeMethod.selectBetween = @[@(startTimer),@(startTimer+60*60*24-1)];
            self.visitCaledarView.visitMoth.hidden = true;
            self.visitCaledarView.visitWeek.hidden = true;
            
            //切换日期筛选条件是需要还原日历选择状态
            [self.visitCaledarView clickCurrentDateWithSender:self.visitCaledarView.vwDateDay.btnCurrentDate];
            
              break;
       
        }
            
        case 11:
            
        {
            [self.visitCaledarView.timeMethod reSetWithDate:date];
            
            self.visitCaledarView.visitMoth.hidden = true;
            self.visitCaledarView.visitWeek.hidden = false;
            [self.visitCaledarView.timeMethod reSetWithDate:date];
            self.visitCaledarView.timeMethod.selectBetween = @[@(self.visitCaledarView.timeMethod.firstDayTimeOfWeek),@(self.visitCaledarView.timeMethod.endDayTimeOfWeek)];
            [self.visitCaledarView clickCurrentDateWithSender:self.visitCaledarView.vwDateWeek.btnCurrentDate];
            
            break;
            
        }
            
            
        case 12:
            
        {
            [self.visitCaledarView.timeMethod reSetWithDate:date];
        
            self.visitCaledarView.timeMethod.selectBetween = @[@(self.visitCaledarView.timeMethod.firstDayTimeOfMonth),@(self.visitCaledarView.timeMethod.endDayTimeOfMonth)];
            
            self.visitCaledarView.visitMoth.hidden = false;
            self.visitCaledarView.visitWeek.hidden = true;
            [self.visitCaledarView clickCurrentDateWithSender:self.visitCaledarView.vwDateWeek.btnCurrentDate];
            
            break;
            
        }
            
        case 13:
            
        {
//            NSDate *date = [NSDate date];
            self.visitCaledarView.timeMethod.selectBetween = @[@(0),@(0)];
            self.visitCaledarView.hidden = true;
            self.visitCountView.frame = CGRectMake(0, 0, kScreenWidth, kVisitCountView_Height);
            [self.table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(kVisitCountView_Height + 10);
            }];
            
            break;
            
        }
            
        default:
            break;
    }
    
    
}



-(void)addCaledarView{
    kWeakS(weakSelf);
    self.visitCaledarView = [[VisitCaledarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCalendarContentViewHeightShort + kCalendarMenuViewHeight)];
    [self.view addSubview:self.visitCaledarView];
    self.visitCaledarView.visitMoth.hidden = true;
    self.visitCaledarView.visitWeek.hidden = true;
    [[self.visitCaledarView.timeMethod  rac_valuesForKeyPath:@"selectBetween" observer:self] subscribeNext:^(NSArray *  _Nullable x) {
        DLog(@"时间变了-----------------%@",x);
        
        [weakSelf configData];
    }];
}





-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:true];
    
}




- (void)rightClick:(UIButton *)btn{
    
    if (btn.tag == 1000) {
     HYAddVisitVC *vc =  [[HYAddVisitVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else{
        if (!self.fitterView) {
            HYFitterView *fitter = [[HYFitterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height)];
            [self.view addSubview:fitter];
            self.fitterView = fitter;
            self.fitterView.delegate = self;
            [self configSX];
        }
    }
}




#pragma mark- 📚 ***********HYFitterViewDelegate  **************
- (void)fitter:(HYFitterView *)fitter AndResultArray:(NSArray *)result isCancel:(BOOL)isCancel{
    
    if (isCancel) {
        //取消不做任何操作
        [self.fitterView removeFromSuperview];
        self.fitterView = nil;
    }else{
        self.fitterArray = result;
        [self.fitterView removeFromSuperview];
        self.fitterView = nil;
        
        if ([self.fitterArray isNotEmpty]) {
            [self setRightBtnsWithImages:@[@"nav_add",@"nav_filter_select"]];
        }else{
            [self setRightBtnsWithImages:@[@"nav_add",@"nav_filter"]];
        }
        
        [self configData];
    }
    
}


/**
 把筛选条件转换成  接口参数

 @return 返回处理好的接口参数
 */
-(NSDictionary *)configFitterParams{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if ([self.fitterArray isNotEmpty]) {
        for (id sub in self.fitterArray) {
            if ([sub isKindOfClass:[HYVisitFitterSubModel class]]) {
                HYVisitFitterSubModel *model = (HYVisitFitterSubModel *)sub;
                [params setObject:[model.id toString]forKey:[model.key toString]];
            }
        }
    }
    return params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
