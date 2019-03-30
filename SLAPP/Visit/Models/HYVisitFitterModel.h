//
//  HYVisitFitterModel.h
//  SLAPP
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYVisitFitterModel : NSObject
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)NSString *name;
@end

@interface HYVisitFitterSubModel : NSObject
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *parentid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)NSString *isparent;
@end
