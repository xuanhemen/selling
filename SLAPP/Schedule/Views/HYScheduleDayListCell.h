//
//  HYScheduleDayListCell.h
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYScheduleListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HYScheduleDayListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *begin;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property(nonatomic,strong)HYScheduleListModel *model;
@end

NS_ASSUME_NONNULL_END
