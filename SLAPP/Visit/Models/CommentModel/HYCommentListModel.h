//
//  HYCommentListModel.h
//  SLAPP
//
//  Created by apple on 2018/11/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCommentListModel : NSObject
@property(nonatomic,copy)NSString * project_name;
@property(nonatomic,copy)NSString * client_name;
@property(nonatomic,copy)NSString * contact_name;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * commentnum;
@property(nonatomic,copy)NSArray  * comment;
@end
