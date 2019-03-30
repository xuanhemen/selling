//
//  SLSheduleContactVC.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLSheduleContactVC.h"
#import "SLScheduleContactCell.h"
#import "SLScheduleContactModel.h"
#import "SLScheduleGroupCell.h"
#import "SLScheduleGroupModel.h"
#import "SLNewBuildScheduleVC.h"
@interface SLSheduleContactVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *tableView;

@property(nonatomic)NSMutableArray *groupArr;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)UIButton *selectedBtn;

@property(nonatomic)UILabel *selectedName;

@property(nonatomic,copy)NSString *ID;

@property(nonatomic)SLScheduleContactModel *seleModel;



@end

@implementation SLSheduleContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择参与人";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SLScheduleContactCell class] forCellReuseIdentifier:@"contact"];
    [_tableView registerClass:[SLScheduleGroupCell class] forCellReuseIdentifier:@"group"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 50+K_SAFE_HEIGHT, 0));
    }];
    
    [self addBottomView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}
#pragma mark - 代理相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_groupArr count]+[_dataArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<[_groupArr count]) {
        SLScheduleGroupModel *model = _groupArr[indexPath.row];
        SLScheduleGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group"];
        cell.headImgView.hidden = NO;
        cell.depName.text = model.name;
        return cell;
    }else{
        SLScheduleContactModel *model = _dataArr[indexPath.row-[_groupArr count]];
        SLScheduleContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact"];
        cell.chooseBtn.tag = indexPath.row-[_groupArr count];
        BOOL ret = [self.ids containsString:model.userid];
        if (ret == NO) {
            cell.chooseBtn.selected = NO;
        }else{
            cell.chooseBtn.selected = YES;
            model.isSelect = YES;
        }
        [cell.chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.name.text = model.realname;
        cell.position.text = model.position_name;
        return cell;
    }
 
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row<[_groupArr count]) {
        SLScheduleGroupModel *model = _groupArr[indexPath.row];
        SLSheduleContactVC *svc = [[SLSheduleContactVC alloc]init];
        svc.parentID = model.ID;
        svc.modelArr = self.modelArr;
        svc.names = self.names;
        [self.navigationController pushViewController:svc animated:YES];
    }else{
        SLScheduleContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self chooseBtnClicked:cell.chooseBtn];
    }
   
}
#pragma mark - 选择参与人
-(void)chooseBtnClicked:(UIButton *)button{
    SLScheduleContactModel *model = _dataArr[button.tag];
    model.isSelect = !model.isSelect;
    if (model.isSelect == YES) {
        [self.modelArr addObject:model];
    }else{
        
        for (SLScheduleContactModel *oldModel in self.modelArr) {
            
            if ([oldModel.userid isEqualToString:model.userid]) {
                 [self.modelArr removeObject:oldModel];
                 break;
            }
        }
       
    }
    
    self.names = [NSMutableString string];
    self.ids = [NSMutableString string];
    for (int i=0; i<[self.modelArr count]; i++) {
        SLScheduleContactModel *model = self.modelArr[i];
        if (i==0) {
            [self.names appendFormat:@"%@",model.realname];
            [self.ids appendFormat:@"%@",model.userid];
        }else{
            [self.names appendFormat:@"、%@",model.realname];
            [self.ids appendFormat:@",%@",model.userid];
        }
    }
    _selectedName.text = self.names;
   
    [self.tableView reloadData];
    
}
#pragma mark - 确定
-(void)sureBtnClicked{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactInfo" object:nil userInfo:@{@"name":_selectedName.text,@"id":self.ids,@"arr":self.modelArr}];
    for (UIViewController *vc in self.navigationController.childViewControllers) {
        if ([vc isKindOfClass:[SLNewBuildScheduleVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
   
}
#pragma mark - 创建底部视图
-(void)addBottomView{
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];
    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.3);
    topLayer.backgroundColor = gray_color.CGColor;
    [bottomView.layer addSublayer:topLayer];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50+K_SAFE_HEIGHT));
        make.bottom.equalTo(self.view);
    }];
    _selectedName = [[UILabel alloc]init];
    _selectedName.text = self.names;
    _selectedName.textColor = kgreenColor;
    _selectedName.font = b_font(16);
    [bottomView addSubview:_selectedName];
    [_selectedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView).offset(-K_SAFE_HEIGHT/2);
        make.left.equalTo(bottomView).offset(20);
        make.right.equalTo(bottomView).offset(-100);
    }];
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 6;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = font(16);
    sureBtn.backgroundColor = kgreenColor;
    [sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView).offset(-K_SAFE_HEIGHT/2);
        make.right.equalTo(bottomView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
}
-(void)requestData{
    [self showProgress];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"parent_id"] = self.parentID;
    [HYBaseRequest getPostWithMethodName:@"pp.user.dep_list_parent" Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
       
        [self showDismiss];
        NSArray *groupArr = result[@"dep"];
        self.groupArr = [SLScheduleGroupModel mj_objectArrayWithKeyValuesArray:groupArr];
        NSArray *arr = result[@"member"];
        self.dataArr = [SLScheduleContactModel mj_objectArrayWithKeyValuesArray:arr];
        [self.tableView reloadData];
    } fail:^(NSDictionary *result) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    self.names = [NSMutableString string];
    self.ids = [NSMutableString string];
    for (int i=0; i<[self.modelArr count]; i++) {
        SLScheduleContactModel *model = self.modelArr[i];
        if (i==0) {
            [self.names appendFormat:@"%@",model.realname];
            [self.ids appendFormat:@"%@",model.userid];
        }else{
            [self.names appendFormat:@"、%@",model.realname];
            [self.ids appendFormat:@",%@",model.userid];
        }
    }
    _selectedName.text = self.names;
    NSLog(@"出%@",self.ids);
    
    
}
-(void)dealloc{
    NSLog(@"我的");
}
-(NSMutableArray *)groupArr{
    if (!_groupArr) {
        _groupArr = [NSMutableArray array];
    }
    return _groupArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
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
