//
//  PDateChooseView.h
//  SLAPP
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDateChooseView : UIView
@property(nonatomic,copy)void (^result)(NSString * timerStr);
@end
