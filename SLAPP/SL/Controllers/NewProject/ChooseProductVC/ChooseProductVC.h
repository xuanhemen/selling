//
//  ChooseProductVC.h
//  CLApp
//
//  Created by 吕海瑞 on 16/8/17.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseProductVC : UIViewController
/**
 *  点击确定按钮后的回调  数组中放有选择的产品model
 */
@property (nonatomic,copy) void(^resultArray)(NSArray *resultArray);


@property(nonatomic,strong)NSMutableArray *alreadyArray;
@end
