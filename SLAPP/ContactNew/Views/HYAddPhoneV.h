//
//  HYAddPhoneV.h
//  SLAPP
//
//  Created by yons on 2018/10/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYAddPhoneHeightChange)(NSInteger cnt);
@interface HYAddPhoneV : UIView
@property (nonatomic,assign) NSInteger cnt;
@property (nonatomic,copy)HYAddPhoneHeightChange action;

- (void)configView;
- (void)configPhones:(NSArray *)phoneArray;
- (NSString *)fetchPhones;
- (void)delButtonClick:(UIButton *)button;
@end
