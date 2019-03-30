//
//  HYContactDetailVC.h
//  SLAPP
//
//  Created by yons on 2018/10/30.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYContactDetailVC : UIViewController

/** 详情列表 */
@property(nonatomic,strong)UITableView * tableView;

/** 联系人id */
@property(nonatomic,copy)NSString *contact_id;
/** 客户id */
@property(nonatomic,copy)NSString *client_id;

/**<#annotation#>*/
@property (nonatomic,weak) id delegate;

@end
