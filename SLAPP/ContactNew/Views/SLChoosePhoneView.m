//
//  SLChoosePhoneView.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLChoosePhoneView.h"

@implementation SLChoosePhoneView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withPhoneArr:(NSArray *)phoneArr
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * remind = [[UILabel alloc]init];
        remind.text = @"请选择要拨打的手机号";
        remind.textColor = COLOR(50, 50, 50, 1);
        remind.font = [UIFont systemFontOfSize:17];
        [self addSubview:remind];
        [remind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
        }];

        for (int i=0; i<[phoneArr count]; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:@"qf_select_statusdefault"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"qf_select_statuschoose"] forState:UIControlStateSelected];
            btn.tag = i;
            btn.frame = CGRectMake(15, 50+40*i, 30, 30);
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
        }
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:17];
        [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
        
        UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        sure.titleLabel.font = [UIFont systemFontOfSize:17];
        [sure addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:sure];
        [sure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
        
    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
   
}
-(void)cancel
{
    [self removeFromSuperview];
}
-(void)sureBtn
{
    NSLog(@"确定");
}
@end
