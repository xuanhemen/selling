//
//  HYSelectClientVC.h
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYClientModel.h"

typedef void(^HYSelectClientAction)(HYClientModel *clientModel);

@interface HYSelectClientVC : UIViewController

@property (nonatomic,copy)HYSelectClientAction action;



@end
