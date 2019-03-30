//
//  HYFollowFiltrateV.h
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYFiltrateAction)(NSInteger type);

@interface HYFollowFiltrateV : UIView

@property (nonatomic,copy) HYFiltrateAction action;

@end
