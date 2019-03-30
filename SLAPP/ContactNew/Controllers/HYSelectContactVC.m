//
//  HYSelectContactVC.m
//  SLAPP
//
//  Created by yons on 2018/10/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYSelectContactVC.h"
#import <Masonry/Masonry.h>
#import "HYContactEditNewCell.h"
#import "UIView+NIB.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "CallContact.h"
#import "HYAddContactVC.h"
#import "QFSelectContactVM.h"
@interface HYSelectContactVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *keyArray;

@property (nonatomic,strong) NSMutableArray *allModels;
@property (nonatomic,strong) NSMutableArray *selectModels;

@property (nonatomic,strong) NSMutableArray *searchModels;

@property (nonatomic,strong) QFSelectContactVM *contactVM;
@property (nonatomic,strong) UITextField *searchField;

@property (nonatomic,assign) BOOL isSearch;

@end

@implementation HYSelectContactVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.keyArray = [NSMutableArray array];
        self.allModels = [NSMutableArray array];
        self.selectModels = [NSMutableArray array];
        self.searchModels = [NSMutableArray array];
        self.contactVM = [[QFSelectContactVM alloc] init];
        self.isSearch = NO;
        self.title = @"选择联系人";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchAllContact];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 界面
- (void)configUI{
    
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.sectionIndexColor = UIColorFromRGB(0x666666);
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(-49.5);
    }];
    
    [self configSearchView];
    [self configBarItems];
}

- (void)configBarItems{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addButton setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = finishItem;
    
    
    UIButton *finishButton = [[UIButton alloc]init];
    [self.view addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    finishButton.backgroundColor = UIColorFromRGB(0x52B87E);
    [finishButton setTitle:@"确定" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finishButtonClick{
    if (self.selectModels.count>0) {
        [self updateContacts];
    }else{
        [self backButtonClick];
    }
}
- (void)addContact{
    HYAddContactVC *vc = [[HYAddContactVC alloc] init];
    vc.clientModel = self.clientModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 搜索界面
- (void)configSearchView{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    searchView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 19, 19)];
    searchImageView.image = [UIImage imageNamed:@"search_gray"];
    [searchView addSubview:searchImageView];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectMake(49, 5, kScreenWidth-49*2, 39)];
    self.searchField.placeholder = @"搜索";
    self.searchField.delegate = self;
    self.searchField.font = [UIFont systemFontOfSize:15];
    [self.searchField addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:self.searchField];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-19-15, 15, 19, 19)];
    cancelImageView.image = [UIImage imageNamed:@"QFContactshut"];
    [searchView addSubview:cancelImageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-49, 0, 49, 49)];
    [button addTarget:self action:@selector(cancelSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:button];
    
    [self.view addSubview:searchView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [searchView addSubview:line];
    
}
- (void)cancelSearchButtonClick{
    if (self.isSearch == YES) {
        [self.searchField resignFirstResponder];
        self.searchField.text = @"";
        [self.searchModels removeAllObjects];
        self.isSearch = NO;
        [self.tableView reloadData];
    }
}
- (void)textFieldEditChange:(UITextField *)textField{
    [self.searchModels removeAllObjects];
    for (QFChooseContactModel *model in self.allModels) {
        if ([model.name rangeOfString:textField.text].length>0) {
            [self.searchModels addObject:model];
        }
    }
    [self.tableView reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.isSearch = YES;
    [self.tableView reloadData];
}

#pragma mark - 数据获取

- (void)fetchAllContact{
    
    __weak HYSelectContactVC *weakSelf = self;
    [self showProgressWithStr:@"获取联系人信息中..."];
    
    if (self.clientModel != nil) {
        [self.contactVM fetchClientContact:self.clientModel.Id andNeedDistinct:self.alreadyArray andBlock:^(BOOL isSuccess, NSArray *dataArray, NSArray *keyArray) {
            if (isSuccess) {
                [weakSelf dismissProgress];
                [weakSelf arrayConfigWithKeyArray:keyArray andDataArray:dataArray];
            }else{
                [weakSelf dissmissWithError];
            }
        }];
    }else{
        [self.contactVM fetchAllContactAndNeedDistinct:self.alreadyArray andBlock:^(BOOL isSuccess, NSArray *dataArray, NSArray *keyArray) {
            if (isSuccess) {
                [weakSelf dismissProgress];
                [weakSelf arrayConfigWithKeyArray:keyArray andDataArray:dataArray];
            }else{
                [weakSelf dissmissWithError];
            }
        }];
    }
}

- (void)arrayConfigWithKeyArray:(NSArray *)keyArray andDataArray:(NSArray *)dataArray{
    [self.keyArray removeAllObjects];
    [self.dataArray removeAllObjects];
    [self.allModels removeAllObjects];
    [self.selectModels removeAllObjects];
    [self.keyArray addObjectsFromArray:keyArray];
    [self.dataArray addObjectsFromArray:dataArray];
    for (int i=0; i<self.dataArray.count; i++) {
        NSArray *subArray = self.dataArray[i];
        for (int j=0; j<subArray.count; j++) {
            QFChooseContactModel *model = subArray[j];
            [self.allModels addObject:model];
            if ([model.qf_select_status isEqualToString:@"choose"]) {
                [self.selectModels addObject:model];
            }
        }
    }
    [self.tableView reloadData];
}
#pragma mark - 提交数据
- (void)updateContacts{
    NSMutableArray *array = [NSMutableArray array];
    
    for (QFChooseContactModel *model in self.allModels) {
        if ([[model.qf_select_status toString] isEqualToString:@"already"]) {
            [self.selectModels addObject:model];
        }
    }
    for (QFChooseContactModel *model in self.selectModels) {
        [array addObject:@{@"id":model.id,@"name":model.name}];
    }
    self.getResult(array);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1;
    }
    return self.keyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchModels.count;
    }
    NSArray *array = self.dataArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"HYContactEditNewCell";
    HYContactEditNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [HYContactEditNewCell loadBundleNib];
    }
    QFChooseContactModel *model;
    if (self.isSearch) {
        model = self.searchModels[indexPath.row];
    }else{
        model = self.dataArray[indexPath.section][indexPath.row];
    }
    cell.cellNameLabel.text = model.name;
    cell.cellCompanylabel.text = model.client_name;
    cell.cellPositionLabel.text = model.position_name;
    
    if (model.headerImage.length == 0||model.headerImage == nil) {
        
    }
    BOOL isExist = NO;
    for (QFChooseContactModel *otherModel in self.selectModels) {
        if ([model isEqual:otherModel]) {
            isExist = YES;
        }
    }
    if (isExist) {
        cell.cellImage.image = [UIImage imageNamed:@"qf_select_statuschoose"];
    }else{
        if ([model.qf_select_status isEqualToString:@"already"]) {
            cell.cellImage.image = [UIImage imageNamed:@"qf_select_statusalready"];
        }else{
            cell.cellImage.image = [UIImage imageNamed:@"qf_select_statusdefault"];
        }
    }
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return nil;
    }
    NSString *keyString = self.keyArray[section];
    if ([keyString isEqualToString:@"QF"]) {
        return nil;
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        headerView.backgroundColor = UIColorFromRGB(0xF2F2F2);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 30)];
        label.text = self.keyArray[section];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = UIColorFromRGB(0x333333);
        [headerView addSubview:label];
        return headerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return 0;
    }
    NSString *keyString = self.keyArray[section];
    if ([keyString isEqualToString:@"QF"]) {
        return 0;
    }else{
        return 30;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        return @"";
    }
    NSString *keyString = self.keyArray[section];
    if ([keyString isEqualToString:@"QF"]) {
        return @"";
    }else{
        return keyString;
    }
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return @[];
    }
    if (self.keyArray.count>0) {
        NSString *keyString = self.keyArray[0];
        if ([keyString isEqualToString:@"QF"]) {
            return @[];
        }else{
            return self.keyArray;
        }
    }else{
        return @[];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QFChooseContactModel *model;
    if (self.isSearch) {
        model = self.searchModels[indexPath.row];
    }else{
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray[indexPath.section]];
        model = array[indexPath.row];
    }
    if ([model.qf_select_status isEqualToString:@"already"]) {
        return;
    }
    BOOL isExist = NO;
    for (QFChooseContactModel *otherModel in self.selectModels) {
        if ([model isEqual:otherModel]) {
            isExist = YES;
        }
    }
    if (isExist) {
        //取消勾选
        [self.selectModels removeObject:model];
        [self.tableView reloadData];
    }else{
        //勾选
        if (self.isSingle) {//单选
            [self.selectModels removeAllObjects];
            [self.selectModels addObject:model];
            [self.tableView reloadData];
        }else{
            [self.selectModels addObject:model];
            [self.tableView reloadData];
        }
    }
}

@end
