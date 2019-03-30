//
//  SLSheduleContactVC.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLSheduleContactVC : SLBaseViewController
/** 回调 */
@property(nonatomic,copy)void(^passContact)(NSString *name,NSString *ID);
/**父类id 取json中的id字段*/
@property(nonatomic,copy)NSString *parentID;
/** 装选中参与人model */
@property(nonatomic,strong)NSMutableArray * modelArr;
/**选中的参与人*/
@property(nonatomic)NSMutableString * names;
/**选中的参与人id*/
@property(nonatomic)NSMutableString * ids;


@end

NS_ASSUME_NONNULL_END
