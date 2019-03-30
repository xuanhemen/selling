//
//  SLScheduleGroupCell.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheduleGroupCell.h"

@implementation SLScheduleGroupCell

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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]initWithImage:img(@"qf_depImage")];
        [self addSubview:_headImgView];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    }
    return _headImgView;
}
-(UILabel *)depName{
    if (!_depName) {
        kWeakS(weakSelf);
        _depName = [[UILabel alloc]init];
        _depName.font = b_font(16);
        _depName.textColor = color_normal;
        [self.contentView addSubview:_depName];
        [_depName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(self->_headImgView.mas_right).offset(20);
        }];
    }
    return _depName;
}
@end
