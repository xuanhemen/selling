//
//  HYBaseRequest.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
@implementation HYBaseRequest

+(void)getPostWithMethodName:(NSString *)name Params:(NSDictionary *)params showToast:(BOOL)show Success:(void (^)(NSDictionary * result))success fail:(void (^)(NSDictionary * result))fail{
    //    TODO:临时处理  要都换成oc
    [LoginRequest getPostWithMethodName:name params:params hadToast:show fail:fail success:success];
    
}



+(void)downLoadFileWithUrl:(NSString *)url showToast:(BOOL)show Success:(void (^)(NSString * result))success fail:(void (^)(NSDictionary * result))fail{
    
    if (![url isNotEmpty]) {
        fail(nil);
        return;
    }
//   NSString * str = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * str = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *requestUrl = [NSURL URLWithString:str];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
   AFHTTPSessionManager * manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //沙盒地址
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        //文件地址(加入时间戳,防止文件名一样打开错误的文件)
        DLog(@"sssssssssssss");
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%ld%@",(long)interval,[response suggestedFilename]]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to __________ : %@", filePath);
        if (error) {
            fail(nil);
        }
        if (filePath) {
            success(filePath.absoluteString);
        }
        
    }];
    [downloadTask resume];
}





@end
