//
//  FitlerRightCell.m
//  CLApp
//
//  Created by harry on 2017/5/22.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "FitlerRightCell.h"

@implementation FitlerRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  
    self.contentView.backgroundColor = HexColor(@"f4f4f4");
    self.backgroundColor = HexColor(@"f4f4f4");
    self.arrowsBtn.hidden = YES;
    
    [self.arrowsBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected == YES)
    {
        
        _markImage.image = [UIImage imageNamed:@"changeStage_selected"];
        [_lable setTextColor:kgreenColor];
    }
    else
    {
        [_lable setTextColor:[UIColor darkTextColor]];
        _markImage.image = [UIImage imageNamed:@"changeStage"];
        if ([_model.id isEqualToString:@"-1"]) {
            [self showback];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setModel:(HYVisitFitterSubModel *)model{
    _model = model;
    _lable.text = model.name;
    self.arrowsBtn.hidden = ![model.isparent intValue];
    
    
    if ([model.id isEqualToString:@"-1"]) {
        [self showback];
    }
    
}

-(void)btnClick:(UIButton *)btn{

    if (self.click) {
        self.click();
    }

}




/**
 是否隐藏选择按钮
 
 @param isHidden <#isHidden description#>
 */
-(void)isHiddenMarkView:(BOOL)isHidden{
    self.markImage.hidden = isHidden;

}



/**
 是否显示箭头
 
 @param isShow bool 是否显示
 */
-(void)isShowArrow:(BOOL)isShow{

    self.arrowsBtn.hidden = !isShow;
    
}



/**
 右侧箭头点击响应
 
 @param click 点击响应block
 */
-(void)arrowClick:(btnclick)click;{

    self.click = [click copy];
}



/**
 显示返回箭头
 */
-(void)showback{
  
    self.markImage.image = [UIImage imageNamed:@"leftArrow"];
}
@end
