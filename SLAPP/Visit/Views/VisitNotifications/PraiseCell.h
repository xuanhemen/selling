//
//  PraiseCell.h
//  CLApp
//
//  Created by harry on 17/2/13.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
@interface PraiseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (strong,nonatomic)RCMessage * model;

@property (strong,nonatomic)UIView * redView;
@end
