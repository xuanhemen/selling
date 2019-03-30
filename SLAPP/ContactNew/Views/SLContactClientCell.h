//
//  SLContactClientCell.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLContactClientModel.h"
@interface SLContactClientCell : UITableViewCell

/** 客户 */
@property(nonatomic,strong)UILabel * client;
/** 职位 */
@property(nonatomic,strong)UILabel * position;
/** 部门 */
@property(nonatomic,strong)UILabel * dep;

-(void)setCellWithModel:(SLContactClientModel *)model;
@end
