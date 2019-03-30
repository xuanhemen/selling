//
//  SLChooseCustomVC.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLChooseCustomVC.h"
#import "SLScheduleModel.h"
#import "SLChooseScheduleCell.h"
#import "SLAPP-Swift.h"
@interface SLChooseCustomVC ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic)UITableView *tableView;

@property(nonatomic)NSMutableArray *dataArr;

@property(nonatomic)UIButton *selectedBtn;

@property(nonatomic)UILabel *selectedName;

@property(nonatomic)NSString *ID;

@property(nonatomic)SLScheduleModel *seleModel;

@end

@implementation SLChooseCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择客户";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClustomer)];
    self.navigationItem.rightBarButtonItem = item;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[SLChooseScheduleCell class] forCellReuseIdentifier:@"schedule"];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self addBottomView];
    
    
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - 代理相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLScheduleModel *model = _dataArr[indexPath.row];
    SLChooseScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"schedule"];
    [cell setCellWithModel:model];
    if (model.isSelect == NO) {
        cell.chooseBtn.selected = NO;
    }else{
        cell.chooseBtn.selected = YES;
    }
    cell.chooseBtn.tag = indexPath.row;
    [cell.chooseBtn addTarget:self action:@selector(selectInfo:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLChooseScheduleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectInfo:cell.chooseBtn];
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
#pragma mark - 添加客户
-(void)addClustomer{
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"CustomPool" bundle:nil];
    CreateCustomViewController *vc = [mainStory instantiateViewControllerWithIdentifier:@"CreateCustomViewController"];
     vc.isFromPublicSea = NO;
    [self.navigationController pushViewController:vc animated:YES];
  
    
}
-(void)selectInfo:(UIButton *)button{
    SLScheduleModel *model = _dataArr[button.tag];
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
//    button.selected = !button.selected;
//    if (button != _selectedBtn) {
//        _selectedBtn.selected = NO;
//        _selectedBtn = button;
//     }
//    _selectedName.text = model.name;
//    _ID = model.ID;
    
}
#pragma mark - 请求客户
-(void)requestData{
    [self showProgress];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [HYBaseRequest getPostWithMethodName:kMyClientPoolList Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
        [self showDismiss];
        NSArray *arr = result[@"data"];
        self.dataArr = [SLScheduleModel mj_objectArrayWithKeyValuesArray:arr];
        [self.tableView reloadData];
    } fail:^(NSDictionary *result) {
        
    }];
}
#pragma mark - 确定
-(void)sureBtnClicked{
    
    if ([_selectedName.text isEqualToString:@""]||_selectedName.text == nil) {
        [self toastWithText:@"请选择客户" andDruation:1.5];
        return;
    }
    self.passCustom( _selectedName.text, _ID);
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.dataArr removeAllObjects];
    [self requestData];
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
