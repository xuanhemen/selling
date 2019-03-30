//
//  HYVisitListVC.m
//  SLAPP
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "UITableView+Category.h"
#import <MJRefresh/MJRefresh.h>
#import "HYReservationVC.h"
#import "HYSummaryVC.h"
#import "HYLookatVisitVC.h"
#import "HYVisitDetailVC.h"
#import "HYVisitHomeDelegate.h"
#import "HYVisitHomeCell.h"
#import "HYVisitListVC.h"
#import "HYBaseDelegate.h"
@interface HYVisitListVC ()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)HYBaseDelegate *delegate;
@end

@implementation HYVisitListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访列表";
    [self configUI];
   
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self configData];
}

-(void)configUI{
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-kNav_height+49);
    }];
    
    UIView *nilview = [[UIView alloc] init];
    _table.tableFooterView = nilview;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[HYVisitHomeCell class] forCellReuseIdentifier:@"HYVisitHomeCell"];
    kWeakS(weakSelf);
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

-(void)configData{
    
//
    if (![_visitIds isNotEmpty]) {
        [self.table.mj_header endRefreshing];
        return;
    }
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ids"] = _visitIds;
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kGetIdsList Params:[params addToken]showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
        [weakSelf.delegate.dataArray removeAllObjects];
        if ([result[@"list"] isNotEmpty]) {
            [weakSelf.delegate.dataArray addObjectsFromArray:[HYVisitModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
        }
        
        [weakSelf.table reloadData];
        [weakSelf.table.mj_header endRefreshing];
        
    } fail:^(NSDictionary *result) {
        [weakSelf.table.mj_header endRefreshing];
        [weakSelf dissmissWithError];
        
    }];

    
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
