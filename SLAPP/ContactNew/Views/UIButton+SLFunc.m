//
//  UIButton+SLFunc.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "UIButton+SLFunc.h"
#import <objc/runtime.h>
@implementation UIButton (SLFunc)
//定义常量 必须是C语言字符串
static char *CloudoxKey = "CloudoxKey";

-(void)setIndentifierStr:(NSString *)indentifierStr
{
     objc_setAssociatedObject(self, CloudoxKey, indentifierStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)indentifierStr
{
    return objc_getAssociatedObject(self, CloudoxKey);
}
@end
