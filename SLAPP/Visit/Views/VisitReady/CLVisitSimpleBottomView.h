//
//  CLVisitSimpleBottomView.h
//  CLAppWithSwift
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLVisitSimpleBottomView;
@protocol CLVisitSimpleBottomViewDelegate <NSObject>;

@optional
-(BOOL)bottomClickWithView:(CLVisitSimpleBottomView *)bottomView Tag:(NSInteger)tag;

@end

@interface CLVisitSimpleBottomView : UIView

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIButton *finishBtn;
@property(nonatomic,assign)id <CLVisitSimpleBottomViewDelegate> delegate;

@end
