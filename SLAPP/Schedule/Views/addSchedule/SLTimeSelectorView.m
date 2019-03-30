//
//  SLTimeSelectorView.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLTimeSelectorView.h"

@implementation SLTimeSelectorView{
    UIView * backView;
    NSMutableArray *years;
    NSMutableArray *months;
    NSMutableArray *days;
    NSMutableArray *hours;
    NSMutableArray *minutes;
    NSString *dateTime;
}
static NSString *year;
static NSString *month;
static NSString *day;
static NSString *hour;
static NSString *minute;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(0, 0, 0, 0.5);
        [self addTarget:nil action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        
        backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = CGRectMake(0, screenHeight, SCREEN_WIDTH, screenHeight-380);
        [self addSubview:backView];
        
        self.pickView.showsSelectionIndicator = YES;
        [backView addSubview:self.cancelBtn];
        [backView addSubview:self.sureBtn];
        
        [UIView animateWithDuration:0.3 animations:^{
            self->backView.frame = CGRectMake(0, screenHeight-380, SCREEN_WIDTH, screenHeight-380);
        }];
        
        [self createDataSource];
        
    }
    return self;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:color_normal forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_cancelBtn.superview).offset(10);
            make.left.equalTo(self->_cancelBtn.superview).offset(10);
        }];
    }
    return _cancelBtn;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:color_normal forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_cancelBtn.superview).offset(10);
            make.right.equalTo(self->_cancelBtn.superview).offset(-10);
        }];
    }
    return _sureBtn;
}
-(UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor clearColor];
        [backView addSubview:_pickView];
        [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->backView).insets(UIEdgeInsetsMake(0, 0, 100, 0));
        }];
        
    }
    return _pickView;
}
-(void)remove{
    [self removeFromSuperview];
}
#pragma mark - 确定时间
-(void)sureBtnClicked{
    self.passTime(dateTime,_style);
    [self removeFromSuperview];
}
- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return [_dataArr count];
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[_dataArr objectAtIndex:component] count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    for (UIView *lineView in pickerView.subviews) {
        if (lineView.frame.size.height<1) {
            lineView.backgroundColor = [UIColor lightGrayColor];
        }
    }
    UILabel * lable = [[UILabel alloc]init];
    lable.text = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    lable.textAlignment = NSTextAlignmentCenter;
    return lable;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0) {
        year = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    }
    if (component==1) {
        month = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    }
    if (component==2) {
        day = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    }
    if (component==3) {
        hour = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    }
    if (component==4) {
        minute = [[_dataArr objectAtIndex:component] objectAtIndex:row];
    }
    dateTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
    
    
}
-(void)createDataSource{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSDate *date = [NSDate date];
    NSString *datestr = [dateFormatter stringFromDate:date];
    NSArray * arr = [datestr componentsSeparatedByString:@"-"];
    NSLog(@"日期%@",arr);
    year = arr[0];
    month = arr[1];
    day = arr[2];
    hour = arr[3];
    minute = arr[4];
    
    dateTime = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:00",year,month,day,hour,minute];
    
    years = [NSMutableArray array];
    for (int i = 2019; i<=2030; i++) {
        NSString * yearStr = [NSString stringWithFormat:@"%d",i];
        [years addObject:yearStr];
    }
    months = [NSMutableArray array];
    NSString * monthStr;
    for (int i = 1; i<=12; i++) {
        if (i<=9) {
           monthStr  = [NSString stringWithFormat:@"0%d",i];
        }else{
           monthStr = [NSString stringWithFormat:@"%d",i];
        }
        
        [months addObject:monthStr];
    }
    days = [NSMutableArray array];
    NSString * dayStr;
    for (int i = 1; i<=31; i++) {
        if (i<=9) {
            dayStr  = [NSString stringWithFormat:@"0%d",i];
        }else{
            dayStr = [NSString stringWithFormat:@"%d",i];
        }
        [days addObject:dayStr];
    }
    hours = [NSMutableArray array];
    NSString * hourStr;
    for (int i = 0; i<=23; i++) {
        if (i<=9) {
            hourStr  = [NSString stringWithFormat:@"0%d",i];
        }else{
            hourStr = [NSString stringWithFormat:@"%d",i];
        }
        [hours addObject:hourStr];
    }
    minutes = [NSMutableArray array];
    NSString * minuteStr;
    for (int i = 0; i<=59; i++) {
        if (i<=9) {
            minuteStr  = [NSString stringWithFormat:@"0%d",i];
        }else{
            minuteStr = [NSString stringWithFormat:@"%d",i];
        }
        [minutes addObject:minuteStr];
    }
    
    _dataArr = [NSMutableArray arrayWithObjects:years,months,days,hours,minutes, nil];
    
    [_pickView selectRow:[year integerValue]-2019 inComponent:0 animated:NO];
    [_pickView selectRow:[month integerValue]-1 inComponent:1 animated:NO];
    [_pickView selectRow:[day integerValue]-1 inComponent:2 animated:NO];
    [_pickView selectRow:[hour integerValue]-0 inComponent:3 animated:NO];
    [_pickView selectRow:[minute integerValue]-0 inComponent:4 animated:NO];
}


@end
