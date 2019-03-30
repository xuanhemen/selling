//
//  SLContactDetailView.m
//  SLAPP
//
//  Created by 董建伟 on 2018/12/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "SLContactDetailView.h"
#import "UIColor+Function.h"
#import "Masonry.h"
#import "UILabel+mothod.h"
#import "UIImageView+WebCache.h"
#define font(size)  [UIFont systemFontOfSize:size]

@implementation SLContactDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/**联系人姓名*/
-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor colorWithHexString:@"#333333"];
        _name.font = [UIFont boldSystemFontOfSize:17];
        [_name sizeToFit];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _name;
}
/**联系人职务*/
-(UILabel *)position
{
    if (!_position) {
        _position = [[UILabel alloc]init];
        _position.textColor = [UIColor colorWithHexString:@"#666666"];
        _position.font = [UIFont systemFontOfSize:15];
        [_position sizeToFit];
        [self addSubview:_position];
        [_position mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_name.mas_bottom).offset(15);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _position;
}
/**联系人部门*/
-(UILabel *)department
{
    if (!_department) {
        _department = [[UILabel alloc]init];
        _department.textColor = [UIColor colorWithHexString:@"#666666"];
        _department.font = [UIFont systemFontOfSize:15];
        [_department sizeToFit];
        [self addSubview:_department];
        [_department mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_position.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _department;
}
/**联系人负责人*/
-(UILabel *)responsible
{
    if (!_responsible) {
        _responsible = [[UILabel alloc]init];
        _responsible.textColor = [UIColor colorWithHexString:@"#666666"];
        _responsible.font = [UIFont systemFontOfSize:15];
        [_responsible sizeToFit];
        [self addSubview:_responsible];
        [_responsible mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_department.mas_bottom).offset(10);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _responsible;
}
-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(100, 80));
        }];
    }
    return _imageView;
}

-(void)setCellWithModel:(SLContactDetailModel *)model
{
    self.name.text = model.name;
    self.position.text = [NSString stringWithFormat:@"职    务：    %@",model.position];
    self.department.text = [NSString stringWithFormat:@"部    门：    %@",model.dep];
    self.responsible.text = [NSString stringWithFormat:@"负责人：    %@",model.res];
    NSURL * imgUrl = [NSURL URLWithString:model.imgName];
    [self.imageView sd_setImageWithURL:imgUrl];
}
@end

/*********ohter***************/

@implementation SLContactDetailHead


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255. blue:240/255. alpha:1];
    }
    return self;
}
/**title*/
-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont boldSystemFontOfSize:15];
        [_title sizeToFit];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
    }
    return _title;
}

@end

@implementation SLContactDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
/**联系人名字*/
-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc]init];
        _title.textColor = [UIColor colorWithHexString:@"#333333"];
        _title.font = [UIFont systemFontOfSize:15];
        [_title sizeToFit];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return _title;
}
/**联系人名字*/
-(UILabel *)content{
    if (!_content) {
        _content = [[UILabel alloc]init];
        _content.textColor = [UIColor blackColor];
        _content.font = [UIFont systemFontOfSize:15];
        [_content sizeToFit];
        [self addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_title.mas_right).offset(15);
            make.centerY.equalTo(self->_title);
        }];
    }
    return _content;
}
@end

@protocol clickButton;
@implementation SLContactBottomView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer * layer = [CALayer layer];
        layer.frame = CGRectMake(0, 49.7, SCREEN_WIDTH, 0.3);
        layer.backgroundColor = COLOR(233, 233, 233, 1).CGColor;
        [self.layer addSublayer:layer];
        NSArray * titleArr = @[@"项目",@"跟进",@"拜访",@"更多"];
        for (int i = 0; i<4; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CALayer * lineLayer = [CALayer layer];
            lineLayer.frame = CGRectMake(SCREEN_WIDTH/4, 13, 0.3, 24);
            lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
            [btn.layer addSublayer:lineLayer];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            btn.frame = CGRectMake(SCREEN_WIDTH/4*i, 0, SCREEN_WIDTH/4, 50);
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
           
        }
    }
    return self;
}
-(void)btnClicked:(UIButton *)button
{
    NSInteger tag = button.tag;
    [self.delegate passBtnTag:tag];
}
//-(void)drawRect:(CGRect)rect{
//    UIColor *color = [UIColor redColor];
//    [color set]; //设置线条颜色
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(10, 10)];
//    [path addLineToPoint:CGPointMake(200, 80)];
//
//    path.lineWidth = 5.0;
//    path.lineCapStyle = kCGLineCapRound; //线条拐角
//    path.lineJoinStyle = kCGLineJoinRound; //终点处理
//
//    [path stroke];
//}
@end





