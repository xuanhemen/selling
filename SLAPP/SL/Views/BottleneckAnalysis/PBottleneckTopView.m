//
//  PBottleneckTopView.m
//  SLAPP
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "PBottleneckTopView.h"

@interface PBottleneckTopView()
@property(nonatomic,strong)UIButton *tempBtn;
@end
@implementation PBottleneckTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setData:(NSDictionary *)data{
    _data = data;
    [self configUI];
}
-(void)configUI{
    
    for (UIView *v in self.subviews) {
        if (v) {
            [v removeFromSuperview];
        }
    }
    
    _pjTag = 0;
    
    float height = 40;
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, height)];
    [self addSubview:titleL];
    titleL.font = [UIFont systemFontOfSize:14];
    titleL.textColor = [UIColor lightGrayColor];
//    titleL.text = @"慷慨激昂可视对讲卡视角大赛的:";
    
    
    NSArray *dispose_arr = _data[@"dispose_arr"];
    
    
    NSArray *stageArray = _data[@"re_stage_arr"];
    
    float maxRatioValue = [self getmaxValue:dispose_arr];
    
    float maxValue = [stageArray.firstObject[@"count"] floatValue];
    float w = self.frame.size.width-160;
    BOOL showPJ = NO;
    for (int i = 0; i < [stageArray count]; i++)
    {
        
        //QF 修改分母为0 崩溃
        NSDictionary *sDic = stageArray[i];
        float currentWidth = 0;
        if (maxValue != 0) {
            currentWidth = w *([sDic[@"count"] floatValue]/maxValue);
        }
        
        if (currentWidth < 100) {
            currentWidth = 100 ;
        }
        
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(10, 40+i*2*height,currentWidth, 30);
        lab.backgroundColor = [UIColor orangeColor];
        lab.textColor = [UIColor whiteColor];
        lab.font = [UIFont systemFontOfSize:13];
        [self addSubview:lab];
        lab.layer.cornerRadius = 15;
        lab.clipsToBounds = YES;

        lab.text = [NSString stringWithFormat:@"  %@  %@",sDic[@"name"],sDic[@"count"]];
        
        if (i != 0) {
            NSDictionary *rationDic = dispose_arr[i-1];
            
//            if ([rationDic[@"under"] floatValue] != 0) {
                UILabel *blab = [[UILabel alloc] initWithFrame:CGRectMake(currentWidth+5,40+i*2*height-15,125, 20)];
                blab.font = [UIFont systemFontOfSize:12];
                blab.textColor = [UIColor darkTextColor];
                blab.text = [NSString stringWithFormat:@"%@",rationDic[@"under_value"]];
                [self addSubview:blab];

//            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(currentWidth+10,40+i*2*height-45,70, 20);
            [btn setImage:[UIImage imageNamed:@"pBottleneckArrow"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%@%@",rationDic[@"ratio"],@"%"] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x4DAC61) forState:UIControlStateNormal];
            [self addSubview:btn];
            btn.tag = 1000+i;
            
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            if ([rationDic[@"under"] floatValue] == maxRatioValue  && showPJ == NO) {
                
                
                
                UILabel *pLable = [[UILabel alloc] initWithFrame:CGRectMake(currentWidth+125, 40+i*2*height-40, 40, 40)];
                pLable.layer.cornerRadius = 20;
                pLable.clipsToBounds = YES;
                pLable.font = [UIFont systemFontOfSize:14];
                pLable.textColor = [UIColor whiteColor];
                pLable.text = @"瓶颈";
                pLable.textAlignment = NSTextAlignmentCenter;
                pLable.backgroundColor = [UIColor redColor];
                [self addSubview:pLable];
                showPJ = YES;
                
               
                    _tempBtn = btn;
                    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                _pjTag = i - 1;
            }
            
            
        }
        
    }
    
    
}


-(float)getmaxValue:(NSArray *)array{
    float max = 0;
    for (NSDictionary *dic in array) {
        float v = [dic[@"under"] floatValue];
        max = max > v ? max :v;
    }
    return max;
    
}

-(void)btnClick:(UIButton *)btn{
    if (_tempBtn) {
        _tempBtn.backgroundColor = [UIColor whiteColor];
    }
    btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tempBtn = btn;
    
    if (self.btnClick) {
        self.btnClick(btn.tag-1000-1);
    }
}

@end
