//
//  SLRepeatInfoCell.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLRepeatInfoCell.h"

#define color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation SLRepeatInfoCell
{
    UIView * bgView;
}

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color(245, 245, 245, 1);
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        CALayer * line = [CALayer layer];
        line.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 0.5);
        line.backgroundColor = color(233, 233, 233, 1).CGColor;
        [bgView.layer addSublayer:line];
        
        _mergeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mergeBtn setTitle:@"合并为同一联系人" forState:UIControlStateNormal];
        [_mergeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _mergeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [bgView addSubview:_mergeBtn];
        [_mergeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->bgView);
            make.bottom.equalTo(self->bgView).offset(-8);
        }];
    }
    return self;
}
/**联系人名字*/
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        _name.font = [UIFont boldSystemFontOfSize:17];
        [_name sizeToFit];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->bgView).offset(15);
            make.top.equalTo(self->bgView).offset(12);
        }];
    }
    return _name;
}
/**客户名称*/
-(UILabel *)customer{
    if (!_customer) {
        _customer = [[UILabel alloc]init];
        _customer.textColor = [UIColor grayColor];
        _customer.font = [UIFont systemFontOfSize:14];
        [_customer sizeToFit];
        [self addSubview:_customer];
        [_customer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->bgView).offset(15);
            make.top.equalTo(self->_name.mas_bottom).offset(15);
        }];
    }
    return _customer;
}
/**联系人电话*/
-(UILabel *)phone{
    if (!_phone) {
        _phone = [[UILabel alloc]init];
        _phone.textColor = [UIColor blackColor];
        _phone.font = [UIFont boldSystemFontOfSize:16];
        [_phone sizeToFit];
        [self addSubview:_phone];
        [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->bgView).offset(-15);
            make.centerY.equalTo(self->_name);
        }];
    }
    return _phone;
}
-(void)setCellWithModel:(SLRepeatInfoModel *)model
{
    self.name.text = model.name;
    self.customer.text = model.client_name;
    self.phone.text = model.phone;
}
@end

@implementation SLRepeatCell
{
    UIView * bgView;
}

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color(245, 245, 245, 1);
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
       
    }
    return self;
}
/**联系人名字*/
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        _name.font = [UIFont boldSystemFontOfSize:17];
        [_name sizeToFit];
        [bgView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->bgView).offset(15);
            make.top.equalTo(self->bgView).offset(12);
        }];
    }
    return _name;
}
/**客户名称*/
-(UILabel *)customer{
    if (!_customer) {
        _customer = [[UILabel alloc]init];
        _customer.textColor = [UIColor grayColor];
        _customer.font = [UIFont systemFontOfSize:14];
        [_customer sizeToFit];
        [bgView addSubview:_customer];
        [_customer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->bgView).offset(15);
            make.top.equalTo(self->_name.mas_bottom).offset(15);
        }];
    }
    return _customer;
}
/**联系人电话*/
-(UILabel *)phone{
    if (!_phone) {
        _phone = [[UILabel alloc]init];
        _phone.textColor = [UIColor blackColor];
        _phone.font = [UIFont boldSystemFontOfSize:16];
        [_phone sizeToFit];
        [bgView addSubview:_phone];
        [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self->bgView).offset(-15);
            make.centerY.equalTo(self->_name);
        }];
    }
    return _phone;
}
-(void)setCellWithModel:(SLRepeatInfoModel *)model
{
    self.name.text = model.name;
    self.customer.text = model.client_name;
    self.phone.text = model.phone;
}
@end

@implementation SLChooseCell

{
    UIView * bgView;
}

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color(245, 245, 245, 1);
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        
    }
    return self;
}
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.text = @"生日";
        _title.textColor = [UIColor grayColor];
        _title.font = [UIFont systemFontOfSize:16];
        [_title sizeToFit];
        [bgView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->bgView).offset(20);
            make.top.equalTo(self->bgView).offset(15);
        }];
    }
    return _title;
}
-(UIButton *)firBtn{
    if (!_firBtn) {
        _firBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_firBtn setImage:[UIImage imageNamed:@"qf_select_statusdefault"] forState:UIControlStateNormal];
        [_firBtn setImage:[UIImage imageNamed:@"qf_select_statuschoose"] forState:UIControlStateSelected];
        
        [bgView addSubview:_firBtn];
        [_firBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self->_title);
            make.left.equalTo(self->_title.mas_right).offset(50);
        }];
    }
    return _firBtn;
}
-(UILabel *)firName{
    if (!_firName) {
        _firName = [[UILabel alloc]init];
        _firName.text = @"生日";
        _firName.textColor = [UIColor grayColor];
        _firName.font = [UIFont systemFontOfSize:16];
        [_firName sizeToFit];
        [bgView addSubview:_firName];
        [_firName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_firBtn.mas_right).offset(20);
            make.centerY.equalTo(self->_firBtn);
        }];
    }
    return _firName;
}
-(UIButton *)secBtn{
    if (!_secBtn) {
        _secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_secBtn setImage:[UIImage imageNamed:@"qf_select_statusdefault"] forState:UIControlStateNormal];
        [_secBtn setImage:[UIImage imageNamed:@"qf_select_statuschoose"] forState:UIControlStateSelected];
       
        [bgView addSubview:_secBtn];
        [_secBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self->_firBtn);
            make.bottom.equalTo(self->bgView).offset(-15);
        }];
    }
    return _secBtn;
}
-(UILabel *)secName{
    if (!_secName) {
        _secName = [[UILabel alloc]init];
        _secName.text = @"生日";
        _secName.textColor = [UIColor grayColor];
        _secName.font = [UIFont systemFontOfSize:16];
        [_secName sizeToFit];
        [bgView addSubview:_secName];
        [_secName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_secBtn.mas_right).offset(20);
            make.centerY.equalTo(self->_secBtn);
        }];
    }
    return _secName;
}


@end
