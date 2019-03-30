//
//  HYHomeTableHeaderView.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeTableHeaderView.h"

@implementation HYHomeTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = UIColorFromRGB(0xE1E1E1);
        _backView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 60)];
        _backView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        _backView.layer.cornerRadius = 30;
        //_backView.layer.borderWidth = 0.5;

        _backView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
        _backView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _backView.layer.shadowOpacity = 0.5;//不透明度
        _backView.layer.shadowRadius = 1;//半径
        
        //_backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:_backView];
        
//        [self configUI];
        
    }
    return self;
}


-(void)setList:(NSArray *)list{
    _list = list;
    [self configUI];
}



-(void)configUI{
    
    for (UIView *view in _backView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger count = _list.count;
    CGFloat width = (kScreenWidth-80)/count;
    
    for (int i = 0; i < count; i++) {
        
        HYHomeTableHeaderViewLab *lable = [[HYHomeTableHeaderViewLab alloc] initWithFrame:CGRectMake(20 + width*i, 5, width,50)];
        [_backView addSubview:lable];
        
        HomeRemindModel *model = _list[i];
        lable.top.text = model.num;
        lable.bottom.text = model.name;
        
        if (i == count-1 ) {
            lable.line.hidden = true;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20 + width*i, 0, width, _backView.frame.size.height)];
        button.tag = i+100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:button];
    }
    
}
- (void)buttonClick:(UIButton *)sender{
    HomeRemindModel *model = _list[sender.tag-100];
    if (self.action) {
        self.action(model);
    }
}
@end




@implementation HYHomeTableHeaderViewLab

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat height =  frame.size.height/2.0;
        CGFloat width =  frame.size.width;
        
        _top = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        [self addSubview:_top];
        _top.text = @"";
        _top.textAlignment = NSTextAlignmentCenter;
        _top.textColor = [UIColor darkTextColor];
        [_top setFont:kBoldFont(22)];
        _bottom = [[UILabel alloc] initWithFrame:CGRectMake(0,frame.size.height/2.0,width, height)];
        
        _bottom.text = @"客户";
        _bottom.textColor = [UIColor darkTextColor];
        _bottom.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_bottom];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(width-0.5, (height-15), 0.5,30)];
       
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
    }
    return self;
}

@end
