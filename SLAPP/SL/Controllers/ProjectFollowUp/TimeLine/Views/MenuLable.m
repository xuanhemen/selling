//
//  MenuLable.m
//  SLAPP
//
//  Created by apple on 2018/9/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "MenuLable.h"

@implementation MenuLable

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}


- (void)setUp
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)]];
}


- (void)longPress
{

    [self becomeFirstResponder];
    UIMenuController * menu = [UIMenuController sharedMenuController];
    
    
    UIMenuItem * item = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(myCopy:)];
    menu.menuItems = @[item];
    if (menu.isMenuVisible)return;
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
    
}

#pragma mark - 对控件权限进行设置
/**
 *  设置label可以成为第一响应者
 *
 *  @注意：不是每个控件都有资格成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
/**
 *  设置label能够执行那些具体操作
 *
 *  @param action 具体操作
 *
 *  @return YES:支持该操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
     if(action == @selector(myCopy:)) return YES;
    return NO;
}

#pragma mark - 方法的实现

- (void)myCopy:(UIMenuController *)menu
{
    if (!self.text) return;
    //复制文字到剪切板
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
    
}

@end
