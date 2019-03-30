//
//  HYAddPhoneV.m
//  SLAPP
//
//  Created by yons on 2018/10/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYAddPhoneV.h"
#import <Masonry/Masonry.h>

@interface HYAddPhoneV()

@property (nonatomic,strong) UIView *addView;
@end

@implementation HYAddPhoneV

- (void)configView{
    self.cnt = 0;
    [self addPhoneView];
    
    kWeakS(weakSelf);
    
    self.addView = [[UIView alloc] init];
    [self addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(49.5);
        make.bottom.mas_equalTo(0.5);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = UIColorFromRGB(0x333333);
    label.text = @"添加电话";
    [self.addView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(70);
        make.centerY.equalTo(weakSelf.addView.mas_centerY);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"qfphoneadd.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
    
}
- (void)addPhoneView{
    UIView *view = [[UIView alloc] init];
    view.tag = 100+self.cnt;
    [self addSubview:view];
    CGFloat y = 20+self.cnt*50;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(y);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = UIColorFromRGB(0x333333);
    if (y == 20) {
        label.text = @"手机";
    }else{
        label.text = @"电话";
    }
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(70);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:16];
    field.keyboardType = UIKeyboardTypeNumberPad;
    field.textColor = UIColorFromRGB(0x333333);
    if (y == 20) {
        field.placeholder = @"请输入手机号";
    }else{
        field.placeholder = @"请输入电话号";
    }
    field.tag = 200+self.cnt;
    [view addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).mas_offset(10);
        make.right.mas_equalTo(60);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"qfphonedel.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 300+self.cnt;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
}

- (void)delButtonClick:(UIButton *)button{
    
    NSInteger index = button.tag-300;
    if (self.cnt == 0) {
        UITextField *field = (UITextField *)[self viewWithTag:200];
        field.text = @"";
    }else{
        for (int i=0; i<=self.cnt; i++) {
            UIView *view = (UIView *)[self viewWithTag:i+100];
            UITextField *field = (UITextField *)[self viewWithTag:i+200];
            UIButton *button = (UIButton *)[self viewWithTag:i+300];
            if (i > index) {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.left.mas_equalTo(0);
                    make.height.mas_equalTo(50);
                    make.top.mas_equalTo((i-1)*50+20);
                }];
                view.tag = view.tag-1;
                field.tag = field.tag-1;
                button.tag = button.tag-1;
            }else if(i == index){
                [view removeFromSuperview];
            }
        }
        self.cnt = self.cnt-1;
        self.action(self.cnt);
    }
    
}
- (void)addButtonClick:(UIButton *)button{
    self.cnt = self.cnt+1;
    [self addPhoneView];
    self.action(self.cnt);
}


- (NSString *)fetchPhones{
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<=self.cnt; i++) {
        UITextField *field = (UITextField *)[self viewWithTag:200+i];
        if (field.text.isNotEmpty) {
            [array addObject:field.text];
        }
    }
    if (array.count == 0) {
        return @"0";
    }else{
        return [array componentsJoinedByString:@","];
    }
    
}
- (void)configPhones:(NSArray *)phoneArray{
    if (![phoneArray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (phoneArray.count == 0) {
        return;
    }
    for (int i=0; i<phoneArray.count-1; i++) {
        self.cnt = self.cnt+1;
        [self addPhoneView];
    }
    for (NSInteger i=0; i<=phoneArray.count-1; i++) {
        UITextField *field = (UITextField *)[self viewWithTag:200+i];
        field.text = phoneArray[i];
    }
    self.action(phoneArray.count-1);
}
@end
