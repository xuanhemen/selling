//
//  QFPopupView.h
//  SLAPP
//
//  Created by qwp on 2018/8/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QFPopupView;
@protocol QFPopupViewDelegate <NSObject>
@optional
- (void)qf_sortButtonClick;
- (void)qf_sortButtonClick:(QFPopupView *)pop;
- (void)qf_segButtonClick;
- (void)qf_segButtonClick:(QFPopupView *)pop;

- (void)qf_carryButtonClick:(QFPopupView *)pop;
@end

@interface QFPopupView : UIView

@property (nonatomic,assign) id<QFPopupViewDelegate>delegate;
@property (nonatomic,strong) UIView *sortView;
@property (nonatomic,strong)UIView *segmentView ;
@property (nonatomic,strong) UILabel *sortLabel;
@property (nonatomic,strong) UILabel *segLabel;
@property (nonatomic,strong) UIImageView *sortDownImageView;


@property (nonatomic,assign)BOOL isCarryDown;
@property (nonatomic,strong)UIView *carryDownView;
@property (nonatomic,strong) UILabel *carryLabel;
- (void)configUI;
@end

