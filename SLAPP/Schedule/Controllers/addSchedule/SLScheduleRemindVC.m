//
//  SLScheduleRemindVC.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheduleRemindVC.h"

@interface SLScheduleRemindVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *tableView;

@property(nonatomic)NSArray * dataArr;

@property(nonatomic)NSArray * array;
@end

@implementation SLScheduleRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提醒";
    
    _dataArr = @[@"无",@"30分钟前",@"1小时前",@"半天前",@"1天前"];
    
    _array = @[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:30],[NSNumber numberWithInteger:60],[NSNumber numberWithInteger:12*60],[NSNumber numberWithInteger:24*60]];
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.font = font(16);
    cell.textLabel.textColor = color_normal;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",_array[indexPath.row]);
    NSNumber *num = _array[indexPath.row];
    NSInteger hour = [num integerValue];
    NSInteger seconds = hour*60;
    NSLog(@"小时%ld秒%ld",(long)hour,(long)seconds);
    self.passRemindTime(cell.textLabel.text,seconds);
    [self.navigationController popViewControllerAnimated:YES];
    
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
