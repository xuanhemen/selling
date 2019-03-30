//
//  LikeView.m
//  CLApp
//
//  Created by rms on 17/1/12.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "LikeView.h"
#define kSepLineColor HexColor(@"D2D2D2")
#define imgW 30
#define imgMargin 10
#define BTN_WIDTH 30.0
@implementation LikeView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineViewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        UIView *lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5)];
        lineViewTop.backgroundColor = kSepLineColor;
        lineViewBottom.backgroundColor = kSepLineColor;
        [self addSubview:lineViewTop];
        [self addSubview:lineViewBottom];
        self.rightBtn = [[UIButton alloc]init];
        [self.rightBtn setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        [self.rightBtn setTitle:dataSource.count?[NSString stringWithFormat:@"%ld个人赞过",dataSource.count]:@"还没有人赞过" forState:UIControlStateNormal];
        self.rightBtn.userInteractionEnabled = dataSource.count;
        [self.rightBtn sizeToFit];
        self.rightBtn.titleLabel.font = kFont(15);
        self.rightBtn.frame = CGRectMake(frame.size.width - 10 - self.rightBtn.frame.size.width, 7, self.rightBtn.frame.size.width, 30);
        [self addSubview:self.rightBtn];
        UIImageView *rightImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nextIcon"]];
        rightImgV.hidden = !dataSource.count;
        rightImgV.frame = CGRectMake(frame.size.width - 15, 15, 7, 14);
        [self addSubview:rightImgV];
        
        UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - self.rightBtn.frame.size.width - 10 - 5, frame.size.height)];
        scrollV.contentSize = CGSizeMake((imgW +imgMargin) * dataSource.count + imgMargin, frame.size.height);
        [self addSubview:scrollV];
        for (NSUInteger i=0; i<dataSource.count; i++) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(imgMargin*(i+1) + imgW*i, 7, imgW, imgW)];
            iv.backgroundColor = [UIColor whiteColor];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            iv.clipsToBounds = YES;
            iv.layer.cornerRadius = BTN_WIDTH/2;
            if ([dataSource[i] isKindOfClass:[UIImage class]]) {
                iv.image = dataSource[i];
            }else if ([dataSource[i] isKindOfClass:[NSString class]]){
                [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataSource[i]]] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
            }else if ([dataSource[i] isKindOfClass:[NSURL class]]){
                [iv sd_setImageWithURL:dataSource[i] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
            }
            self.dataSource = dataSource;
            iv.tag = i;
            [scrollV addSubview:iv];
        }
    }
    return self;
}

@end
