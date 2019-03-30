//
//  HYClientPoolCell.m
//  SLAPP
//
//  Created by yons on 2018/11/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYClientPoolCell.h"

@implementation HYClientPoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonAction:(id)sender {
    if (self.action) {
        self.action(self);
    }
}

@end
