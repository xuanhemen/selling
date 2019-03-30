//
//  SLRealContactCell.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLRealContactCell.h"

@implementation SLRealContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setImage:img(@"qf_select_statusdefault") forState:UIControlStateNormal];
        [_chooseBtn setImage:img(@"qf_select_statuschoose") forState:UIControlStateSelected];
        [self addSubview:_chooseBtn];
        [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
    }
    return _chooseBtn;
}
-(UILabel *)name{
    if (!_name) {
        kWeakS(weakSelf);
        _name = [[UILabel alloc]init];
        _name.font = b_font(16);
        _name.textColor = color_normal;
        [self.contentView addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(13);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _name;
}
-(UILabel *)company{
    if (!_company) {
        kWeakS(weakSelf);
        _company = [[UILabel alloc]init];
        _company.font = font(14);
        _company.textColor = color_light;
        [self.contentView addSubview:_company];
        [_company mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).offset(-13);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _company;
}
-(UILabel *)position{
    if (!_position) {
        kWeakS(weakSelf);
        _position = [[UILabel alloc]init];
        _position.font = b_font(16);
        _position.textColor = color_normal;
        [self.contentView addSubview:_position];
        [_position mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(13);
            make.left.equalTo(self->_name.mas_right).offset(15);
        }];
    }
    return _position;
}
-(void)setCellWithModel:(SLRealContactModel *)model{
    self.chooseBtn.hidden = NO;
    self.name.text = model.name;
    self.company.text = model.client_name;
    self.position.text = model.position_name;
}
@end
