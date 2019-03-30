//
//  HYAddContactVC.h
//  SLAPP
//
//  Created by yons on 2018/10/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAddPhoneV.h"
#import "HYClientModel.h"

typedef void(^QFEditContact)(void);
@interface HYAddContactVC : UIViewController

@property (weak, nonatomic) IBOutlet HYAddPhoneV *phoneV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneHeight;

@property (weak, nonatomic) IBOutlet UITextField *clientField;//客户
@property (weak, nonatomic) IBOutlet UITextField *nameField;//姓名
@property (weak, nonatomic) IBOutlet UITextField *positionField;//职位

@property (weak, nonatomic) IBOutlet UITextField *deparmentField;//部门
@property (weak, nonatomic) IBOutlet UITextField *sexField;//性别
@property (weak, nonatomic) IBOutlet UITextField *ageField;//生日
@property (weak, nonatomic) IBOutlet UITextField *wechatField;//微信
@property (weak, nonatomic) IBOutlet UITextField *QQField;//QQ
@property (weak, nonatomic) IBOutlet UITextField *emailField;//邮箱
@property (weak, nonatomic) IBOutlet UITextField *addressField;//地址
@property (weak, nonatomic) IBOutlet UITextField *remarkField;//备注


@property (weak, nonatomic) IBOutlet UIButton *maskButton;//变态的蒙版按钮


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deparmentHeight;//部门高度 显示50 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuttingline_one_height;//第一条邪恶分割线 显示20 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sexHeight;//性别高度 显示50 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ageHeight;//生日高度 显示50 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuttingline_two_height;//第二条邪恶分割线 显示20 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QQheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuttingline_three_height;//第三条邪恶分割线 显示20 隐藏 0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cuttingline_add_height;


@property (nonatomic,strong) NSString *contactID;
@property (nonatomic,strong) NSString *clientID;

@property(nonatomic,assign)BOOL *isFromCustom;

@property (nonatomic,strong) NSDictionary *contactInfo;
@property (nonatomic,strong) HYClientModel *clientModel;
@property (nonatomic,copy) QFEditContact action;

/** <#annotation#> */
@property(nonatomic,copy)NSString *indentifier;

@end
