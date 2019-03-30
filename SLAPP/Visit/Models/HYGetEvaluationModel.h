//
//  HYGetEvaluationModel.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJRefresh/MJRefresh.h>
@interface HYGetEvaluationModel : NSObject

@property(nonatomic,strong)NSArray *effect;
@property(nonatomic,strong)NSArray *trust;

@end


@interface HYEvaluationSubModel : NSObject
@property(nonatomic,strong)NSString *classname;
@property(nonatomic,strong)NSArray *rows;
@property(nonatomic,strong)NSString *selectId;
@end


@interface HYEvaluationOptionModel : NSObject
@property(nonatomic,strong)NSString *evaluateitem;
@property(nonatomic,strong)NSString *evaluatevalue;
@property(nonatomic,strong)NSString *itemid;
@end
