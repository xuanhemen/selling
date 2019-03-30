//
//  HYScheduleListCell.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleListCell.h"

@implementation HYScheduleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HYScheduleListModel *)model{
    _model = model;
    
    _week.text = model.showWeek;
    _day.text = model.showDay;
    _time.text = model.showTime;
    _user.text = model.realname;
    _content.text = model.title;
}

@end
