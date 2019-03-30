//
//  HYVisitDetailSectionHeaderView.h
//  SLAPP
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYVisitDetailSectionHeaderView : UIView
@property(nonatomic,strong)UIImageView *img_icon;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)UIButton *upDownBtn;

@property(nonatomic,copy)void (^upDownBtnClick)(NSString * str);
@property(nonatomic,copy)void (^editBtnClick)();
@end
