//
//  SLNewBuildScheduleVC.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/14.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLNewBuildScheduleVC.h"
#import "SLScheduleCell.h"
#import "SLTimeSelectorView.h"
#import "SLScheduleRemindVC.h"
#import "SLChooseCustomVC.h"
#import "SLSheduleContactVC.h"
#import "SLScheProjectVC.h"
#import "SLRealContactVC.h"
#import "SLScheduleContactModel.h"
#import <UserNotifications/UserNotifications.h>
#import "SLAPP-Swift.h"
#import "UILabel+SLFunc.h"
#import "SLTextFieldView.h"
@interface SLNewBuildScheduleVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

/** tablview */
@property(nonatomic)UITableView *tableView;
/**  */
@property(nonatomic,strong)SLScheduleCell * selectedCell;

@property(nonatomic,strong)NSMutableString *idStr;
/** 装选中参与人model */
@property(nonatomic,strong)NSMutableArray * modelArr;
/**中间变量cell*/
@property(nonatomic,strong)SLScheduleCell * seleCell;
/**详情信息*/
@property(nonatomic,copy)NSDictionary *detailDic;

@property(nonatomic)UIButton *button;

@property(nonatomic)UIView * secView;

@property(nonatomic)UITextView *contView;

@property(nonatomic)SLTextFieldView *titleView;

@end

@implementation SLNewBuildScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.buildStyle == SLBuildStyleNew){
        _itemString = @"添加";
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:_itemString forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_button];
        self.navigationItem.rightBarButtonItem = item;
     }
    
    _titleView = [[SLTextFieldView alloc]init];
   // _titleView.textView.scrollEnabled = NO;
    _titleView.title.text = @"标题";
    _titleView.placeHoder.text = @"请输入标题";
    _titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self.view addSubview:_titleView];
    kWeakS(weakSelf);
    _titleView.passContent = ^(NSString * _Nonnull contentStr) {
        weakSelf.params[@"title"] = contentStr;
    };
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.sectionFooterHeight = 0;
    _tableView.tableHeaderView = [self createTableView];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_titleView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveContactInfo:) name:@"contactInfo" object:nil];
    if (self.buildStyle != SLBuildStyleNew) {
        self.title = @"日程";
        [self requestData];
    }else{
        self.title = @"新建日程";
    }
    
   // [self requestRI];
    
    // Do any additional setup after loading the view.
}
#pragma mark - 创建内容输入框
-(UIView *)createTableView{
    
    _secView = [[UIView alloc]init];
    _secView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(15, 0, SCREEN_WIDTH-15, 0.5);
    layer.backgroundColor = gray_color.CGColor;
    [_secView.layer addSublayer:layer];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"内容";
    title.font = font(16);
    title.textColor = color_normal;
    [_secView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_secView).offset(15);
        make.centerY.equalTo(self->_secView);
    }];
    _contView = [[UITextView alloc]init];
    _contView.backgroundColor = [UIColor whiteColor];
    _contView.delegate = self;
    _contView.font = font(16);
    _contView.frame = CGRectMake(80, 0.5, SCREEN_WIDTH-80, 120);
    [_secView addSubview:_contView];
    
    if (self.buildStyle != SLBuildStyleNew) {
        _contView.text = self.detailDic[@"more"];
        self.params[@"more"] = self.detailDic[@"more"];
       
    }
    

    return _secView;
    
}
-(void)seterTabViewHeight{
    CGRect bounds = _contView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, CGFLOAT_MAX);
    CGSize newSize = [_contView sizeThatFits:maxSize];
    bounds.size = newSize;
    _contView.bounds = bounds;
    if (bounds.size.height<=120) {
        _contView.frame = CGRectMake(80, 0.5, SCREEN_WIDTH-80, 120);
        _secView.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, 120);
    }else{
        _contView.frame = CGRectMake(80, 0.5, SCREEN_WIDTH-80, bounds.size.height);
        _secView.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, bounds.size.height);
    }
    self.tableView.tableHeaderView = _secView;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.params[@"more"] = textView.text;
    
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-100, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    if (bounds.size.height<=120) {
        textView.frame = CGRectMake(80, 0.5, SCREEN_WIDTH-80, 120);
        _secView.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, 120);
    }else{
        textView.frame = CGRectMake(80, 0.5, SCREEN_WIDTH-80, bounds.size.height);
         _secView.frame = CGRectMake(0, 0.5, SCREEN_WIDTH, bounds.size.height);
    }
    self.tableView.tableHeaderView = _secView;
}
//-(void)requestRI{
//    [self showProgress];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"pull_time"] = [self getNowTimeTimestamp];
//
//    [HYBaseRequest getPostWithMethodName:@"pp.schedule.pull_schedule_all" Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
//        [self showDismiss];
////        self.detailDic = result;
////        [self.tableView reloadData];
//    } fail:^(NSDictionary *result) {
//
//    }];
//}
#pragma mark - 请求详情
-(void)requestData{
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"schedule_id"] = self.numberID;
    
    [HYBaseRequest getPostWithMethodName:@"pp.schedule.schedule_particulars" Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
        [self showDismiss];
        self.detailDic = result;
        NSInteger isEdit = [self.detailDic[@"save_status"] integerValue];
        NSInteger isDele = [self.detailDic[@"del_status"] integerValue];
        
        if (isEdit==1 && self.buildStyle != SLBuildStyleLook) {
            self->_itemString = @"编辑";
            self->_button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self->_button setTitle:self->_itemString forState:UIControlStateNormal];
            [self->_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self->_button addTarget:self action:@selector(addSchedule) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:self->_button];
            self.navigationItem.rightBarButtonItem = item;
        }
        if (isDele==1 && self.buildStyle != SLBuildStyleLook) {
            UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleBtn setTitleColor:color_normal forState:UIControlStateNormal];
            [deleBtn addTarget:self action:@selector(deleSchedule) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:deleBtn];
            [deleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.left.right.mas_equalTo(0);
                make.bottom.equalTo(self.view).offset(-K_SAFE_HEIGHT);
            }];
        }
        if (self.buildStyle != SLBuildStyleNew) {
            self.titleView.placeHoder.text = @"";
            self.titleView.textView.text = self.detailDic[@"title"];
            self.params[@"title"] = self.detailDic[@"title"];
            self.contView.text = self.detailDic[@"more"];
            self.params[@"more"] = self.detailDic[@"more"];
            [self seterTabViewHeight];
            [self.titleView seterSelfHeight];
        }
        
        [self.tableView reloadData];
    } fail:^(NSDictionary *result) {
        
    }];
}
#pragma mark - 删除
-(void)deleSchedule{
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"schedule_id"] = self.numberID;
    
    [HYBaseRequest getPostWithMethodName:@"pp.schedule.schedule_del" Params:[dic addToken] showToast:YES Success:^(NSDictionary *result) {
        [self showDismiss];
        [self toastWithText:@"删除成功" andDruation:1.5];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.freshList(self.numberID);
            [self.navigationController popViewControllerAnimated:YES];
        });
        
        
    } fail:^(NSDictionary *result) {
        
    }];
}
#pragma mark - 添加通知
-(void)addLocalNoticeWithTitle:(NSString *)title number:(NSString *)numberID time:(NSInteger)seconds{
    //  > 使用 UNUserNotificationCenter 来管理通知-- 单例
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // > 需创建一个包含待通知内容的 UNMutableNotificationContent 对象，可变    UNNotificationContent        对象，不可变
    //  > 通知内容
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    // > 通知的title
    content.title = [NSString localizedUserNotificationStringForKey:@"日程提醒" arguments:nil];
    // > 通知的要通知内容
    content.body = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.userInfo = @{@"id":numberID,@"content":title};
    // > 通知的提示声音
    content.sound = [UNNotificationSound defaultSound];
    
    //  > 通知的延时执行
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:seconds repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:numberID
                                                                          content:content trigger:trigger];
    
    //添加推送通知，等待通知即可！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
    
}
#pragma mark - 添加日程
-(void)addSchedule{
    if ([_itemString isEqualToString:@"编辑"]) {
        _itemString = @"完成";
        [_button setTitle:@"完成" forState:UIControlStateNormal];
        self.buildStyle = SLBuildStyleEdit;
        [self.tableView reloadData];
        return;
    }
    [self.view endEditing:YES];

    if (self.buildStyle != SLBuildStyleNew) {
        self.params[@"schedule_id"] = self.numberID;
    }
    if ([self.params[@"title"] isEqualToString:@""]) {
        [self toastWithText:@"请填写题目" andDruation:1.5];
        return;
    }else if ([self.params[@"more"] isEqualToString:@""]){
        [self toastWithText:@"请填写日程内容" andDruation:1.5];
        return;
    }else if ([self.params[@"begin_time"] isEqualToString:@""]){
        [self toastWithText:@"请选择开始时间" andDruation:1.5];
        return;
    }else if ([self.params[@"end_time"] isEqualToString:@""]){
        [self toastWithText:@"请选择结束时间" andDruation:1.5];
        return;
    }else if ([self.params[@"ahead_time"] isEqualToString:@""]){
        [self toastWithText:@"请选择提醒时间" andDruation:1.5];
        return;
    }
    NSString *beginStr = self.params[@"begin_time"];
   // NSString *remindStr = self.params[@"ahead_time"];
    NSString *endStr = self.params[@"end_time"];
    NSString *nowStr = [self getNowTimeTimestamp];
    if (self.buildStyle == SLBuildStyleNew){
        if ([endStr integerValue]>[beginStr integerValue] && [beginStr integerValue]>[nowStr integerValue]) {
            NSLog(@"no proplem");
        }else{
            [self toastWithText:@"请填写正确的时间" andDruation:1.5];
        }
    }
    
    [self showProgress];
    NSLog(@"最后%@",self.params);
    [HYBaseRequest getPostWithMethodName:@"pp.schedule.schedule_add_or_save" Params:[self.params addToken] showToast:YES Success:^(NSDictionary *result) {
        [self showDismiss];
        if (self.buildStyle == SLBuildStyleEdit) {
            [self toastWithText:@"修改成功" andDruation:1.5];
        }else if (self.buildStyle == SLBuildStyleNew){
            [self toastWithText:@"添加成功" andDruation:1.5];
        }
        
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *numberID = result[@"id"];
            NSString *beginStr = self.params[@"begin_time"];
            NSInteger begin = [beginStr integerValue];
            NSString *endStr = self.params[@"ahead_time"];
            NSInteger end = [endStr integerValue];
            NSString *nowStr = [self getNowTimeTimestamp];
            NSInteger now = [nowStr integerValue];
            NSInteger seconds = begin-now-end;
            NSLog(@"提%ld",(long)end);
            NSLog(@"我的%ld",(long)seconds);
            if (seconds>0) {
                 [self addLocalNoticeWithTitle:self.params[@"title"] number:numberID time:seconds];
            }
           
            self.freshList(numberID);
            [self.navigationController popViewControllerAnimated:YES];
        });
       
    } fail:^(NSDictionary *result) {
        
    }];
    
}
-(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//
//    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = gray_color;
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==2) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SLScheduleCell *cell = [[SLScheduleCell alloc]init];
    if (self.buildStyle == SLBuildStyleLook || self.buildStyle == SLBuildStyleToView) {
         cell.accessoryType = UITableViewCellAccessoryNone;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.title.text = @"关联业务";
            if (self.buildStyle != SLBuildStyleNew) {
                NSString *clientName = self.detailDic[@"client_name"];
                NSString *projectName = self.detailDic[@"pro_name"];
                NSString *contactName = self.detailDic[@"contact_name"];
                if (clientName.length!=0) {
                    cell.content.text = clientName;
                    self.params[@"client_id"] = self.detailDic[@"client_id"];
                }else if (projectName.length!=0){
                    cell.content.text = projectName;
                    self.params[@"pro_id"] = self.detailDic[@"pro_id"];
                }else if (contactName.length!=0){
                    cell.content.text = contactName;
                    self.params[@"contact_ids"] = self.detailDic[@"contact_ids"];
                }
            }
           
        }else{
            cell.title.text = @"参  与  人";
            if (self.buildStyle != SLBuildStyleNew) {
               
                NSArray *arr = self.detailDic[@"participator_name"];
                NSMutableString *string = [NSMutableString string];
                NSMutableString *idString = [NSMutableString string];
                self.modelArr = [NSMutableArray array];
                for (int i=0; i<[arr count]; i++) {
                    SLScheduleContactModel *model = [[SLScheduleContactModel alloc]init];
                    NSDictionary *dic = arr[i];
                    model.userid = dic[@"userid"];
                    model.realname = dic[@"realname"];
                    if (i==0) {
                        [string appendFormat:@"%@",dic[@"realname"]];
                        [idString appendFormat:@"%@",dic[@"userid"]];
                    }else{
                        [string appendFormat:@"、%@",dic[@"realname"]];
                        [idString appendFormat:@",%@",dic[@"userid"]];
                    }
                    [self.modelArr addObject:model];
                    
                }
                cell.content.text = string;
                self.params[@"participators"] = idString;
                //制造model
            }
            
        }
        cell.content.placeholder = @"请选择";
        cell.content.enabled = NO;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            cell.title.text = @"开始时间";
            cell.content.placeholder = @"请选择（必填）";
            if (self.buildStyle != SLBuildStyleNew) {
                cell.content.text = self.detailDic[@"begin_time_str"];
                self.params[@"begin_time"] = self.detailDic[@"begin_time"];
                NSString * nowStr = [self getNowTimeTimestamp];
                if ([self.detailDic[@"begin_time"] integerValue] <= [nowStr integerValue]) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }else{
            cell.title.text = @"结束时间";
            cell.content.placeholder = @"请选择 (必填)";
            if (self.buildStyle != SLBuildStyleNew) {
                cell.content.text = self.detailDic[@"end_time_str"];
                self.params[@"end_time"] = self.detailDic[@"end_time"];
            }
        }
         cell.content.enabled = NO;
    }else if (indexPath.section==2){
        if (self.buildStyle != SLBuildStyleNew) {
            NSString * str = self.detailDic[@"ahead_time"];
            NSInteger time = [str integerValue];
            NSInteger lastTime = time/3600;
            NSArray *arr = @[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:30],[NSNumber numberWithInteger:60],[NSNumber numberWithInteger:12*60],[NSNumber numberWithInteger:24*60]];
            NSInteger loc = [arr indexOfObject:[NSNumber numberWithInteger:lastTime*60]];
            NSString *locStr = [NSString stringWithFormat:@"%ld",loc];
            NSArray *array = @[@"0",@"1",@"2",@"3",@"4"];
            if ([array containsObject:locStr]) {
                NSArray *titles = @[@"无",@"30分钟前",@"1小时前",@"半天前",@"1天前"];
                cell.content.text = titles[loc];
            }else{
                cell.content.text = [NSString stringWithFormat:@"%ld小时",(long)lastTime];
            }
            self.params[@"ahead_time"] = self.detailDic[@"ahead_time"];
            NSString * nowStr = [self getNowTimeTimestamp];
            if ([self.detailDic[@"begin_time"] integerValue] <= [nowStr integerValue]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        cell.title.text = @"提醒";
        cell.content.placeholder = @"请选择（必填）";
        cell.content.enabled = NO;
    }
    
    return cell;
}
#pragma mark - textField、textView代理
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    [_seleCell.textView endEditing:YES];
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length == 0) {
//        return;
//    }
//    self.params[@"title"] = textField.text;
//}
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//     [_seleCell.content endEditing:YES];
//    _seleCell.placeHoler.text = @"";
//}
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    if (textView.text.length == 0) {
//        _seleCell.placeHoler.text = @"请输入日程内容";
//        return;
//    }
//    self.params[@"more"] = textView.text;
//}

#pragma mark - 转化成时间戳
-(NSString *)stringConversionDateString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datestr timeIntervalSince1970]];
    return timeSp;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.buildStyle == SLBuildStyleToView || self.buildStyle == SLBuildStyleLook ) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    SLScheduleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section==1) {//选择时间
        SLTimeSelectorView * timeView = [[SLTimeSelectorView alloc]initWithFrame:self.view.frame];
        if (indexPath.row==0) {
            timeView.style = @"begin";
            if (self.buildStyle == SLBuildStyleEdit) {
                NSString * nowStr = [self getNowTimeTimestamp];
                if ([self.detailDic[@"begin_time"] integerValue] <= [nowStr integerValue]) {
                    return;
                }
            }
        }else{
            timeView.style = @"end";
        }
        timeView.passTime = ^(NSString * _Nonnull time,NSString *style) {
            
            if ([style isEqualToString:@"begin"]) {
                NSString *timeStr = [self stringConversionDateString:time];
                self.params[@"begin_time"] = timeStr;
                 cell.content.text = time;
            }else{
                NSString *timeStr = [self stringConversionDateString:time];
                self.params[@"end_time"] = timeStr;
                cell.content.text = time;
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:timeView];
        
    }else if (indexPath.section==0){
        
        if (indexPath.row==0) {//关联业务
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:@"关联业务" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * customer = [UIAlertAction actionWithTitle:@"客户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SLChooseCustomVC * cvc = [[SLChooseCustomVC alloc]init];
                cvc.passCustom = ^(NSString * _Nonnull name, NSString * _Nonnull ID) {
                    cell.content.text = name;
                    self.params[@"client_id"] = ID;
                    self.params[@"pro_id"] = @"";
                    self.params[@"contact_ids"] = @"";
                };
                [self.navigationController pushViewController:cvc animated:YES];
                
            }];
            UIAlertAction * project = [UIAlertAction actionWithTitle:@"项目" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SLScheProjectVC *pvc = [[SLScheProjectVC alloc]init];
                pvc.passProject = ^(NSString * _Nonnull name, NSString * _Nonnull ID) {
                    cell.content.text = name;
                    self.params[@"pro_id"] = ID;
                     self.params[@"client_id"] = @"";
                     self.params[@"contact_ids"] = @"";
                };
                [self.navigationController pushViewController:pvc animated:YES];
            }];
            UIAlertAction * contact = [UIAlertAction actionWithTitle:@"联系人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SLRealContactVC *cvc = [[SLRealContactVC alloc]init];
                cvc.passContact = ^(NSString * _Nonnull name, NSString * _Nonnull ID) {
                    cell.content.text = name;
                    self.params[@"contact_ids"] = ID;
                    self.params[@"pro_id"] = @"";
                    self.params[@"client_id"] = @"";
                };
                [self.navigationController pushViewController:cvc animated:YES];
            }];
//            UIAlertAction * clues = [UIAlertAction actionWithTitle:@"线索" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
            
            [alert addAction:customer];
            [alert addAction:project];
            [alert addAction:contact];
           // [alert addAction:clues];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (indexPath.row==1){//参与人
            SLSheduleContactVC * svc = [[SLSheduleContactVC alloc]init];
            svc.parentID = @"";
            self->_selectedCell = cell;
            svc.modelArr = self.modelArr;
            [self.navigationController pushViewController:svc animated:YES];
        }
    }else if (indexPath.section==2){
        if (self.buildStyle == SLBuildStyleEdit) {
            NSString * nowStr = [self getNowTimeTimestamp];
            if ([self.detailDic[@"begin_time"] integerValue] <= [nowStr integerValue]) {
                return;
            }
        }
        SLScheduleRemindVC *svc = [[SLScheduleRemindVC alloc]init];
        svc.passRemindTime = ^(NSString * _Nonnull time, NSInteger paraTime) {
            cell.content.text = time;
            NSLog(@"提前%ld",(long)paraTime);
            self.params[@"ahead_time"] = [NSString stringWithFormat:@"%ld",(long)paraTime];
        };
        [self.navigationController pushViewController:svc animated:YES];
    }
}
-(void)reciveContactInfo:(NSNotification *)notice{
   
    NSDictionary *dic = notice.userInfo;
    _selectedCell.content.text = dic[@"name"];
    self.modelArr = dic[@"arr"];
    NSMutableString *string = [NSMutableString string];
    for (int i=0; i<[self.modelArr count]; i++) {
        SLScheduleContactModel *model = self.modelArr[i];
        if (i==0) {
            [string appendFormat:@"%@",model.userid];
        }else{
            [string appendFormat:@",%@",model.userid];
        }
    }
    self.params[@"participators"] = string;
}
//-(NSMutableArray *)modelArr{
//    if (!_modelArr) {
//        _modelArr = [NSMutableArray array];
//    }
//    return _modelArr;
//}
-(void)viewWillAppear:(BOOL)animated{
   
}
//参数
-(NSMutableDictionary *)params{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
        _params[@"title"] = @"";
        _params[@"more"] = @"";
        _params[@"begin_time"] = @"";
        _params[@"end_time"] = @"";
        _params[@"pro_id"] = @"";
        _params[@"client_id"] = @"";
        _params[@"contact_ids"] = @"";
        _params[@"participators"] = @"";//参与人 可多选
        _params[@"ahead_time"] = @"";//提前多少秒
    }
    return _params;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
