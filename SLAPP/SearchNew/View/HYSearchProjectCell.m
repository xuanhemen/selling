//
//  HYSearchProjectCell.m
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYSearchProjectCell.h"

@implementation HYSearchProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redView.layer.cornerRadius = 4;
    self.redView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setViewModelWithDictWithDict:(NSDictionary *)dict{
    NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"dealtime"]];
    NSTimeInterval interval    =    [timeStr doubleValue];
    
    NSString *dateText = @"1970年01月01日";
    if (![timeStr isEqualToString:@""]){
        NSDate *date               =    [NSDate dateWithTimeIntervalSince1970:interval];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString  = [formatter stringFromDate: date];
        dateText = dateString;
    }
    if ([dateText isEqualToString: @"1970年01月01日"]) {
        dateText = @"未知";
    }
    
    
    NSInteger cnt = 0;
    if (dict[@"fo_count"] != nil&&dict[@"msg_count"] != nil) {
        NSInteger fo_count = [[NSString stringWithFormat:@"%@",dict[@"fo_count"]] integerValue];
        NSInteger msg_count = [[NSString stringWithFormat:@"%@",dict[@"msg_count"]] integerValue];
        cnt = fo_count + msg_count;
    }
    if (cnt > 0) {
        self.redView.hidden = NO;
    }else{
        self.redView.hidden = YES;
    }
    
    
    self.cellNameLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    self.cellMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",dict[@"amount"]] floatValue]];
    self.cellDateLabel.text = [NSString stringWithFormat:@"%@",dateText];
    self.cellClientNameLabel.text = [NSString stringWithFormat:@"%@",dict[@"client_name"]];
}
@end
