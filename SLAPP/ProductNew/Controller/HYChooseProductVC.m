//
//  HYChooseProductVC.m
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYChooseProductVC.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "HYProductModel.h"

@interface HYChooseProductVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *leftTableView;
@property (nonatomic,strong)UITableView *rightTableView;

@property (nonatomic,strong)NSMutableArray *leftArray;

@property (nonatomic,strong)NSMutableDictionary *rightDict;
@property (nonatomic,strong)NSArray *allData;
@property (nonatomic,assign)NSInteger level;
@property (nonatomic,strong)NSIndexPath *leftIndexPath;

@end

@implementation HYChooseProductVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alreadyArray = [NSMutableArray array];
        self.leftArray = [NSMutableArray array];
        self.selectArray = [NSMutableArray array];
        self.rightDict = [NSMutableDictionary dictionary];
        self.level = 0;
        self.leftIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self getAllProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    self.title = @"选择产品";
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, kScreenHeight) style:UITableViewStylePlain];
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 0, kScreenWidth/2, kScreenHeight) style:UITableViewStylePlain];
    
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    self.rightTableView.tableFooterView = [[UIView alloc] init];
   
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    self.rightTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    
}

- (void)getAllProduct{
    kWeakS(weakSelf);
    
    
    
    UserModel *model = [UserModel getUserModel];
    [HYBaseRequest getPostWithMethodName:@"pp.user.all_products" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
        NSArray *array = result[@"data"];
        NSMutableArray *data = [NSMutableArray array];
        for (NSDictionary *subDict in array){
            HYProductModel *model = [[HYProductModel alloc] initWithDictionary:subDict];
            [data addObject:model];
        }
        weakSelf.allData = [array copy];
        [self configData];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
}



- (void)configData{
    
    if (self.allData.count == 0){
        DLog(@"当前没有可选择的产品");
        return;
    }
    self.level = 0;
    [self configALLData:self.allData];
    
    if (self.alreadyArray.count>0) {
        [self.selectArray removeAllObjects];
        for (NSDictionary *dic in self.alreadyArray){
            
            HYProductModel *subModel = [[HYProductModel alloc] init];
            subModel.Id = dic[@"id"];
            subModel.amount = dic[@"price"];
            subModel.name = dic[@"products"];
            HYProductModel *nameModel = [self findProduct_lineModel:subModel.Id andLines:self.allData];
            subModel.name = nameModel.name;
            subModel.parentid = nameModel.parentid;
            [self.selectArray addObject:subModel];
        }
    }
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    
}

- (void)configALLData:(NSArray *)parentArray {
    for (id dict in parentArray) {
        HYProductModel *pModel;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            pModel = [[HYProductModel alloc] initWithDictionary:dict];
        }else{
            pModel = dict;
        }
        
        NSMutableArray *rightArray = [NSMutableArray array];
        if ([pModel.parentid isEqualToString: @"0"]){
            self.level = 0;
        }
        
        NSArray *subProducts = pModel.child;
        if (subProducts != nil && subProducts.count != 0){
            self.level = self.level + 1;
            [self.leftArray addObject:pModel];
            
            NSMutableArray *allRight = [NSMutableArray array];
            if (pModel.child != nil) {
                for (NSInteger j=0; j<pModel.child.count;j++) {
                    HYProductModel *chileP = pModel.child[j];
                    chileP.parentid = pModel.Id;
                    if (chileP.child != nil && chileP.child.count != 0){
                        continue;
                    }
                    [allRight addObject:chileP];
                }
            }
            [self.rightDict setObject:allRight forKey:pModel.Id];
            [self configALLData:subProducts];
        }else{
            if (self.level == 0){
                [self.leftArray addObject:pModel];
                NSMutableArray *allRight = [NSMutableArray arrayWithArray:@[pModel]];
                if (pModel.child != nil){
                    for (NSInteger i=0;i<pModel.child.count;i++){
                        HYProductModel *chileP = pModel.child[i];
                        chileP.parentid = pModel.Id;
                        if (chileP.child != nil && chileP.child.count != 0){
                            continue;
                        }
                        [allRight addObject:chileP];
                    }
                }
                [self.rightDict setObject:allRight forKey:pModel.Id];
            }
            if (self.rightDict[pModel.parentid] == nil){
                [self.rightDict setObject:@[pModel] forKey:pModel.parentid];
            }else{
                NSMutableArray *a = [NSMutableArray arrayWithArray:self.rightDict[pModel.parentid]];
                BOOL isExist = NO;
                for (HYProductModel *newModel in a) {
                    if ([newModel.Id isEqualToString:pModel.Id]) {
                        isExist = YES;
                    }
                }
                if (isExist == NO) {
                    [a addObject:pModel];
                }
                [self.rightDict setObject:a forKey:pModel.parentid];
            }
        }
    }
}


- (HYProductModel *)findProduct_lineModel:(NSString *)pId andLines:(NSArray *)lines {
    HYProductModel *pLineModel = nil;
    for (HYProductModel *lineModel in lines ){
        if (lineModel.Id == pId){
            pLineModel = lineModel;
        }
        if (pLineModel == nil && lineModel.child != nil && lineModel.child.count != 0){
            pLineModel = [self findProduct_lineModel:pId andLines:lineModel.child];
        }
    }
    return pLineModel;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        return 44;
    }else{
        return 60;
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.leftTableView]) {
        return self.leftArray.count;
    }else{
        if (self.leftArray.count == 0){
            return 0;
        }
        HYProductModel *model = self.leftArray[self.leftIndexPath.row];
        NSArray *array = self.rightDict[model.Id];
        if (array != nil) {
            return array.count;
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]) {
        NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
        }
        
        HYProductModel *model = self.leftArray[indexPath.row];
        NSArray *array = self.rightDict[model.Id];
        
        if (indexPath == self.leftIndexPath){
            cell.textLabel.textColor = UIColorFromRGB(0x43be5f);
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }else{
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
        }
        
        
        for (HYProductModel *selectModel in self.selectArray){
            if (selectModel.parentid == model.Id) {
                cell.textLabel.textColor = UIColorFromRGB(0x43be5f);
            }
        }
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:@""];
        for (NSInteger i=0; i<[model.level integerValue];i++) {
            [str appendString:@"     "];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@",str,model.name];
        return cell;
    }else{
        NSString *cellIde = @"QFProductRightCell";
        kWeakS(weakSelf);
        QFProductRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"QFProductRightCell" owner:self options:nil] lastObject];
        }
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.indexPath = indexPath;
        cell.rightCellMarkBtnClick = ^(NSIndexPath * indexPath) {
            [weakSelf rightCellMarkBtnClickWithIndexpath:indexPath];
        };
        cell.textField.delegate = self;
        HYProductModel *model = self.leftArray[self.leftIndexPath.row];
        NSArray *array = self.rightDict[model.Id];
        HYProductModel *rModel = array[indexPath.row];
        cell.nameLable.text = rModel.name;
        cell.textField.text = [rModel.amount isEqualToString:@"0"] ? rModel.amount : @"";
        cell.textField.tag = [rModel.Id integerValue];
        cell.markBtn.selected = NO;
        cell.textField.enabled = NO;
        cell.textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        for (HYProductModel *selectmodel in self.selectArray){
            
            if (rModel.Id == selectmodel.Id){
                cell.markBtn.selected = YES;
                cell.textField.text = [selectmodel.amount floatValue]>0 ? selectmodel.amount : @"";
                cell.textField.enabled = YES;
                cell.textField.backgroundColor = UIColorFromRGB(0xFFFFFF);
            }else{
                
            }
        }
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.leftTableView]){
        self.leftIndexPath = indexPath;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }else{
        [self rightCellMarkBtnClickWithIndexpath:indexPath];
    }
    
}


- (void)rightCellMarkBtnClickWithIndexpath:(NSIndexPath *)indexpath {
    
    
    QFProductRightCell *cell = [self.rightTableView cellForRowAtIndexPath:indexpath];
    
    cell.markBtn.selected = !cell.markBtn.isSelected;
    cell.textField.enabled = cell.markBtn.isSelected;
    if (cell.markBtn.isSelected){
        cell.textField.backgroundColor = UIColorFromRGB(0xFFFFFF);
        HYProductModel *model = self.leftArray[self.leftIndexPath.row];
        NSArray *array = self.rightDict[model.Id];
        HYProductModel *rModel = array[indexpath.row];
        HYProductModel * selectModel = [[HYProductModel alloc] init];
        selectModel.Id = rModel.Id;
        selectModel.amount = rModel.amount;
        selectModel.name = rModel.name;
        selectModel.parentid = rModel.parentid;
        [self.selectArray addObject:selectModel];
        [cell.textField becomeFirstResponder];
    }else{
        cell.textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        HYProductModel * model = self.leftArray[self.leftIndexPath.row];
        NSArray *array = self.rightDict[model.Id];
        HYProductModel * rModel = array[indexpath.row];
        for (HYProductModel *selectmodel in self.selectArray){
            if (selectmodel.Id==rModel.Id){
                [self.selectArray removeObject:selectmodel];
                break;
            }
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.isNotEmpty){
        for (HYProductModel *selectmodel in self.selectArray){
            if ([selectmodel.Id integerValue] == textField.tag){
                selectmodel.amount = textField.text != nil ? textField.text : @"";
                break;
            }
        }
    }else{
        textField.text = @"";
        
    }
}

- (void)rightButtonClick {
    [self.view endEditing:YES];
    if (self.action) {
        self.action([self.selectArray copy]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
