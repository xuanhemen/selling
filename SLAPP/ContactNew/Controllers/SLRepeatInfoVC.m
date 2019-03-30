//
//  SLRepeatInfoVC.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLRepeatInfoVC.h"
#import "Masonry.h"
#import "SLRepeatInfoCell.h"
#import "SLRepeatInfoModel.h"
#import "SLChooseView.h"
#import "SLRepeatPopModel.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "SVProgressHUD.h"
@interface SLRepeatInfoVC ()<UITableViewDelegate,UITableViewDataSource>

/** tableview */
@property(nonatomic,strong)UITableView * tableView;

@end

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

@implementation SLRepeatInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重复信息";
    /**创建左右导航按钮*/
    [self createNavigationButtons];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}
 /**创建左右导航按钮*/
-(void)createNavigationButtons
{
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTheCurrentView)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"直接创建" style:UIBarButtonItemStylePlain target:self action:@selector(createContactsDirectly)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}
/**取消当前视图*/
-(void)cancelTheCurrentView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**直接创建联系人*/
-(void)createContactsDirectly
{
    NSMutableDictionary * para = [self parameters];
    para[@"client_id"] = @"";
    para[@"status"] = @"1";
    [self createContactWithContactId:para];
    
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [self footView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.width.mas_equalTo(self.view.frame.size.width);
        }];
    }
    return _tableView;
}
-(UILabel *)footView
{
    UILabel * remind = [[UILabel alloc]init];
    remind.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    remind.text = @"系统中存在相似的联系人信息";
    remind.textAlignment = NSTextAlignmentCenter;
    remind.textColor = [UIColor whiteColor];
    remind.font = [UIFont boldSystemFontOfSize:14];
    remind.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    return remind;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLRepeatInfoModel * model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.jurisdiction isEqualToString:@"1"]) {
        return 140;
    }
    return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLRepeatInfoModel * model = [self.dataArr objectAtIndex:indexPath.row];
    if ([model.jurisdiction isEqualToString:@"1"]) {
        SLRepeatInfoCell *cell = [[SLRepeatInfoCell alloc]init];
        [cell setCellWithModel:model];
        cell.mergeBtn.tag = indexPath.row;
        [cell.mergeBtn addTarget:self action:@selector(popContrastInformationView:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        SLRepeatCell * cell = [[SLRepeatCell alloc]init];
        [cell setCellWithModel:model];
        return cell;
    }
    
    
}
-(void)popContrastInformationView:(UIButton *)button
{
    SLRepeatInfoModel *model = [self.dataArr objectAtIndex:button.tag];
    NSMutableArray * array = [NSMutableArray array];
    NSArray *titleArr = @[@"姓名",@"生日",@"微信",@"QQ",@"邮件",@"备注"];
    NSArray *arr = @[@"name",@"birthday",@"wechat",@"qq",@"email",@"more"];
    for (int i = 0; i<6; i++) {
        SLRepeatPopModel * popModel = [[SLRepeatPopModel alloc]init];
        popModel.styleStr = [titleArr objectAtIndex:i];
        NSString * key = [arr objectAtIndex:i];
        popModel.firName = [model valueForKey:key];
        popModel.secName = [self.commitModel valueForKey:key];
        if (!IsStrEmpty(popModel.firName)&&!IsStrEmpty(popModel.secName)&&![popModel.firName isEqualToString:popModel.secName]) {
            [array addObject:popModel];
        }
    }
    if ([array count] == 0) {
        NSLog(@"合并==直接创建");
        NSMutableDictionary * parameters = [self parameters];
        [self createContactWithContactId:parameters];
        return;
    }
    NSMutableDictionary * para = [self parameters];
    [SLChooseView showViewWithArr:array passVlue:^(NSMutableDictionary *dic) {
        
        NSArray * keyArr = [dic allKeys];
        for (NSString *key in keyArr) {
            para[key] = [dic objectForKey:key];
        }
       
        
    } commit:^{
        [self createContactWithContactId:para];
    }];
   
}
-(NSMutableDictionary *)parameters{
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    UserModel *model = [UserModel getUserModel];
    SLRepeatInfoModel * infoModel = [self.dataArr objectAtIndex:0];
    parameter[@"token"] = model.token;
    parameter[@"client_id"] = self.commitModel.client_id;
    parameter[@"client_name"] = self.commitModel.client_name;
    parameter[@"contact_name"] = self.commitModel.name;
    parameter[@"phone"] = self.commitModel.phone;
    parameter[@"contact_id"] = infoModel.numberID;
    /*********以上字段为必填**********/
    parameter[@"position_name"] = self.commitModel.position_name;
    parameter[@"dep"] = self.commitModel.dep;
    parameter[@"sex"] = self.commitModel.sex;
    parameter[@"birthday"] = self.commitModel.birthday;
    parameter[@"weixin"] = self.commitModel.wechat;
    parameter[@"qq"] = self.commitModel.qq;
    parameter[@"email"] = self.commitModel.email;
    parameter[@"particulars"] = self.commitModel.more;
    parameter[@"status"] = @"2";
    return parameter;
}
/**合并联系人*/
-(void)createContactWithContactId:(NSMutableDictionary *)parameter
{
    kWeakS(weakSelf);
    [self showProgressWithStr:@"正在保存联系人..."];
    NSString * urlStr = @"pp.contact.contact_international_waters_add_not_judge";
    NSString * remindStr;
    if ([parameter[@"status"] isEqualToString:@"1"]) {
        remindStr = @"创建成功";
    }else{
        remindStr = @"合并成功";
    }
    NSLog(@"直接骂%@",parameter);
    [HYBaseRequest getPostWithMethodName:urlStr Params:parameter showToast:YES Success:^(NSDictionary *result) {
        NSLog(@"结果%@",result);
        [weakSelf dismissProgress];
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        [SVProgressHUD showSuccessWithStatus:remindStr];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.notice();
        });
        [self dismissViewControllerAnimated:true completion:nil];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
