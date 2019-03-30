//
//  HYAddVisitViewModel.h
//  SLAPP
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAddVisitViewModel : NSObject


-(NSArray *)configData;


@property(nonatomic,assign)BOOL ourIsDelete;

@property(nonatomic,assign)BOOL visitIsDelete;

//拜访对象的高度
@property(nonatomic,assign)CGFloat visitersHeight;
//参与者高度
@property(nonatomic,assign)CGFloat oursHeight;
//拜访对象数组
@property(nonatomic,strong)NSArray *visiters;
//参与人数组
@property(nonatomic,strong)NSArray *ours;


/**
 返回拜访对象的id

 @return return value description
 */
-(NSArray *)getVisiterIds;


/**
 返回参与者的id

 @return <#return value description#>
 */
-(NSArray *)getOursIds;
@end
