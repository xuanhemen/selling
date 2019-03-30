//
//  LeftCell.h
//  拜访罗盘
//
//  Created by harry on 16/5/20.
//  Copyright © 2016年 xslp.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitFitterModel.h"
@interface LeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftlable;
@property(nonatomic,strong)HYVisitFitterModel *model;
@end
