//
//  HYCarryDownCell.h
//  SLAPP
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCarryDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *project;
@property (weak, nonatomic) IBOutlet UILabel *client;
@property (weak, nonatomic) IBOutlet UIImageView *markImage;

@end
