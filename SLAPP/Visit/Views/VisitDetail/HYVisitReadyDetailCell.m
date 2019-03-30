//
//  HYVisitReadyDetailCell.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitReadyDetailCell.h"

@implementation HYVisitReadyDetailCell

-(void)configUIWithModel{
    
    self.content.text = self.model.content;
    if (![self.content.text isNotEmpty]) {
       self.content.textColor = kgreenColor;
        self.content.text = @"无";
    }else{
        self.content.textColor = [UIColor darkTextColor];
    }
}


-(void)configUI{
//    _leftLab = [UILabel new];
    self.content = [UILabel new];
    self.content.numberOfLines = 0;
     self.content.font = kFont(14);
//    [self.contentView addSubview:_leftLab];
    [self.contentView addSubview:self.content];
//    kWeakS(weakSelf);
    
    
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(40);
    }];
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
