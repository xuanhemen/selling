//
//  SLContactDetailObjcVC.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLContactDetailObjcVC.h"
#import "SLContactDetailView.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "SLProjectModel.h"
#import "SLDetailProjectCell.h"
#import "SLDeleteProjectVC.h"
@interface SLContactDetailObjcVC ()<UITableViewDataSource,UITableViewDelegate>
/** 列表 */
@property(nonatomic,strong)UITableView * tableView;

/** <#annotation#> */
@property(nonatomic,strong)NSMutableArray * dataArr;

@end

@implementation SLContactDetailObjcVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"项目列表";
    /**请求项目数据*/
    [self requestData];
   
    UIBarButtonItem * editBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ch_product_edit_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
     UIBarButtonItem * addBarItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject)];
    self.navigationItem.rightBarButtonItems = @[addBarItem,editBarItem];
    // Do any additional setup after loading the view.
}
/**编辑*/
-(void)edit
{
    SLDeleteProjectVC * dvc = [[SLDeleteProjectVC alloc]init];
    dvc.indentifer = @"delete";
    dvc.notice = ^{
         [self requestData];
    };
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:dvc];
    dvc.dataArr = self.dataArr;
    dvc.contact_id = self.contact_id;
    dvc.client_id = self.client_id;
    [self presentViewController:nvc animated:YES completion:nil];
}
/**添加项目*/
-(void)addProject
{
    SLDeleteProjectVC * dvc = [[SLDeleteProjectVC alloc]init];
    dvc.indentifer = @"add";
    dvc.notice = ^{
        [self requestData];
    };
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:dvc];
   // dvc.dataArr = self.dataArr;
    dvc.contact_id = self.contact_id;
    dvc.client_id = self.client_id;
    [self presentViewController:nvc animated:YES completion:nil];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[SLDetailProjectCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, -K_SAFE_HEIGHT, 0));
        }];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLDetailProjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SLProjectModel * model = [self.dataArr objectAtIndex:indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLProjectModel * model = [self.dataArr objectAtIndex:indexPath.row];
    PublicPush *push = [[PublicPush alloc] init];
    [push pushToProjectVCWithId:model.numberID];

}
-(void)requestData
{
    __weak SLContactDetailObjcVC * weakSelf = self;
    UserModel * model = [UserModel getUserModel];
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = model.token;
    parameter[@"contact_id"] = self.contact_id;
    parameter[@"client_id"] = self.client_id;
    
    NSString * urlStr = @"pp.contact.contact_particulars_pro";
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlStr Params:parameter showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSLog(@"结果%@",result);
        NSArray * arr = [result objectForKey:@"data"];
        NSArray * array = [SLProjectModel mj_objectArrayWithKeyValuesArray:arr];
        NSLog(@"结果 array %@",array);
        self.dataArr = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
       
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
