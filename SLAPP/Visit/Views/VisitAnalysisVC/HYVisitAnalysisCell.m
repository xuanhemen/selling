//
//  HYVisitAnalysisCell.m
//  SLAPP
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitAnalysisCell.h"

@implementation HYVisitAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _cycleView.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
