//
//  SLRealContactVC.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLRealContactVC.h"
#import "SLRealContactCell.h"
#import "SLRealContactModel.h"
#import "UIButton+SLFunc.h"
@interface SLRealContactVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic)UITableView *tableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)UIButton *selectedBtn;

@property(nonatomic)UILabel *selectedName;

@property(nonatomic)NSString *ID;

@property(nonatomic)SLRealContactModel *seleModel;

@property(nonatomic)NSMutableArray *titleArr;
@end

@implementation SLRealContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SLRealContactCell class] forCellReuseIdentifier:@"contact"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addBottomView];
    
    [self requestData];
    // Do any additional setup after loading the view.
}
#pragma mark - 代理相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{\
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = COLOR(240, 240, 240, 1);
    UILabel *lable = [[UILabel alloc]init];
    lable.text = self.titleArr[section];
    [headView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView);
        make.left.equalTo(headView).offset(15);
    }];
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLRealContactModel *model = _dataArr[indexPath.section][indexPath.row];
    SLRealContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contact"];
    [cell setCellWithModel:model];
    if (model.isSelect == NO) {
        cell.chooseBtn.selected = NO;
    }else{
        cell.chooseBtn.selected = YES;    }
    cell.chooseBtn.tag = indexPath.row;
    cell.chooseBtn.indentifierStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    [cell.chooseBtn addTarget:self action:@selector(chooseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLRealContactCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self chooseBtnClicked:cell.chooseBtn];
}
-(void)chooseBtnClicked:(UIButton *)button{
    NSInteger section = [button.indentifierStr integerValue];
    SLRealContactModel *model = _dataArr[section][button.tag];
    model.isSelect = !model.isSelect;
    if (model!=_seleModel) {
        _seleModel.isSelect = NO;
        _seleModel = model;
        _selectedName.text = model.name;
        _ID = model.ID;
    }else{
        _seleModel = nil;
        _selectedName.text = @"";
        _ID = @"";
    }
    [self.tableView reloadData];
    
    
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
    _selectedName.textColor = kgreenColor;
    _selectedName.font = b_font(16);
    [bottomView addSubview:_selectedName];
    [_selectedName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView).offset(-K_SAFE_HEIGHT/2);
        make.left.equalTo(bottomView).offset(20);
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
#pragma mark - 确定
-(void)sureBtnClicked{
    self.passContact(_selectedName.text, _ID);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 请求数据
-(void)requestData{
    [self showProgress];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.contact" Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
        
        [self showDismiss];
        NSArray *array = result[@"list"];
        NSArray *models = [SLRealContactModel mj_objectArrayWithKeyValuesArray:array];
        NSMutableSet *set = [NSMutableSet set];
        for (SLRealContactModel *model in models) {
            [set addObject:model.key];
        }
        NSArray *titles = [set allObjects];
        self->_titleArr = [NSMutableArray arrayWithArray:titles];
        [self->_titleArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2 options:NSForcedOrderingSearch];
        }];
        
        for (NSString *key in self.titleArr) {
            NSMutableArray * arr = [NSMutableArray array];
            for (SLRealContactModel *model in models) {
                if ([model.key isEqualToString:key]) {
                    [arr addObject:model];
                }
            }
            [self.dataArr addObject:arr];
        }
         [self.tableView reloadData];
    } fail:^(NSDictionary *result) {
        
    }];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//-(NSMutableArray *)titleArr{
//    if (!_titleArr) {
//        _titleArr = [NSMutableArray array];
//    }
//    return _titleArr;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
