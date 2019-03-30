//
//  HYSelectEvaluationModel.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSelectEvaluationModel : NSObject
@property(nonatomic,strong)NSArray *effect;
@property(nonatomic,strong)NSArray *trust;

@property(nonatomic,strong)NSString *effect_othernum;
@property(nonatomic,strong)NSString *effectnum;
@property(nonatomic,strong)NSString *trust_othernum;
@property(nonatomic,strong)NSString *trustnum;
@end


@interface HYSelectSubEvaluationModel : NSObject
@property(nonatomic,strong)NSString *itemtxt;
@property(nonatomic,strong)NSString *max;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)NSString *val;
@end

