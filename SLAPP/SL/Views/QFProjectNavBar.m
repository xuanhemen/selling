//
//  QFProjectNavBar.m
//  SLAPP
//
//  Created by qwp on 2018/8/3.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFProjectNavBar.h"
#import "QFHeader.h"
#import "ChatKeyBoardMacroDefine.h"

@interface QFProjectNavBar()
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIView *titleBackView;

@end

@implementation QFProjectNavBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0,NAV_HEIGHT-64, [UIScreen mainScreen].bounds.size.width, 64);
        self.backgroundColor = kBackColor;
        
        
    }
    return self;
}
- (void)configOnlyTitle:(NSString *)title andHaveRight:(BOOL)isHave{
    self.titleBackView = [[UIView alloc] initWithFrame:CGRectMake(80, 25, self.frame.size.width-160, 30)];
    self.titleBackView.layer.cornerRadius = 15;
    self.titleBackView.backgroundColor = [UIColor clearColor];
    self.titleBackView.clipsToBounds = YES;
    [self addSubview:self.titleBackView];
    
    if (title) {
        self.listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-160, 30)];
        self.listLabel.textColor = [UIColor whiteColor];
        self.listLabel.text = title;
        self.listLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
        self.listLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleBackView addSubview:self.listLabel];
        
    }
    if (isHave) {
        self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-40, 20, 30, 44)];
        [self.searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.searchButton];
        
        self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-70, 20, 30, 44)];
        [self.addButton setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
    }
}
- (void)uiConfig{
    [self configOnlyTitle:nil andHaveRight:YES];
    
    self.titleBackView.backgroundColor = UIColorFromRGB(0x2F323F);
    
    self.changeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width-160)/2, 30)];
    self.changeView.layer.cornerRadius = 15;
    self.changeView.backgroundColor = UIColorFromRGB(0x1C1D2B);
    self.changeView.clipsToBounds = YES;
    [self.titleBackView addSubview:self.changeView];
    
    self.listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width-160)/2, 30)];
    self.listLabel.textColor = [UIColor whiteColor];
    self.listLabel.text = @"列表";
    self.listLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBackView addSubview:self.listLabel];
    
    self.statisticalLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-160)/2, 0, (self.frame.size.width-160)/2, 30)];
    self.statisticalLabel.textColor = UIColorFromRGB(0x848484);
    self.statisticalLabel.text = @"统计";
    self.statisticalLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleBackView addSubview:self.statisticalLabel];
    
    UIButton *listBtn = [[UIButton alloc] initWithFrame:self.listLabel.frame];
    [listBtn addTarget:self action:@selector(listBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBackView addSubview:listBtn];
    
    UIButton *statisticalBtn = [[UIButton alloc] initWithFrame:self.statisticalLabel.frame];
    [statisticalBtn addTarget:self action:@selector(statisticalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBackView addSubview:statisticalBtn];
    
    
    
}
- (void)searchButtonClick:(UIButton *)sender{
    if (self.searchButtonBlock) {
        self.searchButtonBlock();
    }
}
- (void)addButtonClick:(UIButton *)sender{
    if (self.addButtonBlock) {
        self.addButtonBlock();
    }
}
- (void)statisticalBtnClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.changeView.frame = CGRectMake((self.frame.size.width-160)/2, 0, (self.frame.size.width-160)/2, 30);
    }];
    self.statisticalLabel.textColor = [UIColor whiteColor];
    self.listLabel.textColor = UIColorFromRGB(0x848484);
    if (self.changeViewBlock) {
        self.changeViewBlock(NO);
    }
}
- (void)listBtnClick{
    [UIView animateWithDuration:0.3 animations:^{
        self.changeView.frame = CGRectMake(0, 0, (self.frame.size.width-160)/2, 30);
    }];
    self.listLabel.textColor = [UIColor whiteColor];
    self.statisticalLabel.textColor = UIColorFromRGB(0x848484);
    if (self.changeViewBlock) {
        self.changeViewBlock(YES);
    }
}

-(void)addBack{
    
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0,20, 50, 50);
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-10,0,0);
        [_backBtn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
    }
}

-(void)backClick{
    if (self.backBtnClick) {
        self.backBtnClick();
    }
}
@end
