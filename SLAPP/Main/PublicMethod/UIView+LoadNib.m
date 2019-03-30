//
//  UIView+LoadNib.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "UIView+LoadNib.h"

@implementation UIView (LoadNib)
+ (id)loadBundleNib
{
    
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
}
@end
