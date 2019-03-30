//
//  UploadManager.h
//  UploadImages
//
//  Created by yabei on 16/7/7.
//  Copyright © 2016年 com.bodi.merchant. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^uploadCallBlock)();
typedef void(^uploadSuccess)(NSDictionary *imgDic, int idx);
typedef void(^uploadFailure)(NSError *error, int idx);

@interface UploadManager : NSObject

+ (void)uploadImagesWith:(NSArray *)images :(NSString *)url :(NSDictionary *)params uploadFinish:(uploadCallBlock)finish success:(uploadSuccess)success failure:(uploadFailure)failure;


+ (void)commentReqWithImages:(NSArray *)imageArr :(NSString *)url
                      params:(NSDictionary *)pramaDic
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *))failure;

@end
