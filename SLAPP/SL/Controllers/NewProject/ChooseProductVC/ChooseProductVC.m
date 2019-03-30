//
//  ChooseProductVC.m
//  CLApp
//
//  Created by 吕海瑞 on 16/8/17.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "ChooseProductVC.h"
#import "RLMResults.h"
#import "Product_lineModel.h"
#import "ProductRightCell.h"

@interface ChooseProductVC ()<RightCellDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic)  UITableView *left;
@property (strong, nonatomic)  UITableView *right;

@property(nonatomic,strong)NSMutableArray *leftArray;
@property(nonatomic,strong)NSMutableDictionary *rightDic;
@property(nonatomic,strong)NSMutableArray *selectArray;

@property(nonatomic,strong)NSIndexPath *leftIndex;
@property(nonatomic,assign)NSInteger level;
@end

@implementation ChooseProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self congigUI];
    [self configData];
}

- (void)congigUI
{
    self.title = @"选择产品";
    self.left = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2., MAIN_SCREEN_HEIGHT)];
    self.right = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2., 0, SCREEN_WIDTH/2., MAIN_SCREEN_HEIGHT)];
    self.left.tableFooterView = [[UIView alloc]init];
    self.right.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:self.left];
    [self.view addSubview:self.right];
    self.left.delegate = self;
    self.left.dataSource = self;
    self.right.delegate = self;
    self.right.dataSource = self;
    
    self.right.backgroundColor = [UIColor groupTableViewBackgroundColor];

    [self setRightBtnWithTitle:@"确定"];
}

- (void)configData
{
    self.leftArray = [NSMutableArray array];
    self.rightDic = [NSMutableDictionary dictionary];
    self.selectArray = [NSMutableArray array];
    
    RLMResults *products = [[Product_lineModel allObjects] objectsWhere:@"is_del == '0'"];
    
    
    if (products.count == 0 || products == nil) {
        [self toastWithText:@"当前没有可选择的产品"];
        return;
    }
    
    RLMResults *parents  = [products objectsWhere:@"parentid = '0'"];
    self.level = 0;
    
    [self cycleDataWithProducts:products and:parents];

    [self.left reloadData];
    [self.right reloadData];
    
    
    
    if (self.alreadyArray.count>0 )
    {
        for (NSDictionary *dic in self.alreadyArray)
        {
           Product_lineModel *subModel = [[Product_lineModel alloc]init];
           [subModel setValuesForKeysWithDictionary:dic];
            Product_lineModel *nameModel = [products objectsWhere:@"id = %@",subModel.id].firstObject;
            subModel.name = nameModel.name;
           [self.selectArray addObject:subModel];
        }
    }
    
    [_right reloadData];
    
}

- (void)cycleDataWithProducts:(RLMResults*)products and:(RLMResults *)parents
{
    
    for (Product_lineModel *pModel in parents)
    {
        NSMutableArray *rightArray = [NSMutableArray array];
        if ([pModel.parentid integerValue] == 0)
        {
            self.level = 0;
        }
        UPDATE_REALM_DATA(^{
            pModel.level = self.level;
        });
        
        
        RLMResults *subProducts = [products objectsWhere:@"parentid = %@",pModel.id];
        if (subProducts.count)
        {
            self.level++;
            [self.leftArray addObject:pModel];
//            NSMutableArray *allRight = [NSMutableArray arrayWithObject:pModel];
            NSMutableArray *allRight = [NSMutableArray array];
            for (Product_lineModel * chileP in pModel.childrenProduct) {
                if (chileP.childrenProduct.count !=0) {
                    continue;
                }
                [allRight addObject:chileP];
            }
            [self.rightDic setObject:allRight forKey:pModel.id];
            [self cycleDataWithProducts:products and:subProducts];
        }
        else
        {
            if (self.level == 0)
            {
                [self.leftArray addObject:pModel];
                NSMutableArray *allRight = [NSMutableArray arrayWithObject:pModel];
                for (Product_lineModel * chileP in pModel.childrenProduct) {
                    if (chileP.childrenProduct.count !=0) {
                        continue;
                    }
                    [allRight addObject:chileP];
                }
                [self.rightDic setObject:allRight forKey:pModel.id];
            }
            [rightArray addObject:pModel];
        }
        //        if (self.level == 0)
        //        {
        //            [self.rightDic setObject:rightArray forKey:pModel.id];
        //        }
        //        else
        //        {
        //         [self.rightDic setObject:rightArray forKey:pModel.parentid];
        //        }
        
    }
    
    
    
    

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_left])
    {
        return 44;
    }
    else
    {
        return 60;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.left])
    {
        return self.leftArray.count;
    }
    else
    {
        if (self.leftArray.count == 0) {
            return 0;
        }
        Product_lineModel *model = self.leftArray[self.leftIndex.row];
        NSArray *array = self.rightDic[model.id];
        if (array) {
            return array.count;
        }
        else{
            return 0;
        }
        
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:self.left])
    {
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            [cell.textLabel setFont:kFont_Big];
            [cell.textLabel setTextColor:[UIColor darkTextColor]];
        }
        if ([indexPath isEqual:self.leftIndex])
        {
            [cell.textLabel setTextColor:kGreenColor];
        }
        else
        {
            [cell.textLabel setTextColor:[UIColor darkTextColor]];
        }
        Product_lineModel *model = self.leftArray[indexPath.row];
        
        NSMutableString *str = [[NSMutableString alloc]init];
        for (int i = 0 ; i<model.level; i ++)
        {
            [str appendString:@"     "];
        }
        cell.textLabel.text =[NSString stringWithFormat:@"%@%@",str,model.name];
        
        return cell;
    }
    else
    {
        static NSString *cellIde = @"cellRight";
        ProductRightCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductRightCell" owner:self options:nil]lastObject];
        }
        cell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.textField.delegate = self;
        Product_lineModel *model = self.leftArray[self.leftIndex.row];
        NSArray *array = _rightDic[model.id];
        Product_lineModel *rModel = array[indexPath.row];
        
        cell.nameLable.text =rModel.name;
        cell.textField.text = [rModel.amount floatValue] != 0?rModel.amount:nil;
        cell.textField.tag = [rModel.id integerValue];
        for (Product_lineModel *selectmodel in _selectArray)
        {
            if ([rModel.id isEqualToString:selectmodel.id])
            {
                cell.markBtn.selected = YES;
                cell.textField.text =[selectmodel.amount floatValue]>0?selectmodel.amount:nil;
                cell.textField.enabled = YES;
                cell.textField.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                cell.textField.enabled = NO;
                cell.textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
                
            }
        }
        return cell;
    }
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.left])
    {
        self.leftIndex = indexPath;
        [self.left reloadData];
        [self.right reloadData];
    }
    else
    {
        //cell.markBtn.selected = !cell.markBtn.selected;
    }
    
}


-(void)rightCellMarkBtnClickWith:(NSIndexPath *)indexPath
{
    ProductRightCell *cell = [self.right cellForRowAtIndexPath:indexPath];
    
    if (cell.markBtn.selected)
    {
        cell.textField.backgroundColor = [UIColor whiteColor];
        Product_lineModel *model = self.leftArray[_leftIndex.row];
        NSArray *array = self.rightDic[model.id];
        Product_lineModel *rModel = array[indexPath.row];
        Product_lineModel *selectModel = [[Product_lineModel alloc]init];
        selectModel.id = rModel.id;
        selectModel.amount = rModel.amount;
        selectModel.name = rModel.name;
        selectModel.parentid = rModel.parentid;
        [self.selectArray addObject:selectModel];
        [cell.textField becomeFirstResponder];
        
    }
    else
    {
        cell.textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        Product_lineModel *model = self.leftArray[_leftIndex.row];
        NSArray *array = self.rightDic[model.id];
        Product_lineModel *rModel = array[indexPath.row];
        for (Product_lineModel *selectmodel in _selectArray)
        {
            if ([selectmodel.id isEqualToString:rModel.id])
            {
                [self.selectArray removeObject:selectmodel];
                break;
            }
        }
    }
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if([textField.text isFloatNumber] ||textField.text == nil)
    {
        
        for (Product_lineModel *selectmodel in self.selectArray)
        {
            if ([selectmodel.id isEqualToString:[NSString stringWithFormat:@"%ld",textField.tag]])
            {
                selectmodel.amount = [textField.text isNotEmpty]?textField.text:@"0.0";
                break;
            }
        }
    }
    else
    {
        textField.text = nil;
        [self toastWithText:@"请输入正确的金额"];
        
    }
    
}



-(void)rightClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    
    if (self.resultArray)
    {
        self.resultArray(self.selectArray);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
