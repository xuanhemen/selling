//
//  LeftCell.m
//  拜访罗盘
//
//  Created by harry on 16/5/20.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (void)setModel:(HYVisitFitterModel *)model{
    _model = model;
    self.leftlable.text = model.name;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textLabel.font = kFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
