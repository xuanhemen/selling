//
//  UITableView+Category.m
//  SLAPP
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)



/**
 table 无数据提醒

 @param refresh 点击刷新响应block
 */
- (void)addEmptyViewAndClickRefresh:(void (^)(void))refresh{
    [self addEmptyViewAndClickTitle:@"暂无数据" imageName:@"noDataRemind" detail:nil btnTitle:@"刷新试试" Refresh:refresh];
}




/**
 无数据提醒

 @param title 标题
 @param imageName 图片
 @param detail 详情
 @param btnTitle 刷新按钮名称
 @param refresh 刷新block
 */
- (void)addEmptyViewAndClickTitle:(NSString *)title imageName:(NSString *)imageName detail:(NSString *)detail btnTitle:(NSString *)btnTitle Refresh:(void (^)(void))refresh{
    
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:imageName titleStr:title detailStr:detail btnTitleStr:btnTitle btnClickBlock:^{
        refresh();
    }];
    emptyView.subViewMargin = 36;
    emptyView.titleLabFont = kFont(15);
    emptyView.titleLabTextColor = kgreenColor;
    emptyView.actionBtnFont = kFont(15);
    emptyView.actionBtnTitleColor = [UIColor whiteColor];
    emptyView.actionBtnHeight = 40;
    emptyView.actionBtnHorizontalMargin = 74;
    emptyView.actionBtnCornerRadius = 20;
    emptyView.actionBtnBackGroundColor = kgreenColor;
    self.ly_emptyView = emptyView;
}




/**
 添加无数据提醒  （不带响应）
 */
- (void)addEmptyViewWithNoAction{
    
    [self addEmptyViewWithNoActionTitle:@"暂无数据" imageName:@"noDataRemind" detail:nil];
}



/**
 添加无数据提醒  （不带响应）
 @param title 无数据提醒标题
 @param imageName 图片
 @param detail 详情
 */
- (void)addEmptyViewWithNoActionTitle:(NSString *)title imageName:(NSString *)imageName detail:(NSString *)detail{
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:imageName titleStr:title detailStr:detail];
    emptyView.subViewMargin = 36;
    emptyView.titleLabFont = kFont(15);
    emptyView.titleLabTextColor = kgreenColor;
    self.ly_emptyView = emptyView;
}


@end
