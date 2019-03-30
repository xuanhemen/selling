// $_FILEHEADER_BEGIN ***************************
// 版权声明:Timer
// Copyright © 2012 - Timer All Rights Reserved
// 文件名称: UIView+NIB.m
// 创建日期: 15/7/31
// 创 建 人: 甄鑫
// 文件说明: UIView 关于nib的 类别
// $_FILEHEADER_END ******************************


#import "UIView+NIB.h"

@implementation UIView (UIView_NIB)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (id)loadNib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (NSString *)getClassName
{
    return NSStringFromClass([self class]);
}

+ (id)loadBundleNib
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]firstObject];
}

+ (id)loadBundleNibWithOwner:(id)owner
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil];
}

+ (NSArray *)getBundleNibArray
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
}

@end
