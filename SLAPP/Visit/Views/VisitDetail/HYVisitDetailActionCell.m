//
//  HYVisitDetailActionCell.m
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitDetailActionCell.h"

@implementation HYVisitDetailActionCell

-(void)configUIWithModel{
    _bestContent.text = self.model.bestContent;
    _lowestContent.text = self.model.lowestContent;
    
    if (![_bestContent.text isNotEmpty]) {
        _bestContent.text = @"无";
        _bestContent.textColor = kgreenColor;
    }else{
        
        _bestContent.textColor = [UIColor darkTextColor];
        
    }
    
    if (![_lowestContent.text isNotEmpty]) {
        _lowestContent.text = @"无";
        _lowestContent.textColor = kOrangeColor;
    }else{
        _lowestContent.textColor = [UIColor darkTextColor];
    }
    
}

-(void)configUI{
    
    _best = [UILabel new];
    _bestContent = [UILabel new];
    _lowest = [UILabel new];
    _lowestContent = [UILabel new];
    
    _best.font = kFont(14);
    _bestContent.font = kFont(14);
    _lowest.font = kFont(14);
    _lowestContent.font = kFont(14);
    
   
    _best.text = @"最佳承诺：";
    _lowest.text = @"最低承诺：";
    
    _best.textColor = kgreenColor;
    _lowest.textColor = kOrangeColor;
    
    _bestContent.textColor = [UIColor darkTextColor];
    _lowestContent.textColor = [UIColor darkTextColor];
    
    _lowestContent.numberOfLines = 0;
    _bestContent.numberOfLines = 0;
    [self.contentView addSubview:_best];
    [self.contentView addSubview:_bestContent];
    [self.contentView addSubview:_lowest];
    [self.contentView addSubview:_lowestContent];
    
    CGFloat space = 0;
    
    kWeakS(weakSelf);
    [_best mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView).offset(space);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    [_bestContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.best.mas_bottom).offset(space);
        make.left.equalTo(weakSelf.best.mas_left);
        make.height.mas_greaterThanOrEqualTo(30);
        make.bottom.equalTo(weakSelf.lowest.mas_top).offset(-space);
    }];
    
    [_lowest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bestContent.mas_bottom).offset(space);
        make.left.equalTo(weakSelf.best);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    
    [_lowestContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lowest.mas_bottom).offset(space);
        make.left.equalTo(weakSelf.best);
        make.height.mas_greaterThanOrEqualTo(30);
        make.bottom.equalTo(weakSelf.contentView).offset(-space);
    }];
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
