//
//  SLContactDetailModel.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLContactDetailModel : NSObject

/** 姓名 */
@property(nonatomic,copy)NSString *name;
/** 职务 */
@property(nonatomic,copy)NSString *position;
/** 部门 */
@property(nonatomic,copy)NSString *dep;
/** 负责人 */
@property(nonatomic,copy)NSString *res;
/** 图片 */
@property(nonatomic,copy)NSString *imgName;

@end

@interface SLCocDetailModel : NSObject

/** info */
@property(nonatomic,copy)NSString *content;

@end
