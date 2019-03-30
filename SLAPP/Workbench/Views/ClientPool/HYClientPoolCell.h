//
//  HYClientPoolCell.h
//  SLAPP
//
//  Created by yons on 2018/11/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYClientPoolCell;
typedef void(^QFSelectCellAction)(HYClientPoolCell *sender);

@interface HYClientPoolCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *backNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,copy) QFSelectCellAction action;

@end
