//
//  HYCommentModel.h
//  SLAPP
//
//  Created by apple on 2018/11/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCommentModel : NSObject

@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString * code_content;
@property(nonatomic,copy)NSString * realname;
@property(nonatomic,copy)NSString * addtime;
@property(nonatomic,copy)NSArray * commenderUsers; //点赞的人
@property(nonatomic,copy)NSString * userid;
@property(nonatomic,copy)NSString * praise; //1 是自己点过赞
@property(nonatomic,copy)NSString * addformattime;
@property(nonatomic,copy)NSString * delete;
@property(nonatomic,copy)NSString * head;
@property(nonatomic,copy)NSString * commendernum; //点赞的个数
@property(nonatomic,copy)NSString * replynum;
@property(nonatomic,copy)NSArray * replys;
@property(nonatomic,copy)NSArray * files;
@end
