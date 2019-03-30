//
//  HYScheduleSearchVC.m
//  SLAPP
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019 柴进. All rights reserved.
//
#import "HYSechduleSearchCell.h"
#import "HYScheduleSearchVC.h"
#import "HYScheduleDayListDelegate.h"
#import "HYScheduleListModel.h"
#import "SLNewBuildScheduleVC.h"
@interface HYScheduleSearchVC ()
@property(nonatomic,strong) HYScheduleDayListDelegate *delegate;
@end

@implementation HYScheduleSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索日程";
    kWeakS(weakSelf);
    _delegate = [[HYScheduleDayListDelegate alloc] initWithCellIde:@"HYSechduleSearchCell" AndAutoCellHeight:60 modelKey:nil AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, HYScheduleListModel * model) {
        
        SLNewBuildScheduleVC *bvc = [[SLNewBuildScheduleVC alloc]init];
        bvc.buildStyle = SLBuildStyleToView;
        bvc.numberID = model.id;
        bvc.freshList = ^(NSString * _Nonnull ID) {
            //编辑成功之后code
            
        };
        [weakSelf.navigationController pushViewController:bvc animated:YES];
        
    }];
    self.table.delegate = _delegate;
    self.table.dataSource = _delegate;
}




- (void)configData{
    
    if (![self.searchView.text isNotEmpty]) {
        [self toastWithText:@"搜索内容不能为空"];
        return;
    }
    [self.delegate.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"title_seek"] = self.searchView.text;
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kSearchSchedule Params:[params  addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
        if ([result[@"list"] isNotEmpty]) {
            NSArray *array = [HYScheduleListModel mj_objectArrayWithKeyValuesArray:result[@"list"]];
            [weakSelf.delegate.dataArray addObjectsFromArray:array];
        }
        
        [weakSelf.table reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.table reloadData];
    }];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self configData];
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchText isNotEmpty]) {
        [_delegate.dataArray removeAllObjects];
        [self.table reloadData];
    }
}

@end
