//
//  AddressAreaModel.h
//  Shihanbainian
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 Codeliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressAreaModel : NSObject
@property(nonatomic,strong)NSString *value;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *parent;

+ (instancetype)addressAreaModel:(NSDictionary *)dict;

@end
