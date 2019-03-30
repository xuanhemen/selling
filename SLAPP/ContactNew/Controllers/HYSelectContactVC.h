//
//  HYSelectContactVC.h
//  SLAPP
//
//  Created by yons on 2018/10/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFSelectContactVM.h"
#import "HYClientModel.h"
typedef void(^QFSelectContact)(NSArray *list);

@interface HYSelectContactVC : UIViewController

@property (nonatomic,strong) NSArray *alreadyArray;
@property (nonatomic,strong) HYClientModel *clientModel;
@property (nonatomic,copy) QFSelectContact getResult;
@property (nonatomic,assign) BOOL isSingle;

@end
