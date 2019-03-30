//
//  CommentBottomView.h
//  CLApp
//
//  Created by rms on 16/12/29.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)();
@interface CommentBottomView : UIView
@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,strong) UIButton *detailBtn;
@property(nonatomic,assign) NSUInteger commentNum;
@property(nonatomic,copy) BtnClickBlock commentBtnClickBlock;
@property(nonatomic,copy) BtnClickBlock detailBtnClickBlock;
@end
