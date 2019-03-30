//
//  QFChooseDateView.m
//  SLAPP
//
//  Created by qwp on 2018/8/6.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFChooseDateView.h"
#import "QFHeader.h"

@interface QFChooseDateView(){
    int viewType;
   
}

@end

@implementation QFChooseDateView

- (instancetype)initWithType:(int)type andFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        viewType = type;
        
        
        
    }
    return self;
}

- (void)configUI{
    
    if (!_currentSelect){
        _currentSelect = 0;
    }
    
    CGFloat padding = 15;
    int cnt = 4;
    CGFloat viewHeight = 30;
    NSArray *labelArray = @[@"本周",@"本月",@"本季度",@"本年"];
    NSArray *downLabelArray = @[@"上一周",@"上一月",@"上一季度",@"上一年"];
    CGFloat space = 20;
    if (viewType == 1) {
        cnt = 3;
        space = 5;
        labelArray = @[@"本月",@"本季度",@"本年"];
        downLabelArray = @[@"上一月",@"上季度",@"上一年"];
    }
    CGFloat width = (self.frame.size.width - space*(cnt-1) - padding*2)/cnt;
    
    for (int i=0; i<cnt; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(padding+(width+space)*i, 10, width, viewHeight)];
        view.layer.cornerRadius = 2;
        view.clipsToBounds = YES;
        [self addSubview:view];
        
        UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(padding+(width+space)*i, view.frame.size.height+view.frame.origin.y+0.5, width, view.frame.size.height)];
        downView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        downView.layer.cornerRadius = 2;
        downView.clipsToBounds = YES;
        [self addSubview:downView];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, view.frame.size.height)];
        label.text = labelArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [view addSubview:label];
        
        UILabel *downLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, view.frame.size.height)];
        downLabel.text = downLabelArray[i];
        downLabel.textAlignment = NSTextAlignmentCenter;
        downLabel.textColor = UIColorFromRGB(0x848484);
        downLabel.font = [UIFont systemFontOfSize:13];
        [downView addSubview:downLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width-view.frame.size.height, 0, view.frame.size.height, view.frame.size.height)];
        arrowImageView.image = [UIImage imageNamed:@"qf_down_arrowWhite"];
        arrowImageView.contentMode = UIViewContentModeCenter;
        [view addSubview:arrowImageView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:label.frame];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIButton *downButton = [[UIButton alloc] initWithFrame:label.frame];
        [downButton addTarget:self action:@selector(downButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [downView addSubview:downButton];
        
        view.tag = 100+i;
        downView.tag = 1000+i;
        label.tag = 200+i;
        downLabel.tag = 2000+i;
        button.tag = 300+i;
        downButton.tag = 3000+i;
        
        downView.hidden = YES;
        
        if (i == _currentSelect) {
            view.backgroundColor = UIColorFromRGB(0x4DAC61);
            label.textColor = UIColorFromRGB(0xFFFFFF);
        }else{
            view.backgroundColor = UIColorFromRGB(0xFFFFFF);
            label.textColor = UIColorFromRGB(0x848484);
        }
        
    }
    
    
}
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag-300 == _currentSelect) {
        UIView *downView = (UIView *)[self viewWithTag:sender.tag+700];
        downView.hidden = !downView.hidden;
        
    }else{
        int cnt = 4;
        NSArray *downLabelArray = @[@"上一周",@"上一月",@"上一季度",@"上一年"];
        if (viewType == 1){
            cnt = 3;
            downLabelArray = @[@"上一月",@"上季度",@"上一年"];
        }
        for (int i=0; i<cnt; i++) {
            UIView *downView = (UIView *)[self viewWithTag:1000+i];
            UILabel *downLabel = (UILabel *)[self viewWithTag:2000+i];
            downView.hidden = YES;
            downLabel.text = downLabelArray[i];
        }
        
        UIView *sview = (UIView *)[self viewWithTag:sender.tag-200];
        UILabel *slabel = (UILabel *)[self viewWithTag:sender.tag-100];
        sview.backgroundColor = UIColorFromRGB(0x4DAC61);
        slabel.textColor = UIColorFromRGB(0xFFFFFF);
        
        
        UIView *view = (UIView *)[self viewWithTag:_currentSelect+100];
        UILabel *label = (UILabel *)[self viewWithTag:_currentSelect+200];
        view.backgroundColor = UIColorFromRGB(0xFFFFFF);
        label.textColor = UIColorFromRGB(0x848484);
        
        NSArray *labelArray = @[@"本周",@"本月",@"本季度",@"本年"];
        if (viewType == 1) {
            labelArray = @[@"本月",@"本季度",@"本年"];
        }
        label.text = labelArray[_currentSelect];
        
        NSString *week = nil;
        NSString *month = nil;
        NSString *quarter = nil;
        NSString *year = nil;
        
        NSInteger tag = sender.tag-300;
        if (viewType == 1) {
            tag = tag+1;
        }
        switch (tag) {
            case 0:{
                week = self.thisWeek;
            }
                break;
            case 1:{
                month = self.thisMonth;
            }
                break;
            case 2:{
                quarter = self.thisQuarter;
            }
                break;
            case 3:{
                year = self.thisYear;
            }
                break;
            default:
                break;
        }
        
        if (self.block) {
            self.block(week, month, quarter, year);
        }
    }
    _currentSelect = sender.tag-300;
}
- (void)downButtonClick:(UIButton *)sender{
    
    UIView *downView = (UIView *)[self viewWithTag:sender.tag-2000];
    downView.hidden = YES;
    
    UILabel *label = (UILabel *)[self viewWithTag:sender.tag-1000];
    
    NSString *tempString = @"";
    tempString = label.text;
    
    UILabel *upLabel = (UILabel *)[self viewWithTag:sender.tag-1000-1800];
    label.text = upLabel.text;
    upLabel.text = tempString;
    
    
    NSString *week = nil;
    NSString *month = nil;
    NSString *quarter = nil;
    NSString *year = nil;
    
    NSInteger tag = sender.tag-3000;
    if (viewType == 1) {
        tag = tag+1;
    }
    NSInteger  range = 1;
    if ([upLabel.text rangeOfString:@"本"].length>0){
        range = 0;
    }
    switch (tag) {
        case 0:{
            week = [NSString stringWithFormat:@"%ld",[self.thisWeek integerValue]-range];
        }
            break;
        case 1:{
            month = [NSString stringWithFormat:@"%ld",[self.thisMonth integerValue]-range];
        }
            break;
        case 2:{
            quarter = [NSString stringWithFormat:@"%ld",[self.thisQuarter integerValue]-range];
        }
            break;
        case 3:{
            year = [NSString stringWithFormat:@"%ld",[self.thisYear integerValue]-range];
        }
            break;
        default:
            break;
    }
    
    if (self.block) {
        self.block(week, month, quarter, year);
    }
}
@end
