//
//  HYCarryDownView.h
//  SLAPP
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCarryDownView : UIView
@property(nonatomic,strong)UILabel *des;
@property(nonatomic,strong)UIButton *carrydownBtn;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,copy)void (^carryDownClick)(void);
@end
