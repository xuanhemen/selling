//
//  HYProjectAnalysisCell.m
//  SLAPP
//
//  Created by yons on 2018/9/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYProjectAnalysisCell.h"

@implementation HYProjectAnalysisCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellDataWithDictinoary:(NSDictionary *)dict{
    self.pro_nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"pro_name"]];
    self.amountLabel.text = [NSString stringWithFormat:@"%@",dict[@"amount"]];
    self.title_oneLabel.text = [NSString stringWithFormat:@"%@",dict[@"title_one"]];
    self.title_twoLabel.text = [NSString stringWithFormat:@"%@",dict[@"title_two"]];
    self.title_threeLabel.text = [NSString stringWithFormat:@"%@",dict[@"title_three"]];
    self.title_fourLabel.text = [NSString stringWithFormat:@"%@",dict[@"title_four"]];
    self.logic_time_nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"logic_time_name"]];
    self.client_nameLabel.text = [NSString stringWithFormat:@"%@",dict[@"client_name"]];
    self.people_countLabel.text = [NSString stringWithFormat:@"%@",dict[@"people_count"]];
    self.stageLabel.text = [NSString stringWithFormat:@"%@",dict[@"stage"]];
    self.competitionLabel.text = [NSString stringWithFormat:@"%@",dict[@"competition"]];
    self.feelingLabel.text = [NSString stringWithFormat:@"%@",dict[@"feeling"]];
    self.jinpoLabel.text = [NSString stringWithFormat:@"%@",dict[@"jinpo"]];
    self.chanceLabel.text = [NSString stringWithFormat:@"%@",dict[@"chance"]];
    
}
@end
