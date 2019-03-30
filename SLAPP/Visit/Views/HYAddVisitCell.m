//
//  HYAddVisitCell.m
//  SLAPP
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYAddVisitCell.h"

@implementation HYAddVisitCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _lab_title = [UILabel new];
        [self.contentView addSubview:_lab_title];
        
        _content = [UITextField new];
        [self.contentView addSubview:_content];
        
        [_lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(100);
        }];
        
        kWeakS(weakSelf);
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(weakSelf.lab_title.mas_right).offset(5);
            make.right.mas_equalTo(-20);
        }];
    }
    return self;
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
