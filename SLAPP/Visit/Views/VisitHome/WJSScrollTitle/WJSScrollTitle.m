//
//  TitleScrollView.m
//  TitlesInScrollView
//
//  Created by Peter Kong on 15/6/29.
//  Copyright (c) 2015年 CrazyPeter. All rights reserved.
//

#import "WJSScrollTitle.h"

@interface WJSScrollTitle ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;

@end

@implementation WJSScrollTitle

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate     = self;
        self.buttonArray  = [NSMutableArray array];
        self.titlesArray  = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
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
        self.backgroundColor = [UIColor clearColor];
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
    
    //初次设定button，默认第一个按钮为选中状态
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger curentWeek = [comps weekOfYear];
//    NSLog(@"curentWeek%zd",curentWeek);

    [self clickButton:[self.buttonArray objectAtIndex:curentWeek-1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
    
    //DLog(@"contentOffset.x:%f",self.contentOffset.x)
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self setButtonStatusWithOffsetX:self.contentOffset.x];
    }
}
#pragma mark - 点击本周,下周,和上周 监听事件
/** 上周 */
- (void)setLastWeek:(NSUInteger)lastWeek {
    _lastWeek = lastWeek;
    [self clickButton:[self.buttonArray objectAtIndex:lastWeek - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
}
/** 本周 */
- (void)setWeek:(NSUInteger)week {
    _week = week;
    [self clickButton:[self.buttonArray objectAtIndex:week - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
}
/** 下周 */
- (void)setNextWeek:(NSUInteger)nextWeek {
    _nextWeek = nextWeek;
    [self clickButton:[self.buttonArray objectAtIndex:nextWeek - 1]];
    [self setButtonStatusWithOffsetX:self.contentOffset.x];
}
/*
 更改button的效果请修改这个方法
 */
-(void)initButtonsWithTag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((tag)*self.buttonWidth, 0, self.buttonWidth, self.frame.size.height);
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
    
    
    if (_titlesdelegate && [_titlesdelegate respondsToSelector:@selector(scrollviewShouldScollByTitleScollview:)]) {
        [_titlesdelegate scrollviewShouldScollByTitleScollview:button.tag + 1];
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
        center.x = (button.tag+3)*self.buttonWidth + self.buttonWidth/2.0f;
        button.center = center;
    }
    
    float leftcolorValue = self.gsv_selected - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.gsv_selected - self.gsv_default);
    float leftScale      = self.scale_max - fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);
    
    float rightcolorValue = self.gsv_default + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth;
    float rightScale      = self.scale_min + fmod((double)offsetX,self.buttonWidth)/self.buttonWidth*(self.scale_max - self.scale_min);
    

    
    UIButton *buttonleft = [self.buttonArray objectAtIndex:tempTag];
    UIButton *buttonRight = [self.buttonArray objectAtIndex:(tempTag+1)];
    UIButton *tempBtn;
    if (tempTag != 52) {
        tempBtn = [self.buttonArray objectAtIndex:tempTag+2];
    }else{
        tempBtn = nil;
    }
    
    if(leftScale>rightScale){
        buttonleft = [self.buttonArray objectAtIndex:tempTag];
        buttonRight = [self.buttonArray objectAtIndex:(tempTag+1)];
        if (tempTag != 0) {
            tempBtn = [self.buttonArray objectAtIndex:tempTag-1];
        }else{
            tempBtn = nil;
        }
    }
    
    
    [tempBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    

    
    [buttonleft setTitleColor:[UIColor colorWithWhite:(leftcolorValue) alpha:1] forState:UIControlStateNormal];
    [buttonleft setTitleColor:kgreenColor forState:UIControlStateNormal];
    buttonleft.transform = CGAffineTransformMakeScale(leftScale, leftScale);
    
    
    
    [buttonRight setTitleColor:[UIColor colorWithWhite:(rightcolorValue) alpha:1] forState:UIControlStateNormal];
    [buttonRight setTitleColor:kBlueColor forState:UIControlStateNormal];
    buttonRight.transform = CGAffineTransformMakeScale(rightScale, rightScale);
    
    if(leftScale<rightScale){
        [buttonRight setTitleColor:kgreenColor forState:UIControlStateNormal];
        [buttonleft setTitleColor:kBlueColor forState:UIControlStateNormal];
    }
}

- (void)didScollContentOffsetX:(CGFloat)offsetX andPageSizeX:(CGFloat)pagesizex;
{
    [self setContentOffset:CGPointMake((offsetX/pagesizex)*self.buttonWidth, 0)];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float temp = round(scrollView.contentOffset.x/self.buttonWidth);
//    if ((temp >= 0) &&_titlesdelegate && [_titlesdelegate respondsToSelector:@selector(scrollviewShouldScollByTitleScollview:)]) {
//        [_titlesdelegate scrollviewShouldScollByTitleScollview:temp];
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
@end
