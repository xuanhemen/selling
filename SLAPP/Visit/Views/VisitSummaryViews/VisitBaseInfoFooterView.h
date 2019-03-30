//
//  VisitBaseInfoFooterView.h
//  CLApp
//
//  Created by xslp on 16/8/30.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYSelectEvaluationModel.h"
typedef void(^VisitBaseInfoFooterBlock)(NSInteger tag);
@interface VisitBaseInfoFooterView : UIView

@property(nonatomic,strong) HYSelectEvaluationModel * selectEvaModel;

@property (copy, nonatomic) VisitBaseInfoFooterBlock pushRadarViewBlock;
@end
