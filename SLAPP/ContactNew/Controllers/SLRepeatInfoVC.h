//
//  SLRepeatInfoVC.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLRepeatInfoModel.h"

/**通知返回联系人*/
typedef void(^Notice)(void);

@interface SLRepeatInfoVC : UIViewController

/** 重复信息数据源 */
@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,strong)SLRepeatInfoModel * commitModel;

@property(nonatomic,copy)Notice notice;
@end
