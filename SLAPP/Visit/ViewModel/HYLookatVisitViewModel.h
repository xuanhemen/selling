//
//  HYLookatVisitViewModel.h
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYLookatVisitViewModel : NSObject
//标题
@property(nonatomic,strong)NSArray *sectionTitles;

-(NSArray *)configWithJason:(NSDictionary *)dic;
@end
