//
//  QFMaskView.h
//  SLAPP
//
//  Created by qwp on 2018/8/13.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QFMaskView;

@protocol QFMaskViewDelegate <NSObject>

- (void)qf_selectInView:(QFMaskView *)view;

@end

@interface QFMaskView : UIView

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isLeftTable;
@property (nonatomic,assign)id <QFMaskViewDelegate>delegate;
@property (nonatomic,strong)NSMutableArray *leftArray;
@property (nonatomic,strong)NSMutableArray *rightArray;
@property (nonatomic,assign)NSInteger leftSelectIndex;
@property (nonatomic,assign)NSInteger rightSelectIndex;
@property (nonatomic,assign)BOOL isLeftSelectDown;

//*************
//和结转有关
@property (nonatomic,assign)NSInteger carrySelectIndex;
@property(nonatomic,assign)NSInteger carryDownType;
@property (nonatomic,strong)UIButton *carryDown;
- (void)qf_showMaskViewWithHeight:(CGFloat)height andIsLeft:(BOOL)isLeft;

//和结转有关
- (void)qf_showMaskViewWithHeight:(CGFloat)height andTag:(NSInteger)isLeft;
-(void)configCarryDown;
//*************


- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type;

@end



