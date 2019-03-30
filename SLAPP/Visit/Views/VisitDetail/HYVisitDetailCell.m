//
//  HYVisitDetailCell.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitDetailCell.h"

@implementation HYVisitDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
    
}


-(void)configUI{
    _leftLab = [UILabel new];
    _content = [UILabel new];
    _content.numberOfLines = 0;
    
    _leftLab.font = kFont(14);
    _leftLab.textColor = [UIColor lightGrayColor];
    _content.font = kFont(14);
    _content.textColor = [UIColor darkTextColor];
    
    _content.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_leftLab];
    [self.contentView addSubview:_content];
    kWeakS(weakSelf);
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(weakSelf);
    }];
    
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(105);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.height.mas_greaterThanOrEqualTo(40);
        make.right.mas_equalTo(-10);
    }];
}



-(void)setModel:(HYVisitDetailModel *)model{
    _model = model;
    
}


-(void)configUIWithModel{
    _leftLab.text = _model.left;
    _content.text = _model.content;
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
