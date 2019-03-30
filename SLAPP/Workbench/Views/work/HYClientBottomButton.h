//
//  HYClientBottomButton.h
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HYClientBottomButton : UIView

typedef void(^HYClientBottomButtonAction)(HYClientBottomButton *sender);

@property (nonatomic,copy) HYClientBottomButtonAction action;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *redView;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andBlock:(HYClientBottomButtonAction)block;

- (void)setRedViewWithNum:(NSInteger)num;
@end
