//
//  HYLookatVisitVC.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookatVisitVC.h"
#import "HYVisitReadyDetailCell.h"
#import "HYVisitDetailActionCell.h"
#import "HYVisitDetailModel.h"
#import "HYLookatVisitViewModel.h"
#import "HYLookatVisitSectionHeaderView.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
@interface HYLookatVisitVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)HYLookatVisitViewModel *viewModel;
@end

@implementation HYLookatVisitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    [self configData];
}

-(void)configUI{
    
    self.title = @"拜访";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _table = [[UITableView alloc] init];
    UIView *view = [UIView new];
    _table.tableFooterView = view;
    [self.view addSubview:_table];
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    } ];
    
    
    [_table registerClass:[HYVisitReadyDetailCell class] forCellReuseIdentifier:@"HYVisitReadyDetailCell"];
    [_table registerClass:[HYVisitDetailActionCell class] forCellReuseIdentifier:@"HYVisitDetailActionCell"];
    _table.delegate = self;
    _table.dataSource = self;
}

-(void)configData{
    
    _viewModel = [[HYLookatVisitViewModel alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.visit_id;
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kLook_visit_ready Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf showDismiss];
        DLog(@"%@",result);
        
       weakSelf.dataArray = [weakSelf.viewModel configWithJason:result];
        [weakSelf.table reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
    
    
    
   
    
    
}

#pragma mark- 📚 *********** table 代理 **************

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HYLookatVisitSectionHeaderView *header = [[HYLookatVisitSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    header.content.text = _viewModel.sectionTitles[section];
    return header;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return line;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakS(weakSelf);
    if (indexPath.section == 1){
        
        
        static NSString * cellIde = @"HYVisitDetailActionCell";
        return [tableView fd_heightForCellWithIdentifier:cellIde configuration:^(HYVisitDetailActionCell *cell)
                {
                    cell.model = weakSelf.dataArray[indexPath.section][indexPath.row];
                    [cell configUIWithModel];
                }];
        
        
    }else{
        
        static NSString * cellIde = @"HYVisitReadyDetailCell";
        return [tableView fd_heightForCellWithIdentifier:cellIde configuration:^(HYVisitReadyDetailCell *cell)
                {
                    cell.model = weakSelf.dataArray[indexPath.section][indexPath.row];
                    [cell configUIWithModel];
                }];
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _viewModel.sectionTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   if (indexPath.section == 1){
        
        
        static NSString * cellIde = @"HYVisitDetailActionCell";
        HYVisitDetailActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYVisitDetailActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        [cell configUIWithModel];
        return cell;
        
        
    }else{
        
        static NSString * cellIde = @"HYVisitReadyDetailCell";
        HYVisitReadyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYVisitReadyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        [cell configUIWithModel];
        return cell;
        
        
    }
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
