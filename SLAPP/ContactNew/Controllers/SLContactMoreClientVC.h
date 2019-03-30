//
//  SLContactMoreClientVC.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLContactMoreClientVC : UIViewController

/** 数据源 */
@property(nonatomic,copy)NSArray * dataArr;
/** 电话数据源 */
@property(nonatomic,copy)NSArray * phoneArr;
/** 联系人名字 */
@property(nonatomic,copy)NSString *name;
@end
