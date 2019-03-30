//
//  HYLookEvaluationCell.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYLookEvaluationSubView.h"
#import "HYSelectEvaluationModel.h"
@interface HYLookEvaluationCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)HYLookEvaluationSubView *cycleView;
@property(nonatomic,strong)HYSelectSubEvaluationModel *model;
@end
