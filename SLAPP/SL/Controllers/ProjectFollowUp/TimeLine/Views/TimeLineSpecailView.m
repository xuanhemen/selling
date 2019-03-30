//
//  TimeLineSpecailView.m
//  SLAPP
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "TimeLineSpecailView.h"



@implementation TimeLineSpecailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setModel:(SDTimeLineCellModel *)model{
    _model = model;
    
    
    
    
//    _contentlable = nil;
//    _iconImage = nil;
//    _titleLab = nil;
//    _middleName = nil;
//    _titleLabValue = nil;
//    _middleValue = nil;
//    _bottomName = nil;
//    _bottomVaule = nil;
    
    
    
    
    
    
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *color = [UIColor lightGrayColor];
    float width = kScreenWidth-80;
    float imageWidth = 90;
    float nameWidth = 80;
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 5,width,90)];
        [self addSubview:_backView];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    if ([_model.special_type isEqual:@"pro_analyse"]) {
        
        if (!_iconImage) {
            _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,imageWidth, imageWidth)];
            [_backView addSubview:_iconImage];
            _iconImage.image = [UIImage imageNamed:@"TimelineAnalyse"];
            
        }else{
            _iconImage.image = [UIImage imageNamed:@"TimelineAnalyse"];
        }
        
        if (!_titleLab) {
            _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5, 0,nameWidth, 30)];
            [_backView addSubview:_titleLab];
            _titleLab.text = @"项目得分：";
            _titleLab.font = font;
            _titleLab.textColor = color;
        }else{
            _titleLab.frame = CGRectMake(imageWidth+5, 0,nameWidth, 30);
            _titleLab.text = @"项目得分：";
        }
        
        if (!_titleLabValue) {
            _titleLabValue = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5+nameWidth,0, width-imageWidth - 10 - nameWidth, 30)];
            [_backView addSubview:_titleLabValue];
            _titleLabValue.textColor = kgreenColor;
            _titleLabValue.font = font;
            _titleLabValue.textAlignment = NSTextAlignmentCenter;
            _titleLabValue.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"pro_defen"] intValue]];
        }else{
            _titleLabValue.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"pro_defen"] intValue]];
        }
//
        
        if (!_middleName) {
            _middleName = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5, 30, nameWidth, 30)];
            [_backView addSubview:_middleName];
            _middleName.font = font;
            _middleName.textColor = color;
            _middleName.text = @"赢单指数：";
        }
        
        if (!_middleValue) {
            _middleValue = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5+nameWidth, 30, width-imageWidth - 10 - nameWidth , 30)];
            [_backView addSubview:_middleValue];
            _middleValue.textColor = kgreenColor;
            _middleValue.font = font;
            _middleValue.textAlignment = NSTextAlignmentCenter;
            _middleValue.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"winindex"] intValue]];
        }else{
            _middleValue.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"winindex"] intValue]];
        }
        
        
        if (!_bottomName) {
            _bottomName = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5, 60, nameWidth, 30)];
            [_backView addSubview:_bottomName];
            _bottomName.text = @"风险项：";
            _bottomName.font = font;
            _bottomName.textColor = color;
        }
        
        
        if (!_bottomVaule) {
            _bottomVaule = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5+nameWidth, 60, width-imageWidth - 10 - nameWidth, 30)];
            [_backView addSubview:_bottomVaule];
            _bottomVaule.textColor = kgreenColor;
            _bottomVaule.font = font;
            _bottomVaule.textAlignment = NSTextAlignmentCenter;
            _bottomVaule.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"risk_warning_count"] intValue]];
        }else{
           
            _bottomVaule.text = [NSString stringWithFormat:@"%d",[_model.special_value[@"risk_warning_count"] intValue]];
        }
        
        _titleLab.hidden = false;
        _titleLabValue.hidden = false;
        _middleName.hidden = false;
        _middleValue.hidden = false;
        _bottomName.hidden = false;
        _bottomVaule.hidden = false;
        _contentlable.hidden = YES;
        
    }else if ([_model.special_type isEqual:@"action_plan"]){
        
        if (!_iconImage) {
            _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,imageWidth, imageWidth)];
            [_backView addSubview:_iconImage];
            _iconImage.image = [UIImage imageNamed:@"TimelineAction"];
        }else{
            _iconImage.image = [UIImage imageNamed:@"TimelineAction"];
        }
        
        if (!_titleLab) {
            _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth+5, 0,width-imageWidth-10, 30)];
            [_backView addSubview:_titleLab];
            _titleLab.text = [NSString stringWithFormat:@"%@",_model.special_value[@"title"]];
            _titleLab.textColor = color;
            _titleLab.font = font;
        }else{
            _titleLab.frame = CGRectMake(imageWidth+5, 0,width-imageWidth-10, 30);
            _titleLab.text = [NSString stringWithFormat:@"%@",_model.special_value[@"title"]];
        }
        
        if (!_contentlable) {
            _contentlable = [[CustomLable alloc] initWithFrame:CGRectMake(imageWidth+5, 30, width-imageWidth-10, 60)];
            [_backView addSubview:_contentlable];
            _contentlable.numberOfLines = 0;
            _contentlable.font = font;
            _contentlable.textColor = color;
            _contentlable.text = [NSString stringWithFormat:@"%@",_model.special_value[@"action_target"]];;
        }else{
            _contentlable.text = [NSString stringWithFormat:@"%@",_model.special_value[@"action_target"]];;
        }
        
        
        _titleLab.hidden = false;
        _titleLabValue.hidden = YES;
        _middleName.hidden = YES;
        _middleValue.hidden = YES;
        _bottomName.hidden = YES;
        _bottomVaule.hidden = YES;
        _contentlable.hidden = false;
    }
    
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(0, 0,width,90);
        [_backView addSubview:_btn];
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_backView bringSubviewToFront:_btn];
    }
    
}

-(void)btnClick{
    if (self.clickSpecailView) {
        
        
        self.clickSpecailView(_model.special_type,_model.special_value);
    }
    
}
@end
