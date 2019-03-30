//
//  HYSelectCompanyVC.h
//  SLAPP
//
//  Created by yons on 2018/9/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HYSelectCompanyBlock)(NSString *companyName);
@interface HYSelectCompanyVC : UIViewController<UISearchBarDelegate,UIScrollViewDelegate>
@property (nonatomic,copy)HYSelectCompanyBlock selectBlock;

@end
