//
//  SLScheduleContactModel.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleContactModel : NSObject

/** <#annotation#> */
@property(nonatomic,copy)NSString *userid;
/** annotation */
@property(nonatomic,copy)NSString *realname;
/** <#annotation#> */
@property(nonatomic,copy)NSString *position_name;
/**<#annotation#>*/
@property(nonatomic,assign)BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
