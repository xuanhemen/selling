//
//  HYGetEvaluationModel.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYGetEvaluationModel.h"

@implementation HYGetEvaluationModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"effect":@"HYEvaluationSubModel",
             @"trust":@"HYEvaluationSubModel"
             };
}
@end

@implementation HYEvaluationSubModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"rows":@"HYEvaluationOptionModel",
            
             };
}

-(NSString *)selectId{
    
    if (!_selectId) {
        HYEvaluationOptionModel *model = self.rows[0];
        return model.itemid;
    }
    
    return _selectId;
}

@end


@implementation HYEvaluationOptionModel

@end


