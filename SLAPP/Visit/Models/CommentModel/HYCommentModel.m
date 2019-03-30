//
//  HYCommentModel.m
//  SLAPP
//
//  Created by apple on 2018/11/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYCommentModel.h"

@implementation HYCommentModel
+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"replys":@"HYReplyModel"
             };
}
@end
