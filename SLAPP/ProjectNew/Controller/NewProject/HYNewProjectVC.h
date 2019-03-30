//
//  HYNewProjectVC.h
//  SLAPP
//
//  Created by yons on 2018/10/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNewProjectTopView.h"
#import "HYClientModel.h"

@protocol Jump <NSObject>

@optional
-(void)jumpCancelVC;

@end

@interface HYNewProjectVC : UIViewController

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) CGFloat scrollHeight;


@property (nonatomic,strong) HYNewProjectTopView *baseInfoView;
@property (nonatomic,strong) HYClientModel  *clientModel;

/** <#annotation#> */
@property(nonatomic,weak)id<Jump> delegate;


- (void)cancleBtnClick;
- (void)saveBtnClick;

@end
