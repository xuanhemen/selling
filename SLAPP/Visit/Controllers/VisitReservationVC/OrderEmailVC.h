//
//  OrderEmailVC.h
//  拜访罗盘
//
//  Created by harry on 16/7/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "HYBaseVC.h"

@interface OrderEmailVC : HYBaseVC
/**
 *  是否是总结评估  yes 为总结评估  其他预约
 */
@property(nonatomic,assign)BOOL isSummarytemp;

@property (weak, nonatomic) IBOutlet UITextView *emailText;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet UITextField *copytoText;

@property (weak, nonatomic) IBOutlet UITextField *SendToUserText;
- (IBAction)sendBtnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property(nonatomic,copy)NSString *emailBodyStr;

@property (strong, nonatomic) NSString *visitId;
@end
