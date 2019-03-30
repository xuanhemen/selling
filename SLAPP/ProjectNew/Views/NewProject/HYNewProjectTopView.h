//
//  HYNewProjectTopView.h
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYNewProjectTopView;
@protocol HYTopViewDelegate <NSObject>

- (void)hy_topViewTradeButtonClick:(HYNewProjectTopView *)topView;
- (void)hy_topViewClientButtonClick:(HYNewProjectTopView *)topView;
- (void)hy_topViewProductButtonClick:(HYNewProjectTopView *)topView;
- (void)hy_topViewDateButtonClick:(HYNewProjectTopView *)topView;


@end


@interface HYNewProjectTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *clientView;
@property (weak, nonatomic) IBOutlet UIView *tradeView;
@property (weak, nonatomic) IBOutlet UIView *projectView;
@property (weak, nonatomic) IBOutlet UIView *depView;

@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UIView *contractView;
@property (weak, nonatomic) IBOutlet UIView *performanceView;
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UITextField *clientField;
@property (weak, nonatomic) IBOutlet UIButton *clientButton;
@property (weak, nonatomic) IBOutlet UITextField *tradeField;
@property (weak, nonatomic) IBOutlet UIButton *tradeButton;
@property (weak, nonatomic) IBOutlet UITextField *projectField;
@property (weak, nonatomic) IBOutlet UITextField *depField;
@property (weak, nonatomic) IBOutlet UITextField *productField;
@property (weak, nonatomic) IBOutlet UIButton *productButton;
@property (weak, nonatomic) IBOutlet UITextField *contractField;
@property (weak, nonatomic) IBOutlet UIButton *contractButton;
@property (weak, nonatomic) IBOutlet UITextField *performanceField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;



@property (nonatomic,assign) id<HYTopViewDelegate>delegate;
@property (nonatomic,strong) NSString *clientID;
@property (nonatomic,strong) NSString *tradeID;

@end
