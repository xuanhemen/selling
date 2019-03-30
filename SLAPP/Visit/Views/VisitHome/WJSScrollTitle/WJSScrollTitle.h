//
//  WJSTitleView.m
//  WJSTtitle
//
//  Created by 王静帅 on 15/9/20.
//  Copyright © 2015年 rxb. All rights reserved.
//

/// Waring: 此demo已被修改成一个屏幕显示七个btn,且永远中间那个最大!

#import <UIKit/UIKit.h>


@protocol WJSScrollTitleDelegate <NSObject>

/**
 *  delegate function
 *
 *  @param Xpercent currentpageInTitleScrollview
 */
- (void)scrollviewShouldScollByTitleScollview:(NSInteger)page;

@end

@interface WJSScrollTitle : UIScrollView

/*
 *WARNING: if you want appear 3 buttons at the sametime,in the titlescrollview
 *         you should frame like this :
 *         buttonWidth*3 = titleScrollViewWidth
 */


/**
*  setupWithTitleArray
*
*  @param array titlesForShow
*/
/** 上周 */
@property(nonatomic, assign) NSUInteger lastWeek;
/** 本周 */
@property(nonatomic, assign) NSUInteger week;
/** 下周 */
@property(nonatomic, assign) NSUInteger nextWeek;

- (void)setupWithTitleArray:(NSArray *)array;

@property float buttonWidth;

/*
 *gsv -- gray scale values
*/

/**
 *  gsv_selected - buttonHighlightedColor
 *  gsv_default  - buttonNormalColor
 */
@property float gsv_selected;
@property float gsv_default;

/**
 *  scale_max    - button's Scale,highlighted
 *  scale_min    - button's Scale,normal
 */
@property float scale_max;
@property float scale_min;


/*
 *pagesizex：每页的width
 */
- (void)didScollContentOffsetX:(CGFloat)offsetX andPageSizeX:(CGFloat)pagesizex;

@property (assign, nonatomic) id<WJSScrollTitleDelegate>titlesdelegate;
@end
