//
//  VisitReportCell.m
//  CLApp
//
//  Created by xslp on 16/11/2.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "VisitReportCell.h"
#import "UIView+LoadNib.h"
#define kImgVWidth 40
#define LeftRightPadding 15
#define lbImgVMargin 10

@interface VisitReportCell ()
@property(nonatomic,strong) UIImageView *headerImgV;
@property (strong, nonatomic) UILabel *lbDetail;
@property (strong, nonatomic) UILabel *lbTime;
@end
@implementation VisitReportCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    self.headerImgV = [[UIImageView alloc]init];
    self.headerImgV.image = [UIImage imageNamed:@"pdf"];
    self.headerImgV.layer.cornerRadius = 5;
    self.headerImgV.clipsToBounds = YES;
    
    self.lbDetail = [[UILabel alloc] init];
    self.lbDetail.font = kFont(14);
    self.lbDetail.textColor = [UIColor blackColor];
    self.lbDetail.textAlignment = NSTextAlignmentLeft;
    
    self.lbTime = [[UILabel alloc] init];
    self.lbTime.font = kFont(12);
    self.lbTime.textColor = [UIColor grayColor];
    self.lbTime.textAlignment = NSTextAlignmentLeft;
    
    self.bottomView = [VisitReportCellBottomView loadBundleNib];
    
    [self.contentView addSubview:bgView];
    [self.contentView addSubview:self.bottomView];
    [bgView addSubview:self.headerImgV];
    [bgView addSubview:self.lbDetail];
    [bgView addSubview:self.lbTime];

    kWeakS(weakSelf);
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(60);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(0.5);
        make.left.right.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(40);
    }];
    [self.headerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(LeftRightPadding);
        make.size.mas_equalTo(CGSizeMake(kImgVWidth, kImgVWidth));
    }];
    [self.lbDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerImgV.mas_right).offset(lbImgVMargin);
        make.top.equalTo(weakSelf.headerImgV);
        make.right.mas_equalTo(-LeftRightPadding);
    }];
    [self.lbTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerImgV.mas_right).offset(lbImgVMargin);
        make.bottom.equalTo(weakSelf.headerImgV);
        make.right.mas_equalTo(-LeftRightPadding);
    }];
    
    
    [self.bottomView.shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.downloadBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView.delectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)btnClick:(UIButton *)btn{
    
    if (self.bottomClickWithTag) {
        self.bottomClickWithTag(btn.tag - 1000);
    }
}

-(void)setModel:(HYVisitReportModel *)model{
    _model = model;

    self.lbDetail.text = model.filename;

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";

    NSTimeInterval time = [model.addtime doubleValue];

    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:time];

    self.lbTime.text = time > 0 ? [format stringFromDate:tempDate] : @"";
}


@end
