//
//  LoginTextView.m
//  CLApp
//
//  Created by harry on 16/12/15.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//
#import <ReactiveCocoa/ReactiveCocoa-Swift.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveObjC/ReactiveObjC.h>
#define kNavBarBGColor  [UIColor colorWithHexString:@"43be5f"]
//清除图片名称
#import <ChameleonFramework/Chameleon.h>
#define deleteImage @"x"
#define textSpace 0
#import "SLAPP-Swift.h"
#import "LoginTextView.h"
#import "Masonry.h"
@interface LoginTextView ()
@property(nonatomic,strong)UIButton *verify;

@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)UIImageView *deleteView;
@end

@implementation LoginTextView
{
    dispatch_source_t timer;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame AndImage:(NSString *)imageName placeText:(NSString *)place AndIsHasVerifyBtn:(BOOL)verifyBtn
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        
//        kWeakS(weakSelf);
        __weak typeof(self) weakSelf = self;
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        
        __weak typeof(backView) weakBack = backView;
        [backView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(weakSelf).offset(textSpace);
             make.height.mas_equalTo(weakSelf.bounds.size.height);
             make.top.mas_equalTo(weakSelf).offset(0);
             make.right.mas_equalTo(weakSelf).offset(verifyBtn?-100:-textSpace);
         }];
        
        
        
        UIImageView *imageView = [[UIImageView alloc]init];
        if (imageName) {
             imageView.image = [UIImage imageNamed:imageName];
        }
       
        [backView addSubview:imageView];
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(weakBack).offset(5);
             make.centerY.mas_equalTo(weakBack);
             make.size.mas_equalTo(CGSizeMake(20, 20));
         }];
        
        
        self.deleteView = [[UIImageView alloc]init];
        [backView addSubview:self.deleteView];
        self.deleteView.image = [UIImage imageNamed:deleteImage];
        [self.deleteView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(weakBack).offset(0);
             make.centerY.mas_equalTo(weakBack);
             make.size.mas_equalTo(CGSizeMake(20, 20));
         }];
        

        
        
        
        
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backView addSubview:self.deleteBtn];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.mas_equalTo(weakBack).offset(0);
             make.centerY.mas_equalTo(weakBack);
             make.size.mas_equalTo(CGSizeMake(20, 20));
         }];
        
        
        self.textField = [[UITextField alloc]init];
        [backView addSubview: self.textField];
        [self.textField setFont:[UIFont systemFontOfSize:14]];
        if (place) {
            self.textField.placeholder = place;
        }
        
        __weak typeof(imageView) weakImage = imageView;
       
        [ self.textField mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.mas_equalTo(weakImage.mas_right).offset(5);
             make.centerY.mas_equalTo(weakBack);
             make.right.mas_equalTo(weakSelf.deleteBtn.mas_left).offset(0);
         }];
        
       
        [self.textField.rac_textSignal subscribeNext:^(id x)
         {
             
             
             if ([self isNotEmpty:x] )
             {
                 weakSelf.deleteBtn.hidden = NO;
                 weakSelf.deleteView.hidden = NO;
                 
             }
             else
             {
                 
                 
                 weakSelf.deleteBtn.hidden = YES;
                 weakSelf.deleteView.hidden = YES;
             }

         }];
        
        
        backView.layer.cornerRadius = 6;
        backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        backView.layer.borderWidth = 0.5;

        self.deleteBtn.hidden = YES;
        self.deleteView.hidden = YES;
        if (verifyBtn)
        {
            [self addVerify];
        }

        
        
    }
    return self;
    

}

-(BOOL)isNotEmpty:(id)x
{
    if (x==nil){
        return NO;
    }
    if ([x length] == 0){
        return NO ;
    }
    return YES;
}

/**
 添加验证码获取
 */
-(void)addVerify
{
    __weak typeof(self) weakSelf = self;
    self.verify = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.verify];
    [self.verify.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.verify addTarget:self action:@selector(verify:) forControlEvents:UIControlEventTouchUpInside];
    [self.verify mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerY.mas_equalTo(weakSelf);
         make.right.mas_equalTo(weakSelf).offset(-textSpace);
         make.size.mas_equalTo(CGSizeMake(70, weakSelf.bounds.size.height));
     }];
    
    [self.verify setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.verify.backgroundColor = kNavBarBGColor;
    self.verify.layer.cornerRadius = 6;
    
}

-(void)deleteBtnClick:(UIButton *)btn
{
    self.textField.text = nil;
    self.deleteView.hidden = YES;
    btn.hidden = YES;
}

-(void)verify:(UIButton *)verify
{
   
    verify.enabled = NO;
    if (self.sendVerify){
        self.sendVerify();
        return;
    }
   
   
    
    
}

/**
 开始定时器，倒计时
 */
-(void)startTimer
{
    if (_codeSendSuccess) {
        _codeSendSuccess();
    }
   __weak typeof(self) weakSelf = self;
    __block int s = 60;
    int interval = 1;
    int leeway = 0;
    [self.verify setTitle:[NSString stringWithFormat:@"重新获取%d",s] forState:UIControlStateDisabled];
    
    
    self.verify.backgroundColor = [UIColor lightGrayColor];
    __weak typeof(self.verify) weakSender = self.verify;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if (!timer)
    {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), interval * NSEC_PER_SEC, leeway);
        
        dispatch_source_set_event_handler(timer, ^{
            s -=1;
//            //NSLog(@"%d",s);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSender setTitle:[NSString stringWithFormat:@"重新获取%d",s] forState:UIControlStateDisabled];
                
                if (s <= 1) {
                    
                    [weakSelf stopTimer];
                     [self.verify setTitle:@"重新获取" forState:UIControlStateNormal];
                    if (_reBiud) {
                        _reBiud();
                    }
                }
                
            });
        });
        dispatch_resume(timer);
    }
}


/**
 取消定时器
 */
-(void)stopTimer
{
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
   
    
    self.verify.enabled = YES;
    self.verify.backgroundColor = kNavBarBGColor;
    
    
}
-(void)stop
{
    [self stopTimer];
}
-(void)dealloc
{
    [self stopTimer];
}
@end
