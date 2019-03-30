// $_FILEHEADER_BEGIN ***************************
// 版权声明:Timer
// Copyright © 2012 - Timer All Rights Reserved
// 文件名称: UIView+NIB.h
// 创建日期: 15/7/31
// 创 建 人: 甄鑫
// 文件说明: UIView 关于nib的 类别
// $_FILEHEADER_END ******************************


#import <UIKit/UIKit.h>

#define kLoadBundleNibWithSelf [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

@interface UIView (UIView_NIB)

+ (id)loadNib;
+ (id)loadBundleNib;
+ (id)loadBundleNibWithOwner:(id)owner;
+ (NSArray *)getBundleNibArray;
+ (NSString *)getClassName;
@end
