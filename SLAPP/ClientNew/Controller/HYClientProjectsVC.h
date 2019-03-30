//
//  HYClientProjectsVC.h
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYClientModel.h"
@interface HYClientProjectsVC : UIViewController
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) HYClientModel *model;
@end
