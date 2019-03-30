//
//  HYCarryDownHeadView.h
//  SLAPP
//
//  Created by fank on 2019/1/3.
//  Copyright © 2019年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYProjectGroupModel;

@protocol HYCarryDownHeadViewDelegate <NSObject>
- (void)arrowButtonClick:(NSInteger)section isShow:(NSString *)value;
@end

@interface HYCarryDownHeadView : UIView

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) HYProjectGroupModel *group;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (nonatomic,assign) id<HYCarryDownHeadViewDelegate> delegate;

@end
