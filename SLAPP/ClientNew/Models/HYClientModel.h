//
//  HYClientModel.h
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFBaseModel.h"

@interface HYClientModel : QFBaseModel

@property (nonatomic,strong)NSString *contact;
@property (nonatomic,strong)NSString *Id;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *trade_id;
@property (nonatomic,strong)NSString *trade_name;

@property (nonatomic,strong)NSString *modifiTag;

@end
