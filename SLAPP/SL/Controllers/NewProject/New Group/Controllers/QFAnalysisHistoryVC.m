//
//  QFAnalysisHistoryVC.m
//  SLAPP
//
//  Created by qwp on 2018/8/1.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFAnalysisHistoryVC.h"
#import "ChatKeyBoardMacroDefine.h"
#import <Masonry/Masonry.h>
#import "QFAnalysisHistoryCell.h"
#import "SLAPP-Swift.h"
#import "HistoricalTrendChartVC.h"
#import "QFCheckView.h"
#import "QFContrastVC.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface QFAnalysisHistoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL  isCheck;
@property (nonatomic,assign) NSInteger checkIndexA;
@property (nonatomic,assign) NSInteger checkIndexB;
@property (nonatomic,strong) UIView *checkListView;
@property (nonatomic,strong) NSDictionary   *baseDict;

@property (nonatomic,strong)NSArray *checkDataArray;
@property (nonatomic,strong)NSMutableArray *selectArray;

@end

@implementation QFAnalysisHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isCheck = NO;
    self.checkIndexA = -1;
    self.checkIndexB = -1;
    [self UIConfig];
    [self configData];
    self.title = @"历史记录";
    self.dataArray = [NSMutableArray array];
    self.selectArray = [NSMutableArray array];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    [tabVC.tab setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    [tabVC.tabBar setHidden:YES];
    [tabVC.tab setHidden:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configData{
    UserModel *model = UserModel.getUserModel;
    __weak QFAnalysisHistoryVC *weakSelf = self;
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.logicAnalyse.logicList" params:@{@"project_id":self.model.id,@"token":model.token} hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        
        [self.dataArray removeAllObjects];
        [weakSelf showDismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        
        NSLog(@"%@",a);
        if ([a[@"status"] integerValue] == 1) {
            if ([a[@"data"] isKindOfClass:[NSArray class]]) {
                [self.dataArray addObjectsFromArray:a[@"data"]];
            }
        }
        [self.tableView reloadData];
        
    }];
    [LoginRequest getPostWithMethodName:@"pp.logicAnalyse.compare_head" params:@{@"token":model.token} hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        NSArray *array = a[@"contrast"];
        [weakSelf configCheckListViewWithArray:array];
        
    }];
    
}
- (void)UIConfig{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    kWeakS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-5, 0, 21, 21);
    [btn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.backBarButtonItem = barItem;
    
    UIButton *duibiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    duibiBtn.frame = CGRectMake(0, 0, 21, 21);
    [duibiBtn setImage:[UIImage imageNamed:@"qf_analysis_duibi"] forState:UIControlStateNormal];
    [duibiBtn sizeToFit];
    [duibiBtn addTarget:self action:@selector(duibibtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *qushiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qushiBtn.frame = CGRectMake(0, 0, 21, 21);
    [qushiBtn setImage:[UIImage imageNamed:@"qf_analysis_qushi"] forState:UIControlStateNormal];
    [qushiBtn sizeToFit];
    [qushiBtn addTarget:self action:@selector(qvshiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * duibiItem = [[UIBarButtonItem alloc]initWithCustomView:duibiBtn];
    UIBarButtonItem * qushiItem = [[UIBarButtonItem alloc]initWithCustomView:qushiBtn];
    self.navigationItem.rightBarButtonItems = @[qushiItem,duibiItem];
    
}

- (void)configCheckListViewWithArray:(NSArray *)array{
    
    __weak QFAnalysisHistoryVC *weakSelf = self;
    
    if (self.checkListView){
        [self.checkListView removeFromSuperview];
    }
    
    CGFloat height = 0;
    if (array.count%2 == 0) {
        height = array.count/2*50+80;
    }else{
        height = (array.count/2+1)*50+80;
    }
    
    self.checkDataArray = array;
    [self.selectArray removeAllObjects];
    
    self.checkListView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-QFTopHeight-height, kScreenWidth, height)];
    self.checkListView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.view addSubview:self.checkListView];
    
    
    for (int i=0; i<array.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40+((kScreenWidth-120)/2+40)*(i%2), i/2*50, (kScreenWidth-120)/2, 50)];
        [self.checkListView addSubview:view];
        
        QFCheckView *checkView = [[QFCheckView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        checkView.tag = 100+i;
        checkView.checkBlock = ^(BOOL isCheck, QFCheckView *sender) {
            NSString *key = weakSelf.checkDataArray[sender.tag-100][@"key"];
            if (isCheck) {
                [weakSelf.selectArray addObject:key];
            }else{
                [weakSelf.selectArray removeObject:key];
            }
        };
        [view addSubview:checkView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, view.frame.size.width-40, 30)];
        label.textColor = UIColorFromRGB(0x333333);
        label.text = array[i][@"name"];
        [view addSubview:label];
    }
    
    UIButton *duibiButton = [[UIButton alloc] initWithFrame:CGRectMake(40, self.checkListView.frame.size.height-65, kScreenWidth/2-60, 40)];
    [duibiButton setTitle:@"对比" forState:UIControlStateNormal];
    duibiButton.layer.cornerRadius = 3;
    duibiButton.clipsToBounds = YES;
    [duibiButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [duibiButton addTarget:self action:@selector(gotoContrastVC) forControlEvents:UIControlEventTouchUpInside];
    duibiButton.backgroundColor = UIColorFromRGB(0x4DAC62);
    [self.checkListView addSubview:duibiButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(80+kScreenWidth/2-60, self.checkListView.frame.size.height-65, kScreenWidth/2-60, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.cornerRadius = 3;
    cancelButton.clipsToBounds = YES;
    [cancelButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    cancelButton.backgroundColor = UIColorFromRGB(0xA9A9AB);
    [self.checkListView addSubview:cancelButton];
    
    self.checkListView.hidden = YES;
    
}

- (void)cancelButtonClick{
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight);
    self.checkListView.hidden = YES;
    self.isCheck = NO;
    self.checkIndexA = -1;
    self.checkIndexB = -1;
    [self configCheckListViewWithArray:self.checkDataArray];
    [self.selectArray removeAllObjects];
    [self.tableView reloadData];
    
    
}
- (void)gotoContrastVC{
    if (self.selectArray.count==0) {
        [self toastWithText:@"请选择对比分类" andDruation:1.5];
        return;
    }
    
    if (self.checkIndexA == -1 || self.checkIndexB == -1) {
        [self toastWithText:@"请至少选择两次分析" andDruation:1.5];
        
        return;
    }
    
    NSDictionary *aDict = self.dataArray[self.checkIndexA];
    NSDictionary *bDict = self.dataArray[self.checkIndexB];
    
    
    
    UserModel *model = UserModel.getUserModel;
    __weak QFAnalysisHistoryVC *weakSelf = self;
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.logicAnalyse.comparative_analysis" params:@{@"project_id":self.model.id,@"token":model.token,@"logic_id_one":aDict[@"logic_id"],@"logic_id_two":bDict[@"logic_id"]} hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        
        [weakSelf showDismiss];
        NSLog(@"对比分析%@",a);
        weakSelf.baseDict = a;
        
        QFContrastVC *vc = [[QFContrastVC alloc] init];
        vc.baseDict = weakSelf.baseDict;
        vc.baseSelectArray = [weakSelf.selectArray copy];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [weakSelf cancelButtonClick];
        
    }];
    
    
    
}
- (void)duibibtnClick{
    
    
    if (self.isCheck == NO) {
        self.isCheck = YES;
        self.checkListView.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight-self.checkListView.frame.size.height);
    }else{
        self.isCheck = NO;
        self.checkIndexA = -1;
        self.checkIndexB = -1;
        self.checkListView.hidden = YES;
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight);
    }
    [self.tableView reloadData];
    return;
    
    
}
- (void)qvshiBtnClick{
    HistoricalTrendChartVC *vc = [[HistoricalTrendChartVC alloc] init];
    vc.proId = self.model.id;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)btnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableview  *************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QFAnalysisHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QFAnalysisHistoryCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"QFAnalysisHistoryCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",self.dataArray.count-indexPath.row];
    NSString *dateString = [NSString stringWithFormat:@"%@",dict[@"createtime_str"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[[dateString componentsSeparatedByString:@" "] firstObject]];
    cell.pointLabel.text = [NSString stringWithFormat:@"%@",dict[@"closerate"]];
    cell.indexPathRow = indexPath.row;
    [cell cellSelectStatus:self.isCheck];
    
    if (cell.checkView.isCheck == YES) {
        if (cell.indexPathRow != self.checkIndexA && cell.indexPathRow != self.checkIndexB) {
            [cell.checkView check];
        }
    }
    
    
    
    
    __weak QFAnalysisHistoryVC *weakSelf = self;
    
    cell.checkAction = ^(NSInteger index, BOOL isCheck) {
        if (isCheck) {
            weakSelf.checkIndexB = weakSelf.checkIndexA;
            weakSelf.checkIndexA = index;
        }else{
            if (index == weakSelf.checkIndexA) {
                weakSelf.checkIndexA = -1;
            }else if (index == weakSelf.checkIndexB){
                weakSelf.checkIndexB = -1;
            }
        }
        [weakSelf.tableView reloadData];
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    ProjectAnalyzeVC *vc = [[ProjectAnalyzeVC alloc] init];
    vc.model = self.model;
    vc.logicId = [NSString stringWithFormat:@"%@",dict[@"logic_id"]];
    vc.isHistory = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - tableview_end  *************************
@end
