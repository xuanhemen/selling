//
//  HYHomeVC.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//
#import "HYVisitHomeVC.h"
#import "HYVisitListVC.h"
#import "HYVisitDetailVC.h"
#import "HYVisitHomeVC.h"
#import "HYHomeVC.h"
#import "HYCommonView.h"
#import "SLAPP-Swift.h"
#import "PublishViewController.h"
#import "HYBaseRequest.h"
#import "NSDictionary+Category.h"
#import "HYHomeModel.h"
#import "UITableView+Category.h"
#import <MJRefresh/MJRefresh.h>
#import "HYProjectAnalysisVC.h"
#import <RongIMLib/RongIMLib.h>
#import "HYHomeClientVC.h"
#import "HYHomeProjectListVC.h"
#import "HYNewProjectVC.h"

@interface HYHomeVC ()
@property(nonatomic,strong)HYHomeModel *model;
@property(nonatomic,strong)HYCommonView *commonView;
@end

@implementation HYHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configUI];
    
    [self addNotification];
    [self isShowCarrayDown];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configData];
    [self refreshNofiNum];
}


/**
 添加通知
 */
-(void)addNotification{
    [self refreshNofiNum];
    kWeakS(weakSelf);
    [[NSNotificationCenter defaultCenter] addObserverForName:@"changeGroupRedCount" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf refreshNofiNum];
        });
    }];
    
    
    
    
}



/**
 刷新小数数提醒
 */
-(void)refreshNofiNum{
    
    NSInteger num = [RCIMClient sharedRCIMClient].getTotalUnreadCount;
    
    [self.commonView.top refreshRedNum:num];
    if (self.tabBarController != nil && [self.tabBarController isKindOfClass:[TabBarController class]]) {
        TabBarController *tab = (TabBarController *)self.tabBarController;
        [tab.tabBar.items[0] showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    }
    
}



- (void)configUI{
    
    //    普通员工界面
    HYCommonView *commonView = [[HYCommonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kNav_height-kTab_height)];
    [self.view addSubview:commonView];
    self.commonView = commonView;
    kWeakS(weakSelf);
    commonView.btnClick = ^(NSInteger tag, NSString *key) {
        //上边按钮点击响应事件
        
        if (tag == 1) {
            //消息
            PrivateListViewController * groupListVc = [[PrivateListViewController alloc] init];
            [weakSelf.navigationController pushViewController:groupListVc animated:true];
        }else if (tag == 0){
            SearchViewController *vc = [[SearchViewController alloc] init];
            vc.from = 0;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if (tag == 2){
            HYProjectAnalysisVC *vc = [[HYProjectAnalysisVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else if (tag == 3){
            //新建
            PublishViewController *vc = [[PublishViewController alloc] init];
            vc.click = ^(NSInteger index) {
                //快速新增响应
                [weakSelf quickAddWith:index];
            };
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:true completion:nil];
        }
        
    };
    
    
    
    commonView .clickCellWithModel = ^(HYHomeContentDetailModel *model) {
        //        cell 查看按钮点击事件
        [weakSelf lookAtWithModel:model];
    };
    
    commonView.clickHeadWithModel = ^(HomeRemindModel *model) {
       
        if ([model.name isEqualToString:@"线索"]) {
            SLMyCluesVC *vc = [[SLMyCluesVC alloc]init];
            vc.pageList = model.list;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([model.name isEqualToString:@"客户"]) {
            NSLog(@"点击了客户");
//            HYHomeClientVC *vc = [[HYHomeClientVC alloc] init];
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.isHomeCome = YES;
//            vc.listString = model.list;
//            [self.navigationController pushViewController:vc animated:YES];
            MyCustomListViewController *vc = [[UIStoryboard storyboardWithName:@"CustomPool" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCustomListViewController"];
            vc.pageList = model.list;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if ([model.name isEqualToString:@"项目"]) {
            NSLog(@"点击了项目");
//            HYHomeProjectListVC *vc = [[HYHomeProjectListVC alloc] init];
//            vc.projectIds = model.list;
//            [self.navigationController pushViewController:vc animated:YES];
            QFProjectViewController *vc = [[QFProjectViewController alloc] init];
            vc.pageList = model.list;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        if ([model.name isEqualToString:@"拜访"]) {
            if ([model.list isNotEmpty]) {
                HYVisitHomeVC *vc = [[HYVisitHomeVC alloc] init];
                vc.visitIds = model.list;
                vc.isHome = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
           
        }
        
        
        
    };
    
    commonView.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
    
    
    [commonView.table addEmptyViewAndClickRefresh:^{
        //无数据点击刷新
        [weakSelf configData];
    }];
}




/**
 网络请求
 */
- (void)configData{
    
    kWeakS(weakSelf);
    [self showProgress];
    NSDictionary *params = [NSDictionary dictionary];
    [HYBaseRequest getPostWithMethodName:kurl_home_new Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf.commonView.table.mj_header endRefreshing];
        [weakSelf dismissProgress];
        DLog(@"%@",result);
        if ([result isNotEmpty]) {
            HYHomeModel *model = [HYHomeModel mj_objectWithKeyValues:result];
            weakSelf.model = model;
            [weakSelf refreshUI];
        }
        
        
    } fail:^(NSDictionary *result) {
        [weakSelf.commonView.table.mj_header endRefreshing];
        [weakSelf dissmissWithError];
    }];
    
    
}


-(void)refreshUI{
    self.navigationItem.title = self.model.company_name;
    self.commonView.model = self.model;
}

/**
 快速新增响应
 
 @param index
 */
- (void)quickAddWith:(NSInteger)index{
    
    
    switch (index) {
        case 0:
        {
            [self isHasTime];
        }
            break;
        case 1:
        {
            HYNewProjectVC *vc = [[HYNewProjectVC alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 2:
        {
            AddCustomerVC *vc = [[AddCustomerVC alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        }
            break;
        case 3:
        {
            HYAddContactVC *vc = [[HYAddContactVC alloc] init];
            [self.navigationController pushViewController:vc animated:true];
            
        }
            break;
            
        default:
            break;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/**
 点击查看按钮后的响应
 
 @param model 点击查看所在cell对应的model
 */
-(void)lookAtWithModel:(HYHomeContentDetailModel *)model{
    
    if ([model.type isEqualToString:@"source_events"]){
        //    行动计划详情
//        ProjectSituationModel *pModel = [[ProjectSituationModel alloc] init];
//        pModel.id = model.project_id;
//        QFProjectPlanDetailVC *vc = [[QFProjectPlanDetailVC alloc] init];
//        vc.isProjectIn = false;
//        vc.model = pModel;
//        vc.id = model.id;
        
//        以前是行动计划，现在将行动计划和拜访合并
        HYVisitDetailVC *vc = [[HYVisitDetailVC alloc] init];
        vc.visit_id = model.visit_id;
        [self.navigationController pushViewController:vc animated:true];
    }
    if ([model.type isEqualToString:@"project"]){
        //项目详情
        PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectVCWithId:model.project_id];

    }
    if ([model.type isEqualToString:@"project_analyse"]){
        //分析详情
         PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectAnalyzeVCWithId:model.project_id logic_id:model.logic_id];
        
    }
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)isHasTime{
    
    
    __weak HYHomeVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:@"pp.consult.list_consult" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        
        CGFloat a = [[NSString stringWithFormat:@"%@",result[@"left_hour_str"]] floatValue];
        
        if (a <= 0) {
            [weakSelf dismissWithSuccess:@"您好，您的可预约时长用完了"];
            return;
        }else{
            NSString *per = @"0.0";
            CGFloat all = [[NSString stringWithFormat:@"%@",result[@"license_minute"]] floatValue];
            CGFloat left = [[NSString stringWithFormat:@"%@",result[@"left_minute"]] floatValue];
            
            per = [NSString stringWithFormat:@"%@",result[@"per"]];
            if (all != 0){
                per = [NSString stringWithFormat:@"%f",left/all];
                
            }
            [weakSelf toMakeAppointment:per andLeft:[NSString stringWithFormat:@"%.2f",left]];
        }
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
}

- (void)toMakeAppointment:(NSString *)per andLeft:(NSString *)left{
    __weak HYHomeVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:@"pp.Consult.consult_pro_list" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [self dismissProgress];
        NSArray *dataArray = result[@"data"];
        
        if ([dataArray isKindOfClass:[NSArray class]]){
            NSMutableDictionary *btnDic = [[NSMutableDictionary alloc] init];
            
            
            for (NSDictionary *oneDic in dataArray){
                [btnDic setObject:oneDic[@"pro_name"] forKey:oneDic[@"project_id"]];
            }
            
            UIAlertController *alertCont = [UIAlertController alertControllerWithTitle:@"选择项目" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            for (NSString *key in btnDic) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:btnDic[key] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (![key isEqualToString:@"Cancel"]){
                        BookingTutoringVC *vc = [[BookingTutoringVC alloc] init];
                        NSMutableArray *idArray = [NSMutableArray array];
                        for (NSDictionary *subDict in dataArray) {
                            if ([subDict[@"project_id"] isEqualToString:key]) {
                                [idArray addObject:subDict];
                            }
                        }
                        
                        NSMutableArray *mArray = [NSMutableArray array];
                        
                        if (idArray.count > 0 ){
                            NSDictionary *firstDict = [idArray firstObject];
                            NSArray *subMarray = firstDict[@"member"];
                            if (subMarray != nil) {
                                for (NSDictionary *nsubdic in subMarray) {
                                    MemberModel *m = [[MemberModel alloc] init];
                                    m.head = [NSString stringWithFormat:@"%@",nsubdic[@"head"]];
                                    m.id = [NSString stringWithFormat:@"%@",nsubdic[@"userid"]];
                                    m.name = [NSString stringWithFormat:@"%@",nsubdic[@"realname"]];
                                    [mArray addObject:m];
                                }
                            }
                            
                        }
                        
                        NSDictionary *model = @{@"projectId":key,@"project_name":btnDic[key],@"percentage":per,@"left_minute":left};
                        [vc configAlreadyInfoWithModel:model mArray:mArray];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                }];
                [alertCont addAction:action];
            }
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertCont addAction:cancelAction];
            [self presentViewController:alertCont animated:true completion:nil];
            
        }
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}

-(void)isShowCarrayDown{
    
    kWeakS(weakSelf);
    
    NSDictionary *params = [NSDictionary dictionary];
    [HYBaseRequest getPostWithMethodName:kIsShowWhether_Carrpy_down Params:[params addToken] showToast:NO Success:^(NSDictionary *result) {
        
        if([result[@"carry_down"] intValue] == 1){
            //显示
            if (weakSelf.tabBarController != nil && [weakSelf.tabBarController isKindOfClass:[TabBarController class]]) {
                TabBarController *tab = (TabBarController *)weakSelf.tabBarController;
                [tab showCarrayDownWithStr:[result[@"carry_down_name"] toString]];
            }
            
        }
        
    } fail:^(NSDictionary *result) {
        
    }];
    
}
@end
