//
//  HYReplyModel.h
//  SLAPP
//
//  Created by apple on 2018/11/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYReplyModel : NSObject
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,copy)NSArray *commenders; //点赞人
@property(nonatomic,copy)NSString *comment_id;
@property(nonatomic,copy)NSString *code_content;
@property(nonatomic,copy)NSString *delete;
@property(nonatomic,copy)NSArray *files;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,copy)NSString * commendernum; //点赞的个数
@property(nonatomic,copy)NSString *praise;//1是自己点赞
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *replyrealname;
@property(nonatomic,copy)NSString *head;
@end
