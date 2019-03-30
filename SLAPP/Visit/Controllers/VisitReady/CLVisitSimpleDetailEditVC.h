//
//  CLVisitSimpleDetailEditVC.h
//  CLAppWithSwift
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitDetailModel.h"
@interface CLVisitSimpleDetailEditVC : UIViewController
//修改按钮点击回调
@property(nonatomic,copy)void (^okBtnClickBlock)(void);
//拜访id
@property(nonatomic,copy)NSString *visitId;
//修改的类型
@property(nonatomic,copy)NSString *typeStr;

@property(nonatomic,strong)NSString *visiters;

@property(nonatomic,strong)HYVisitDetailModel *model;
@end
