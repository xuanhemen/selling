//
//  StatisticalListView.m
//  SLAPP
//
//  Created by qwp on 2018/8/3.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "StatisticalListView.h"
#import "QFHeader.h"
@implementation StatisticalListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,kNav_height, kScreenWidth, kScreenHeight-kNav_height-kTab_height);
        self.backgroundColor = UIColorFromRGB(0xECEAF1);
        [self uiConfig];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xECEAF1);
        [self uiConfig];
    }
    return self;
}
- (void)uiConfig{
    CGFloat width = (kScreenWidth-30-20)/3.0;
    CGFloat height = width/558.0*754.0;
    NSArray *imageNameArray = @[@"qf_xiaoshouloudou.jpg",@"qf_shangjitongji.jpg",@"qf_baifangtognji.jpg",@"qf_fengxianfenxi.jpg",@"qf_pingjingfenxi.jpg",@"qf_celvefenxi.jpg"];
    imageNameArray = @[@"qf_xiaoshouloudou.png",@"qf_shangjitongji.png",@"qf_fengxianfenxi.png",@"qf_pingjingfenxi.png",@"qf_yejipaihang.png"];
    for (int i=0; i<5; i++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15+(width+10)*(i%3), 15+(15+height)*(i/3), width, height)];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = [UIImage imageNamed:imageNameArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backView addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] initWithFrame:imageView.frame];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
    }
}
- (void)buttonClick:(UIButton *)sender{
    if (self.statisticalBlock) {
        self.statisticalBlock(sender.tag-1000);
    }
}

@end
