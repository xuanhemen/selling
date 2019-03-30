//
//  HYBaseRequest.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseRequest : NSObject


/**
 <#Description#>

 @param name 接口名称
 @param params 参数
 @param show 是否加提醒
 @param success 成功block
 @param fail 失败block
 */
+(void)getPostWithMethodName:(NSString *)name Params:(NSDictionary *)params showToast:(BOOL)show Success:(void (^)(NSDictionary * result))success fail:(void (^)(NSDictionary * result))fail;


+(void)downLoadFileWithUrl:(NSString *)url showToast:(BOOL)show Success:(void (^)(NSString * filePath))success fail:(void (^)(NSDictionary * result))fail;


@end
