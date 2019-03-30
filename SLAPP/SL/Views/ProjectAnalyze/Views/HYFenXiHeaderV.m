//
//  HYFenXiHeaderV.m
//  SLAPP
//
//  Created by yons on 2018/11/8.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYFenXiHeaderV.h"

@implementation HYFenXiHeaderV

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backVIew1.layer.cornerRadius = self.backVIew2.layer.cornerRadius = self.backVIew3.layer.cornerRadius = self.backVIew4.layer.cornerRadius = self.backVIew5.layer.cornerRadius = 8;
    self.backVIew1.clipsToBounds = self.backVIew2.clipsToBounds = self.backVIew3.clipsToBounds = self.backVIew4.clipsToBounds = self.backVIew5.clipsToBounds = YES;
}

- (IBAction)buttonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.action) {
        self.action(button.tag-200);
    }
}
- (void)configUIWithPercentArray:(NSArray *)percent{
    
    CGFloat width = kScreenWidth-98.5-30-30;
    self.constraint1.constant = -width*([percent[0] floatValue]/100.0);
    self.constraint2.constant = -width*([percent[1] floatValue]/100.0);
    self.constraint3.constant = -width*([percent[2] floatValue]/100.0);
    self.constraint4.constant = -width*([percent[3] floatValue]/100.0);
    self.constraint5.constant = -width*([percent[4] floatValue]/100.0);
    
}
@end
