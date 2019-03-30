//
//  QFCustomerDetailVC.h
//  SLAPP
//
//  Created by yons on 2018/9/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CustomerBlock)(NSString *a);

@interface QFCustomerDetailVC : UIViewController

@property (nonatomic,copy)CustomerBlock needUpdate;
@property (nonatomic,strong)NSString *clientId;
@property (nonatomic,strong)NSDictionary *modelDic;

@end
