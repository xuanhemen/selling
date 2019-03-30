//
//  HYVisitAnalyseVC.m
//  SLAPP
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "UIView+LoadNib.h"
#import "HYVisitAnalyseVC.h"
#import "HYVisitAnalysisCell.h"
#import "SLAPP-Swift.h"
@interface HYVisitAnalyseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)CheckView *checkView;
@end

@implementation HYVisitAnalyseVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"拜访分析";
    _titles = @[@"",@"参与度",@"反馈度",@"支持度",@"组织结果",@"个人赢"];
    [self configUI];
}





- (void)setModel:(HYVisitAnalyseModel *)model{
    _model = model;
    [_table reloadData];
}

/**
 
 */
-(void)configUI{
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:rightBtn];
    
    __weak typeof(rightBtn)weakRightBtn = rightBtn;
    [leftBtn setTitle:@"不更新" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor lightGrayColor];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.bottom.mas_equalTo(-kTab_height+49);
        make.right.equalTo(weakRightBtn.mas_left);
        make.width.equalTo(weakRightBtn.mas_width);
    }];
    
//    kWeakS(weakSelf);
    [rightBtn setTitle:@"更新" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.backgroundColor = kgreenColor;
    __weak typeof(leftBtn)weakLeftBtn = leftBtn;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.equalTo(weakLeftBtn);
        make.left.equalTo(weakLeftBtn.mas_right);
        make.right.mas_equalTo(0);
    }];
    
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    table 相关
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.equalTo(weakLeftBtn.mas_top);
    }];
    
    UIView *view = [[UIView alloc] init];
    _table.tableFooterView = view;
    _table.delegate = self;
    _table.dataSource = self;
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerLab.text = @"此次拜访后现状是否有变化，如有变化请更新";
    headerLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.font = kFont(14);
    _table.tableHeaderView = headerLab;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_model && _model.contact_info) {
        return _model.contact_info.count;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _titles.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde = @"HYVisitAnalysisCell";
    HYVisitAnalysisCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [HYVisitAnalysisCell loadBundleNib];
    }
    cell.titleLab.text = _titles[indexPath.row];
    
    HYVisitAnalyseContactInfoModel *contactInfoModel = _model.contact_info[indexPath.section];
    
//    _titles = @[@"",@"参与度",@"反馈度",@"支持度",@"组织结果",@"个人赢"];
    
    if (indexPath.row == 0) {
        //姓名
        cell.titleLab.text = contactInfoModel.name;
        cell.subLable.text = @"";
        cell.cycleView.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.cycleView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if ([cell.titleLab.text isEqualToString:@"参与度"]){
        cell.subLable.text = contactInfoModel.engagementname;
    }else if ([cell.titleLab.text isEqualToString:@"反馈度"]){
        cell.subLable.text = contactInfoModel.feedbackname;
        
    }else if ([cell.titleLab.text isEqualToString:@"支持度"]){
        cell.subLable.text = contactInfoModel.supportname;
    }else if ([cell.titleLab.text isEqualToString:@"组织结果"]){
        cell.subLable.text = contactInfoModel.orgresultname;
    }else if ([cell.titleLab.text isEqualToString:@"个人赢"]){
        cell.subLable.text = contactInfoModel.personalwinname;
    }else if ([cell.titleLab.text isEqualToString:@"coach"]){
        cell.subLable.text = contactInfoModel.coachname;
    }
    
    return cell;
}

//-(void)configData{
//
//    [self showProgress];
//    kWeakS(weakSelf);
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [HYBaseRequest getPostWithMethodName:kVisitRoleSituation Params: [params addToken] showToast:true Success:^(NSDictionary *result) {
//        [weakSelf dismissProgress];
//
//        DLog(@"%@",result);
//
//    } fail:^(NSDictionary *result) {
//        [weakSelf dissmissWithError];
//    }];
//
//
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    HYVisitAnalysisCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    NSArray *array;
    if ([cell.titleLab.text isEqualToString:@"参与度"]){
        if (_model.engagement) {
            array = [_model.engagement valueForKeyPath:@"name"];
            
        }
       
    }else if ([cell.titleLab.text isEqualToString:@"反馈度"]){
        if (_model.feedback) {
            array = [_model.feedback valueForKeyPath:@"name"];
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"支持度"]){
        
        if (_model.support) {
            array = [_model.support valueForKeyPath:@"name"];
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"组织结果"]){
        if (_model.orgresult) {
            array = [_model.orgresult valueForKeyPath:@"name"];
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"个人赢"]){
        
        if (_model.personalwin) {
            array = [_model.personalwin valueForKeyPath:@"name"];
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"coach"]){
        
        if (_model.coach) {
            array = [_model.coach valueForKeyPath:@"name"];
        }
    }
    
    if (!array) {
        return;
    }
    kWeakS(weakSelf);
  _checkView  = [CheckView configWithTitlesWithTitles:array];
    _checkView.selecArray = @[cell.subLable.text];
    _checkView.click = ^(NSString * key, NSIndexPath * index){
        [weakSelf updateSelect:key index:index.row tableDidSelectIndex:indexPath];
    };
    [self.view addSubview:_checkView];
}




/**
 选择后更新UI
 @param key <#key description#>
 @param row <#row description#>
 @param indexPath <#indexPath description#>
 */
-(void)updateSelect:(NSString *)key index:(NSInteger)row tableDidSelectIndex:(NSIndexPath *)indexPath{
    
    HYVisitAnalysisCell *cell = [_table cellForRowAtIndexPath:indexPath];
    HYVisitAnalyseContactInfoModel *cModel = _model.contact_info[indexPath.section];
    if ([cell.titleLab.text isEqualToString:@"参与度"]){
        if (_model.engagement) {
            HYVisitAnalyseSubModel *subModel = _model.engagement[row];
            cModel.engagement = subModel.id;
            cModel.engagementname = subModel.name;
            cell.subLable.text = cModel.engagementname;
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"反馈度"]){
        if (_model.feedback) {
            
            HYVisitAnalyseSubModel *subModel = _model.feedback[row];
            cModel.feedback = subModel.id;
            cModel.feedbackname = subModel.name;
            cell.subLable.text = cModel.feedbackname;
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"支持度"]){
        
        if (_model.support) {
            
            HYVisitAnalyseSubModel *subModel = _model.support[row];
            cModel.support = subModel.id;
            cModel.supportname = subModel.name;
            cell.subLable.text = cModel.supportname;
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"组织结果"]){
        if (_model.orgresult) {
            HYVisitAnalyseSubModel *subModel = _model.orgresult[row];
            cModel.orgresult = subModel.id;
            cModel.orgresultname = subModel.name;
            cell.subLable.text = cModel.orgresultname;
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"个人赢"]){
        
        if (_model.personalwin) {
            HYVisitAnalyseSubModel *subModel = _model.personalwin[row];
            cModel.personalwin = subModel.id;
            cModel.personalwinname = subModel.name;
            cell.subLable.text = cModel.personalwinname;
        }
        
    }else if ([cell.titleLab.text isEqualToString:@"coach"]){
        
        if (_model.coach) {
            HYVisitAnalyseSubModel *subModel = _model.coach[row];
            cModel.coach = subModel.id;
            cModel.coachname = subModel.name;
            cell.subLable.text = cModel.coachname;
        }
    }
}





-(void)leftClick{
    
    [self.navigationController popViewControllerAnimated:true];
}

-(void)rightClick{
    
    [self updateData];
//    [self.navigationController popViewControllerAnimated:true];
}




/**
 更新
 */
-(void)updateData{
    
    NSMutableArray *array = [NSMutableArray array];
    for (HYVisitAnalyseContactInfoModel *cModel in _model.contact_info) {
        [array addObject:[cModel mj_keyValues]];
    }
    
        [self showProgress];
        kWeakS(weakSelf);
    
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"visitid"] = _visitId;
    params[@"arr"] = array;
        [HYBaseRequest getPostWithMethodName:kSaveVisitRoleSituation Params: [params addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
    
            [weakSelf.navigationController popViewControllerAnimated:YES];
    
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
