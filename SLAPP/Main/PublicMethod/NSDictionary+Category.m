//
//  NSDictionary+Category.m
//  SLAPP
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "NSDictionary+Category.h"
#import "SLAPP-Swift.h"
@implementation NSDictionary (Category)


/**
 参数请求添加token
 
 @return 返回添加token后的参数
 */
-(NSDictionary *)addToken{
    UserModel *uModel = [UserModel getUserModel];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:self];
    params[@"token"] = uModel.token;
    return params;
}

@end
