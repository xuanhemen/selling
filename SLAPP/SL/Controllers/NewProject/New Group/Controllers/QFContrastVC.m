//
//  QFContrastVC.m
//  SLAPP
//
//  Created by qwp on 2018/8/28.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFContrastVC.h"
#import "QFHeader.h"
#import "QFCheckView.h"
#import "SLAPP-Swift.h"
#import "UIColor+RCColor.h"
@interface QFContrastVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *checkArray;
@property (nonatomic,strong) UIView *tableHeaderView;
@property (nonatomic,strong) UIView *contrastView;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) CGFloat contrastViewY;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *labelBackView;

@end

@implementation QFContrastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"对比";
    self.contrastViewY = 0;
    self.selectArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:self.baseSelectArray];
    
    [self configData];
    [self uiConfig];
    
    NSLog(@"%@",self.baseDict[@"source_events"]);
    
    
    
    
}

- (void)configData{
    [self.dataArray removeAllObjects];
    NSMutableArray *subArray = [NSMutableArray array];
    NSArray *planArray = self.baseDict[@"source_events"];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    
    for (int index=0; index<planArray.count; index++) {
        NSDictionary *subDict = planArray[index];
        
        BOOL isExit = NO;
        for (NSString *date in dateArray) {
            if ([date isEqualToString:subDict[@"date"]]) {
                isExit = YES;
            }
        }
        if (isExit == NO) {
            [dateArray addObject:subDict[@"date"]];
        }
    }
    for (NSString *date in dateArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<planArray.count; i++) {
            NSDictionary *sDict = planArray[i];
            if ([date isEqualToString:sDict[@"date"]]) {
                [array addObject:sDict];
            }
        }
        [self.dataArray addObject:array];
    }
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    [tabVC.tab setHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    ProjectSituationTabVC *tabVC = (ProjectSituationTabVC *)self.tabBarController;
    [tabVC.tab setHidden:NO];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)uiConfig{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    self.checkArray = self.baseDict[@"contrast"];
    CGFloat checkHeight = [self configCheckListViewWithArray:self.checkArray];
    
    NSArray *array = [NSArray arrayWithObjects:self.baseDict[@"title_one"],self.baseDict[@"title_two"],nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    segment.frame = CGRectMake(15, checkHeight, kScreenWidth-30, 40);
    segment.userInteractionEnabled = NO;
    segment.tintColor = UIColorFromRGB(0x666666);
    [self.tableHeaderView addSubview:segment];
    self.contrastViewY = 40+checkHeight;
    [self configContrastView];
    
}

- (CGFloat)configCheckListViewWithArray:(NSArray *)array{
    
    __weak QFContrastVC *weakSelf = self;
    
    
    CGFloat height = 0;
    if (array.count%3 == 0) {
        height = array.count/3*50;
    }else{
        height = (array.count/3+1)*50;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self.tableHeaderView addSubview:backView];
    
    for (int i=0; i<array.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10+((kScreenWidth-40)/3+10)*(i%3), i/3*50, (kScreenWidth-40)/3, 50)];
        [backView addSubview:view];
        
        QFCheckView *checkView = [[QFCheckView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        checkView.tag = 100+i;
        NSString *keyString = self.checkArray[i][@"key"];
        for (NSString *str in self.selectArray) {
            if ([keyString isEqualToString:str]) {
                [checkView check];
            }
        }
        checkView.checkBlock = ^(BOOL isCheck, QFCheckView *sender) {
            NSString *key = weakSelf.checkArray[sender.tag-100][@"key"];
            if (isCheck) {
                [weakSelf.selectArray addObject:key];
            }else{
                [weakSelf.selectArray removeObject:key];
            }
            [weakSelf configContrastView];
        };
        [view addSubview:checkView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, view.frame.size.width-40, 30)];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:15];
        label.text = array[i][@"name"];
        [view addSubview:label];
    }
    
    return height;
}

- (void)configContrastView{
    if (self.contrastView) {
        [self.contrastView removeFromSuperview];
    }
    
    NSArray *oneDataArray = self.baseDict[@"re_one_arr"];
    NSArray *twoDataArray = self.baseDict[@"re_two_arr"];
    
    CGFloat subViewHeight = 30 * self.selectArray.count + 20 + (self.selectArray.count-1)*5;
    CGFloat viewHeight = oneDataArray.count>twoDataArray.count?oneDataArray.count*subViewHeight+10:twoDataArray.count*subViewHeight+10;
    
    self.contrastView = [[UIView alloc] initWithFrame:CGRectMake(20, self.contrastViewY, kScreenWidth-40, viewHeight)];
    [self.tableHeaderView addSubview:self.contrastView];
    
    
    for (int i=0; i<oneDataArray.count; i++) {
        
        CGRect rect = CGRectMake(0, 5+subViewHeight*i, self.contrastView.frame.size.width/2-10, subViewHeight);
        [self configSubViewWithFrame:rect andData:oneDataArray[i]];
    }
    for (int i=0; i<twoDataArray.count; i++) {
        CGRect rect = CGRectMake(self.contrastView.frame.size.width/2+10, 5+subViewHeight*i, self.contrastView.frame.size.width/2-10, subViewHeight);
        [self configSubViewWithFrame:rect andData:twoDataArray[i]];
        
    }
    
    if (self.labelBackView) {
        [self.labelBackView removeFromSuperview];
    }
    
    self.labelBackView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight+self.contrastViewY, kScreenWidth, 40)];
    self.labelBackView.backgroundColor = UIColorFromRGB(0xE2E2E2);
    [self.tableHeaderView addSubview:self.labelBackView];
    
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 40)];
    tipLabel.text = @"相关行动记录";
    tipLabel.font = [UIFont systemFontOfSize:14];
    [self.labelBackView addSubview:tipLabel];
    
    
    self.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, viewHeight+self.contrastViewY+40);
    [self.tableView reloadData];
    
}
- (void)configSubViewWithFrame:(CGRect)frame andData:(NSDictionary *)dict{
    UIView *subView = [[UIView alloc] initWithFrame:frame];
    [self.contrastView addSubview:subView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, subView.frame.size.height/2-15, 30, 30)];
    grayView.backgroundColor = UIColorFromRGB(0x999999);
    grayView.layer.cornerRadius = 15;
    grayView.clipsToBounds = YES;
    [subView addSubview:grayView];
    
    NSString *name = [NSString stringWithFormat:@"%@",dict[@"name"]];
    if (name.length == 0) {
        name = @"未知";
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, grayView.frame.size.width-2, grayView.frame.size.height-2)];
    nameLabel.backgroundColor = UIColorFromRGB(0xFFFFFF);
    nameLabel.text = [name substringWithRange:NSMakeRange(0, 1)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = UIColorFromRGB(0x666666);
    
    nameLabel.layer.cornerRadius = nameLabel.frame.size.width/2;
    nameLabel.clipsToBounds = YES;
    [grayView addSubview:nameLabel];
    
    NSArray *dArray = dict[@"data"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<self.checkArray.count; i++) {
        NSString *keyString = self.checkArray[i][@"key"];
        for (NSString *key in self.selectArray) {
            if ([key isEqualToString:keyString]) {
                [arr addObject:key];
            }
        }
    }
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:arr];
    
    for (int i=0; i<self.selectArray.count; i++) {
        
        NSDictionary *currentDict;
        NSString *key = self.selectArray[i];
        
        for (int j=0; j<dArray.count; j++) {
            NSDictionary *subDict = dArray[j];
            if ([key isEqualToString:subDict[@"key"]]) {
                currentDict = subDict;
            }
        }

        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(40, 10+35*i, subView.frame.size.width-40, 30)];
        backView.backgroundColor = [UIColor colorWithHexString:currentDict[@"color"] alpha:1];
        [subView addSubview:backView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backView.frame.size.width/2, 30)];
        nameLabel.textColor = UIColorFromRGB(0x333333);
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.text = [NSString stringWithFormat:@"%@:",currentDict[@"name"]];
        nameLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:nameLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width/2, 0, backView.frame.size.width/2, 30)];
        valueLabel.textColor = UIColorFromRGB(0x333333);
        valueLabel.font = [UIFont systemFontOfSize:10];
        valueLabel.text = [NSString stringWithFormat:@"%@",currentDict[@"value"]];
        valueLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:valueLabel];
        
    }
    
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0,0,kScreenWidth,30);
    UIView *headerView = [[UIView alloc] initWithFrame:frame];
    headerView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    NSDictionary *dict = self.dataArray[section][0];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, headerView.frame.size.width-30, 20)];
    titleLabel.text = dict[@"date"];
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [headerView addSubview:titleLabel];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"QFProjectPlanCell";
    QFProjectPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[QFProjectPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *array = self.dataArray[indexPath.section];
    [cell setDictWithDict:array[indexPath.row]];
    //cell?.setData(model: self.dataArray[indexPath.section][indexPath.row])
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *modelDict = self.dataArray[indexPath.section][indexPath.row];
    QFProjectPlanDetailVC *vc = [[QFProjectPlanDetailVC alloc] init];
    
    
    QFProjectPlanModel *model = [[QFProjectPlanModel alloc] init];
    model.action_style = modelDict[@"action_style"];
    model.action_style_name = modelDict[@"action_style_name"];
    model.action_target = modelDict[@"action_target"];
    model.corpid = modelDict[@"corpid"];
    model.date = modelDict[@"date"];
    model.date_d = modelDict[@"date_d"];
    model.date_m = modelDict[@"date_m"];
    model.date_n = modelDict[@"date_n"];
    model.date_y = modelDict[@"date_y"];
    model.id = modelDict[@"id"];
    model.is_achieve = modelDict[@"is_achieve"];
    model.logic_id = modelDict[@"logic_id"];
    model.overtime = modelDict[@"overtime"];
    model.people_name = modelDict[@"people_name"];
    model.peopleid = modelDict[@"peopleid"];
    model.projectid = modelDict[@"projectid"];
    
    vc.model = self.model;
    vc.isProjectIn = YES;
    vc.planModel = model;
    [self.navigationController pushViewController:vc animated:YES];

    
}
@end
