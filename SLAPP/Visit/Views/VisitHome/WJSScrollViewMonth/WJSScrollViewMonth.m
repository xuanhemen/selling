//
//  WJSTitleView.m
//  WJSTtitle
//
//  Created by 王静帅 on 15/9/20.
//  Copyright © 2015年 rxb. All rights reserved.
//

/// Waring: 此demo已被修改成一个屏幕显示七个btn,且永远中间那个最大!

#import "WJSScrollViewMonth.h"

@interface WJSScrollViewMonth ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end

@implementation WJSScrollViewMonth

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate     = self;
        self.buttonArray  = [NSMutableArray array];
        self.titlesArray  = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        self.buttonWidth  = 40.0f;
        self.scale_max    = 1.0f;
        self.scale_min    = 0.8;
        self.gsv_selected = 1.0f;
        self.gsv_default  = 0.8;
        
        //不显示滑动条
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate     = self;
        self.buttonArray  = [NSMutableArray array];
        self.titlesArray  = [NSMutableArray array];
        self.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        self.buttonWidth  = 40.0f;
        self.scale_max    = 1.0f;
        self.scale_min    = 0.8;
        self.gsv_selected = 1.0f;
        self.gsv_default  = 0.8;
        
        //不显示滑动条
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)setupWithTitleArray:(NSArray *)array
{
    self.titlesArray = [NSMutableArray arrayWithArray:array];
    self.buttonArray = [NSMutableArray array];
    self.contentSize = CGSizeMake(self.buttonWidth * (array.count+2), self.frame.size.height);
    for (int i = 0; i < self.titlesArray.count; i++) {
        [self initButtonsWithTag:i];
    }
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //获取今天是第几个月
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM"];
    NSString * locationString =[dateformatter stringFromDate:senddate];
    [self clickButton:(UIButton *)[self.buttonArray objectAtIndex:locationString.intValue - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self setButtonStatusWithOffsetX:self.contentOffset.x];
    }
}

/*
 更改button的效果请修改这个方法
 */
-(void)initButtonsWithTag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake((tag + 1)*self.buttonWidth, 0, self.buttonWidth, self.frame.size.height);
    button.tag = tag;
    
    [button setTitle:[self.titlesArray objectAtIndex:tag] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithWhite:self.gsv_selected alpha:1] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonArray addObject:button];
    
    [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(self.scale_min, self.scale_min);
    
    CGPoint center = button.center;
    center.x = (button.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;
    button.center = center;
    
    [self addSubview:button];
}

-(void)clickButton:(UIButton *)button
{
    CGFloat left = ((button.tag)*self.buttonWidth);
    [self setContentOffset:CGPointMake(left, 0) animated:YES];
    if (_titlesdelegate && [_titlesdelegate respondsToSelector:@selector(scrollMonthShouldScollByTitleScollview:)]) {
        [_titlesdelegate scrollMonthShouldScollByTitleScollview:button.tag + 1];
    }
}

//核心内容
-(void)setButtonStatusWithOffsetX:(CGFloat)offsetX
{
    if (offsetX < 0) {
        return;
    }
    
    if (offsetX > (self.contentSize.width - self.buttonWidth)) {
        return;
    }
    
    int tempTag = (offsetX/self.buttonWidth);
    
    if (tempTag > self.titlesArray.count - 2) {
        return;
    }
    
    for (UIButton *button in self.buttonArray) {
//        [button setTitleColor:[UIColor colorWithWhite:self.gsv_default alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.transform = CGAffineTransformMakeScale(self.scale_min, self.scale_min);
        
        CGPoint center = button.center;
        center.x = (button.tag+1)*self.buttonWidth + self.buttonWidth/2.0f;
        button.center = center;
    }
    
    UIButton *buttonleft    = [self.buttonArray objectAtIndex:tempTag];
    UIButton *buttonRight   = [self.buttonArray objectAtIndex:(tempTag+1)];
    
    float leftcolorValue = self.gsv_selected - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.gsv_selected - self.gsv_default);
    float leftScale      = self.scale_max - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);

    [buttonleft setTitleColor:[UIColor colorWithWhite:(leftcolorValue) alpha:1] forState:UIControlStateNormal];
    [buttonleft setTitleColor:kgreenColor forState:UIControlStateNormal];
    buttonleft.transform = CGAffineTransformMakeScale(leftScale, leftScale);
    
    float rightcolorValue = self.gsv_default + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth;
    float rightScale      = self.scale_min + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);
    
    [buttonRight setTitleColor:[UIColor colorWithWhite:(rightcolorValue) alpha:1] forState:UIControlStateNormal];
    [buttonRight setTitleColor:kgreenColor forState:UIControlStateNormal];
    buttonRight.transform = CGAffineTransformMakeScale(rightScale, rightScale);
}
- (void)didScollContentOffsetX:(CGFloat)offsetX andPageSizeX:(CGFloat)pagesizex;
{
    [self setContentOffset:CGPointMake((offsetX/pagesizex)*self.buttonWidth, 0)];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float temp = round(scrollView.contentOffset.x/self.buttonWidth);
//    if ((temp >= 0) &&_titlesdelegate && [_titlesdelegate respondsToSelector:@selector(scrollMonthShouldScollByTitleScollview:)]) {
//        [_titlesdelegate scrollMonthShouldScollByTitleScollview:temp + 1];
//    }
    int tempInt = (int)temp;
    UIButton * button = [self viewWithTag:tempInt];
    [self clickButton:button];
}

-(void)dealloc
{
    self.titlesdelegate = nil;
    self.delegate = nil;
    [self removeObserver:self forKeyPath:@"contentOffset"];
}
//设置那个月
/** 本月 */
- (void)setMonth:(NSUInteger)month {
    _month = month;
    [self clickButton:(UIButton *)[self.buttonArray objectAtIndex:month - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
    
}
/** 上月 */
- (void)setLastMonth:(NSUInteger)lastMonth {
    _lastMonth = lastMonth;
    [self clickButton:(UIButton *)[self.buttonArray objectAtIndex:lastMonth - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];

}
/** 下月 */
- (void)setNextMonth:(NSUInteger)nextMonth {
    _nextMonth = nextMonth;
    [self clickButton:(UIButton *)[self.buttonArray objectAtIndex:nextMonth - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];

}
@end
