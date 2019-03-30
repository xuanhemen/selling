//
//  HYProjectAnalysisCell.h
//  SLAPP
//
//  Created by yons on 2018/9/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYProjectAnalysisCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pro_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *title_oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *title_twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *title_threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *title_fourLabel;
@property (weak, nonatomic) IBOutlet UILabel *logic_time_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *client_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *people_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *stageLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinpoLabel;
@property (weak, nonatomic) IBOutlet UILabel *chanceLabel;

- (void)setCellDataWithDictinoary:(NSDictionary *)dict;

@end
