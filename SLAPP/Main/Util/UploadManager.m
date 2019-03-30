//
//  UploadManager.m
//  UploadImages
//
//  Created by yabei on 16/7/7.
//  Copyright © 2016年 com.bodi.merchant. All rights reserved.
//

#import "UploadManager.h"
#import "NSURLSessionWrapperOperation.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFURLSessionManager.h>

@interface UploadManager ()
{
    NSMutableArray *imagesArr;
}
@end

@implementation UploadManager

//gcd上传
+ (void)commentReqWithImages:(NSArray *)imageArr :(NSString *)url
                      params:(NSDictionary *)pramaDic
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *))failure
{
    
    __block NSInteger imgBackCount = 0;
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < imageArr.count; i++) {
        
        dispatch_group_enter(group);
        
        NSURLSessionUploadTask* uploadTask = [UploadManager uploadTaskWithImage:imageArr[i] :url :pramaDic completion:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                //NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
//                @synchronized () {  NSMutableArray 是线程不安全的，所以加个同步锁
//                    
//                }
                imgBackCount++;
                if (imgBackCount == imageArr.count) {
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        
                        //图片上传之后的操作
                        
                    });

                }
                
                //处理成功返回数据
                
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
}


+ (void)uploadImagesWith:(NSArray *)images :(NSString *)url :(NSDictionary *)params uploadFinish:(uploadCallBlock)finish success:(uploadSuccess)success failure:(uploadFailure)failure
{
    
//自己在处理operation上传多图的时候， 可能会出现bug   completionOperation在最后一个uploadOperation还没完成时就执行了   会导致少一张图    暂时没找到原因；希望有大神能够找出问题所在
// （GCD和NSOperation之间的优缺点比较就不提了）

//很坑,最终测试  两个方法都没有问题  主要还是大量的异步操作.  导致 最后一个task回调回来的时候  completion的依赖触发,就执行完成回调了,这时候最后一个图上传的结果才回来
//针对这个大坑,只能在图片上传task里面  进行判断  成功个数count和数组个数相等  再执行fisish
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    queue.maxConcurrentOperationCount = 5;//control it yourself
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{ // 回到主线程执行，方便更新 UI 等
            //NSLog(@"上传完成!");
            
            finish();
        }];
    }];
    
    __block NSInteger imgBackCount = 0;
    for (NSInteger i = 0; i < images.count; i++) {
        
        NSURLSessionUploadTask* uploadTask = [UploadManager uploadTaskWithImage:images[i] :url :params completion:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                //NSLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                failure(error, (int)i);
            } else {
                //NSLog(@"第 %d 张图片上传成功: ", (int)i + 1);
                imgBackCount++;
                @synchronized (images) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    
                    NSError *error = nil;
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                    NSDictionary *imgInfoDic = [dic objectForKey:@"data"];
                    
                    success(imgInfoDic, (int)i);
                    /**
                     *  这里有i这个参数  所以图片成功返回数据的先后顺序是有序的  怎么做靠你自己拉
                     */
                    
                }
                
                if (imgBackCount == images.count) {
                    [queue addOperation:completionOperation];
                }
                
            }
        }];
        
        //重写系统NSOperation 很关键  你可以直接copy
        NSURLSessionWrapperOperation *uploadOperation = [NSURLSessionWrapperOperation operationWithURLSessionTask:uploadTask];
        [completionOperation addDependency:uploadOperation];
        [queue addOperation:uploadOperation];
        
    }
}

#pragma mark - util

+ (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage *)image  :(NSString *)url :(NSDictionary *)params completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    
    @autoreleasepool {
        
        // 构造 NSURLRequest
        NSError* error = NULL;
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //转换data的方法 仅适用于😈楼主😈本人
//            NSData *imageData = [image imageByScalingToWithSize:PIC_MAX_WIDTH];
            
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
        } error:&error];
        
        // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        AFHTTPResponseSerializer *responseSerializer = manager.responseSerializer;
        
        NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/plain"];
        
        manager.responseSerializer = responseSerializer;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        
        
        
        NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
       } completionHandler:completionBlock];
        
        return uploadTask;
        
    }
}

@end
