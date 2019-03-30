//
//  HYNewProjectTopView.m
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYNewProjectTopView.h"

@implementation HYNewProjectTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.clientID = @"";
     self.tradeID = @"";
}

- (IBAction)tradeButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hy_topViewTradeButtonClick:)]) {
        [self.delegate performSelector:@selector(hy_topViewTradeButtonClick:) withObject:self];
    }
}
- (IBAction)clientButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hy_topViewClientButtonClick:)]) {
        [self.delegate performSelector:@selector(hy_topViewClientButtonClick:) withObject:self];
    }
}
- (IBAction)productButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hy_topViewProductButtonClick:)]) {
        [self.delegate performSelector:@selector(hy_topViewProductButtonClick:) withObject:self];
    }
}

- (IBAction)dateButtonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hy_topViewDateButtonClick:)]) {
        [self.delegate performSelector:@selector(hy_topViewDateButtonClick:) withObject:self];
    }
}
@end
