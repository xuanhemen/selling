//
//  HYCarryDownVC.m
//  SLAPP
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "UITableView+Category.h"
#import <MJExtension/MJExtension.h>
#import "NSDictionary+Category.h"
#import "HYBaseRequest.h"
#import "HYCarryDownCell.h"
#import "HYCarryDownVC.h"
#import <Masonry/Masonry.h>
#import "HYProjectModel.h"
#import "HYProjectGroupModel.h"
#import "HYCarryDownHeadView.h"
#import "UIView+NIB.h"

@interface HYCarryDownVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate, HYCarryDownHeadViewDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *showDataArray;
@property(nonatomic,strong)NSMutableArray *selectDataArray;
@property(nonatomic,strong)UISearchBar *search;
@end

@implementation HYCarryDownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目列表";
    
    _dataArray = [NSMutableArray array];
    _showDataArray = [NSMutableArray array];
    _selectDataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

-(void)configUI{
    
    UISearchBar *search = [[UISearchBar alloc] init];
    [self.view addSubview:search];
    self.search = search;
    search.placeholder = @"搜索项目名/公司名/状态";
    [search setBackgroundImage:[UIImage imageNamed:@"backGray"]];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    search.delegate = self;
    
    
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(-kTab_height+49-49);
    }];
    [_table registerNib:[UINib nibWithNibName:@"HYCarryDownCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HYCarryDownCell"];
    _table.delegate = self;
    _table.dataSource = self;
//    kWeakS(weakSelf);
//    [_table addEmptyViewAndClickRefresh:^{
//        [weakSelf configData];
//    }];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [allBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    [self.view addSubview:allBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消全选" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    allBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(-kTab_height+49);
        make.height.mas_equalTo(49);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(-kTab_height+49);
        make.height.mas_equalTo(49);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    __weak typeof(allBtn)weakAllBtn = allBtn;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.centerX.equalTo(weakAllBtn.mas_right);
        make.height.mas_equalTo(19);
        make.centerY.equalTo(weakAllBtn);
    }];
    
    [allBtn addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"hebingfenzu"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"zhangkaifenzu"] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    
    __weak typeof(cancelBtn)weakCancelBtn = cancelBtn;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(weakCancelBtn.mas_top);
    }];
    
    [btn addTarget:self action:@selector(groupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)groupButtonClick:(UIButton *)sender {
    
    for (HYProjectGroupModel *group in _dataArray) {
        group.isShow = sender.selected == YES ? @"1" : @"0";
    }
    
    sender.selected = !sender.selected;
    
    [self.table reloadData];
}

-(void)allClick{
    [self.selectDataArray removeAllObjects];
    
    for (HYProjectGroupModel *group in _dataArray) {
        if ([group.isShow isEqualToString:@"1"]) {
            for (HYProjectModel *model in group.list) {
                [self.selectDataArray addObject:model];
            }
        };
    }
    
    [self.table reloadData];
}

-(void)cancelClick{
    [self.selectDataArray removeAllObjects];
    [self.table reloadData];
}

-(void)rightClick{
    
    
    if(self.selectDataArray.count == 0){
        [self toastWithText:@"还没有选择要结转的项目"];
        return;
    }
    NSArray *array = [self.selectDataArray valueForKeyPath:@"id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ids"] = [array componentsJoinedByString:@","];
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kProjectSettingSave Params:[params addToken]showToast:true Success:^(NSDictionary *result) {

        [weakSelf dismissProgress];
        [weakSelf toastWithText:@"结转成功"];
        [weakSelf.navigationController popViewControllerAnimated:true];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
}


-(void)configData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kProjectSetting Params:[params addToken]showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.showDataArray removeAllObjects];
        [weakSelf.selectDataArray removeAllObjects];
        [weakSelf dismissProgress];
        if([result[@"new_list"] isNotEmpty]){
            
            [HYProjectGroupModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{ @"list":[HYProjectModel class] };
            }];
            
            for (NSDictionary * sub in result[@"new_list"] ){
                HYProjectGroupModel *model = [HYProjectGroupModel mj_objectWithKeyValues:sub];
                [weakSelf.dataArray addObject:model];
            }
        }
        
        [weakSelf.showDataArray addObjectsFromArray:weakSelf.dataArray];
        [weakSelf.table reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _showDataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HYProjectGroupModel *group = _dataArray[section];
    BOOL isShow = [group.isShow isEqualToString:@"1"];
    return isShow ? [_showDataArray[section] list].count : 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYCarryDownCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HYCarryDownCell"];
    
    HYProjectGroupModel *group = self.showDataArray[indexPath.section];
    
    HYProjectModel *model = group.list[indexPath.row];
    cell.project.text = model.name;
    cell.client.text = model.client_name;
    cell.status.text = model.close_status_name;
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id == %@",model.id];
    
    if([[self.selectDataArray filteredArrayUsingPredicate:pre] isNotEmpty]){
        cell.imageView.image = [UIImage imageNamed:@"qf_select_statuschoose"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"qf_select_statusdefault"];
    }
    
//    qf_select_statusdefault
//    qf_select_statuschoose
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HYCarryDownHeadView *headView = [HYCarryDownHeadView loadBundleNib];
    headView.group = _showDataArray[section];
    headView.section = section;
    headView.delegate = self;
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 9)];
    footView.backgroundColor = [UIColor colorWithHexString:@"F0F1F4"];
    return footView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYProjectGroupModel *group = self.showDataArray[indexPath.section];
    
    HYProjectModel *model = group.list[indexPath.row];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id == %@",model.id];
    NSArray *filterArray = [self.selectDataArray filteredArrayUsingPredicate:pre];
    if([filterArray isNotEmpty]){
        
        HYProjectModel *fmodel = filterArray.firstObject;
        
        [self.selectDataArray removeObject:fmodel];
       
        
    }else{
        [self.selectDataArray addObject:model];
    }
    
    [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSLog(@"*** count = %lu", (unsigned long)self.selectDataArray.count);
}

- (void)arrowButtonClick:(NSInteger)section isShow:(NSString *)value {
    
    HYProjectGroupModel *group = _dataArray[section];
    group.isShow = value;
    
    [self.table reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.showDataArray removeAllObjects];
    if([searchText isNotEmpty]){
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@ or close_status_name CONTAINS %@ or client_name CONTAINS %@",searchText,searchText,searchText];
        
        NSMutableArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.dataArray]];
        
        NSMutableArray *delArray = [NSMutableArray array];
        
        for (HYProjectGroupModel *group in tempArray) {
            group.list = (NSMutableArray *)[group.list filteredArrayUsingPredicate:pre];
        }
        
        [tempArray removeObjectsInArray:delArray];
        
        [self.showDataArray addObjectsFromArray:tempArray];
    }else{
        [self.showDataArray addObjectsFromArray:self.dataArray];
    }
    [_table reloadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText = searchBar.text;
    if (![searchText isNotEmpty]){
        [self toastWithText:@"搜索内容不能为空"];
        return;
    }
    
    [self.showDataArray removeAllObjects];
    if([searchText isNotEmpty]){
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@ or close_status_name CONTAINS %@ or client_name CONTAINS %@",searchText,searchText,searchText];
        
        NSMutableArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.dataArray]];
        
        NSMutableArray *delArray = [NSMutableArray array];
        
        for (HYProjectGroupModel *group in tempArray) {
            group.list = (NSMutableArray *)[group.list filteredArrayUsingPredicate:pre];
        }
        
        [tempArray removeObjectsInArray:delArray];
        
        [self.showDataArray addObjectsFromArray:tempArray];
    }else{
        [self.showDataArray addObjectsFromArray:self.dataArray];
    }
    [_table reloadData];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_search resignFirstResponder];
    
}

@end
