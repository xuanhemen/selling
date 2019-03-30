//
//  SLContactClientCell.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLContactClientCell.h"

@implementation SLContactClientCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**客户*/
-(UILabel *)client
{
    if (!_client) {
        _client = [[UILabel alloc]init];
        _client.text = @"客户";
        _client.textColor = [UIColor colorWithHexString:@"#333333"];
        _client.font = [UIFont systemFontOfSize:16];
        [_client sizeToFit];
        [self addSubview:_client];
        [_client mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(10);
        }];
    }
    return _client;
}
/**客户*/
-(UILabel *)position
{
    if (!_position) {
        _position = [[UILabel alloc]init];
        _position.text = @"客户";
        _position.textColor = [UIColor colorWithHexString:@"#333333"];
        _position.font = [UIFont systemFontOfSize:16];
        [_position sizeToFit];
        [self addSubview:_position];
        [_position mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return _position;
}
/**客户*/
-(UILabel *)dep
{
    if (!_dep) {
        _dep = [[UILabel alloc]init];
        _dep.text = @"客户";
        _dep.textColor = [UIColor colorWithHexString:@"#333333"];
        _dep.font = [UIFont systemFontOfSize:16];
        [_dep sizeToFit];
        [self addSubview:_dep];
        [_dep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _dep;
}
-(void)setCellWithModel:(SLContactClientModel *)model
{
    self.client.text = [NSString stringWithFormat:@"客户：%@",model.client_name];
    self.position.text = [NSString stringWithFormat:@"职位：%@",model.position_name];
    self.dep.text = [NSString stringWithFormat:@"部门：%@",model.dep];;
}
@end
