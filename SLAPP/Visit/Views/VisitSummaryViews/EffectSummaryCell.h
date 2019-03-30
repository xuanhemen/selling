//
//  EffectSummaryCell.h
//  CLApp
//
//  Created by 吕海瑞 on 16/9/6.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYGetEvaluationModel.h"
@interface EffectSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *markTitle;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (assign, nonatomic) BOOL ismark;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableLeft;
@property (assign,nonatomic)int index;

@property(nonatomic,strong)HYEvaluationOptionModel *model;
@end
