//
//  HYChooseTagVC.h
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HYChooseTagListAction)(NSArray *array, NSArray *nameArray);
@interface HYChooseTagVC : UIViewController
@property (nonatomic,strong)NSMutableArray  *alreadyArray;


@property (nonatomic,copy)HYChooseTagListAction action;

@end
