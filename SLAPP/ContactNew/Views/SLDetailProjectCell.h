//
//  SLDetailProjectCell.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLProjectModel.h"
@interface SLDetailProjectCell : UITableViewCell

/** title */
@property(nonatomic,strong)UILabel * name;
/** time */
@property(nonatomic,strong)UILabel * time;
/** money */
@property(nonatomic,strong)UILabel * money;

-(void)setCellWithModel:(SLProjectModel *)model;
@end

@interface SLDetailDeleteCell : UITableViewCell

/** <#annotation#> */
@property(nonatomic,strong)UIButton * deleteBtn;
/** title */
@property(nonatomic,strong)UILabel * name;
/** time */
@property(nonatomic,strong)UILabel * time;
/** money */
@property(nonatomic,strong)UILabel * money;

-(void)setCellWithModel:(SLProjectModel *)model;
@end
