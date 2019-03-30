//
//  LikeDetailCell.m
//  CLApp
//
//  Created by rms on 17/2/17.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "LikeDetailCell.h"

@interface LikeDetailCell ()

@end
@implementation LikeDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        kWeakS(weakSelf);
        self.headImageView = [[UIImageView alloc] init];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kGAP);
            make.width.height.mas_equalTo(kAvatar_Size);
        }];
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = kAvatar_Size/2;
        
        // nameLabel
        self.nameLabel = [UILabel new];
        [self.contentView addSubview:self.nameLabel];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.preferredMaxLayoutWidth = kScreenWidth - kAvatar_Size - 2*kGAP-kGAP;
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.font = kFont(15);
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(kGAP);
            make.centerY.mas_equalTo(weakSelf.headImageView);
        }];

    }
    return self;
}

//-(void)setModel:(MemberModel *)model{
//
//    _model = model;
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@90x90.jpg",BASE_REQUEST_HEAD_URL,model.head]] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
//    self.nameLabel.text = model.realname;
//
//}
@end
