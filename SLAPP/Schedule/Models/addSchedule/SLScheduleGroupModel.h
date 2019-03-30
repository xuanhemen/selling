//
//  SLScheduleGroupModel.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleGroupModel : NSObject
/** <#annotation#> */
@property(nonatomic,copy)NSString *ID;
/** <#annotation#> */
@property(nonatomic,copy)NSString *name;
/** parentid */
@property(nonatomic,copy)NSString *parentid;
/** dep_id */
@property(nonatomic,copy)NSString *dep_id;
@end

NS_ASSUME_NONNULL_END
