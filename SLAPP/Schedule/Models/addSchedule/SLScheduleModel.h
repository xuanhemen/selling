//
//  SLScheduleModel.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleModel : NSObject

/** <#annotation#> */
@property(nonatomic,copy)NSString *ID;
/** <#annotation#> */
@property(nonatomic,copy)NSString *name;
/** annotation */
@property(nonatomic,copy)NSString *place;
/** <#annotation#> */
@property(nonatomic,copy)NSString *contact;
/** <#annotation#> */
@property(nonatomic,assign)BOOL isSelect;

//"id": "23883",
//"name": "\u8fd8\u6709\u8c01(\u5927\u8fde)\u98df\u54c1\u79d1\u6280\u6709\u9650\u516c\u53f8",
//"trade_id": "75",
//"trade_name": "\u7269\u6d41\u4ed3\u50a8",
//"province": "330000",
//"city": "330300",
//"area": "330326",
//"addtime": "1548899839",
//"place": "\u6d59\u6c5f\u7701\u6e29\u5dde\u5e02\u5e73\u9633\u53bf\u5ba2\u6237\u5730\u5740",
//"create_userid": "8908",
//"contact": "\u8fd8\u6709\u6211",
//"addtime_str": "2019\u5e7401\u670831\u65e5",
//"dir": "\u6d59\u6c5f\u6e29\u5dde\u5e02\u5e73\u9633\u53bf\u6d59\u6c5f\u7701\u6e29\u5dde\u5e02\u5e73\u9633\u53bf\u5ba2\u6237\u5730\u5740",
//"definition": "\u81ea\u521b\u5ba2\u6237",
//"fo_count": "0",
//"msg_count": "0"
@end

NS_ASSUME_NONNULL_END
