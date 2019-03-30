//
//  SLScheProjectModel.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheProjectModel : NSObject

/** ID */
@property(nonatomic,copy)NSString *ID;
/** 项目名称 */
@property(nonatomic,copy)NSString *name;
/** 客户 */
@property(nonatomic,copy)NSString *client_name;
/** 钱 */
@property(nonatomic,copy)NSString *amount;
/** 创建时间 */
@property(nonatomic,copy)NSString *create_time;
/** <#annotation#> */
@property(nonatomic,assign)BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
