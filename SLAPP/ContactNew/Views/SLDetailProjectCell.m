//
//  SLDetailProjectCell.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLDetailProjectCell.h"

@implementation SLDetailProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
/**联系人名字*/
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor colorWithHexString:@"#333333"];
        _name.font = [UIFont systemFontOfSize:17];
        [_name sizeToFit];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
        }];
    }
    return _name;
}
/**联系人名字*/
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:16];
        [_time sizeToFit];
        [self addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _time;
}
/**联系人名字*/
-(UILabel *)money{
    if (!_money) {
        _money = [[UILabel alloc]init];
        _money.textColor = [UIColor blackColor];
        _money.font = [UIFont systemFontOfSize:16];
        [_money sizeToFit];
        [self addSubview:_money];
        [_money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return _money;
}
-(void)setCellWithModel:(SLProjectModel *)model
{
    self.name.text = model.name;
    self.time.text = model.time;
    NSString * str = [NSString stringWithFormat:@"%@万",model.money];
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length-1, 1)];
    self.money.attributedText = attriStr;
}
@end

@implementation SLDetailDeleteCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"qf_select_statusdefault"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"qf_select_statuschoose"] forState:UIControlStateSelected];
        [self addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
    }
    return _deleteBtn;
}
/**联系人名字*/
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor colorWithHexString:@"#333333"];
        _name.font = [UIFont systemFontOfSize:17];
        [_name sizeToFit];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(60);
            make.top.equalTo(self).offset(15);
        }];
    }
    return _name;
}
/**联系人名字*/
-(UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:16];
        [_time sizeToFit];
        [self addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(60);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _time;
}
/**联系人名字*/
-(UILabel *)money{
    if (!_money) {
        _money = [[UILabel alloc]init];
        _money.textColor = [UIColor blackColor];
        _money.font = [UIFont systemFontOfSize:16];
        [_money sizeToFit];
        [self addSubview:_money];
        [_money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return _money;
}
-(void)setCellWithModel:(SLProjectModel *)model
{
    
    self.name.text = model.name;
    self.time.text = model.time;
    self.money.text = model.money;
}
@end
