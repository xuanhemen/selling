//
//  HYSechduleSearchCell.m
//  SLAPP
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYSechduleSearchCell.h"

@implementation HYSechduleSearchCell


- (void)setModel:(HYScheduleListModel *)model{
    _model = model;
    _content.text = model.title;
    _user.text = model.realname;
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    _time.text = [NSString stringWithFormat:@"%@-%@",[f stringFromDate:[NSDate dateWithTimeIntervalSince1970:_model.begin_time]],[f stringFromDate:[NSDate dateWithTimeIntervalSince1970:_model.end_time]]];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
