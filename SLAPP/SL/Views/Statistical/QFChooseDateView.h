//
//  QFChooseDateView.h
//  SLAPP
//
//  Created by qwp on 2018/8/6.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QFDateBlock)(NSString *week,NSString *month,NSString *quarter,NSString *year);
@interface QFChooseDateView : UIView

@property (nonatomic,assign)NSInteger currentSelect;
@property (nonatomic,strong) NSString *thisYear;
@property (nonatomic,strong) NSString *thisQuarter;
@property (nonatomic,strong) NSString *thisMonth;
@property (nonatomic,strong) NSString *thisWeek;
@property (nonatomic,copy) QFDateBlock block;
- (instancetype)initWithType:(int)type andFrame:(CGRect)frame;
- (void)configUI;
@end
