//
//  HYFenXiHeaderV.h
//  SLAPP
//
//  Created by yons on 2018/11/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYFenxiHeaderAction)(NSInteger index);
@interface HYFenXiHeaderV : UIView

@property (nonatomic,copy)HYFenxiHeaderAction action;

@property (weak, nonatomic) IBOutlet UIView *backVIew1;
@property (weak, nonatomic) IBOutlet UIImageView *greenView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint1;

@property (weak, nonatomic) IBOutlet UIView *backVIew2;
@property (weak, nonatomic) IBOutlet UIImageView *greenView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint2;

@property (weak, nonatomic) IBOutlet UIView *backVIew3;
@property (weak, nonatomic) IBOutlet UIImageView *greenView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint3;

@property (weak, nonatomic) IBOutlet UIView *backVIew4;
@property (weak, nonatomic) IBOutlet UIImageView *greenView4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint4;

@property (weak, nonatomic) IBOutlet UIView *backVIew5;
@property (weak, nonatomic) IBOutlet UIImageView *greenView5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint5;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *title5;


- (void)configUIWithPercentArray:(NSArray *)percent;
@end
