//
//  SLProjectModel.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLProjectModel : NSObject

/** id */
@property(nonatomic,copy)NSString *numberID;
/** 项目名称 */
@property(nonatomic,copy)NSString *name;
/** 时间 */
@property(nonatomic,copy)NSString *time;
/** 钱 */
@property(nonatomic,copy)NSString *money;
@end
