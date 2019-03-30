//
//  HYHomeCell.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeCell.h"
#import "HYHomeModel.h"
#import <Masonry/Masonry.h>
#import "NSString+AttributedString.h"
@implementation HYHomeCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellAccessoryNone;
        [self configUI];
        
        
    }
    return self;
    
}

- (void)configUI{
    float width = 40;
    
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, width, 30)];
    
    
    _leftLabel.textColor = UIColorFromRGB(0x4f82f5);
    _leftLabel.text = @"";
    _leftLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    [self.contentView addSubview:_leftLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(3);
       
    }];
    
    
    
    _contentLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftLabel.frame), 0,kScreenWidth-width-50-50, 30)];
    _contentLab.text = @"";
    _contentLab.numberOfLines = 3;
    _contentLab.textColor = UIColorFromRGB(0x333333);
    _contentLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.contentView addSubview:_contentLab];
    kWeakS(weakSelf);
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLabel.mas_right);
        make.top.equalTo(weakSelf.contentView).offset(5);
        make.right.equalTo(weakSelf.contentView).offset(-50);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(0);
        make.height.mas_greaterThanOrEqualTo(10);
    }];
    //_contentLab.numberOfLines = 0;
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(kScreenWidth-50, 5, width, 20);
    _rightBtn.layer.cornerRadius = 10;
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [_rightBtn setTitle:@"查看" forState:UIControlStateNormal];
    [_rightBtn setBackgroundColor:UIColorFromRGB(0x4f82f5)];
    [self.contentView addSubview:_rightBtn];
    
//    [_rightBtn m];
    
    [_rightBtn addTarget:self action:@selector(lookatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setModel:(HYHomeContentDetailModel *)model{
    _model = model;
    
    _leftLabel.text = _model.title;
    
    _contentLab.attributedText = [self configWithText:[NSString stringWithFormat:@"%@  %@",_model.overtime_date,_model.action_target]];
    _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    

}

-(NSMutableAttributedString *)configWithText:(NSString *)allStr{
    NSRange range = NSMakeRange(0, allStr.length);
    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:allStr];

    [aStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    CGFloat lineSpace = 5;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = lineSpace;
        [aStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    
    
    return aStr;
}


-(void)lookatBtnClick{
    
    if (self.clickCellWithModel) {
        if (_model) {
            self.clickCellWithModel(_model);
        }
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
