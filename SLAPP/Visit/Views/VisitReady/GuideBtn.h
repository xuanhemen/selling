//
//  GuideBtn.h
//  CLApp
//
//  Created by 吕海瑞 on 16/8/22.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideBtn : UIButton
-(void)configWithTag:(NSInteger )markTag;
@property(nonatomic)NSInteger markTag;
@property(nonatomic,strong)UILabel *remindLable;
@property(nonatomic)BOOL isClicked;
@end
