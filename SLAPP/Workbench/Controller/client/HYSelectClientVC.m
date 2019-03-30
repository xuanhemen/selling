//
//  HYSelectClientVC.m
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYSelectClientVC.h"
#import "HYBaseRequest.h"

#import "SLAPP-Swift.h"

@interface HYSelectClientVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UISearchBar *searchView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray    *allDataArray;

@property (nonatomic,strong) UIView    *noDataView;




@end

@implementation HYSelectClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户";
    self.dataArray = [NSMutableArray array];
    
    
    [self configUI];
    [self dataInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, kScreenHeight-QFTopHeight-50) style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.searchView = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [self.view addSubview:self.searchView];
    self.searchView.delegate = self;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [addButton setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = item;
    
    self.noDataView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.noDataView.backgroundColor = UIColorFromRGB(0xEEEFF3);
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
    [self configNodataView];
    
}
- (void)configNodataView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, self.noDataView.frame.size.height/6, (kScreenWidth-100), (kScreenWidth-100)/1000*647)];
    imageView.image = [UIImage imageNamed:@"noData"];
    [self.noDataView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/5*1.5, imageView.frame.origin.y+imageView.frame.size.height+50, kScreenWidth/5*2, kScreenWidth*0.4/25*6)];
    button.backgroundColor = UIColorFromRGB(0x6AB372);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"添加客户" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.noDataView addSubview:button];
    
    
}
- (void)dataInit{
    
    __weak HYSelectClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.inquire_client" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        
        [weakSelf.dataArray removeAllObjects];
        NSMutableArray *baseArray = [NSMutableArray array];
        [baseArray addObjectsFromArray:result[@"data"]];
        for (NSDictionary *dict in baseArray) {
            HYClientModel *model = [[HYClientModel alloc] initWithDictionary:dict];
            [weakSelf.dataArray addObject:model];
        }
        
        [weakSelf.tableView reloadData];
        if (weakSelf.dataArray.count==0) {
            weakSelf.noDataView.hidden = NO;
        }else{
            weakSelf.noDataView.hidden = YES;
        }
        weakSelf.allDataArray = [weakSelf.dataArray copy];
        [weakSelf.tableView reloadData];
        
    } fail:^(NSDictionary *result) {
    }];
}

-(void)rightClick:(UIButton *)btn{
    __weak HYSelectClientVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:@"pp.user.loginer_message" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        UserModel *userModel = [UserModel getUserModel];
        userModel.is_root = [NSString stringWithFormat:@"%@",result[@"is_root"]];
        userModel.depId = [NSString stringWithFormat:@"%@",result[@"dep_id"]];
        [userModel saveUserModel];
        
        AddCustomerVC *vc = [[AddCustomerVC alloc] init];
        vc.isSelectCome = YES;
        vc.customerNew = ^(NSString * clientId, NSString * clientName, NSString * tradeId, NSString * tradeName) {
            HYClientModel *newModel = [[HYClientModel alloc] init];
            newModel.id = clientId;
            newModel.name = clientName;
            newModel.trade_id = tradeId;
            newModel.trade_name = tradeName;
            weakSelf.action(newModel);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"CustomerCell";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    HYClientModel *model = self.dataArray[indexPath.row];
    cell.lbCustomerName.text = model.name;
    cell.lbContacts.text = model.contact;
    cell.headerImage.image = [UIImage imageNamed:@"head"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HYClientModel *model = self.dataArray[indexPath.row];
    self.action(model);
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (!searchText.isNotEmpty||searchBar.text == nil || [searchBar.text isEqualToString: @""]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.allDataArray];
        [self.tableView reloadData];
        [self.view endEditing:YES];
        [self.searchView resignFirstResponder];
    }else{
        [self.dataArray removeAllObjects];
        
        for (HYClientModel *model in self.allDataArray) {
            NSString *nameString = model.name;
            if ([nameString rangeOfString:searchBar.text].length>0) {
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self.searchView resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self.searchView resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    [self.searchView resignFirstResponder];
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.allDataArray];
    [self.tableView reloadData];
    
}

@end
