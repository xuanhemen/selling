//
//  PBottleneckTopView.h
//  SLAPP
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBottleneckTopView : UIView
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,copy)void (^btnClick)(NSInteger tag);
@property(nonatomic,assign)int pjTag;
@end
