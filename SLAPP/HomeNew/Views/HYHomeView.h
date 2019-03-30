//
//  HYHomeView.h
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYHomeModel.h"
@interface HYHomeView : UIView

//    首页上边的界面


/**
 按钮点击block 目前用tag  如果可配置需要用key
 */
@property(nonatomic,copy)void(^btnClick)(NSInteger tag,NSString *key);


@property(nonatomic,strong)HYHomeModel *model;

/**
 刷新提醒个数
 */
- (void)refreshRedNum:(NSInteger)num;
@end
