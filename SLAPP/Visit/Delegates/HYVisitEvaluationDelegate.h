//
//  HYVisitEvaluationDelegate.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseDelegate.h"
#import "HYGetEvaluationModel.h"



typedef NS_ENUM(NSInteger, EvaluateType) {
    effect,
    trust
};

@interface HYVisitEvaluationDelegate : HYBaseDelegate
@property(nonatomic,strong)HYGetEvaluationModel *evaluationModel;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)EvaluateType type;

@property(nonatomic,assign)BOOL isLast;

/**
 当前显示的题对应的选中id

 @return
 */
-(NSString *)currentItemId;


/**
 设置当前显示的题选中的id

 @param itemId
 */
-(void)configSelectItemId:(NSString *)itemId;


/**
 

 @param isAdd <#isAdd description#>
 */
-(void)currentIndexWithIsAdd:(BOOL)isAdd;


-(NSDictionary *)configParams;
@end
