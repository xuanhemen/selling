//
//  SLRealContactModel.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLRealContactModel : NSObject
/** id */
@property(nonatomic,copy)NSString *ID;
/** name */
@property(nonatomic,copy)NSString *name;
/** 客户 */
@property(nonatomic,copy)NSString *client_name;
/** 职务 */
@property(nonatomic,copy)NSString *position_name;
/** key */
@property(nonatomic,copy)NSString *key;
/** select */
@property(nonatomic,assign)BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
