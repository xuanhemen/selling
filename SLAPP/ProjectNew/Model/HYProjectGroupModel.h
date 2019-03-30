//
//  HYProjectGroupModel.h
//  SLAPP
//
//  Created by fank on 2019/1/3.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import "QFBaseModel.h"

@interface HYProjectGroupModel : QFBaseModel

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *count;

@property (nonatomic, strong) NSString *isShow;

@property (nonatomic, strong) NSMutableArray *list;

@end
