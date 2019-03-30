//
//  TimeLineSpecailView.h
//  SLAPP
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTimeLineCellModel.h"
#import "CustomLable.h"
@interface TimeLineSpecailView : UIView
@property(nonatomic,strong)SDTimeLineCellModel *model;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *titleLabValue;
@property(nonatomic,strong)UILabel *middleName;
@property(nonatomic,strong)UILabel *middleValue;
@property(nonatomic,strong)UILabel *bottomName;
@property(nonatomic,strong)UILabel *bottomVaule;
@property(nonatomic,strong)CustomLable *contentlable;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIButton  *btn;
@property(nonatomic,copy)void (^clickSpecailView)(NSString *type,NSDictionary *value);
@end
