//
//  ContactTableViewCell.m
//  Demo
//
//  Created by LeeJay on 2017/3/27.
//  Copyright © 2017年 LeeJay. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "LJPerson.h"
#import <Masonry/Masonry.h>
@interface ContactTableViewCell ()

@property (strong, nonatomic)  UIImageView *iconImageV;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  UILabel *phoneNumLabel;

@end

@implementation ContactTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    
    __weak typeof(self) weakSelf = self;
//    self.iconImageV = [[UIImageView alloc]init];
//    [self.contentView addSubview:_iconImageV];
//    [_iconImageV  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(45);
//        make.left.mas_equalTo(15);
//        make.centerY.equalTo(weakSelf);
//
//    }];
    
    _nameLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf);
        make.left.equalTo(weakSelf).offset(15);
    }];
    
//    _phoneNumLabel = [[UILabel alloc]init];
//    _phoneNumLabel.font = [UIFont systemFontOfSize:14];
//    _phoneNumLabel.textColor = [UIColor darkGrayColor];
//    [self.contentView addSubview:_phoneNumLabel];
//    [_phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(30);
//        make.right.mas_equalTo(0);
//        make.left.equalTo(weakSelf.nameLabel.mas_left);
//        make.height.mas_equalTo(20);
//
//    }];
    
    
}
- (void)setModel:(LJPerson *)model
{
//    self.iconImageV.image = model.image ? model.image : [UIImage imageNamed:@"mine_avatar"];
    self.nameLabel.text = model.fullName;
//    LJPhone *phoneModel = model.phones.firstObject;
//    self.phoneNumLabel.text = phoneModel.phone;
//    self.phoneNumLabel.text = @"1123989818982";
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
