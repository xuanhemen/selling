//
//  HYFollowFiltrateV.m
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYFollowFiltrateV.h"

@interface HYFollowFiltrateV()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,assign)NSInteger currentRow;

@end

@implementation HYFollowFiltrateV
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataArray = @[@"全部",@"拜访",@"联系",@"商务",@"方案",@"自定义"];
        self.currentRow = 0;
        [self configUI];
    }
    return self;
}
- (void)configUI{
    UIButton *backView = [[UIButton alloc]initWithFrame:self.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    [backView addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backView];
    
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.6, self.frame.size.width, self.frame.size.height*0.4)];
    whiteBackView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [self addSubview:whiteBackView];
    
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, whiteBackView.frame.size.width, whiteBackView.frame.size.height-40)];
    pick.delegate = self;
    [whiteBackView addSubview:pick];
    
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 39)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [whiteBackView addSubview:cancelButton];
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 0, 60, 39)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:UIColorFromRGB(0x71B97D) forState:UIControlStateNormal];
    [whiteBackView addSubview:sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 1)];
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    [whiteBackView addSubview:line];
    
}
- (void)hiddenView{
    [self removeFromSuperview];
}

#pragma mark - picker
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentRow = row;
}

#pragma mark - 按钮
- (void)cancelButtonClick{
    [self hiddenView];
}

- (void)sureButtonClick{
    [self hiddenView];
    if (self.action) {
        self.action(self.currentRow);
    }
    
}
@end
