//
//  StatisticalListView.h
//  SLAPP
//
//  Created by qwp on 2018/8/3.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StatisticalBlock)(NSInteger index);
@interface StatisticalListView : UIView

@property (nonatomic,copy) StatisticalBlock statisticalBlock;

@end
