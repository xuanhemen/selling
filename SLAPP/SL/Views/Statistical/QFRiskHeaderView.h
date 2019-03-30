//
//  QFRiskHeaderView.h
//  SLAPP
//
//  Created by qwp on 2018/8/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QFRiskHeaderView : UIView

@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,copy) void (^clickIds)(NSString *ids);

- (CGFloat)configUIWithData:(NSArray *)array;
@end
