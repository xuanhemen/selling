//
//  HYCarryDownHeadView.m
//  SLAPP
//
//  Created by fank on 2019/1/3.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import "HYCarryDownHeadView.h"
#import "HYProjectGroupModel.h"

@implementation HYCarryDownHeadView

- (IBAction)arrowClick:(UIButton *)sender {
    
    _arrowButton.selected = !_arrowButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(arrowButtonClick:isShow:)]) {
        [self.delegate arrowButtonClick:_section isShow:_arrowButton.selected ? @"1" : @"0"];
    }
}

- (void)setGroup:(HYProjectGroupModel *)group {
    
    _group = group;
    
    self.nameLabel.text = group.realname;
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)group.list.count];;
    
    self.arrowButton.selected = [group.isShow isEqualToString:@"1"] ? true : false;
}

@end
