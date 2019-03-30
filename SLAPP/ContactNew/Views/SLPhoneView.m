//
//  SLPhoneView.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLPhoneView.h"
@interface SLPhoneView()


/** 主要视图 */
@property(nonatomic)UIView * mainView;
/** 中间变量 */
@property(nonatomic)UIButton * selectedBtn;
/** 中间变量 */
@property(nonatomic,copy)NSArray * arr;
/** 选中的电话 */
@property(nonatomic,copy)NSString *phoneStr;

@end
@implementation SLPhoneView

static SLPhoneView * _instance = nil;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(void)showWithTitleArray:(NSArray *)titleArr sureBtnClicked:(SureBtn)sure
{
    _instance = [[SLPhoneView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _instance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _instance.windowLevel = UIWindowLevelAlert;
    _instance.hidden = NO;
    
    _instance.arr = titleArr;
    _instance.sureBtn = sure;
    
    _instance.mainView = [[UIView alloc]init];
    _instance.mainView.layer.masksToBounds = YES;
    _instance.mainView.layer.cornerRadius = 6;
    _instance.mainView.backgroundColor = [UIColor whiteColor];
    [_instance addSubview:_instance.mainView];
    [_instance.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_instance);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo(100+40*[titleArr count]);
    }];
    [_instance createViewWithArr:titleArr];
}
-(void)createViewWithArr:(NSArray *)phoneArr
{
    UILabel * remind = [[UILabel alloc]init];
    remind.text = @"请选择要拨打的手机号";
    remind.textColor = COLOR(50, 50, 50, 1);
    remind.font = [UIFont systemFontOfSize:17];
    remind.textAlignment = NSTextAlignmentCenter;
    [_mainView addSubview:remind];
    [remind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self->_mainView);
        make.top.equalTo(self->_mainView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 50));
    }];
    
    for (int i=0; i<[phoneArr count]; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"qf_select_statusdefault"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"qf_select_statuschoose"] forState:UIControlStateSelected];
        btn.tag = i;
        btn.frame = CGRectMake(100, 65+40*i, 20, 20);
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:btn];
        
        UILabel * content = [[UILabel alloc]init];
        content.text = phoneArr[i];
        content.textColor = COLOR(100, 100, 100, 1);
        content.font = [UIFont systemFontOfSize:15];
        [_mainView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(20);
            make.centerY.equalTo(btn);
        }];
       
        
    }
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_mainView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_mainView);
        make.bottom.equalTo(self->_mainView);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-60)/2, 40));
    }];
    
    UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    sure.titleLabel.font = [UIFont systemFontOfSize:17];
    [sure addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_mainView addSubview:sure];
    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_mainView);
        make.bottom.equalTo(self->_mainView);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-60)/2, 40));
    }];
}
-(void)buttonClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button != _selectedBtn) {
        button.selected = YES;
        _selectedBtn.selected = NO;
        _selectedBtn = button;
    }else{
        button.selected = YES;
    }
    /**选中的电话号码*/
    self.phoneStr = [self.arr objectAtIndex:button.tag];
}
-(void)cancel
{
    _instance.hidden = YES;
    _instance = nil;
}
-(void)sureBtnClicked
{
    if (self.phoneStr.length == 0) {
        return;
    }
    
    self.sureBtn(self.phoneStr);
    _instance.hidden = YES;
    _instance = nil;
}

@end
