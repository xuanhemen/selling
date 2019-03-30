//
//  HYAddVisitVC.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "HYVisitActionTypeVC.h"
#import "HYAddVisitVC.h"
#import "HYAddVisitViewModel.h"
#import "HomePageSectionView.h"
#import "HYAddVisitCell.h"

#import "CLVisitSimpleVC.h"
#import "SLAPP-Swift.h"
#import "HYVisitChooseProjectVC.h"
#import "CLDatePicker.h"
#import "UIView+LoadNib.h"
#import "SLAPP-Swift.h"
#import "HYSelectContactVC.h"

@interface HYAddVisitVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)HYAddVisitViewModel *addVisitViewModel;
@property(nonatomic,strong)CLDatePicker *picker;
@property(nonatomic,strong)QFChooseTypeView *actionTypeView;
@end

@implementation HYAddVisitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configData];
}


#pragma mark- 📚 ***********  UI创建 **************

-(void)configUI{
    self.title = @"拜访-基本信息";
    _addVisitViewModel = [[HYAddVisitViewModel alloc] init];
    _dataArray = [NSMutableArray array];
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    } ];
    _table.delegate = self;
    _table.dataSource = self;
    
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextStep addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [nextStep setFrame:CGRectMake(57, 17, kScreenWidth - 57 * 2, 30)];
//    if (self.onlyEditBaseInfo) {
//        [nextStep setTitle:@"确定" forState:UIControlStateNormal];
//    }else{
        [nextStep setTitle:@"保存" forState:UIControlStateNormal];
//    }
    [nextStep setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStep setBackgroundColor:kgreenColor];
    [footerView addSubview:nextStep];
    _table.tableFooterView = footerView;
}

#pragma mark- 📚 *********** 下一步点击响应 **************
- (void)nextStep{
    
    if (![_visitModel.project_id isNotEmpty]) {
        [self toastWithText:@"项目不能为空"];
        return;
    }
    
    if (![_visitModel.client_id isNotEmpty]) {
        [self toastWithText:@"客户不能为空"];
        return;
    }
    
    if (![_visitModel.visit_date isNotEmpty]) {
        [self toastWithText:@"拜访时间不能为空"];
        return;
    }
    
    if (![_addVisitViewModel.visiters isNotEmpty]) {
        [self toastWithText:@"拜访对象不能为空"];
        return;
    }
    
    if (_visitModel.starModel == nil) {
        [self toastWithText:@"行动类型不能为空"];
        return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"prjid"] = _visitModel.project_id;
    
    params[@"actiontype"] = _visitModel.starModel.id;
    
    if ([_addVisitViewModel.visiters isNotEmpty]) {
        params[@"vist_contacts"] = [_addVisitViewModel getVisiterIds];
    }
    
    if ([_addVisitViewModel.ours isNotEmpty]) {
         params[@"our_user"] = [_addVisitViewModel getOursIds];
    }
   
    if (_visitModel.timeStamp) {
        params[@"visit_date"] = @(_visitModel.timeStamp);
    }
    
    [self showProgress];
    kWeakS(weakSelf);
    
    NSString *url = @"";
    if ([_visitModel.id isNotEmpty]) {
        url = kUpdate_visitBase;
        params[@"id"] = _visitModel.id;
    }else{
        
        url = kAdd_visitBase;
    }
    
    
    [HYBaseRequest getPostWithMethodName:url Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf remindIsCompleteVisitInfo:result[@"id"]];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}


/**
 提醒是否完善拜访信息  不完善 返回上一层  完善走下一步

 @param str
 */
-(void)remindIsCompleteVisitInfo:(NSString *)str{
    kWeakS(weakSelf);
    [self addAlertViewWithTitle:@"温馨提示" message:@"拜访新建成功，是否继续完善拜访信息？" actionTitles:@[@"稍后",@"去完善"] okAction:^(UIAlertAction *action) {
       [weakSelf.navigationController  popViewControllerAnimated:true];
        
    } cancleAction:^(UIAlertAction *action) {
        CLVisitSimpleVC *vc = [[CLVisitSimpleVC alloc] init];
        vc.visitId = str;
        [weakSelf.navigationController pushViewController:vc animated:true];
        
    }];
    
    
}



#pragma mark- 📚 *********** 数据创建 **************

-(void)configData{
    [_dataArray addObjectsFromArray:[_addVisitViewModel configData]];
    if (!_visitModel) {
//        新增
        _visitModel = [[HYVisitModel alloc] init];
        
        if (self.proModel) {
            //项目下新增   项目下新增是不能修改项目和客户的
            _visitModel.client_id = _proModel.client_id;
            _visitModel.client_name = _proModel.client_name;
            _visitModel.project_id = _proModel.id;
            _visitModel.project_name = _proModel.name;
        }
        
        
    }else{
//        修改   会在跳转到界面时把所有拜访相关的数据  赋值给 _visitModel
        self.addVisitViewModel.ours = [_visitModel oursMember];
        self.addVisitViewModel.visiters = [_visitModel visitersMember];
    }
    [_table reloadData];
    
}








#pragma mark- 📚 *********** table delegate datasource **************

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 44;
    }
    else if (indexPath.section == 1){
        return self.addVisitViewModel.visitersHeight;
    }else if (indexPath.section == 2){
        return self.addVisitViewModel.oursHeight;
    }
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sub = self.dataArray[section];
    return sub.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0){
        
//        拜访基本信息
        static NSString * cellIde = @"cell";
        HYAddVisitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYAddVisitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        NSString * titleStr = self.dataArray[indexPath.section][indexPath.row];
        cell.lab_title.text = titleStr;
        cell.content.placeholder = @"必填";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([titleStr isEqualToString:@"项目"]) {
            cell.content.text = _visitModel.project_name;
            if (self.visitModel.id || self.proModel != nil) {
               cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if ([titleStr isEqualToString:@"客户"])
        {
            
            cell.content.text = _visitModel.client_name;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if ([titleStr isEqualToString:@"拜访日期"])
        {
            cell.content.text = _visitModel.visit_date;
        }else if ([titleStr isEqualToString:@"行动类型"]){
            
            cell.content.text = _visitModel.starModel != nil ? _visitModel.starModel.name : @"";
        }
        
        cell.content.enabled = false;
        return cell;
    }else if (indexPath.section == 1)
    {
        
//        拜访对象
        static NSString * cellIde = @"cellVisit";
        ProSituationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[ProSituationMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        [cell configTypeWithTagWithTag:2];
        cell.nameLable.text = @"";
        [cell refreshLayoutForVisit];
        [self configVisitCellClick:cell];
        
        return cell;
    }else{
//        我方参与人员
        static NSString * cellIde = @"cellOur";
        ProSituationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[ProSituationMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.nameLable.text = @"";
        [cell refreshLayoutForVisit];
        [cell configTypeWithTagWithTag:0];
        cell.isDelete = self.addVisitViewModel.ourIsDelete;
         [cell configAlReadyWithArray:self.addVisitViewModel.ours];
        [self configOurCellClick:cell];
        return cell;
        
    }
    
    
}







/**
 拜访对象添加  删除的一些操作处理

 @param cell <#cell description#>
 */
-(void)configVisitCellClick:(ProSituationMemberCell *)cell{
    kWeakS(weakSelf);
    __weak typeof(cell) weakCell = cell;
    cell.isDelete = self.addVisitViewModel.visitIsDelete;
    [cell configAlReadyWithArray:self.addVisitViewModel.visiters];
    cell.click = ^(NSString * str) {
        
        if ([str isEqualToString:@"+"]) {
            if (weakCell.isDelete == true)
            {
                weakSelf.addVisitViewModel.visitIsDelete = false;
                weakCell.isDelete = false;
                [weakCell.collectionView reloadData];
                
            }
            
            if ([weakSelf.visitModel.client_id isNotEmpty]) {
                HYSelectContactVC *contactVC = [[HYSelectContactVC alloc] init];
                HYClientModel *cModel = [[HYClientModel alloc] init];
                cModel.Id = weakSelf.visitModel.client_id;
                cModel.name = weakSelf.visitModel.client_name;
                contactVC.clientModel =  cModel;
                contactVC.alreadyArray = weakCell.currentMemberWithDicType;
                [contactVC setGetResult:^(NSArray *list) {
                    NSMutableArray *subArray = [NSMutableArray array];
                    for (NSDictionary *sub in list) {
                        MemberModel *model = [[MemberModel alloc] init];
                        model.id = sub[@"id"];
                        model.name = sub[@"name"];
                        [subArray addObject:model];
                    }
                    [weakCell configAlReadyWithArray:subArray];
                    weakSelf.addVisitViewModel.visiters = subArray;
                    [weakSelf.table reloadData];
                }];
                
                [weakSelf.navigationController pushViewController:contactVC animated:true];
                
            }else{
                [weakSelf toastWithText:@"确定客户后才可以操作"];
                return;
            }
            
        }else if ([str isEqualToString:@"-"]){
            if (weakCell.isDelete == true)
            {
                weakSelf.addVisitViewModel.visitIsDelete = false;
                weakCell.isDelete = false;
                [weakCell.collectionView reloadData];
                
            }else{
                weakSelf.addVisitViewModel.visitIsDelete = true;
                weakCell.isDelete = true;
                [weakCell.collectionView reloadData];
            }
            
        }else{
            weakSelf.addVisitViewModel.visiters = weakCell.currentMember;
            [weakSelf.table beginUpdates];
            [weakSelf.table endUpdates];
        }
    };
    
}


/**
 我方参与人员添加删除的一些处理

 @param cell <#cell description#>
 */
-(void)configOurCellClick:(ProSituationMemberCell *)cell{
    kWeakS(weakSelf);
     __weak typeof(cell)weakCell = cell;
    cell.click = ^(NSString * str) {
        if ([str isEqualToString:@"+"]) {
            
            if (weakCell.isDelete == true)
            {
                weakSelf.addVisitViewModel.ourIsDelete = false;
                weakCell.isDelete = false;
                [weakCell.collectionView reloadData];
                
            }
            
            HYColleaguesVC *vc = [[HYColleaguesVC alloc] init];
            vc.selectDataArray = weakCell.currentMember;
            vc.selectWithMembers = ^(NSArray<MemberModel *> * mArray) {
                [weakCell configAlReadyWithArray:mArray];
                
                weakSelf.addVisitViewModel.ours = mArray;
                [weakSelf.table reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"-"]){
            if (weakCell.isDelete == true)
            {
                weakSelf.addVisitViewModel.ourIsDelete = false;
                weakCell.isDelete = false;
                [weakCell.collectionView reloadData];
                
            }else{
                weakSelf.addVisitViewModel.ourIsDelete = true;
                weakCell.isDelete = true;
                [weakCell.collectionView reloadData];
            }
            
        }else{
            weakSelf.addVisitViewModel.ours = weakCell.currentMember;
            [weakSelf.table beginUpdates];
            [weakSelf.table endUpdates];
        }
    };
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomePageSectionView *sectionView = [[HomePageSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 36)];
    sectionView.hiddenIcon = YES;
    sectionView.titleLabel.text = self.dataArray[section][0];
    return sectionView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0) {
        NSString * titleStr = self.dataArray[indexPath.section][indexPath.row];
        kWeakS(weakSelf);
        if ([titleStr isEqualToString:@"项目"]) {
            if (self.visitModel.id || self.proModel != nil) {
                return;
            }
            HYVisitChooseProjectVC *vc = [[HYVisitChooseProjectVC alloc] init];
            vc.click = ^(HYVisitChooseProModel *pModel) {
                weakSelf.visitModel.client_id = pModel.client_id;
                weakSelf.visitModel.client_name = pModel.client_name;
                 weakSelf.visitModel.project_id = pModel.id;
                weakSelf.visitModel.project_name = pModel.name;
                
                [weakSelf.table reloadData];
            };
            [self.navigationController pushViewController:vc animated:true];
        }
        
        if ([titleStr isEqualToString:@"拜访日期"]) {
            if (!self.picker) {
                CLDatePicker *picker = [CLDatePicker loadBundleNib];
                picker.isVisit = YES;
                [picker showInVC:self.view];
                self.picker = picker;
                picker.datePicker.date = [NSDate dateWithTimeIntervalSinceNow:60*60*1];
                picker.resultTimeStr = ^(NSString *str,double time) {
                    if ([str isNotEmpty]) {
                        weakSelf.visitModel.visit_date = str;
                        weakSelf.visitModel.timeStamp = time;
                        [weakSelf.table reloadData];
                    }
                    
                    weakSelf.picker = nil;
                };
            }
            
        }
        
        if ([titleStr isEqualToString:@"行动类型"]) {
            
            if ([self.visitModel.client_id isNotEmpty]) {
                HYVisitActionTypeVC *vc = [[HYVisitActionTypeVC alloc] init];
                vc.proId = self.visitModel.project_id;
                kWeakS(weakSelf);
                vc.starViewClick = ^(ProjectPlanStarModel *model) {
                    weakSelf.visitModel.starModel = model;
                    [weakSelf.table reloadData];
                };
                [self.navigationController pushViewController:vc animated:true];
            }else{
                
                [self toastWithText:@"选择项目后才可以操作"];
            }
            
            
        }
    }
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
