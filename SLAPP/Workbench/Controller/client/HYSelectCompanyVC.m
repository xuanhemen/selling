//
//  HYSelectCompanyVC.m
//  SLAPP
//
//  Created by yons on 2018/9/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYSelectCompanyVC.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
@interface HYSelectCompanyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)UISearchBar *searchView;
@end


@implementation HYSelectCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司检索";
    self.dataArray= [NSMutableArray array];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configUI{
    
    _searchView = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _searchView.backgroundColor = [UIColor whiteColor];
    _searchView.placeholder = @"请输入您要查询的企业名称";
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
//    searchView?.backgroundColor = UIColor.clear
//    self.navigationItem.titleView = searchView
//    searchView?.setBackgroundImage(UIImage.init(named: "backColor")!, for: .any, barMetrics: .default)
//    searchView?.showsCancelButton = true
    
    
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,50,kScreenWidth, kScreenHeight-QFTopHeight-50) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

- (void)searchCompany:(NSString *)text {
    
    
    __weak HYSelectCompanyVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.getCompanyList" Params:@{@"token":model.token,@"keyname":text} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
        [weakSelf.dataArray removeAllObjects];
        [weakSelf.dataArray addObjectsFromArray:result[@"data"]];
        [weakSelf.tableView reloadData];

        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock([NSString stringWithFormat:@"%@",dict[@"name"]]);
        [self.navigationController popViewControllerAnimated:true];
    }
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    if (_searchView.isFirstResponder) {
        [_searchView resignFirstResponder];
    }
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([searchBar.text isNotEmpty]) {
        [self searchCompany:searchBar.text];
    }
}

@end
