//
//  LoginTextView.h
//  CLApp
//
//  Created by harry on 16/12/15.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTextView : UIView
@property(nonatomic,assign)NSInteger phoneOrEmail;  //1phone 2email
//是注册 还是忘记  还是 登录     对应 1  2  3
@property(nonatomic,assign)NSInteger viewType;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,copy)void(^reBiud)();
@property(nonatomic,copy)void(^codeSendSuccess)();
@property(nonatomic,copy)void(^sendVerify)();
-(id)initWithFrame:(CGRect)frame AndImage:(NSString *)imageName placeText:(NSString *)place AndIsHasVerifyBtn:(BOOL)verifyBtn;



-(void)stop;

/**
 开始定时器，倒计时
 */
-(void)startTimer;

@end
