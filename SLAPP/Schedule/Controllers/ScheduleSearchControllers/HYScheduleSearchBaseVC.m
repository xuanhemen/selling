//
//  HYScheduleSearchBaseVC.m
//  SLAPP
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleSearchBaseVC.h"

@interface HYScheduleSearchBaseVC ()

@end

@implementation HYScheduleSearchBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    [self configUI];
}

-(void)configUI{
    
    _searchView = [[UISearchBar alloc] init];
    _searchView.placeholder = @"搜索";
    _searchView.backgroundImage = [UIImage imageNamed:@"backGray"];
    [self.view addSubview:_searchView];
    
    _searchView.delegate = self;
    
    [_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];

    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(49-kTab_height);
    }];
    
    _table.tableFooterView = [[UIView alloc] init];
    
}

- (void)configData{
    
}

@end
