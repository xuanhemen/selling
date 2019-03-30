//
//  PicView.h
//  CLApp
//
//  Created by rms on 17/1/5.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicView : UIScrollView
@property(nonatomic,strong)NSArray *picsArr;
@property (nonatomic, copy)void(^deleteBtnClickBlock)(UIButton *button);

@end
