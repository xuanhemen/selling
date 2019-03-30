//
//  HYBaseCell.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYBaseCell.h"

@implementation HYBaseCell

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    DLog(@"注意！！！！！某个属性没有");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
