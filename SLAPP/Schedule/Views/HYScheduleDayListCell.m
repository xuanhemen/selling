//
//  HYScheduleDayListCell.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleDayListCell.h"

@implementation HYScheduleDayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HYScheduleListModel *)model{
    
    _model = model;
    
    _user.text = model.realname;
    _content.text = model.title;
//    DLog(@"%@",model.showTime);
    _begin.text = model.showTime;
    _end.text = model.showEndTime;
}

@end
