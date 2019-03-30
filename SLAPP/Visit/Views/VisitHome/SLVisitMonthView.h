//
//  SLVisitMonthView.h
//  拜访罗盘
//
//  Created by 王静帅 on 16/5/12.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSTitleView.h"
#import "WJSScrollViewMonth.h"

@interface SLVisitMonthView : UIView
/** month索引 */
@property(nonatomic, strong) WJSTitleView *monthTop;
/** month */
@property(nonatomic, strong) WJSScrollViewMonth *scrllMonth;
@end
