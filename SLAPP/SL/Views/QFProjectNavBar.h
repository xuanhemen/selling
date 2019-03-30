//
//  QFProjectNavBar.h
//  SLAPP
//
//  Created by qwp on 2018/8/3.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddButtonBlock)(void);
typedef void(^SearchButtonBlock)(void);
typedef void(^ChangeViewBlock)(BOOL isList);

@interface QFProjectNavBar : UIView

@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) UIButton *searchButton;
@property (nonatomic,strong) UIView *changeView;
@property (nonatomic,strong) UILabel *listLabel;
@property (nonatomic,strong) UILabel *statisticalLabel;

@property (nonatomic,copy) AddButtonBlock addButtonBlock;
@property (nonatomic,copy) SearchButtonBlock searchButtonBlock;
@property (nonatomic,copy) ChangeViewBlock changeViewBlock;

//返回按钮点击
@property (nonatomic,copy) void(^backBtnClick)(void);
//添加返回按钮
-(void)addBack;

- (void)uiConfig;
- (void)configOnlyTitle:(NSString *)title andHaveRight:(BOOL)isHave;
@end
