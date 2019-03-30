//
//  QFMemberV.h
//  SLAPP
//
//  Created by yons on 2018/10/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    QF_Default = 0,
    QF_Add,
    QF_Minus,
} QFMemberType;

typedef void(^MemberAction)(QFMemberType type,NSString *idString);

@interface QFMemberV : UIView



@property (nonatomic,assign)QFMemberType currentType;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)NSString *idString;
@property (nonatomic,copy)MemberAction action;


- (CGFloat)configMinWidth:(CGFloat)minWidth;
- (void)configUIWithPoint:(CGPoint)point;
@end
