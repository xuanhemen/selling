//
//  UIView+LoadNib.h
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadNib)

/**
 获取view 通过xib文件
 @return 返回对应类的对象
 */
+ (id)loadBundleNib;
@end
