//
//  SLScheProjectCellTableViewCell.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheProjectCellTableViewCell.h"

@implementation SLScheProjectCellTableViewCell

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
-(UILabel *)projectName{
    if (!_projectName) {
        kWeakS(weakSelf);
        _projectName = [[UILabel alloc]init];
        _projectName.font = b_font(16);
        _projectName.textColor = color_normal;
        [self.contentView addSubview:_projectName];
        [_projectName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(15);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _projectName;
}
-(UILabel *)company{
    if (!_company) {
        kWeakS(weakSelf);
        _company = [[UILabel alloc]init];
        _company.font = font(14);
        _company.textColor = color_light;
        [self.contentView addSubview:_company];
        [_company mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).offset(-15);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _company;
}
-(UILabel *)money{
    if (!_money) {
        kWeakS(weakSelf);
        _money = [[UILabel alloc]init];
        _money.font = b_font(16);
        _money.textColor = color_normal;
        [self.contentView addSubview:_money];
        [_money mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(13);
            make.right.equalTo(weakSelf).offset(-15);
        }];
    }
    return _money;
}
-(UILabel *)time{
    if (!_time) {
        kWeakS(weakSelf);
        _time = [[UILabel alloc]init];
        _time.font = font(14);
        _time.textColor = color_light;
        [self.contentView addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf).offset(-13);
            make.right.equalTo(weakSelf).offset(-15);
        }];
    }
    return _time;
}
-(void)setCellWithModel:(SLScheProjectModel *)model{
    self.chooseBtn.hidden = NO;
    self.projectName.text = model.name;
    self.company.text = model.client_name;
    self.money.text = [model.amount stringByAppendingFormat:@"%@",@"万"];
    self.time.text = model.create_time;
}
@end
