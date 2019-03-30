//
//  SLNewBuildScheduleVC.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/14.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**新建或编辑*/
typedef NS_ENUM(NSInteger, SLBuildStyle) {
    SLBuildStyleNew,
    SLBuildStyleEdit,
    SLBuildStyleLook,
    SLBuildStyleToView
};

@interface SLNewBuildScheduleVC : SLBaseViewController
/**回调*/
@property(nonatomic,copy)void(^freshList)(NSString *ID);//ID 新建成功后返回的日程id
/**参数*/
@property(nonatomic)NSMutableDictionary *params;
/** 标识 新建或者编辑 */
@property(nonatomic,assign)SLBuildStyle buildStyle;
/** 条目id */
@property(nonatomic,copy)NSString *numberID;

/** <#annotation#> */
@property(nonatomic,copy)NSString *itemString;

@property(nonatomic,copy)NSString *userID;

@end

NS_ASSUME_NONNULL_END
