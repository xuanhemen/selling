//
//  CLVisitInputView.h
//  CLAppWithSwift
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import <Masonry/Masonry.h>
#import "UITextView+Category.h"
#define kInputSpace 10
#define kInputViewHeight 100
@interface CLVisitInputView : UIView <UITextViewDelegate>
@property(nonatomic,strong)UILabel *labVisitRole;
@property(nonatomic,strong)UILabel *labContent;
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)UITextView *inputText1;
@property(nonatomic,strong)UIScrollView *backView;

/**
 输入内容有变动
 */
@property(nonatomic,copy)void (^textDidChange)();

- (void)configUI;

-(void)refreshSizeWithTextView:(UITextView *)textView;
@end
