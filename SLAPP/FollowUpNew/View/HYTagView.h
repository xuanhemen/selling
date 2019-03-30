//
//  HYTagView.h
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TAGTYPE_SEE = 0,
    TAGTYPE_CONTACT,
    TAGTYPE_BUSINESS,
    TAGTYPE_SCHEME,
    TAGTYPE_CUSTOM,
    TAGTYPE_ADD
} HYTAGTYPE;

@class HYTagView;
@protocol HYTagViewDelegate<NSObject>

- (void)addTagView:(HYTagView *)tagView;
- (void)tagViewEditSelect:(HYTagView *)tagView;
- (void)tagViewSelect:(HYTagView *)tagView;
@end

@interface HYTagView : UIView
@property (nonatomic,strong)UIImageView *editImageView;
@property (nonatomic,assign)HYTAGTYPE currentType;
@property (nonatomic,assign)id<HYTagViewDelegate> delegate;

- (void)configTitle:(NSString *)title andType:(HYTAGTYPE)type andIsEdit:(BOOL)isEdit;
- (void)select:(BOOL)select;

@end
