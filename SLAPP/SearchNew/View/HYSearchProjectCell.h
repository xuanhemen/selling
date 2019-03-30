//
//  HYSearchProjectCell.h
//  SLAPP
//
//  Created by yons on 2018/10/19.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYSearchProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellClientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *redView;

- (void)setViewModelWithDictWithDict:(NSDictionary *)dict;
@end
