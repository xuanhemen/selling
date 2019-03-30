//
//  SLChooseScheduleCell.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLChooseScheduleCell.h"

@implementation SLChooseScheduleCell

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
-(UILabel *)company{
    if (!_company) {
        kWeakS(weakSelf);
        _company = [[UILabel alloc]init];
        _company.font = b_font(16);
        _company.textColor = color_normal;
        [self.contentView addSubview:_company];
        [_company mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf).offset(-70/4);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _company;
}
-(UILabel *)address{
    if (!_address) {
        kWeakS(weakSelf);
        _address = [[UILabel alloc]init];
        _address.font = font(14);
        _address.textColor = color_light;
        [self.contentView addSubview:_address];
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf).offset(70/4);
            make.left.equalTo(self->_chooseBtn.mas_right).offset(15);
        }];
    }
    return _address;
}
-(UILabel *)response{
    if (!_response) {
        kWeakS(weakSelf);
        _response = [[UILabel alloc]init];
        _response.font = font(14);
        _response.textColor = color_light;
        [self.contentView addSubview:_response];
        [_response mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf).offset(-15);
        }];
    }
    return _response;
}
-(void)setCellWithModel:(SLScheduleModel *)model{
    self.chooseBtn.hidden = NO;
    self.company.text = model.name;
    if (model.place==nil||[model.place isEqual:@""]) {
        self.address.text = @"暂无地址";
    }else{
        self.address.text = model.place;
    }
    self.response.text = [NSString stringWithFormat:@"负责人：%@",model.contact];
}
@end
