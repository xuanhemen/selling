//
//  CustomerFollowUpDetailVC.m
//  SLAPP
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "CustomerFollowUpDetailVC.h"
#import "GlobalDefines.h"


#import "SDRefresh.h"

#import "SDTimeLineTableHeaderView.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"


#define kTimeLineTableViewCellId @"SDTimeLineCell"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "SLAPP-Swift.h"
@interface CustomerFollowUpDetailVC ()

@end

@implementation CustomerFollowUpDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    self.tableView.frame = CGRectMake(0, 0,MAIN_SCREEN_WIDTH ,MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT);
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)btnClick{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)getMsgNum{
    
}

- (void)showTab{
    
}

- (void)configData{
    
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = [UserModel getUserModel];
    params[@"fo_id"] = self.cId;
    params[@"token"] = model.token;
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.followup.fo_detail" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        //        //NSLog(@"%@",a);
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf showDismiss];
        SDTimeLineCellModel *model =  [weakSelf getFollowupDetailModel:a];
        weakSelf.title = model.name;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObject:model];
        [weakSelf.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}



@end
