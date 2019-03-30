//
//  HYBoltingDepMemberCell.m
//  SLAPP
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYBoltingDepMemberCell.h"

@implementation HYBoltingDepMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick{
    if (self.nextClick) {
        self.nextClick();
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
