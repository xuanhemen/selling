//
//  DatePicker.h
//  拜访罗盘
//
//  Created by harry on 16/6/1.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDatePicker : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)sureBtnClick:(id)sender;
@property (nonatomic,copy) void (^resultTimeStr)(NSString *str,double timeStamp);
@property (assign, nonatomic) BOOL isVisit;//拜访里选择日期

-(void)showInVC:(UIView *)view;
@end
