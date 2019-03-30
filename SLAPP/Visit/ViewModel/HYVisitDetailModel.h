//
//  HYVisitDetailModel.h
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYVisitDetailModel : NSObject
@property(nonatomic,strong)NSString * sectionName;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL isEmpty;
@property(nonatomic,strong)NSString *left;

//行动承诺  有两个数据
@property(nonatomic,strong)NSString *bestContent;
@property(nonatomic,strong)NSString *lowestContent;

@end
