//
//  HYBoltingDepMemberCell.h
//  SLAPP
//
//  Created by apple on 2019/2/21.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYBoltingDepMemberCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UILabel *upLab;
@property (weak, nonatomic) IBOutlet UILabel *downLab;

@property(nonatomic,copy)void (^nextClick)(void);

@end

NS_ASSUME_NONNULL_END
