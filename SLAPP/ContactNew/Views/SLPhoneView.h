//
//  SLPhoneView.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBtn)(NSString * phone);
@interface SLPhoneView : UIWindow

/** <#annotation#> */
@property(nonatomic,copy)SureBtn sureBtn;

+(void)showWithTitleArray:(NSArray *)titleArr sureBtnClicked:(SureBtn)sure;
@end
