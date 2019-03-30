//
//  EffectSummaryCell.m
//  CLApp
//
//  Created by 吕海瑞 on 16/9/6.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "EffectSummaryCell.h"

@implementation EffectSummaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 6;
    self.markTitle.layer.cornerRadius = 12.5;
    self.markTitle.layer.borderWidth = 1;
    self.markTitle.layer.borderColor = kgreenColor.CGColor;
    self.markTitle.font = [UIFont systemFontOfSize:10];
    self.markTitle.textAlignment = NSTextAlignmentCenter;
    self.markTitle.clipsToBounds = YES;
    self.markTitle.textColor = kgreenColor;
   
    self.markTitle.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.lable.textColor = [UIColor darkTextColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(HYEvaluationOptionModel *)model{
       _model = model;
    
      self.lable.text = _model.evaluateitem;
}


-(void)setIsmark:(BOOL)ismark
{
    _ismark = ismark;
    
    if (_ismark)
    {
        self.backView.backgroundColor = kgreenColor;
        self.lable.textColor = [UIColor whiteColor];
//        self.markImage.image = [UIImage imageNamed:@"changeStage_selected"];
    }
    else
    {
        self.backView.backgroundColor = [UIColor whiteColor];
        self.lable.textColor = [UIColor darkTextColor]
        ;
        
//      self.markImage.image = [UIImage imageNamed:@"changeStage"];
    }
    
    
}

-(void)setIndex:(int)index{
    _index = index;
    char a = 'A' + index;
    _markTitle.text = [NSString stringWithCString: &a encoding:NSUTF8StringEncoding];
}

@end
