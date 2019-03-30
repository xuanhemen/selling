//
//  HYBoltingDepAndMemberView.m
//  SLAPP
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 柴进. All rights reserved.
//
#import "HYBoltingDepMemberCell.h"
#import "HYBoltingDepAndMemberView.h"
@interface HYBoltingDepAndMemberView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)NSString * parentId;
@end
@implementation HYBoltingDepAndMemberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _selectModel = [[HYDepMemberModel alloc] init];
        _depArray = [NSArray array];
        _memberArray = [NSArray array];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    [self addSubview:titleLab];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    titleLab.text = @"部门与人员";
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame = CGRectMake(0, 0, 40, 40);
    [_lastBtn setImage:[UIImage imageNamed:@"qf_web_back"] forState:UIControlStateNormal];
    [self addSubview:_lastBtn];
    [_lastBtn addTarget:self action:@selector(lastClick) forControlEvents:UIControlEventTouchUpInside];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-89)];
    [self addSubview:_table];
    
    UIView *fView = [[UIView alloc] init];
    _table.tableFooterView = fView;
    
    
    [_table registerNib:[UINib nibWithNibName:@"HYBoltingDepMemberCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    _table.delegate = self;
    _table.dataSource = self;
    
    
    
    
    UIView *bottomline = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-49.5, self.frame.size.width, 0.5)];
    bottomline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomline];
    CGFloat width = self.frame.size.width/2;
    UIButton * reSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reSetBtn.frame = CGRectMake(0, self.frame.size.height-49,width,49);
    [reSetBtn setTitle:@"取消" forState:UIControlStateNormal];
    [reSetBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self addSubview:reSetBtn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kgreenColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(width, self.frame.size.height-49, width, 49);
    [self addSubview:sureBtn];
    
    [reSetBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backBtnClick{
    
    if (self.result) {
        self.result(_selectModel);
    }
}

-(void)sureBtnClick{
    if (self.result) {
        self.result(_selectModel);
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 && _memberArray.count > 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return line;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0 && _memberArray.count > 0) {
        return 10;
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_depArray count];
    }
    return [_memberArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYBoltingDepMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
       
        HYDepListModel * model = _depArray[indexPath.row];
        cell.headerImage.image = [UIImage imageNamed:@"qf_depImage"];
        cell.upLab.text = model.name;
        
        if ([_selectModel.key isEqualToString:@"dep"] && [_selectModel.id isEqualToString:model.id]) {
            cell.markImage.image = [UIImage imageNamed:@"qf_select_statuschoose"];
        }else{
            cell.markImage.image = [UIImage imageNamed:@"qf_select_statusdefault"];
        }
        
        NSInteger num = [self childrenNumWithId:model.id];
        cell.downLab.text = [NSString stringWithFormat:@"%ld人",num];
        cell.rightArrow.hidden = cell.rightBtn.hidden = !num;
        
        
        kWeakS(weakSelf);
        __weak typeof(model)wModel = model;
        cell.nextClick = ^{
            [weakSelf toConfigDataWithId:wModel.id];
        };
        
    }else{
        
        HYMember_listModel *model = _memberArray[indexPath.row];
        cell.headerImage.image = [UIImage imageNamed:@"ch_protrait_green"];
        cell.upLab.text = model.realname;
        cell.downLab.text = @"";
        cell.rightBtn.hidden = YES;
        cell.rightArrow.hidden = YES;
        if ([_selectModel.key isEqualToString:@"member"] && [_selectModel.id isEqualToString:model.userid]) {
            cell.markImage.image = [UIImage imageNamed:@"qf_select_statuschoose"];
        }else{
            cell.markImage.image = [UIImage imageNamed:@"qf_select_statusdefault"];
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
       HYDepListModel * model = _depArray[indexPath.row];
        if ([_selectModel.key isEqualToString:@"dep"] && [model.id isEqualToString:_selectModel.id]) {
            _selectModel.id = @"";
        }else{
            
            _selectModel.key = @"dep";
            _selectModel.id = model.id;
        }
        
        
    }else{
        
        HYMember_listModel *model = _memberArray[indexPath.row];
        if ([_selectModel.key isEqualToString:@"member"] && [model.userid isEqualToString:_selectModel.id]) {
            _selectModel.id = @"";
        }else{
            _selectModel.key = @"member";
            _selectModel.id = model.userid;
        }
    }
    [tableView reloadData];
}


- (void)setModel:(HYBoltingModel *)model{
    _model = model;
    
    _parentId = [model.dep_parent_id mutableCopy];
    _lastBtn.hidden = YES;
    NSPredicate *depPre = [NSPredicate predicateWithFormat:@" parentid == %@",_parentId];
    _depArray = [_model.more.dep_list filteredArrayUsingPredicate:depPre];
    
    NSPredicate *memberPre = [NSPredicate predicateWithFormat:@" departmentid == %@",_parentId];
    _memberArray = [_model.more.member_list filteredArrayUsingPredicate:memberPre];
    [_table reloadData];
}





/**
 适配数据

 @param id
 */
-(void)toConfigDataWithId:(NSString *)id{
   
    self.parentId = id;
    self.lastBtn.hidden = [id isEqualToString:_model.dep_parent_id];
    NSPredicate *depPre = [NSPredicate predicateWithFormat:@" parentid == %@",id];
    _depArray = [_model.more.dep_list filteredArrayUsingPredicate:depPre];
    
    NSPredicate *memberPre = [NSPredicate predicateWithFormat:@" departmentid == %@",id];
    _memberArray = [_model.more.member_list filteredArrayUsingPredicate:memberPre];
    [_table reloadData];
    
}



/**
 部门的子集个数

 @param id <#id description#>
 @return <#return value description#>
 */
-(NSInteger)childrenNumWithId:(NSString *)id{
    
    NSPredicate *depPre = [NSPredicate predicateWithFormat:@" parentid == %@",id];
   NSArray *d = [_model.more.dep_list filteredArrayUsingPredicate:depPre];
    
    NSPredicate *memberPre = [NSPredicate predicateWithFormat:@" departmentid == %@",id];
    NSArray * m = [_model.more.member_list filteredArrayUsingPredicate:memberPre];
    
    
    return [d count] + [m count];
}



-(void)lastClick{
    
    NSPredicate *depPre = [NSPredicate predicateWithFormat:@" id == %@",self.parentId];
    
    
    NSArray *d = [_model.more.dep_list filteredArrayUsingPredicate:depPre];
    if ([d isNotEmpty]) {
        HYDepListModel *model = d.firstObject;
        [self toConfigDataWithId:model.parentid];
    }
   
    
}
@end
