//
//  HYClientDetailFooterV.h
//  SLAPP
//
//  Created by yons on 2018/10/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFMemberV.h"

typedef void(^QFClickMemberAction)(QFMemberType type,NSString *idString);
@interface HYClientDetailFooterV : UIView
@property (nonatomic,copy) QFClickMemberAction action;

- (void)refreshUIWithArray:(NSArray *)array;

@end
