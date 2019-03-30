//
//  SLScheduleRemindVC.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleRemindVC : SLBaseViewController
/**传递时间*/
@property(nonatomic,copy)void(^passRemindTime)(NSString *time,NSInteger paraTime);

@end

NS_ASSUME_NONNULL_END
