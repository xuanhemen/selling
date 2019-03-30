//
//  SLDeleteProjectVC.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLDeleteProjectVC.h"
#import "SLDetailProjectCell.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
@interface SLDeleteProjectVC ()<UITableViewDataSource,UITableViewDelegate>
/** 列表 */
@property(nonatomic,strong)UITableView * tableView;

/**装参数*/
@property(nonatomic,strong)NSMutableDictionary * paraDic;

/** <#annotation#> */
@property(nonatomic,copy)NSString *urlStr;
@end

@implementation SLDeleteProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择项目";
    
    NSString * rightStr;
    if ([self.indentifer isEqualToString:@"delete"]) {
        rightStr = @"移除";
        self.urlStr = @"pp.contact.del_batch_contact_to_pro";
    }else if ([self.indentifer isEqualToString:@"add"]){
         rightStr = @"确定";
         self.urlStr = @"pp.contact.add_batch_contact_to_pro";
        [self requestAddProject];
    }
    UIBarButtonItem * editBarItem = [[UIBarButtonItem alloc]initWithTitle:rightStr style:UIBarButtonItemStylePlain target:self action:@selector(ActionObject)];
    self.navigationItem.rightBarButtonItem = editBarItem;
    UIBarButtonItem * cancelBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = editBarItem;
    self.navigationItem.leftBarButtonItem = cancelBarItem;
    
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}
/**编辑*/
-(void)ActionObject
{
    NSArray * arr = [self.paraDic allValues];
    NSMutableString * paraStr = [NSMutableString string];
    for (int i = 0; i<[arr count]; i++) {
        NSString * string = [arr objectAtIndex:i];
        if (i==0) {
            [paraStr appendFormat:@"%@",string];
        }else{
             [paraStr appendFormat:@",%@",string];
        }
    }
   __weak SLDeleteProjectVC * weakSelf = self;
    UserModel * model = [UserModel getUserModel];
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = model.token;
    parameter[@"contact_id"] = self.contact_id;
    parameter[@"client_id"] = self.client_id;
    parameter[@"project_ids"] = paraStr;
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:self.urlStr Params:parameter showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSLog(@"结果%@",result);
        /**通知刷新项目列表*/
        self.notice();
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}
-(void)requestAddProject
{
    __weak SLDeleteProjectVC * weakSelf = self;
    UserModel * model = [UserModel getUserModel];
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = model.token;
    parameter[@"contact_id"] = self.contact_id;
    parameter[@"client_id"] = self.client_id;
    
    NSString * urlStr = @"pp.contact.contact_particulars_not_pro";
    
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
-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[SLDetailDeleteCell class] forCellReuseIdentifier:@"cell"];
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
    SLDetailDeleteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    SLProjectModel * model = [self.dataArr objectAtIndex:indexPath.row];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setCellWithModel:model];
    
    return cell;
}
-(void)deleteClicked:(UIButton *)button
{
    SLProjectModel * model = [self.dataArr objectAtIndex:button.tag];
    NSString * key = [NSString stringWithFormat:@"%ld",(long)button.tag];
    button.selected = !button.selected;
    if (button.selected == YES) {
        [self.paraDic setObject:model.numberID forKey:key];
    }else{
        [self.paraDic removeObjectForKey:key];
    }
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableDictionary *)paraDic
{
    if (!_paraDic) {
        _paraDic = [NSMutableDictionary dictionary];
    }
    return _paraDic;
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
