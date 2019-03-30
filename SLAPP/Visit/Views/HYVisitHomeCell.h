//
//  HYVisitHomeCell.h
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseCell.h"
#import "HYVisitModel.h"
@interface HYVisitHomeCell : HYBaseCell

@property(nonatomic,strong)UILabel *visitPerson;
@property(nonatomic,strong)UILabel *visitDate;
@property(nonatomic,strong)UILabel *visitStatus;
@property(nonatomic,strong)UILabel *visitProject;
@property(nonatomic,strong)UILabel *visitMoney;
@property(nonatomic,strong)UILabel *visitClient;

@property(nonatomic,copy)void (^bottomClickWithKey)(NSString *key,HYVisitModel *model);
@property(nonatomic,strong)HYVisitModel *model;
@end
