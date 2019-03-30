//
//  HYCommonView.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYCommonView.h"
#import "HYHomeView.h"
#import "HYHomeCell.h"
#import "HYHomeSectionHeaderView.h"
#import "HYHomeTableHeaderView.h"
@implementation HYCommonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
     kWeakS(weakSelf);
    CGFloat viewHeight = (kScreenWidth-80)/3+20;
    HYHomeView *top = [[HYHomeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, viewHeight)];
    [self addSubview:top];
    weakSelf.top = top;
    top.btnClick = ^(NSInteger tag, NSString *key) {
        if (weakSelf.btnClick) {
            weakSelf.btnClick(tag, key);
        }
    };
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(top.frame), kScreenWidth, self.frame.size.height-top.frame.size.height-10) style:UITableViewStyleGrouped];
    [_table registerClass:[HYHomeCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    HYHomeTableHeaderView *head = [[HYHomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    _table.tableHeaderView = head;
    self.head = head;
    self.head.action = ^(HomeRemindModel *model) {
        if (weakSelf.clickHeadWithModel) {
            weakSelf.clickHeadWithModel(model);
        }
    };
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor whiteColor];
    
   
    return view;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HYHomeSectionHeaderView *header = [[HYHomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    if (_model && _model.remind) {
        HYHomeContentModel * cModel = _model.remind[section];
        header.titleLab.text = cModel.name;
        if ([cModel.key isEqualToString:@"schedule"]) {
            header.iconImage.image = [UIImage imageNamed:@"backLog"];
        }else if ([cModel.key isEqualToString:@"smart_reminder"]) {
            header.iconImage.image = [UIImage imageNamed:@"aiRemind"];
        }
        
        
        
    }
    return header;
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (_model && _model.remind) {
        HYHomeContentModel * cModel = _model.remind[indexPath.section];
        cell.model = cModel.list[indexPath.row];
    }
    kWeakS(weakSelf);
    cell.clickCellWithModel = ^(HYHomeContentDetailModel *model) {
        if (weakSelf.clickCellWithModel) {
            weakSelf.clickCellWithModel(model);
        }
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model && _model.remind) {
        HYHomeContentModel * cModel = _model.remind[section];
        if (cModel.list) {
            return cModel.list.count;
        }else{
            return 0;
        }
        
    }
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_model && _model.remind) {
        
        return _model.remind.count;
    }
    return 0;
}



-(void)setModel:(HYHomeModel *)model{
    _model = model;
    
    NSMutableArray * listArray = [NSMutableArray array];
    for (HomeRemindModel *rModel in _model.list) {
        if ([rModel.exists isEqualToString:@"0"]) {
            [listArray addObject:rModel];
        }
    }
    [_table reloadData];
    self.head.list = listArray;
    
}


@end
