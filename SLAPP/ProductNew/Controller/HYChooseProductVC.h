//
//  HYChooseProductVC.h
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYChooseProductAction)(NSArray *modelArray);
@interface HYChooseProductVC : UIViewController

@property (nonatomic,copy)HYChooseProductAction action;
@property (nonatomic,strong)NSMutableArray *alreadyArray;
@property (nonatomic,strong)NSMutableArray *selectArray;

@end
