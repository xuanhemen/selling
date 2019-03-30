//
//  HYVisitChooseProjectVC.h
//  SLAPP
//
//  Created by apple on 2018/10/23.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitChooseProModel.h"
@interface HYVisitChooseProjectVC : UIViewController
@property(nonatomic,copy)void (^click)(HYVisitChooseProModel *pModel);
@end
