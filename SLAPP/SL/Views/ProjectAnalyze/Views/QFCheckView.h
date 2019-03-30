//
//  QFCheckView.h
//  SLAPP
//
//  Created by qwp on 2018/8/1.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface QFCheckView : UIView

typedef void(^QFCheckBlock)(BOOL isCheck,QFCheckView *sender);

@property (nonatomic,copy)QFCheckBlock checkBlock;
- (void)configDefaultCheckView;
@property (nonatomic,assign)BOOL isCheck;
- (void)check;
@end
