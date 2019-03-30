    //
//  HYProjectHeaderView.m
//  SLAPP
//
//  Created by yons on 2018/9/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYProjectHeaderView.h"

@interface HYProjectHeaderView()

@property (nonatomic,strong) UILabel *tageName;
@property (nonatomic,strong) UILabel *number;
@property (nonatomic,strong) UILabel *money;
@property (nonatomic,strong) UILabel *detailLabel;



@end

@implementation HYProjectHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
- (void)setViewClientModelWithDict:(NSDictionary *)dict{
    self.tageName.text = [NSString stringWithFormat:@"%@",dict[@"realname"]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@个",[NSString stringWithFormat:@"%@",dict[@"count"]]];
    [self.showBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p_show%@",dict[@"isShow"]]] forState:UIControlStateNormal];
}

- (void)setViewModelWithDict:(NSDictionary *)dict{
    
    self.tageName.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    self.detailLabel.text = [NSString stringWithFormat:@"%.2f万/%@个",[[NSString stringWithFormat:@"%@",dict[@"amount"]] floatValue],dict[@"total"]];
    [self.showBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p_show%@",dict[@"isShow"]]] forState:UIControlStateNormal];
}

- (void)configUI{
    self.backgroundColor = UIColorFromRGB(0xEEEFF3);
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, self.frame.size.height-10.5)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    self.tageName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/4, backView.frame.size.height)];
    self.tageName.text = @"意向";
    self.tageName.font = [UIFont systemFontOfSize:14];
    self.tageName.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.tageName];
    
    self.showBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/8*7, 0, kScreenWidth/8, backView.frame.size.height)];
    [self.showBtn setImage:[UIImage imageNamed:@"p_show1"] forState:UIControlStateNormal];
    [backView addSubview:self.showBtn];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tageName.frame.size.width+10, 0, kScreenWidth-self.tageName.frame.size.width-10-self.showBtn.frame.size.width, backView.frame.size.height)];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.text = @"100万/30个";
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.detailLabel];
}

@end
