//
//  HYContactNewCell.h
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYContactNewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellCompanylabel;
@property (nonatomic,strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end
