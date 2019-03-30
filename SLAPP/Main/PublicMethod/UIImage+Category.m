//
//  UIImage+Category.m
//  SLAPP
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

/**
  *  用颜色返回一张图片
  */
+ (UIImage *)createImageWithColor:(UIColor *)color {
      CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
      UIGraphicsBeginImageContext(rect.size);
      CGContextRef context = UIGraphicsGetCurrentContext();
      CGContextSetFillColorWithColor(context, [color CGColor]);
      CGContextFillRect(context, rect);
      UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      return theImage;
}


@end
