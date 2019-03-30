//
//  HYHomeView.m
//  SLAPP
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYHomeView.h"
#import "HYHomeTopBtn.h"
#import <WZLBadge/UIView+WZLBadge.h>

@interface HYHomeView()
@property(nonatomic,strong)HYHomeTopBtn *tempBtn;
@end

@implementation HYHomeView
- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        self.backgroundColor = kBackColor;
    }
    return self;
}


/**
 刷新提醒个数
 */
- (void)refreshRedNum:(NSInteger)num{
    
    if (_tempBtn){
        [_tempBtn showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    }
    
    
    
}

-(void)configUI{
   
    float spcace = 20;
    float width = (kScreenWidth-spcace*4)/4;
    float height = width/0.75;
    NSArray * imageArray = @[@"HomeSearch",@"HomeMessage",@"HomeAnalysis",@"HomeAdd"];
    NSArray * titleArray = @[@"搜索",@"消息",@"项目分析",@"新建"];
    for (int i = 0; i< 4; i++) {
        HYHomeTopBtn *btn = [[HYHomeTopBtn alloc] initWithFrame:CGRectMake(spcace/2 + (width + spcace)*i, 0, width, height)];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        if (i == 0) {
//            btn.enabled = false;
//            [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//        }
        
        if (i == 1) {
            _tempBtn = btn;
            _tempBtn.badgeCenterOffset = CGPointMake(-width/2.0+20,height/2.0-20);
//            [_tempBtn showBadgeWithStyle:WBadgeStyleNumber value: animationType:WBadgeAnimTypeNone];
        }
    }
    
}

-(void)btnClick:(UIButton *)btn{
    if (self.btnClick) {
        self.btnClick(btn.tag-1000, @"");
    }
}
@end
