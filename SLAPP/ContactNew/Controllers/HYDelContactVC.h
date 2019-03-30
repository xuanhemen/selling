//
//  HYDelContactVC.h
//  SLAPP
//
//  Created by yons on 2018/10/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QFDelContact)(NSArray *list);
@interface HYDelContactVC : UIViewController
@property (nonatomic,strong) NSArray *alreadyArray;
@property (nonatomic,assign) BOOL isSingle;
@property (nonatomic,copy) QFDelContact getResult;
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) NSString *clientName;

//客户详情删除联系人 0    新建项目为1 
@property (nonatomic,assign)NSInteger comeType;
@end
