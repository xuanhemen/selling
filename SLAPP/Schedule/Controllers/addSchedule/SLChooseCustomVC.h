//
//  SLChooseCustomVC.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLChooseCustomVC : SLBaseViewController

/** 回调 */
@property(nonatomic,copy)void(^passCustom)(NSString *name,NSString *ID);

@end

NS_ASSUME_NONNULL_END
