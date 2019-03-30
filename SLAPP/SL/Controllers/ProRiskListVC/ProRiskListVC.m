//
//  ProRiskListVC.m
//  SLAPP
//
//  Created by apple on 2018/8/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "ProRiskListVC.h"
#import "SLAPP-Swift.h"
#import "QFPopupView.h"
#import "QFMaskView.h"
@interface ProRiskListVC ()<UITableViewDelegate,UITableViewDataSource,QFPopupViewDelegate,QFMaskViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong) NSString *group_typeL;//分组名称(默认不填就是阶段stage,部门dep,行业trade,人 user)
@property (nonatomic,strong) NSString *group_sort_typeL;//排序类型（asc 正序desc倒序）
@property (nonatomic,strong) NSString *group_fieldL;//排序字段(edittime更新时间 create_time创建时间

@property (nonatomic,strong) QFPopupView *popupViewLeft;

@property(nonatomic,strong)QFMaskView *maskView;
@end

@implementation ProRiskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.group_typeL = @"";
    self.group_fieldL = @"";
    self.group_sort_typeL = @"";

     _dataArray = [NSMutableArray array];
    [self configUI];
    [self configData];
}

-(void)configUI{
    
    self.title = @"相关项目";
     UIView *topback = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    topback.backgroundColor = UIColorFromRGB(0x434652);
    [self.view addSubview:topback];
    _popupViewLeft = [[QFPopupView alloc] initWithFrame:CGRectMake(0,10, kScreenWidth, 50)];
    
    _popupViewLeft.sortView.backgroundColor = UIColorFromRGB(0x434652);
    _popupViewLeft.segmentView.backgroundColor = UIColorFromRGB(0x434652);
    _popupViewLeft.delegate = self;
    [self.view addSubview:_popupViewLeft];
    [_popupViewLeft configUI];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50,kScreenWidth, kMain_screen_height_px-kNav_height-50)];
    _tableView.backgroundColor = [UIColor whiteColor];
    UIView *viewf = [[UIView alloc] init];
    _tableView.tableFooterView = viewf;
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    self.maskView = [[QFMaskView alloc] initWithFrame:CGRectMake(0,QFTopHeight, kScreenWidth, kScreenHeight-QFTopHeight)];
    self.maskView.delegate = self;
    [self.view addSubview:self.maskView];
}

-(void)configData{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:self.group_typeL forKey:@"group"];
    [params setObject:self.group_sort_typeL forKey:@"sort_type"];
    [params setObject:self.group_fieldL forKey:@"field"];
    
//       [params setObject:@"9558,9560,9561,9562,9579,9584,9555" forKey:@"project_ids"];
    [params setObject:_ids forKey:@"project_ids"];

    if(![params[@"project_ids"] isNotEmpty]){
        [self.dataArray removeAllObjects];
        [self.tableView  reloadData];
        return;
    }
    //    NSLog(@"请求的数据%@",params);
    [params setObject:[UserModel getUserModel].token forKey:@"token"];
    
    kWeakS(weakSelf);
    [self showOCProgress];
    
    
    [LoginRequest getPostWithMethodName:@"pp.projectStatistics.sorted_content" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
        //        [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        //[weakSelf.tableView.mj_header endRefreshing];
        
        
        NSArray *fulldata = a[@"data"];
        [self.dataArray removeAllObjects];
        for (int i=0; i<fulldata.count; i++) {
            NSDictionary *oneList = fulldata[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:oneList];
            if (i == 0) {
                [dict setObject:@"1" forKey:@"isShow"];
            }else{
                [dict setObject:@"0" forKey:@"isShow"];
            }
            
            [self.dataArray addObject:dict];
        }
        [weakSelf.tableView  reloadData];
        
    }];
    
    
    
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
        return self.dataArray.count;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        NSDictionary *dict = self.dataArray[section];
        NSArray *array = dict[@"pro_list"];
        if ([dict[@"isShow"] integerValue]==0) {
            return 0;
        }else{
            return array.count;
        }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = @"HYProjectCell";
    HYProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYProjectCell" owner:self options:nil] lastObject];
    }
        NSDictionary *dict = self.dataArray[indexPath.section];
        NSArray *array = dict[@"pro_list"];
        [cell setViewModelWithDictWithDict:array[indexPath.row]];
        return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSArray *proList = self.dataArray[indexPath.section][@"pro_list"];
        NSDictionary *dict = proList[indexPath.row];
        PublicPush *push = [[PublicPush alloc] init];
        [push pushToProjectVCWithId:dict[@"id"]];
    
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        HYProjectHeaderView *view = [[HYProjectHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        [view.showBtn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        view.showBtn.tag = section+200;
        NSDictionary *dict = self.dataArray[section];
        [view setViewModelWithDict:dict];
        return view;
}
- (void)headerButtonClick:(UIButton *)sender{
    
    
        NSDictionary *dict = self.dataArray[sender.tag-200];
        if ([dict[@"isShow"] integerValue]==0) {
            [dict setValue:@"1" forKey:@"isShow"];
        }else{
            [dict setValue:@"0" forKey:@"isShow"];
        }
        [self.dataArray replaceObjectAtIndex:sender.tag-200 withObject:dict];
        [self.tableView reloadData];
    
    
    
}


// MARK: - popViewDelegate

-(void)qf_segButtonClick:(QFPopupView *)pop{
    [self.maskView qf_showMaskViewWithHeight: -55 andIsLeft:NO];
}

-(void)qf_sortButtonClick:(QFPopupView *)pop{
    [self.maskView qf_showMaskViewWithHeight: - 55 andIsLeft:YES];
}


- (void)qf_selectInView:(QFMaskView *)view{
    
//    self.popupViewLeft.sortLabel.text = view.leftArray[view.leftSelectIndex][1];
//    self.group_fieldL = view.leftArray[view.leftSelectIndex][0];
//    if (view.isLeftSelectDown == YES) {
//        self.group_sort_typeL = @"desc";
//        self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
//    }else{
//        self.group_sort_typeL = @"asc";
//        self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_up"];
//    }
//    
//    [self configData];
    
    if (view.isLeftTable) {
        self.popupViewLeft.sortLabel.text = view.leftArray[view.leftSelectIndex][1];
        self.group_fieldL = view.leftArray[view.leftSelectIndex][0];
        if (view.isLeftSelectDown == YES) {
            self.group_sort_typeL = @"desc";
            self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_down"];
        }else{
            self.group_sort_typeL = @"asc";
            self.popupViewLeft.sortDownImageView.image = [UIImage imageNamed:@"p_menu_up"];
        }
    }else{
        self.popupViewLeft.segLabel.text = view.rightArray[view.rightSelectIndex][1];
        self.group_typeL = view.rightArray[view.rightSelectIndex][0];
    }
    [self configData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
