//
//  HYVisitEvaluationDelegate.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitEvaluationDelegate.h"
#import "HYEvaluationBottomView.h"
@implementation HYVisitEvaluationDelegate




-(NSInteger)currentIndex{
    if (!_currentIndex) {
        return 0;
    }
    return _currentIndex;
}


-(NSString *)currentItemId{
    
    if (_type == effect) {
        HYEvaluationSubModel * model = self.evaluationModel.effect[_currentIndex];
        return model.selectId;
    }else{
        HYEvaluationSubModel * model = self.evaluationModel.trust[_currentIndex];
        return model.selectId;
    }
    
}


/**
 设置当前显示的题选中的id
 
 @param itemId
 */
-(void)configSelectItemId:(NSString *)itemId{
    
    if ([itemId isNotEmpty]) {
        
        if (_type == effect) {
            HYEvaluationSubModel * model = self.evaluationModel.effect[_currentIndex];
            model.selectId = itemId;
            
            
        }else{
            HYEvaluationSubModel * model = self.evaluationModel.trust[_currentIndex];
           model.selectId = itemId;
            
        }
        
        
    }
}


/**
 
 
 @param isAdd <#isAdd description#>
 */
-(void)currentIndexWithIsAdd:(BOOL)isAdd{
    if (isAdd) {
        if (_type == effect) {
            if (_currentIndex < self.evaluationModel.effect.count - 1) {
                _currentIndex += 1;
            }
        }else{
            if (_currentIndex < self.evaluationModel.trust.count - 1) {
                _currentIndex += 1;
            }
        }
        
    }else{
        if (_type == effect) {
            if (_currentIndex != 0) {
                _currentIndex -= 1;
            }
        }else{
            if (_currentIndex != 0) {
                _currentIndex -= 1;
            }
        }
        
    }
    
   
}


-(BOOL)isLast{
    if (_type == effect) {
        return _currentIndex == self.evaluationModel.effect.count - 1 ;
    }else{
        return _currentIndex == self.evaluationModel.trust.count - 1 ;
    }
    return _isLast;
}



-(NSDictionary *)configParams{
    
    if (self.type == effect)
    {
        NSArray *array = [self.evaluationModel.effect valueForKeyPath:@"selectId"];
        return @{
                 @"content":array,
                 @"mark":@"0"
                 };
        
    }else{
        NSArray *array = [self.evaluationModel.trust valueForKeyPath:@"selectId"];
        return @{
                 @"content":array,
                 @"mark":@"1"
                 };
        
    }
    
    
}

@end
