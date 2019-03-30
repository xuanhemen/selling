//
//  SLScheduleCell.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/15.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLScheduleCell.h"


@implementation SLScheduleCell

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
        
    }
    return self;
}
-(UILabel *)title{
    if (!_title) {
        kWeakS(weakSelf);
        _title = [[UILabel alloc]init];
        _title.font = font(16);
        _title.textColor = color_normal;
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(15);
        }];
    }
    return _title;
}
-(UITextField *)content{
    if (!_content) {
        _content = [[UITextField alloc]init];
        _content.font = font(16);
        _content.textColor = color_normal;
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(110);
            make.top.bottom.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView);
        }];
    }
    return _content;
}
-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = font(16);
        _textView.delegate = self;
        _textView.textColor = color_normal;
        [self.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(30);
            make.top.bottom.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView);
        }];
    }
    return _textView;
}
-(UILabel *)placeHoler{
    if (!_placeHoler) {
        _placeHoler = [[UILabel alloc]init];
        _placeHoler.textColor = COLOR(210, 210, 210, 1);
        _placeHoler.font = font(16);
        [self.contentView addSubview:_placeHoler];
        [_placeHoler mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_title.mas_right).offset(32);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return _placeHoler;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeHoler.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        _placeHoler.text = @"请输入日程内容";
    }
}
@end
