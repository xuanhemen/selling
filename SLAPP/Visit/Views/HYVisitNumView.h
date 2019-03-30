//
//  HYVisitNumView.h
//  SLAPP
//
//  Created by apple on 2018/10/31.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYVisitNumView : UIView
@property(nonatomic,strong)UIButton *left;
@property(nonatomic,strong)UIButton *middle;
@property(nonatomic,strong)UIButton *right;
@property(nonatomic,strong)UIView * statusView;
@property(nonatomic,strong)UIButton *temp;

@property(nonatomic,assign)BOOL isVisitHome;

/**
 状态按钮点击后刷新数据
 */
@property(nonatomic,copy)void (^statusClick)(NSString *key);

-(void)refreshWithResult:(NSDictionary *)result;
//返回当前的状态key
-(NSString *)currentStatusKey;
@end
