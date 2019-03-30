//
//  MailConfigVC.h
//  CLApp
//
//  Created by 吕海瑞 on 16/9/3.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "HYBaseVC.h"

@interface MailConfigVC : HYBaseVC
@property (weak, nonatomic) IBOutlet UIButton *sysBtn;

@property (weak, nonatomic) IBOutlet UIButton *mineBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *mailUserName;
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *mailOassword;
@end
