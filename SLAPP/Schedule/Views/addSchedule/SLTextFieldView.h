//
//  SLTextFieldView.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/28.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTextFieldView : UIView<UITextViewDelegate>

/** textView */
@property(nonatomic,strong)UITextView * textView;
/**占位符*/
@property(nonatomic,strong)UILabel * placeHoder;
/**title*/
@property(nonatomic,strong)UILabel * title;

@property(nonatomic,copy)void(^passContent)(NSString *contentStr);

-(void)seterSelfHeight;

@end

NS_ASSUME_NONNULL_END
