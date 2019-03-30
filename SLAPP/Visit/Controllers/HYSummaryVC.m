//
//  HYSummaryVC.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitAnalyseVC.h"
#import "HYAddVisitVC.h"
#import "HYVisitModel.h"

#import "UIImage+Category.h"
#import "HYSummaryVC.h"
#import "CardView.h"
#import "CLVisitSimpleSummary.h"
#import "HYVisitEvaluationDelegate.h"
#import "EffectSummaryCell.h"
#import "HYEvaluationBottomView.h"

#import "HYEvaluationTopView.h"
#import "NSString+AttributedString.h"
#import "HYLookVisitEvaluationDelegate.h"
#import "HYSelectEvaluationModel.h"
#import "VisitBaseInfoFooterView.h"
#import "UITableView+Category.h"
#import <YBPopupMenu/YBPopupMenu.h>
#import "HYVisitReportVC.h"
#import "HYReservationVC.h"
@interface HYSummaryVC ()<YBPopupMenuDelegate>
@property(nonatomic,strong)CardView *cardView;
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)CLVisitSimpleSummary *summaryView;
@property(nonatomic,strong)UITableView *evaluationView;


@property(nonatomic,strong)HYEvaluationBottomView *evaluationBottomView;
@property(nonatomic,strong)HYEvaluationTopView *evaluationTopView;
@property(nonatomic,strong)HYVisitEvaluationDelegate * getEvauationDelegate;


@property(nonatomic,strong)HYLookVisitEvaluationDelegate * selectEvauationDelegate;

@property(nonatomic,strong)VisitBaseInfoFooterView *evaluationLookHeader;
@property(nonatomic,strong)UISegmentedControl *mySegment;
@end

@implementation HYSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"总结评估";
//    [self configUI];
//    [self getVisitSummaryData];
//    [self getVisitEvaluationData];
//    [self congigGetEvaluation];
    
//    [self getEvaluationSelect];
//    [self congigSelectEvaluation];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reSetAll];
}


- (void)congigGetEvaluation{
    
    kWeakS(weakSelf);
    _getEvauationDelegate = [[HYVisitEvaluationDelegate alloc] initWithCellIde:@"EffectSummaryCell" AndAutoCellHeight:70 modelKey:@"model" AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, HYEvaluationOptionModel * model)
    {
        #pragma mark- 📚 *********** cell点击响应 **************
        [weakSelf.getEvauationDelegate configSelectItemId:model.itemid];
        [tableView reloadData];
        [tableView layoutIfNeeded];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
            
            [weakSelf.getEvauationDelegate currentIndexWithIsAdd:true];
            [weakSelf getEvaluationRefresh];
            if (weakSelf.getEvauationDelegate.isLast) {
                [weakSelf.evaluationBottomView.rightBtn setTitle:@"提交试卷" forState:UIControlStateNormal];
            }
            if (weakSelf.getEvauationDelegate.currentIndex != 0) {
                weakSelf.evaluationBottomView.leftBtn.backgroundColor = kgreenColor;
                weakSelf.evaluationBottomView.leftBtn.enabled = YES;
            }
            
            [weakSelf configCurrentTop];
            
            
            
        });
        
       
        
        
        
    }];
    
    _getEvauationDelegate.configCell = ^(EffectSummaryCell *cell, NSIndexPath *index) {
        #pragma mark- 📚 *********** 对cell 做设置 **************
        cell.ismark = [cell.model.itemid isEqualToString:[weakSelf.getEvauationDelegate currentItemId]];
        cell.index = (int)index.row;
    };
    _evaluationView.delegate = _getEvauationDelegate;
    _evaluationView.dataSource = _getEvauationDelegate;
    
    
    #pragma mark- 📚 *********** 添加顶端视图 **************
    _evaluationTopView = [[HYEvaluationTopView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 60)];
    UIView *topBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    [topBack addSubview:_evaluationTopView];
    topBack.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _evaluationView.tableHeaderView = topBack;
    
    #pragma mark- 📚 *********** 添加底端视图 **************
    _evaluationBottomView = [[HYEvaluationBottomView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    [self.backScrollView addSubview:_evaluationBottomView];
    [_evaluationBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(0);
    }];
    
    
    _evaluationBottomView.btnClick = ^(NSInteger tag) {
        #pragma mark- 📚 *********** 底端按钮点击 上一步  下一步 **************
        if (tag == 0)
        {
//            上一步
            [weakSelf.evaluationBottomView.rightBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [weakSelf.getEvauationDelegate currentIndexWithIsAdd:NO];
            [weakSelf getEvaluationRefresh];
            if (weakSelf.getEvauationDelegate.currentIndex == 0) {
                weakSelf.evaluationBottomView.leftBtn.backgroundColor = [UIColor grayColor];
                weakSelf.evaluationBottomView.leftBtn.enabled = NO;
            }
        }else{
            

            if (weakSelf.getEvauationDelegate.isLast)
            {
//                提交试卷
                [weakSelf sendEvaluation];
            }else{
                //            下一步
                [weakSelf.getEvauationDelegate currentIndexWithIsAdd:YES];
                [weakSelf getEvaluationRefresh];
                if (weakSelf.getEvauationDelegate.currentIndex != 0) {
                    weakSelf.evaluationBottomView.leftBtn.backgroundColor = kgreenColor;
                    weakSelf.evaluationBottomView.leftBtn.enabled = YES;
                }
                
                if (weakSelf.getEvauationDelegate.isLast){
                    [weakSelf.evaluationBottomView.rightBtn setTitle:@"提交试卷" forState:UIControlStateNormal];
                }
                
            }
            
        }
        
         [weakSelf configCurrentTop];
    };
}



/**
 获取拜访总结内容
 */
-(void)getVisitSummaryData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visit_id"] = _visit_id;
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kGetVisitSummary Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        HYGetVisitSummaryModel *model = [HYGetVisitSummaryModel mj_objectWithKeyValues:result];
        weakSelf.summaryView.summaryModel = model;
        [weakSelf addRightBtn];
        [weakSelf configEditWithStatus:model.status];
        [weakSelf chooseLoadEvaluationData];
        
    } fail:^(NSDictionary *result) {
        
        [weakSelf dissmissWithError];
    }];
    
}






/**
 评估topView
 */
-(void)configCurrentTop{
    
    if (self.getEvauationDelegate.type == effect)
    {
        HYEvaluationSubModel * model = self.getEvauationDelegate.evaluationModel.effect[self.getEvauationDelegate.currentIndex];
        _evaluationTopView.content.text = [model.classname toString];
        _evaluationTopView.typetitle.text = @"效果评估";
        NSString *currentNum = [NSString stringWithFormat:@"%ld",self.getEvauationDelegate.currentIndex+1];
        NSString *num = [NSString stringWithFormat:@"（%@/%ld）",currentNum,self.getEvauationDelegate.evaluationModel.effect.count];
        
        
        _evaluationTopView.num.attributedText = [NSString configAttributedStrAll:num subStr:currentNum allColor:[UIColor darkTextColor] subColor:kOrangeColor font:kFont(14) lineSpace:0];
    }else{
        
        
        HYEvaluationSubModel * model = self.getEvauationDelegate.evaluationModel.trust[self.getEvauationDelegate.currentIndex];
        _evaluationTopView.content.text = [model.classname toString];
        _evaluationTopView.typetitle.text = @"信任评估";
        NSString *currentNum = [NSString stringWithFormat:@"%ld",self.getEvauationDelegate.currentIndex+1];
        NSString *num = [NSString stringWithFormat:@"（%@/%ld）",currentNum,self.getEvauationDelegate.evaluationModel.trust.count];
        
        
        _evaluationTopView.num.attributedText = [NSString configAttributedStrAll:num subStr:currentNum allColor:[UIColor darkTextColor] subColor:kOrangeColor font:kFont(14) lineSpace:0];
    }
   
    
    
}



/**
 获取试题
 */
-(void)getEvaluationRefresh{
    
    NSInteger current = self.getEvauationDelegate.currentIndex;
    if (self.getEvauationDelegate.type == effect) {
        HYEvaluationSubModel *subModel = self.getEvauationDelegate.evaluationModel.effect[current];
        
        [self.getEvauationDelegate.dataArray removeAllObjects];
        [self.getEvauationDelegate.dataArray addObjectsFromArray:subModel.rows];
    }else{
        HYEvaluationSubModel *subModel = self.getEvauationDelegate.evaluationModel.trust[current];
        
        [self.getEvauationDelegate.dataArray removeAllObjects];
        [self.getEvauationDelegate.dataArray addObjectsFromArray:subModel.rows];
        
    }
   
    [self.evaluationView reloadData];
    [self configCurrentTop];
    
}



/**
 获取答题记录
 */
-(void)selectEvaluationRefresh{

    [self.selectEvauationDelegate.dataArray removeAllObjects];
    if (_mySegment.selectedSegmentIndex == 0) {
        self.selectEvauationDelegate.type = effect;
        [self.selectEvauationDelegate.dataArray addObjectsFromArray:self.selectEvauationDelegate.selectEvaModel.effect];
    }else{
        self.selectEvauationDelegate.type = trust;
        [self.selectEvauationDelegate.dataArray addObjectsFromArray:self.selectEvauationDelegate.selectEvaModel.trust];
    }
    [self.evaluationView reloadData];
}


#pragma mark- 📚 *********** 获取拜访评估题库 **************
/**
 获取拜访评估题库
 */
-(void)getVisitEvaluationData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visit_id"] = _visit_id;
    [self showDismiss];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kGetEvaluation Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
    HYGetEvaluationModel * model = [HYGetEvaluationModel mj_objectWithKeyValues:result];
         weakSelf.getEvauationDelegate.evaluationModel = model;
        [weakSelf getEvaluationRefresh];
//        weakSelf.summaryView.summaryModel = model;
        
        DLog(@"%@",result);
        
        [weakSelf dismissProgress];
        
    } fail:^(NSDictionary *result) {
        
        [weakSelf dissmissWithError];
    }];
    
}

#pragma mark- 📚 *********** 提交问卷 **************
-(void)sendEvaluation{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[self.getEvauationDelegate configParams]];
    params[@"visit_id"] = self.visit_id;
    
    DLog(@"%@",params);
    kWeakS(weakSelf);
    
    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:kAddEvaluate Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        DLog(@"%@",result);
        [weakSelf dismissProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (weakSelf.getEvauationDelegate.type == trust) {
//                [weakSelf reSetAll];
//                信任评估提交完成
                //判断是否要更新拜访分析
                [weakSelf visitAnalyse];
                
            }else{
                weakSelf.getEvauationDelegate.currentIndex = 0;
                weakSelf.getEvauationDelegate.type = trust;
                [weakSelf getEvaluationRefresh];
                [weakSelf.evaluationBottomView reSet];
            }
            
        });
       
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}



-(void)reSetAll{
    
    if (_backScrollView) {
         [_backScrollView removeFromSuperview];
        _backScrollView = nil;
    }
   
    if (_cardView) {
         [_cardView removeFromSuperview];
        _cardView = nil;
    }
   
    if (_summaryView) {
        [_summaryView removeFromSuperview];
        _summaryView = nil;
    }
    
    if (_evaluationView) {
        [_evaluationView removeFromSuperview];
        _evaluationView = nil;
    }
    
    [self configUI];
    [self getVisitSummaryData];
}



#pragma mark- 📚 *********** 获取答题记录 **************
/**
 获取答题记录
 */
- (void)getEvaluationSelect{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visitid"] = self.visit_id;
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kGetEvaluationSelect Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        DLog(@"%@",result);
        [weakSelf dismissProgress];
        if ([result isNotEmpty]) {
             HYSelectEvaluationModel *model = [HYSelectEvaluationModel mj_objectWithKeyValues:result];
            weakSelf.selectEvauationDelegate.selectEvaModel = model;
            weakSelf.evaluationLookHeader.selectEvaModel = model;
            [weakSelf selectEvaluationRefresh];
        }
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}

- (void)congigSelectEvaluation{

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    _evaluationLookHeader = [[VisitBaseInfoFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [header addSubview:_evaluationLookHeader];
    header.backgroundColor = HexColor(@"EFF0F1");
    
    UISegmentedControl *segMent = [[UISegmentedControl alloc] initWithItems:@[@"效果评估",@"信任评估"]];
    segMent.tintColor = [UIColor lightGrayColor];
    segMent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    segMent.layer.borderWidth = 0.5;
    [segMent setBackgroundImage:[UIImage createImageWithColor:kgreenColor] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [segMent setBackgroundImage:[UIImage createImageWithColor:HexColor(@"EFF0F1")] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segMent setTitleTextAttributes:@{NSForegroundColorAttributeName:HexColor(@"EFF0F1")} forState:UIControlStateSelected];
    [segMent setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    segMent.selectedSegmentIndex = 0;
    segMent.frame = CGRectMake(10,210, kScreenWidth-20, 40);
    [header addSubview:segMent];
    
    [segMent addTarget:self action:@selector(segMentClick:) forControlEvents:UIControlEventValueChanged];
    _mySegment = segMent;
    _evaluationView.tableHeaderView = header;
    
    _selectEvauationDelegate = [[HYLookVisitEvaluationDelegate alloc] init];
   
    
    _evaluationView.delegate = _selectEvauationDelegate;
    _evaluationView.dataSource = _selectEvauationDelegate;
    

}



- (void)segMentClick:(UISegmentedControl *)segment{
    [self selectEvaluationRefresh];
}


-(void)configUI{
    
    _cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    [self.view addSubview:_cardView];
    [_cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    
    _cardView.backgroundColor = [UIColor clearColor];
    _cardView.titleNormalColor = [UIColor darkTextColor];
    _cardView.titleSelectColor = kgreenColor;
    
    kWeakS(weakSelf);
    _cardView.btnClickBlock = ^BOOL(NSInteger btnTag) {
        [weakSelf.summaryView endEditing:YES];
        if (btnTag == 10) {
            [weakSelf.backScrollView setContentOffset:CGPointMake(0, 0)];
        }else{
            [weakSelf.backScrollView setContentOffset:CGPointMake(kScreenWidth, 0)];
        }
        
        
        return false;
    };
    [_cardView creatBtnsWithTitles:@[@"拜访总结",@"拜访评估"]];
    
    _backScrollView = [UIScrollView new];
    [self.view addSubview:_backScrollView];
    _backScrollView.scrollEnabled = NO;
    [_backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.cardView.mas_bottom).offset(1);
        make.bottom.mas_equalTo(kNav_height-49);
        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(kMain_screen_height_px-kNav_height-42-1);
        make.width.mas_equalTo(kScreenWidth*2);
    }];
    
    _backScrollView.backgroundColor = [UIColor redColor];
    
    _summaryView = [CLVisitSimpleSummary new];
    [_backScrollView addSubview:_summaryView];
    
    _summaryView.visitId = _visit_id;
    
    [_summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(weakSelf.backScrollView);
        make.height.mas_equalTo(kMain_screen_height_px-kNav_height-42-1);
    }];
    
    
    
    
    
    #pragma mark- 📚 ***********拜访评估 界面block的一些响应处理  **************
    _summaryView.saveFinish = ^{
//      保存成功后的处理
        [weakSelf.cardView configSelectWith:11];
    };
    
    
    _summaryView.sendFinish = ^{
//       发送拜访总结
        HYReservationVC *vc = [[HYReservationVC alloc] init];
        vc.visitId = weakSelf.visit_id;
        vc.isReservation = NO;
        [self.navigationController pushViewController:vc animated:true];
    };
    
    _summaryView.myCopyFinish = ^(NSString *visitId) {
//       新建拜访
    [weakSelf toAddVisitWithId:visitId];
    };
    
//    ReservationVC * vc = [ReservationVC ];
    
    
    
    
    
    _evaluationView = [UITableView new];
    _evaluationView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_backScrollView addSubview:_evaluationView];
    [_evaluationView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(weakSelf.summaryView.mas_right).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.right.equalTo(weakSelf.backScrollView);
        make.height.mas_equalTo(kMain_screen_height_px-kNav_height-42-1);
    }];
    
    
    [_evaluationView addEmptyViewAndClickTitle:@"数据加载失败" imageName:@"noDataRemind" detail:@"" btnTitle:@"点击重新加载" Refresh:^{
        [weakSelf reLoadData];
    }];
    
}


/**
 重新请求数据
 */
-(void)reLoadData{
    
    if (self.summaryView.summaryModel == nil) {
        [self getVisitSummaryData];
    }else{
        [self chooseLoadEvaluationData];
    }
    
}



/**
 选择加载评估数据
 */
- (void)chooseLoadEvaluationData{
    
    if ([[self.summaryView.summaryModel.status toString] intValue] == 1) {
        //完成状态
        [self congigSelectEvaluation];
        [self getEvaluationSelect];
    }
    else{
        [self congigGetEvaluation];
        [self getVisitEvaluationData];
    }
}




/**
 调整拜访准备是否可编辑

 @param status <#status description#>
 */
-(void)configEditWithStatus:(NSString *)status{
    
    [self.summaryView isfinish:status];
}



/**
 新建拜访

 @param visitId 当前拜访的id
 */
-(void)toAddVisitWithId:(NSString *)visitId{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.visit_id;
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kGetVisitBase Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        HYVisitModel * vModel = [[HYVisitModel alloc] init];
        vModel.editVisitResult = result;
        HYAddVisitVC *vc = [[HYAddVisitVC alloc] init];
        
//      注意  这里的新建是为了将现在的拜访  做下一次拜访准备   拜访中涉及到的信息相同  所以请求了当前拜访的信息   但是拜访id应该制空 才能是新建  否则就是本次的修改
        vModel.id = nil;
        
        
        vc.visitModel = vModel;
        [weakSelf.navigationController pushViewController:vc animated:true];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
}




#pragma mark- 📚 *********** 权限 **************

- (void)addRightBtn{
    if (!self.summaryView.summaryModel) {
        return;
    }
    
    if ([self.summaryView.summaryModel.rightTitles isNotEmpty]) {
        [self setRightBtnsWithImages:@[@"promore"]];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
        
    }
}


- (void)rightClick:(UIButton *)btn{
    if ([self.summaryView.summaryModel.rightTitles isNotEmpty]) {
        [YBPopupMenu showRelyOnView:btn titles:self.summaryView.summaryModel.rightTitles icons:nil menuWidth:120 delegate:self];
    }
}





- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if ([self.summaryView.summaryModel.rightTitles isNotEmpty]) {
        NSString *str = self.summaryView.summaryModel.rightTitles[index];
//        if ([str isEqualToString:@"完成"]) {
//            //            跳转到拜访总结
//            HYSummaryVC *vc = [[HYSummaryVC alloc] init];
//            vc.visit_id = _visit_id;
//            [self.navigationController pushViewController:vc animated:true];
//
//        }else
        if ([str isEqualToString:@"预约"]){
        
            HYReservationVC *vc = [[HYReservationVC alloc] init];
            vc.visitId = _visit_id;
            vc.isReservation = YES;
            [self.navigationController pushViewController:vc animated:true];
            
            
            
            
        }else if ([str isEqualToString:@"删除"]){
             kWeakS(weakSelf);
            [self addAlertViewWithTitle:@"温馨提示" message:@"您确定删除该拜访？" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction *action) {
                [weakSelf toDeleteVisit];
            } cancleAction:^(UIAlertAction *action) {
                
            }];
            
            
        }else if ([str isEqualToString:@"发送总结"]){
            HYReservationVC *vc = [[HYReservationVC alloc] init];
            vc.visitId = _visit_id;
            vc.isReservation = NO;
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"准备报告"]){
            HYVisitReportVC *vc = [[HYVisitReportVC alloc] init];
            vc.visitId = _visit_id;
            vc.type = @"0";
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"总结报告"]){
            HYVisitReportVC * vc = [[HYVisitReportVC alloc] init];
            vc.visitId = _visit_id;
            vc.type = @"1";
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"重新打开"]){
            
//            [self showProgress];
//            kWeakS(weakSelf);
//            [HYBaseRequest getPostWithMethodName:kVisit_reOpen Params:[@{@"visitid":_visit_id} addToken] showToast:true Success:^(NSDictionary *result) {
//                [weakSelf showDismiss];
//                [weakSelf configData];
//                [weakSelf toastWithText:@"打开成功"];
//            } fail:^(NSDictionary *result) {
//                [weakSelf showDismissWithError];
//            }];
//            
            
        }
    }
    
}


/**
 删除拜访
 */
-(void)toDeleteVisit{
    
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName: kVisit_delete Params:[@{@"visitid":_visit_id} addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf showDismiss];
        [weakSelf toastWithText:@"删除成功"];
        [weakSelf.navigationController popViewControllerAnimated:true];
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
}



/**
 拜访报告分析
 每次答题完成后都要调用该接口  通过接口返回的数据   （人员）数组是否空来判断是否跳转（不空就跳转）
 */
-(void)visitAnalyse{
    
    [self showProgress];
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visitid"] = _visit_id;
    [HYBaseRequest getPostWithMethodName:kVisitRoleSituation Params: [params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        if ([result isNotEmpty] && [result[@"contact_info"] isNotEmpty]) {
            HYVisitAnalyseModel *model = [HYVisitAnalyseModel mj_objectWithKeyValues:result];
            HYVisitAnalyseVC *vc = [[HYVisitAnalyseVC alloc] init];
            vc.visitId = weakSelf.visit_id;
            vc.model = model;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else{
            [weakSelf.navigationController popViewControllerAnimated:true];
            
        }
        
        

        
        
        DLog(@"%@",result);
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
