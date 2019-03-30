//
//  HYAddContactVC.m
//  SLAPP
//
//  Created by yons on 2018/10/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYAddContactVC.h"
#import "LCActionSheet.h"
#import "HYSelectClientVC.h"
#import "PGDatePickManager.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "SLRepeatInfoModel.h"
#import "MJExtension.h"
#import "SLRepeatInfoVC.h"
@interface HYAddContactVC ()<LCActionSheetDelegate>
@property (nonatomic,strong) NSMutableArray *fieldArray;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property(nonatomic)NSMutableArray *phoneArr;

@property(nonatomic,strong)SLRepeatInfoModel * commitModel;

@end
static int cout = 1;
@implementation HYAddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self uiConfig];
    
    [self createView];
    
}
-(NSMutableArray *)phoneArr
{
    if (!_phoneArr) {
        _phoneArr= [NSMutableArray array];
    }
    return _phoneArr;
}
- (IBAction)jumpToAddressBook:(id)sender {
   
    if (self.clientField.text.length == 0) {
        [self toastWithText:@"请先选择客户" andDruation:1];
        return;
    }
    SortAddressVC * svc = [[SortAddressVC alloc]init];
    svc.indentifier = @"newBuild";
    svc.passSelecteObjc = ^(LJPerson *model){
        self->_nameField.text = model.fullName;
        NSArray * arr = self.contactInfo[@"phone_arr"];
        NSInteger arrCount = cout==1?[arr count]:0;
        NSInteger count = self.phoneArr.count+arrCount;
        for (int i = 0; i<self.phoneArr.count+arrCount; i++) {
            UIButton * btn = [UIButton new];
            btn.tag = 300+count-1;
            count--;
            [self.phoneV delButtonClick:btn];
        }
        cout = 0;
        [self.phoneArr removeAllObjects];
        for (LJPhone * phoneModel in model.phones) {
            [self.phoneArr addObject:phoneModel.phone];
        }
        
        [self.phoneV configPhones:self.phoneArr];
    };
    [self.navigationController pushViewController:svc animated:YES];
}
-(void)createView
{
    self.maskButton.hidden = self.clientID.isNotEmpty;
    if (self.clientModel != nil) {
        self.clientField.text = self.clientModel.name;
        self.clientID = self.clientModel.Id;
        self.maskButton.hidden = YES;
    }
    if (self.contactInfo == nil) {
        self.title = @"创建联系人";
    }else{
        if (self.isFromCustom == nil) {
            self.title = @"修改联系人";
        } else {
            self.title = @"创建联系人";
        }
        self.maskButton.hidden = YES;
        self.contactID = [self.contactInfo[@"id"] toString];
        self.nameField.text = [self.contactInfo[@"name"] toString];
        
        
        
        
        if ([self.contactInfo[@"dep"] isNotEmpty]) {
            self.deparmentField.text = [self.contactInfo[@"dep"] toString];
            self.deparmentHeight.constant = 50;
            [self.fieldArray removeObject:@"部门"];
        }
        if ([self.contactInfo[@"qq"] isNotEmpty]) {
            self.QQField.text = [self.contactInfo[@"qq"] toString];
            self.QQheight.constant = 50;
            self.cuttingline_two_height.constant = 20;
            [self.fieldArray removeObject:@"QQ"];
        }
        if ([self.contactInfo[@"wechat"] isNotEmpty]) {
            self.wechatField.text = [self.contactInfo[@"wechat"] toString];
            self.wechatheight.constant = 50;
            self.cuttingline_two_height.constant = 20;
            [self.fieldArray removeObject:@"微信"];
        }
        if ([self.contactInfo[@"email"] isNotEmpty]) {
            self.emailField.text = [self.contactInfo[@"email"] toString];
            self.emailHeight.constant = 50;
            self.cuttingline_two_height.constant = 20;
            [self.fieldArray removeObject:@"邮件"];
        }
        if ([self.contactInfo[@"addr"] isNotEmpty]) {
            self.addressField.text = [self.contactInfo[@"addr"] toString];
            self.addressHeight.constant = 50;
            self.cuttingline_two_height.constant = 20;
            [self.fieldArray removeObject:@"地址"];
        }
        if ([self.contactInfo[@"sex"] isNotEmpty]) {
            self.sexField.text = [self.contactInfo[@"sex"] toString];
            self.cuttingline_one_height.constant = 20;
            self.sexHeight.constant = 50;
            [self.fieldArray removeObject:@"性别"];
        }
        if ([self.contactInfo[@"birthday"] isNotEmpty]) {
            self.ageField.text = [self.contactInfo[@"birthday"] toString];
            self.cuttingline_one_height.constant = 20;
            self.ageHeight.constant = 50;
            [self.fieldArray removeObject:@"生日"];
        }
        if ([self.contactInfo[@"more"] isNotEmpty]) {
            self.remarkField.text = [self.contactInfo[@"more"] toString];
            self.remarkHeight.constant = 80;
            self.cuttingline_three_height.constant = 20;
            [self.fieldArray removeObject:@"备注"];
        }
        
        self.positionField.text = [self.contactInfo[@"position_name"] toString];
        
        if ([self.contactInfo[@"client_id"] isNotEmpty]) {
            self.clientID = [self.contactInfo[@"client_id"] toString];
            self.clientField.text = [self.contactInfo[@"client_name"] toString];
        }
    }
    
    if (self.contactInfo != nil&&[self.contactInfo[@"phone_arr"] isNotEmpty]) {
        [self.phoneV configPhones:self.contactInfo[@"phone_arr"]];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    if ([self.indentifier isEqualToString:@"保存并新建"]) {
        self.title = @"创建联系人";
    }
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - textfield

- (void)textFieldEditChanged:(UITextField *)textField{
    //    if (textField.text.length>=8) {
    //        textField.text = [textField.text substringWithRange:NSMakeRange(0, 8)];
    //    }
    
    NSString * temp = textField.text;
    
    
    if (textField.markedTextRange ==nil){
        
        while(1){
            if ([self convertToInt:temp] <= 60) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        textField.text=temp;
    }
}
- (NSUInteger)convertToInt:(NSString*)strtemp{
    
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < strtemp.length; i++) {
        
        
        unichar uc = [strtemp characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    
    return unicodeLength;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)uiConfig{
    kWeakS(weakSelf);
    
    self.deparmentHeight.constant = 0;
    self.cuttingline_one_height.constant = 0;
    self.sexHeight.constant = 0;
    self.ageHeight.constant = 0;
    self.cuttingline_two_height.constant = 0;
    self.wechatheight.constant = 0;
    self.QQheight.constant = 0;
    self.emailHeight.constant = 0;
    self.addressHeight.constant = 0;
    self.cuttingline_three_height.constant = 0;
    self.remarkHeight.constant = 0;
    self.cuttingline_add_height.constant = 60;
    self.phoneHeight.constant = 120;
    
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick)];
    
    UIImage * image = [UIImage imageNamed:@"QuickContant"];
    self.addressBtn.bounds = CGRectMake(0, 0, 30, 30);
    [self.addressBtn setImage:image forState:UIControlStateNormal];
    
    [self.phoneV configView];
    self.phoneV.action = ^(NSInteger cnt) {
        weakSelf.phoneHeight.constant = 20+cnt*50+100;
    };
    
    [self.remarkField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
#pragma mark - 数据处理
- (void)dataInit{
    NSArray *fieldArr = @[@"部门",@"性别",@"生日",@"微信",@"QQ",@"邮件",@"备注"];
    self.fieldArray = [NSMutableArray arrayWithArray:fieldArr];
    
}


#pragma mark - actionSheet
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1000) {
        if (buttonIndex==self.fieldArray.count) {
            return;
        }
        NSString *string = self.fieldArray[buttonIndex];
        if ([string isEqualToString:@"部门"]) {
            self.deparmentHeight.constant = 50;
        }
        if ([string isEqualToString:@"性别"]) {
            self.cuttingline_one_height.constant = 20;
            self.sexHeight.constant = 50;
        }
        if ([string isEqualToString:@"生日"]) {
            self.cuttingline_one_height.constant = 20;
            self.ageHeight.constant = 50;
        }
        if ([string isEqualToString:@"微信"]) {
            self.cuttingline_two_height.constant = 20;
            self.wechatheight.constant = 50;
        }
        if ([string isEqualToString:@"QQ"]) {
            self.cuttingline_two_height.constant = 20;
            self.QQheight.constant = 50;
        }
        if ([string isEqualToString:@"邮件"]) {
            self.cuttingline_two_height.constant = 20;
            self.emailHeight.constant = 50;
        }
        if ([string isEqualToString:@"地址"]) {
            self.cuttingline_two_height.constant = 20;
            self.addressHeight.constant = 50;
        }
        if ([string isEqualToString:@"备注"]) {
            self.cuttingline_three_height.constant = 20;
            self.remarkHeight.constant = 80;
        }
        [self.fieldArray removeObject:string];
        if (self.fieldArray.count == 0) {
            self.cuttingline_add_height.constant = 0;
        }
    }
    
    if (actionSheet.tag == 1001) {
        if (buttonIndex==2) {
            return;
        }
        NSArray *sexArray = @[@"男",@"女"];
        self.sexField.text = sexArray[buttonIndex];
    }
}

#pragma mark - 页面按钮点击
//选择客户按钮点击
- (IBAction)chooseClientButtonClick:(id)sender {
    kWeakS(weakSelf);
    if (self.clientModel != nil) {
        return;
    }
    HYSelectClientVC *vc = [[HYSelectClientVC alloc] init];
    vc.action = ^(HYClientModel *clientModel) {
        weakSelf.clientID = clientModel.Id;
        weakSelf.clientField.text = clientModel.name;
        [weakSelf.maskButton removeFromSuperview];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}
//选择性别按钮点击
- (IBAction)sexButtonClick:(id)sender {
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"请选择性别" buttonTitles:@[@"男",@"女"] redButtonIndex:-1 delegate:self];
    sheet.tag = 1001;
    [sheet show];
}
//选择生日按钮点击
- (IBAction)ageButtonClick:(id)sender {
    kWeakS(weakSelf);
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.datePickerMode = PGDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        NSLog(@"dateComponents = %@", dateComponents);
        NSString *dateString = [NSString stringWithFormat:@"%ld年%ld月%ld日",dateComponents.year,dateComponents.month,dateComponents.day];
        weakSelf.ageField.text = dateString;
    };
    [self presentViewController:datePickManager animated:YES completion:nil];
    
}

//添加更多字段按钮点击
- (IBAction)addButtonClick:(id)sender {
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"添加更多信息" buttonTitles:self.fieldArray redButtonIndex:-1 delegate:self];
    sheet.tag = 1000;
    [sheet show];
}
- (IBAction)maskButtonClick:(id)sender {
    //if (self.clientField.text.length == 0) {
        [self toastWithText:@"请先选择客户" andDruation:1];
//    }else{
//        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"添加更多信息" buttonTitles:self.fieldArray redButtonIndex:-1 delegate:self];
//        sheet.tag = 1000;
//        [sheet show];
//    }
}

- (void)saveButtonClick{
    
    if (!self.nameField.text.isNotEmpty){
        [self toastWithText:@"姓名不能为空" andDruation:1];
        return;
    }
    //let result = shareView.resultParams()
    UserModel *mode = [UserModel getUserModel];
    NSMutableDictionary *params;
    if ([self.title isEqualToString:@"创建联系人"]) {
        params =
        [[NSMutableDictionary alloc] initWithDictionary:
         @{
           @"contact_name":self.nameField.text,
           @"phone":[self.phoneV fetchPhones],
           @"client_id":self.clientID,
           @"client_name":[NSString stringWithFormat:@"%@",self.clientField.text],
           @"position_name":[NSString stringWithFormat:@"%@",self.positionField.text],
           @"email":[NSString stringWithFormat:@"%@",self.emailField.text],
           @"qq":[NSString stringWithFormat:@"%@",self.QQField.text],
           @"weixin":[NSString stringWithFormat:@"%@",self.wechatField.text],
           @"contact_addr":[NSString stringWithFormat:@"%@",self.addressField.text],
           @"dep":[NSString stringWithFormat:@"%@",self.deparmentField.text],
           @"sex":[NSString stringWithFormat:@"%@",self.sexField.text],
           @"birthday":[NSString stringWithFormat:@"%@",self.ageField.text],
           @"particulars":[NSString stringWithFormat:@"%@",self.remarkField.text],
           @"token":mode.token
           }];
    }else if ([self.title isEqualToString:@"修改联系人"]){
        params =
        [[NSMutableDictionary alloc] initWithDictionary:
         @{
           @"contact_name":self.nameField.text,
           @"contact_phone":[self.phoneV fetchPhones],
           @"contact_client_id":self.clientID,
           @"contact_client_name":[NSString stringWithFormat:@"%@",self.clientField.text],
           @"contact_position":[NSString stringWithFormat:@"%@",self.positionField.text],
           @"contact_email":[NSString stringWithFormat:@"%@",self.emailField.text],
           @"contact_qq":[NSString stringWithFormat:@"%@",self.QQField.text],
           @"contact_wechat":[NSString stringWithFormat:@"%@",self.wechatField.text],
           @"contact_addr":[NSString stringWithFormat:@"%@",self.addressField.text],
           @"contact_dep":[NSString stringWithFormat:@"%@",self.deparmentField.text],
           @"contact_sex":[NSString stringWithFormat:@"%@",self.sexField.text],
           @"birthday":[NSString stringWithFormat:@"%@",self.ageField.text],
           @"contact_comment":[NSString stringWithFormat:@"%@",self.remarkField.text],
           @"token":mode.token
           }];
        
    }
    
    
    
    _commitModel = [[SLRepeatInfoModel alloc]init];
    _commitModel.name = self.nameField.text;
    _commitModel.phone = [self.phoneV fetchPhones];
    _commitModel.email = self.emailField.text;
    _commitModel.qq = self.QQField.text;
    _commitModel.wechat = self.wechatField.text;
    _commitModel.birthday = self.ageField.text;
    _commitModel.sex = self.sexField.text;
    _commitModel.more = self.remarkField.text;
    _commitModel.client_name = self.clientField.text;
    _commitModel.client_id = self.clientID;
    _commitModel.position_name = self.positionField.text;
    _commitModel.dep = self.deparmentField.text;
    
//    NSString  *requestURL = @"pp.clientContact.contact_add";
     NSString * newRequestURL = @"pp.contact.contact_private_add_judge";
    
    if (![self.title isEqualToString:@"创建联系人"]) {
        [params setObject:[self.contactInfo[@"id"] toString] forKey:@"contact_id"];
        newRequestURL = @"pp.clientContact.contact_save";
        NSLog(@"URL:%@,参数%@",newRequestURL,params);
    }
    NSLog(@"新参数%@,%@",newRequestURL,params);
    kWeakS(weakSelf);
    [self showProgressWithStr:@"正在保存联系人..."];
    [HYBaseRequest getPostWithMethodName:newRequestURL Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        if (weakSelf.action) {
            weakSelf.action();
        }
        if ([self.title isEqualToString:@"修改联系人"]) {
            [self toastWithText:@"修改成功" andDruation:1.5];
        }else{
            [self toastWithText:@"新建成功" andDruation:1.5];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:^(NSDictionary *result) {
        int code = (int)[result objectForKey:@"status"];
        if (code == 35) {
            NSArray * dataArr = [result objectForKey:@"data"];
            NSMutableArray * array = [SLRepeatInfoModel mj_objectArrayWithKeyValuesArray:dataArr];
            SLRepeatInfoVC * rvc = [[SLRepeatInfoVC alloc]init];
            UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:rvc];
            rvc.dataArr = array;
            rvc.commitModel = self->_commitModel;
            rvc.notice = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [self presentViewController:nvc animated:YES completion:nil];
        }
        
        [weakSelf dissmissWithError];
    }];
}

@end
