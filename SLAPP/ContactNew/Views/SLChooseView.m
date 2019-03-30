//
//  SLChooseView.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLChooseView.h"
#import "SLRepeatInfoCell.h"
#import "SLRepeatPopModel.h"
#import "UIButton+SLFunc.h"
#import "UIColor+Function.h"
#define color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define screen_width [UIScreen mainScreen].bounds.size.width
@interface SLChooseView()

@property(nonatomic,strong)NSMutableArray * btnArr;

@property(nonatomic,strong)NSMutableDictionary *parameterDic;
@end
@implementation SLChooseView

static SLChooseView * _chooseView = nil;

+(void)showViewWithArr:(NSMutableArray *)dataArr passVlue:(PassOpitionDic)dic commit:(CommitInfo)commit
{
    //    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        _chooseView = [[SLChooseView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _chooseView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _chooseView.windowLevel = UIWindowLevelAlert;
        _chooseView.hidden = NO;
        _chooseView.dataArr = dataArr;
        _chooseView.passOpitionDic = dic;
        _chooseView.commitInfo = commit;
        [_chooseView createDataView];
    // });
}
-(void)createDataView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self headView];
    _tableView.tableFooterView = [self footView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.center = _chooseView.center;
    _tableView.bounds = CGRectMake(0, 0, screen_width-40, _chooseView.dataArr.count*100+100);
    [self addSubview:_tableView];
    }
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLRepeatPopModel * model = [self.dataArr objectAtIndex:indexPath.row];
    SLChooseCell * cell = [[SLChooseCell alloc]init];
    cell.title.text = model.styleStr;
    cell.firBtn.indentifierStr = model.firName;
    cell.firBtn.tag = indexPath.row;
    cell.firName.text = model.firName;
    cell.secBtn.indentifierStr = model.secName;
    cell.secBtn.tag = indexPath.row;
    cell.secName.text = model.secName;
    [cell.firBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [cell.secBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * selecBtn = [UIButton new];
    selecBtn.tag = indexPath.row;
    [self.btnArr addObject:selecBtn];
    return cell;
}
-(void)click:(UIButton *)button
{
    UIButton * selectedBtn = [self.btnArr objectAtIndex:button.tag];
    if (button != selectedBtn) {
        selectedBtn.selected = NO;
        button.selected = YES;
    }
    selectedBtn = button;
    [self.btnArr replaceObjectAtIndex:button.tag withObject:selectedBtn];
    
    SLRepeatPopModel * model = [self.dataArr objectAtIndex:button.tag];
    if ([model.styleStr isEqualToString:@"姓名"]) {
       self.parameterDic[@"contact_name"] = button.indentifierStr;
    }else if ([model.styleStr isEqualToString:@"生日"]){
       self.parameterDic[@"birthday"] = button.indentifierStr;
    }else if ([model.styleStr isEqualToString:@"微信"]){
        self.parameterDic[@"weixin"] = button.indentifierStr;
    }else if ([model.styleStr isEqualToString:@"QQ"]){
       self.parameterDic[@"qq"] = button.indentifierStr;
    }else if ([model.styleStr isEqualToString:@"邮件"]){
       self.parameterDic[@"email"] = button.indentifierStr;
    }else if ([model.styleStr isEqualToString:@"备注"]){
       self.parameterDic[@"particulars"] = button.indentifierStr;
    }
    self.passOpitionDic(_parameterDic);
}
-(UIView *)footView
{
    UIView * footView = [[UIView alloc]init];
    footView.backgroundColor = color(245, 245, 245, 1);
    footView.frame = CGRectMake(0, 0, screen_width, 50);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提 交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4;
    btn.backgroundColor = [UIColor colorWithHexString:@"#25b673"];
    [btn addTarget:self action:@selector(commitInfos) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView);
        make.centerY.equalTo(footView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(120, 40));
    }];
    return footView;
}
-(void)commitInfos
{
    self.commitInfo();
    [self remove];
}
-(UIView *)headView
{
    UIView * headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, screen_width, 50);
    headView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    UILabel * lable = [[UILabel alloc]init];
    lable.text = @"合并信息";
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont boldSystemFontOfSize:17];
    lable.textAlignment = NSTextAlignmentCenter;
    [lable sizeToFit];
    [headView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headView);
    }];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"mrDelete"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.right.equalTo(headView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    return headView;
}
-(void)remove
{
    _chooseView.hidden = YES;
    _chooseView = nil;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableDictionary *)parameterDic
{
    if (!_parameterDic) {
        _parameterDic = [NSMutableDictionary dictionary];
    }
    return _parameterDic;
}
@end
