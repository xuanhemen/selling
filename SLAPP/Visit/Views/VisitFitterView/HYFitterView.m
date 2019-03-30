//
//  HYFitterView.m
//  SLAPP
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "HYVisitFitterModel.h"
#import "HYFitterView.h"
#import "LeftCell.h"
#import "FitlerRightCell.h"
#import "UIView+LoadNib.h"
@interface HYFitterView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *leftTable;
@property(nonatomic,strong)UITableView *rightTable;
@property(nonatomic,strong)NSIndexPath *currentLeftIndex;
@property(nonatomic,strong)NSIndexPath *currentRightIndex;
@property(nonatomic,strong)NSMutableArray *alreadyArray;
//当前部门id
@property(nonatomic,strong)NSString *currentDepParentId;
@property(nonatomic,strong)NSString *lastDepParentId;
@end
@implementation HYFitterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
        _currentLeftIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        _currentDepParentId = @"0";
    }
    return self;
}



/**
 配置已经选择的项
 
 @param array <#array description#>
 */
-(void)configAlready:(NSArray *)array{
    
    if ([array isNotEmpty]) {
        
        if (_alreadyArray.count == array.count) {
            [_alreadyArray removeAllObjects];
            [_alreadyArray addObjectsFromArray:array];
            [_leftTable reloadData];
            [_rightTable reloadData];
        }
       
    }
    
}

- (void)setAllData:(NSArray *)allData{
    _allData = allData;
    
    if ([_allData isNotEmpty]) {
        _alreadyArray = [[NSMutableArray alloc]initWithCapacity:_allData.count];
        for (id a in _allData) {
            [_alreadyArray addObject:@""];
        }
    }
    
    [_leftTable reloadData];
    [_rightTable reloadData];
    
}


-(void)configUI{
    
    _leftTable  =  [UITableView new];
    _rightTable = [UITableView new];
    [self addSubview:_leftTable];
    [self addSubview:_rightTable];
    
    _leftTable.backgroundColor = [UIColor whiteColor];
    _rightTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *view = [UIView new];
    _rightTable.tableFooterView = view;
    _leftTable.tableFooterView = view;
    
    
    [_leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(120);
        make.bottom.mas_equalTo(-50);
    }];
    
    kWeakS(weakSelf);
    [_rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.left.equalTo(weakSelf.leftTable.mas_right).offset(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    _leftTable.delegate = self;
    _leftTable.dataSource = self;
    _rightTable.delegate = self;
    _rightTable.dataSource = self;
    
    
    
    
    NSArray *images = @[@"filter_cancel",@"filter_reset",@"filter_ok"];
    NSArray *imagesSelect = @[@"filter_cancel_press",@"filter_reset_press",@"filter_ok_press"];
    for (int i = 0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.frame.size.width/3.0*i,self.frame.size.height-50,self.frame.size.width/3.0, 50);
        
        btn.tag = 1000+i;
        btn.titleLabel.font = kFont(14);
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:kgreenColor forState:UIControlStateHighlighted];
        [btn setTitleColor:kgreenColor forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imagesSelect[i]] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:imagesSelect[i]] forState:UIControlStateHighlighted];
        //            btn.imageEdgeInsets =
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        if (i == 0){
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }else if (i == 1)
        {
            [btn setTitle:@"重置" forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    for (int i = 1; i<3; i++)
    {
        UIView*line = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/3.0*i,self.frame.size.height-50,0.7, 50)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    UIView*line = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50,self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    UIView*lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height,self.frame.size.width, 0.5)];
    lineBottom.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineBottom];
    
}


#pragma mark -- 底端按钮点击响应时间 （重置，确定）
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1000){
      
    }
    else  if (btn.tag == 1001)
    {
        [self.alreadyArray removeAllObjects];
    }
    else if (btn.tag == 1002)
    {
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(fitter:AndResultArray: isCancel:)]) {
        [_delegate fitter:self AndResultArray:self.alreadyArray isCancel:btn.tag == 1000];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_leftTable isEqual:tableView]) {
        if (_allData) {
             return [_allData count];
        }
        return 0;
    }else{
        
        if (_allData) {
            
            HYVisitFitterModel *model = _allData[_currentLeftIndex.row];
            DLog(@"%@",model.key);
            if ([model.key isEqualToString:@"dep"]) {
                return [self currentShowDepModel].count;
            }else{
                return [model.list isNotEmpty] ? model.list.count : 0;
            }
            
        }
        return 0;
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_leftTable]) {
        return  [self configLeftCellWith:tableView Index:indexPath];
    }else{
        return [self configRightCellWith:tableView Index:indexPath];
    }
}

-(UITableViewCell *)configLeftCellWith:(UITableView *)tableView Index:(NSIndexPath*)indexPath{
    static NSString *cellName = @"cellLeft";
    LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LeftCell" owner:self options:nil]lastObject];
    }
    HYVisitFitterModel *model = _allData[indexPath.row];
    cell.model = model;
    [cell prepareForReuse];
    if ([indexPath isEqual:_currentLeftIndex]) {
        cell.leftlable.textColor = kgreenColor;
    }

    if ([self.alreadyArray[indexPath.row] isKindOfClass:[HYVisitFitterSubModel class]]) {
        cell.leftlable.textColor = kgreenColor;
    }
    
    
    return cell;
}



-(UITableViewCell *)configRightCellWith:(UITableView *)tableView Index:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellRight";
    FitlerRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FitlerRightCell" owner:self options:nil]lastObject];
    }
    [cell prepareForReuse];
    HYVisitFitterModel *model = _allData[_currentLeftIndex.row];
    if ([model.key isEqualToString:@"dep"]) {
        cell.model =  [self currentShowDepModel][indexPath.row];
    }else{
        cell.model = model.list[indexPath.row];
    }
    kWeakS(weakSelf);
    __weak typeof(cell)weakCell = cell;
    [cell arrowClick:^{
        weakSelf.currentDepParentId = weakCell.model.id;
        [weakSelf.rightTable reloadData];
    }];
    
    
    
    if ([_alreadyArray[_currentLeftIndex.row] isKindOfClass:[HYVisitFitterSubModel class]]) {
        HYVisitFitterSubModel * aModel = _alreadyArray[_currentLeftIndex.row];
        if ([aModel.id isEqualToString:cell.model.id]) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
    }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTable) {
        _currentLeftIndex = indexPath;
        _currentRightIndex = nil;
        [_leftTable reloadData];
        [_rightTable reloadData];
    }else{
        _currentRightIndex = indexPath;
        
        HYVisitFitterModel *model = _allData[_currentLeftIndex.row];
        
        if ([model.key isEqualToString:@"dep"]) {
             HYVisitFitterSubModel *subModel =  [self currentShowDepModel][indexPath.row];
            if ([subModel.id isEqualToString:@"-1"]) {
               
                _currentDepParentId = [self getCurrentId];
            }else{
                subModel.key = model.key;
                [_alreadyArray replaceObjectAtIndex:_currentLeftIndex.row withObject:subModel];
            }
        }else{
            HYVisitFitterSubModel *subModel = model.list[indexPath.row];
            subModel.key = model.key;
            [_alreadyArray replaceObjectAtIndex:_currentLeftIndex.row withObject:subModel];
        }
        [_rightTable reloadData];
    }
}


-(NSString *)getCurrentId{
    
    if ([_allData isNotEmpty] && _allData[_currentLeftIndex.row] != nil){
        HYVisitFitterModel *model = _allData[_currentLeftIndex.row];
        if ([model.list isNotEmpty]) {
            for (HYVisitFitterSubModel *sub in model.list) {
                if ([sub.id isEqualToString:_currentDepParentId]) {
                    return sub.parentid;
                    break;
                }
            }
        }else{
            return @"0";
        }
    }
    return @"0";
    
}


-(NSArray *)currentShowDepModel{
    if ([_allData isNotEmpty] && _allData[_currentLeftIndex.row] != nil){
        HYVisitFitterModel *model = _allData[_currentLeftIndex.row];
        if ([model.list isNotEmpty]) {
            NSMutableArray * dArray = [NSMutableArray array];
            for (HYVisitFitterSubModel *sub in model.list) {
                if ([sub.parentid isEqualToString:_currentDepParentId]) {
                    [dArray addObject:sub];
                }
            }
            if ([_currentDepParentId integerValue] != 0) {
                HYVisitFitterSubModel * subModel = [[HYVisitFitterSubModel alloc] init];
                subModel.name = @"返回";
                subModel.id = @"-1";
                [dArray insertObject:subModel atIndex:0];
            }
            return  dArray;
        }else{
            return @[];
        }
    }
    return @[];
}


@end
