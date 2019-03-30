//
//  HYContactDetailVC.m
//  SLAPP
//
//  Created by yons on 2018/10/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYContactDetailVC.h"
#import "Masonry.h"
#import "SLContactDetailView.h"
#import "SLContactDetailModel.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"

#import "SLContactDetailObjcVC.h"
#import "QFTimeLineVC.h"
#import "LCActionSheet.h"
#import <ContactsUI/ContactsUI.h>
#import "UILabel+mothod.h"
#import "HYAddContactVC.h"
#import "SLPhoneView.h"
#define screen_width   [UIScreen mainScreen].bounds.size.width

@interface HYContactDetailVC ()<UITableViewDelegate,UITableViewDataSource,CNContactPickerDelegate,CNContactViewControllerDelegate,LCActionSheetDelegate,clickButton>
/** 详情数据对象 */
@property(nonatomic,strong)NSMutableDictionary * dataDic;
/** 数据源 */
@property(nonatomic,strong)NSArray * dataArr;
/** <#annotation#> */
@property(nonatomic,strong)CNContactViewController * cvvc;

/** 映射 */
@property(nonatomic,strong)NSMutableDictionary * mapDic;
@end

@implementation HYContactDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"联系人详情";
    /**映射*/
    NSDictionary * dictionary = @{@"姓名：":@"name",@"公司：":@"client_name",@"职位：":@"position_name",@"部门：":@"dep",@"性别：":@"sex",@"生日：":@"birthday",@"微信：":@"wechat",@"QQ：":@"qq",@"邮件：":@"email",@"地址：":@"addr",@"备注：":@"more",@"最新跟进：":@"fo_new_time_str",@"创建人：":@"realname",@"修改人：":@"save_realname",@"创建时间：":@"addtime_str",@"客户：":@"client_name"};
    _mapDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    /**请求详情*/
    [self requestDetails];
    /**创建底部视图*/
    [self createBottomView];
    // Do any additional setup after loading the view.
}
/**编辑联系人详情*/
-(void)editInfo
{
    HYAddContactVC * cvc = [[HYAddContactVC alloc]init];
    cvc.contactInfo = @{@"dep":_dataDic[@"dep"],//部门
                        @"sex":_dataDic[@"sex"],//性别
                        @"qq":_dataDic[@"qq"],//QQ
                        @"wechat":_dataDic[@"wechat"],//微信
                        @"email":_dataDic[@"email"],//邮件
                        @"addr":_dataDic[@"addr"],//地址
                        @"birthday":_dataDic[@"birthday"],//生日
                        @"more":_dataDic[@"more"],//备注
                        @"position_name":_dataDic[@"position_name"],//职位
                        @"client_id":self.client_id,//客户id
                        @"name":_dataDic[@"name"],//联系人姓名
                        @"id":self.contact_id,//联系人id
                        @"client_name":_dataDic[@"client_name"],//客户姓名
                        @"phone_arr":_dataDic[@"phone_arr"]};//电话
    
   [self.navigationController pushViewController:cvc animated:YES];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, K_SAFE_HEIGHT+50+2, 0));
        }];
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]init];
    return footView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArr count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 150;
    }
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        NSArray * phoneArr = self.dataDic[@"phone_arr"];
        NSInteger rows = [phoneArr count];
        return 10+rows;
    }
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indentifier = @"cell";
    SLContactDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[SLContactDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
    }else{
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.title.text = self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section==2) {
        [cell.title labelAlightLeftAndRightWithWidth:85];
    }else{
        [cell.title labelAlightLeftAndRightWithWidth:60];
    }
    
    NSString * key = _mapDic[cell.title.text];
    cell.content.text = self.dataDic[key];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"CustomPool" bundle:nil];
    CustomDetailViewController * svc = [storyBoard instantiateViewControllerWithIdentifier:@"CustomDetailViewController"];
    svc.customIdString = self.client_id;
    [self.navigationController pushViewController:svc animated:YES];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        SLContactDetailView * view = [[SLContactDetailView alloc]init];
        SLContactDetailModel * model = [[SLContactDetailModel alloc]init];
        model.name = _dataDic[@"name"];
        model.position = _dataDic[@"position_name"];
        model.dep = _dataDic[@"dep"];
        model.res = _dataDic[@"realname"];
        if (_dataDic[@"file_url"]!=[NSNull null]) {
            model.imgName = _dataDic[@"file_url"];
        }
       
        [view setCellWithModel:model];
        return view;
    }else{
        SLContactDetailHead * view = [[SLContactDetailHead alloc]init];
        if (section == 1) {
            view.title.text = @"基本信息";
        }else{
            view.title.text = @"系统信息";
        }
        return view;
    }
    
}
/**请求联系人详情*/
-(void)requestDetails
{
    __weak HYContactDetailVC * weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"token"] = model.token;
    parameter[@"contact_id"] = self.contact_id;
    parameter[@"client_id"] = self.client_id;
    
    NSString * urlStr = @"pp.contact.contact_particulars";
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlStr Params:parameter showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSLog(@"结果%@",result);
        /**取出整个联系人详情信息*/
        weakSelf.dataDic = [NSMutableDictionary dictionaryWithDictionary:result];
        NSArray * phoneArr = weakSelf.dataDic[@"phone_arr"];
        NSArray * mainArr = @[@"客户："];
        NSArray * arr = @[@"姓名：",@"公司：",@"职位：",@"部门：",@"性别：",@"生日：",@"微信：",@"QQ：",@"邮件：",@"备注："];
        NSMutableArray * basicInfoArr = [NSMutableArray arrayWithArray:arr];
        NSArray * systemArr = @[@"最新跟进：",@"创建人：",@"修改人：",@"创建时间："];
        for (int i = 0; i<[phoneArr count]; i++) {
            if ([phoneArr count] > 1) {
                NSString * name = [NSString stringWithFormat:@"手机%d：",i+1];
                NSString * nameStr = [NSString stringWithFormat:@"iphone%d",i+1];
                [basicInfoArr insertObject:name atIndex:4+i];
                [weakSelf.dataDic setObject:phoneArr[i] forKey:nameStr];
                [weakSelf.mapDic setObject:nameStr forKey:name];
            }else{
                [basicInfoArr insertObject:@"手机：" atIndex:4];
                [weakSelf.dataDic setObject:phoneArr[0] forKey:@"phone"];
                [weakSelf.mapDic setObject:@"phone" forKey:@"手机："];

            }
        }
        self.dataArr = @[mainArr,basicInfoArr,systemArr];
        [self.tableView reloadData];
        NSNumber * saveAuth = (weakSelf.dataDic[@"save_auth"]);

        if ([saveAuth intValue]==1) {

            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editInfo)];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
}
-(NSMutableDictionary *)dataDic
{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
/**创建底部bar*/
-(void)createBottomView
{
    SLContactBottomView * bottomView = [[SLContactBottomView alloc]init];
    bottomView.delegate = self;
    bottomView.bounds = CGRectMake(0, 0, screen_width, 50);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-K_SAFE_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(screen_width, 50));
    }];
    /**加阴影*/
    [self addShadowToView:bottomView withColor:COLOR(220, 220, 220, 1)];
}
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    
    theView.layer.shadowColor = theColor.CGColor;
    theView.layer.shadowOffset = CGSizeMake(0,0);
    theView.layer.shadowOpacity = 0.5;
    theView.layer.shadowRadius = 2;
    // 单边阴影 顶边
    float shadowPathWidth = theView.layer.shadowRadius;
    CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, theView.bounds.size.width, shadowPathWidth);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
    theView.layer.shadowPath = path.CGPath;
}
/**bottomView代理*/
-(void)passBtnTag:(NSInteger)tag
{
    if (tag==0) {
        SLContactDetailObjcVC * cvc = [[SLContactDetailObjcVC alloc]init];
        cvc.contact_id = self.contact_id;
        cvc.client_id = self.client_id;
        [self.navigationController pushViewController:cvc animated:YES];
    }else if (tag==1){

        QFTimeLineVC * tvc = [[QFTimeLineVC alloc]init];
        tvc.contactId = self.contact_id;
        tvc.contactName = _dataDic[@"name"];
        tvc.clientId = self.client_id;
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (tag==2){
        HYClientAndContactsVisitListVC *vc = [[HYClientAndContactsVisitListVC alloc] init];
        vc.title = @"";
        vc.contactId = self.contact_id;
        [self.navigationController pushViewController:vc animated:true];
        
//        [self toastWithText:@"暂未开放"];
    }else if (tag==3){
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"更多操作" buttonTitles:@[@"打电话",@"保存到手机"] redButtonIndex:-1 delegate:self];
        sheet.tag = 10001;
        [sheet show];
    }
    
}
#pragma mark - actionSheet
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 10001) {
        if (buttonIndex == 0) {
            NSArray *arr = self.dataDic[@"phone_arr"];
            if ([arr count]==0) {
                [self toastWithText:@"该联系人电话不存在"];
            }else if ([arr count]==1){
                NSString * phone = arr[0];
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
               
            }else{
                [SLPhoneView showWithTitleArray:arr sureBtnClicked:^(NSString *phone) {
                    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }];
            }
        }
        if (buttonIndex == 1) {
            CNContactStore * contactStore = [[CNContactStore alloc]init];
            BOOL isOrNo = [self getContactAuthorize:contactStore];
            if (isOrNo) {
                NSLog(@"已授权");
                // 创建联系人对象
                CNMutableContact *contact = [[CNMutableContact alloc] init];
                // 设置联系人姓名
                //contact.givenName = @"王";
                // 设置姓氏
                contact.familyName = self.dataDic[@"name"];
                NSArray * phoneArr = self.dataDic[@"phone_arr"];
                for (int i = 0; i<[phoneArr count]; i++) {
                    NSString * phone = [phoneArr objectAtIndex:i];
                    CNPhoneNumber *mobileNumber = [[CNPhoneNumber alloc] initWithStringValue:phone];
                    CNLabeledValue *mobilePhone = [[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberMobile value:mobileNumber];
                    contact.phoneNumbers = @[mobilePhone];
                }
                CNContactViewController * vc = [CNContactViewController viewControllerForNewContact:contact];
                vc.delegate = self;
                UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
                vc.navigationController.navigationBar.tintColor = [UIColor blackColor];
                //                vc.navigationController.navigationBar.translucent = NO;
                NSDictionary *dic = @{NSForegroundColorAttributeName: [UIColor blackColor]};
                vc.navigationController.navigationBar.titleTextAttributes = dic;
                [self presentViewController:nvc animated:YES completion:nil];
            }else{
                NSLog(@"没有授权");
            }
        }
        
    }
    
}
- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    if (contact) {
        [self toastWithText:@"保存成功"];
    }else{
        [self toastWithText:@"取消保存"];
    }
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}
//获取是否授权
- (BOOL)getContactAuthorize:(CNContactStore *)contactStore {
    __block BOOL grandted = YES;
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            grandted = YES;
        }else {
            grandted = NO;
        }
    }];
    return grandted;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
