//
//  SLVisitDayView.h
//  拜访罗盘
//
//  Created by 王静帅 on 16/5/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSTitleView.h"
#import "WJSScrollTitle.h"

@interface SLVisitWeekView : UIView
/** week索引 */
@property(nonatomic, strong) WJSTitleView *weekTop;
/** scrollTtitle */
@property(nonatomic, strong) WJSScrollTitle *scrollTitle;

@end
