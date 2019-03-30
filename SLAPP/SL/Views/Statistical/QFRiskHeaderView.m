//
//  QFRiskHeaderView.m
//  SLAPP
//
//  Created by qwp on 2018/8/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFRiskHeaderView.h"
#import "QFHeader.h"

@interface QFRiskHeaderView()


@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation QFRiskHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [self configUI];
        
    }
    return self;
}
- (void)configUI{
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 40)];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.text = @"本月丢单的项目中，主要存在着如下风险：";
    self.tipLabel.textColor = UIColorFromRGB(0x333333);
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.tipLabel];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(15,40, self.frame.size.width-30, 250)];
    [self addSubview:self.backView];
    
    [self configUIWithData:nil];
}
- (CGFloat)configUIWithData:(NSArray *)array{
    
    for (UIView *subView in self.backView.subviews) {
        [subView removeFromSuperview];
    }
    
    if (array==nil||array.count==0) {
        NSString *string = self.tipLabel.text;
        NSString *dateString = [[string componentsSeparatedByString:@"丢单"] firstObject];
        self.tipLabel.text = [NSString stringWithFormat:@"%@没有丢单的项目！",dateString];
    }
    
    _dataArray = array;
    for (int i=0; i<array.count; i++) {
        
        NSString *string = [NSString stringWithFormat:@"%@（%@）",array[i][@"name"],array[i][@"count"]];
//        CGRect rect = [string boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        CGFloat maxValue = [array[0][@"count"] floatValue];
        CGFloat minValue = [array[array.count-1][@"count"] floatValue];
        CGFloat width = self.backView.frame.size.width;
        CGFloat currentValue = [array[i][@"count"] floatValue];
        if (maxValue == minValue) {
            //width = rect.size.width;
        }else{
            CGFloat tempValue = maxValue - minValue;
            width = width/2+(currentValue-minValue)/tempValue*(width/2);
        }
        [self configViewWithY:i*50 andText:string andGreenWidth:width+20 tag:i+1000];
        
    }
    
    self.backView.frame = CGRectMake(15,40, self.frame.size.width-30, array.count*50+40+10);
    
    
    return array.count*50+40+10;
    
}

- (void)configViewWithY:(CGFloat)y andText:(NSString *)text andGreenWidth:(CGFloat)width tag:(int)tag{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.backView.frame.size.width, 50)];
    [self.backView addSubview:view];

    if (width>view.frame.size.width) {
        width = view.frame.size.width;
    }
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, width, 40)];
    greenView.layer.cornerRadius = 3;
    greenView.clipsToBounds = YES;
    greenView.backgroundColor = UIColorFromRGB(0x4DAC62);
    [view addSubview:greenView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, greenView.frame.size.width-20, 40)];
    label.textColor = UIColorFromRGB(0xFFFFFF);
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    [greenView addSubview:label];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, 40);
    [greenView addSubview:btn];
   
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
}

-(void)btnClick:(UIButton *)btn{
    
    NSDictionary *dic = _dataArray[btn.tag-1000];
    if ([dic[@"pro"] isNotEmpty]) {
        if (self.clickIds) {
            self.clickIds(dic[@"pro"]);
        }
    }
    
}

@end
