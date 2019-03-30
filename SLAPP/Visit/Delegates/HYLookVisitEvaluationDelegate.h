//
//  HYLookVisitEvaluationDelegate.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseDelegate.h"
#import "HYSelectEvaluationModel.h"
#import "HYVisitEvaluationDelegate.h"
@interface HYLookVisitEvaluationDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) HYSelectEvaluationModel * selectEvaModel;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)EvaluateType type;
@end
