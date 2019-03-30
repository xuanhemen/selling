//
//  QFContrastVC.h
//  SLAPP
//
//  Created by qwp on 2018/8/28.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectSituationModel;
@interface QFContrastVC : UIViewController
@property (nonatomic,strong)NSDictionary *baseDict;
@property (nonatomic,strong)NSArray *baseSelectArray;
@property (nonatomic,strong)ProjectSituationModel *model;
@end
