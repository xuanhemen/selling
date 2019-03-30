//
//  TopGuideView.h
//  CLApp
//
//  Created by 吕海瑞 on 16/8/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopGuideView;
@protocol TopGuideViewDelegate <NSObject>

-(void)topGuideView:(TopGuideView *)topGuideView BtnClick:(UIButton *)btn;
@end

@interface TopGuideView : UIView
@property(nonatomic,assign)id <TopGuideViewDelegate> delegate;
@property(nonatomic)NSInteger historyTag;
@property(nonatomic)NSInteger currentTag;
-(void)configUI;
-(void)configWith:(NSInteger)historyTag;
-(void)changeBtnWithPage:(NSInteger)page;
-(NSInteger)currentPageTag;
@end
