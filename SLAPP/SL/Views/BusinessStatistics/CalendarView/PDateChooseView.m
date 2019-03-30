//
//  PDateChooseView.m
//  SLAPP
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 柴进. All rights reserved.
//
#import "CardView.h"
#import "PDateChooseView.h"
@interface PDateChooseView()
@property(nonatomic,strong)UIDatePicker *startPicker;
@property(nonatomic,strong)UIDatePicker *endPicker;
@property(nonatomic,strong)CardView *card;
@property(nonatomic,strong)UIView *backView;
@end
@implementation PDateChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth-80, 350)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.center = self.center;
    [self addSubview:_backView];
    
    
    _card = [[CardView alloc]initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, 39)];
//    _card.titleNormalColor = [UIColor blackColor];
//    _card.titleSelectColor = [UIColor redColor];
    
    
    
//    [_card selectActionWithTag:0];
    
    kWeakS(weakSelf);
    
    
    
    _card.btnClickBlock = ^BOOL(NSInteger index) {
        DLog(@"%ld",index);
        if(index == 10){
            weakSelf.startPicker.hidden = false;
            weakSelf.endPicker.hidden = true;
        }else{
            weakSelf.startPicker.hidden = true;
            weakSelf.endPicker.hidden = false;
        }
        
        return YES;
    };
    [_card creatBtnsWithTitles:@[@"开始时间",@"结束时间"]];
    [_backView addSubview:_card];
    _startPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, _backView.frame.size.width, _backView.frame.size.height-90)];
    [_backView addSubview:_startPicker];
    _startPicker.datePickerMode = UIDatePickerModeDate;
    _startPicker.maximumDate = [NSDate date];
    //[riQidatePicker setDate:nowDate animated:YES];
    //属性：datePicker.date当前选中的时间 类型 NSDate
    
    [_startPicker addTarget:self action:@selector(dateChange:) forControlEvents: UIControlEventValueChanged];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
     _endPicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,40, _backView.frame.size.width, _backView.frame.size.height-40)];
    _endPicker.datePickerMode = UIDatePickerModeDate;
    _endPicker.maximumDate = [NSDate date];
    [_endPicker addTarget:self action:@selector(dateChangeEnd:) forControlEvents: UIControlEventValueChanged];
    _endPicker.hidden = true;
    [_backView addSubview:_endPicker];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    pinStr = [formatter stringFromDate:riQidatePicker.date];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.frame = CGRectMake(0, _backView.frame.size.height-50, _backView.frame.size.width/2.0, 50);
    [_backView addSubview:cancel];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    sure.frame = CGRectMake(_backView.frame.size.width/2.0, _backView.frame.size.height-50, _backView.frame.size.width/2.0, 50);
    [_backView addSubview:sure];
    
    [cancel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [cancel addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    [sure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dateChange:(UIDatePicker *)start{
    
}

-(void)dateChangeEnd:(UIDatePicker *)end{
    
}

-(void)cancelClick{
    [self removeFromSuperview];
}
-(void)sureClick{
    if ([_startPicker.date timeIntervalSince1970]>[_endPicker.date timeIntervalSince1970]) {
        [self toastWithText:@"开始时间不可以大于结束时间，请重新选择" andDruation:1];
        return;
    }
    if (_result) {
        NSString *str = [NSString stringWithFormat:@"%f,%f",[_startPicker.date timeIntervalSince1970],[_endPicker.date timeIntervalSince1970]];
        _result(str);
    }
    [self removeFromSuperview];
    
}
@end
