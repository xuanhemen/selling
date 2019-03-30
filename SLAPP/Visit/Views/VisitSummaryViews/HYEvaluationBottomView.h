//
//  HYEvaluationBottomView.h
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYEvaluationBottomView : UIView
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,copy)void(^btnClick)(NSInteger tag);

-(void)reSet;
@end
