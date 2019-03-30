//
//  QFFunnelView.h
//  SLAPP
//
//  Created by qwp on 2018/8/9.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QFFunnelViewDelegate <NSObject>

- (void)qf_funnelViewDataChange;

@end

@interface QFFunnelView : UIView

@property (nonatomic,strong)NSArray *selectArray;

@property (nonatomic,strong)NSString *project_ids;
@property (nonatomic,strong)NSString *amount;
@property (nonatomic,strong)NSString *project_num;
@property (nonatomic,strong)NSString *down_payment;

@property (nonatomic,strong)NSString *rightAmount;
@property (nonatomic,strong)NSString *allString;
@property (nonatomic,strong)NSString *rightDown_payment;

@property (nonatomic,assign)id<QFFunnelViewDelegate>delegate;

- (void)funnelDataArray:(NSArray *)array;
@end
