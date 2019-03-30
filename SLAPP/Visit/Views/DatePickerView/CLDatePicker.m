
//
//  DatePicker.m
//  拜访罗盘
//
//  Created by harry on 16/6/1.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "CLDatePicker.h"

@implementation CLDatePicker

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_cancelBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kgreenColor forState:UIControlStateSelected];
    [_sureBtn setTitleColor:kgreenColor forState:UIControlStateNormal];
    [_sureBtn setTitleColor:kgreenColor forState:UIControlStateSelected];
    
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
}

-(void)setIsVisit:(BOOL)isVisit
{
    _isVisit = isVisit;
    if (_isVisit == YES) {
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
}
-(void)showInVC:(UIView *)view
{

    
     self.frame = CGRectMake(0, kScreenHeight-kNav_height, kScreenWidth, 200);
    [UIView animateWithDuration:0.5 animations:^{
        self .frame = CGRectMake(0, kMain_screen_height_px-200-kNav_height, kScreenWidth, 200);
    }];
    
    [view addSubview:self];

}


- (IBAction)cancelBtnClick:(id)sender
{
    if (_resultTimeStr)
    {
        _resultTimeStr(nil,0);
    }
    [self removeFromSuperview];
}

- (IBAction)sureBtnClick:(id)sender
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
    
    //拜访里要精确到分钟
    if (self.isVisit == YES) {
        [fomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        [fomatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSString *dateStr = [fomatter stringFromDate:_datePicker.date];
    if (_resultTimeStr) {
        _resultTimeStr(dateStr,[_datePicker.date timeIntervalSince1970]);
    }
    [self removeFromSuperview];
}
@end
