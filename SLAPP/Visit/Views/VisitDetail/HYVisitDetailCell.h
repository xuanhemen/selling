//
//  HYVisitDetailCell.h
//  SLAPP
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYVisitDetailModel.h"
@interface HYVisitDetailCell : UITableViewCell
@property(nonatomic,strong)UILabel *leftLab;
@property(nonatomic,strong)UILabel *content;
@property(nonatomic,strong)HYVisitDetailModel *model;
-(void)configUIWithModel;
-(void)configUI;
@end
