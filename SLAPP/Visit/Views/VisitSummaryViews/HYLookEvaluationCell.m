//
//  HYLookEvaluationCell.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookEvaluationCell.h"
#import "HYLookEvaluaTionArrowView.h"

@interface HYLookEvaluationCell()
@property(nonatomic,strong)HYLookEvaluaTionArrowView *arrow;

@end
@implementation HYLookEvaluationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth - 30, 30)];
        _titleLable.textColor = [UIColor darkGrayColor];
        _titleLable.font = kFont(14);
        
        _cycleView = [[HYLookEvaluationSubView alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth-30, 20)];
        [self.contentView addSubview:_titleLable];
        [self.contentView addSubview:_cycleView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setModel:(HYSelectSubEvaluationModel *)model
{
    _model = model;
    _titleLable.text = [model.text toString];
    
    if (_cycleView) {
        for (UIView *view in _cycleView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    if (_arrow) {
        [_arrow removeFromSuperview];
        _arrow = nil;
    }
    
     int cVal = [[model.val toString] intValue];

    
    [_cycleView creatcreatImgVsWithCount:[model.max intValue] Index:cVal];
    
   
    if (cVal > 0 && cVal <= [model.max intValue]) {
        
        CGFloat x = ([[model.val toString] intValue]-1) * (kScreenWidth - 15 * 2 - 10 * 2)/(5-1)+10;
        HYLookEvaluaTionArrowView *arrow = [[HYLookEvaluaTionArrowView alloc] initWithFrame:CGRectMake(10, 70, kScreenWidth-20, 40) origin:CGPointMake(x, 5) text:[model.itemtxt toString]];
        [self addSubview:arrow];
        _arrow = arrow;
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
