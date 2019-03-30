//
//  SLDeleteProjectVC.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^Notice)(void);
@interface SLDeleteProjectVC : UIViewController
/** <#annotation#> */
@property(nonatomic,strong)NSMutableArray * dataArr;

/** 联系人id */
@property(nonatomic,copy)NSString *contact_id;
/** 客户id */
@property(nonatomic,copy)NSString *client_id;

/** 标识--是添加还是删除 */
@property(nonatomic,copy)NSString *indentifer;

@property(nonatomic,copy)Notice notice;
@end
