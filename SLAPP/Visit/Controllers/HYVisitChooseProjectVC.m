//
//  HYVisitChooseProjectVC.m
//  SLAPP
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitChooseProjectVC.h"
#import "HYVisitChooseProDelegate.h"

#import "SLAPP-Swift.h"
#import "UIView+LoadNib.h"
#import <MJRefresh/MJRefresh.h>
@interface HYVisitChooseProjectVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *allDataArray;
@property(nonatomic,strong)UISearchBar *search;
@end

@implementation HYVisitChooseProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _allDataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

-(void)configData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kPro_lists Params:[params addToken] showToast:true Success:^(NSDictionary *result)
    {
        [weakSelf dismissProgress];
        if ([result[@"data"] isNotEmpty]) {
            [weakSelf.allDataArray removeAllObjects];
            
            for (NSDictionary *sub in result[@"data"]) {
                HYVisitChooseProModel *model = [HYVisitChooseProModel mj_objectWithKeyValues:sub];
                [weakSelf.allDataArray addObject:model];
            }
           
            [weakSelf.dataArray addObjectsFromArray:weakSelf.allDataArray];
            [weakSelf.table reloadData];
        }
        
        
        
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}


- (void)configUI{
    
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    
    self.title = @"选择项目";
    
    UISearchBar *search = [[UISearchBar alloc] init];
    [self.view addSubview:search];
    self.search = search;
    search.placeholder = @"搜索";
    [search setBackgroundImage:[UIImage imageNamed:@"backGray"]];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    search.delegate = self;
    __weak typeof(search)weakSearch = search;
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSearch.mas_bottom);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTab_height+49);
        
    } ];

    _table.delegate = self;
    _table.dataSource  = self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIde = @"cell";
    QFFollowUpProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"QFFollowUpProjectCell" owner:nil options:nil].lastObject;
    }
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    HYVisitChooseProModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     HYVisitChooseProModel *model = self.dataArray[indexPath.row];
    if (self.click) {
        self.click(model);
    }
    [self.navigationController popViewControllerAnimated:true];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.search resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchText isNotEmpty]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.allDataArray];
        [self.table reloadData];
    }else{
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",searchBar.text];
        NSArray *array = [self.allDataArray filteredArrayUsingPredicate:filterPredicate];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.table reloadData];
    }
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text isNotEmpty]) {
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",searchBar.text];
        NSArray *array = [self.allDataArray filteredArrayUsingPredicate:filterPredicate];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        [self.table reloadData];
    }
    
}



@end
