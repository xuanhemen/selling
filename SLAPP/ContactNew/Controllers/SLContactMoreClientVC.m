//
//  SLContactMoreClientVC.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLContactMoreClientVC.h"
#import "SLContactClientCell.h"
#import "HYContactDetailVC.h"
@interface SLContactMoreClientVC ()<UITableViewDelegate,UITableViewDataSource>

/** 列表 */
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation SLContactMoreClientVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系人详情";
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, -K_SAFE_HEIGHT, 0));
        }];
    }
    return _tableView;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }
    return 120;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [self.phoneArr count];
    }
    return [self.dataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSString * phoneStr = self.phoneArr[indexPath.row];
        UITableViewCell * cell = [[UITableViewCell alloc]init];
        cell.userInteractionEnabled = NO;
        cell.textLabel.text = [NSString stringWithFormat:@"手机：%@",phoneStr];
        return cell;
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        static NSString * indentifier = @"cell";
        SLContactClientCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[SLContactClientCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        SLContactClientModel * model = [self.dataArr objectAtIndex:indexPath.row];
        [cell setCellWithModel:model];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLContactClientModel * model = [self.dataArr objectAtIndex:indexPath.row];
    HYContactDetailVC * cvc = [[HYContactDetailVC alloc]init];
    cvc.contact_id = model.contact_id;
    cvc.client_id = model.client_id;
    [self.navigationController pushViewController:cvc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor whiteColor];
        UILabel * name = [[UILabel alloc]init];
        name.text = self.name;
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:17];
        [headView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.equalTo(headView).offset(15);
        }];
        return headView;
    }else{
        UIView * headView = [[UIView alloc]init];
        headView.backgroundColor = COLOR(240, 240, 240, 1);
        UILabel * name = [[UILabel alloc]init];
        name.text = @"客户信息";
        name.textColor = [UIColor blackColor];
        name.font = [UIFont systemFontOfSize:15];
        [headView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.equalTo(headView).offset(15);
        }];
        return headView;
    }
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
