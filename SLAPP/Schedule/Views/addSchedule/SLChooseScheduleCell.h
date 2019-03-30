//
//  SLChooseScheduleCell.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLScheduleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLChooseScheduleCell : UITableViewCell

/** 选择标识 */
@property(nonatomic,strong)UIButton * chooseBtn;
/** company */
@property(nonatomic,strong)UILabel * company;
/** address */
@property(nonatomic,strong)UILabel * address;
/** 负责人 */
@property(nonatomic,strong)UILabel * response;

-(void)setCellWithModel:(SLScheduleModel *)model;

@end

NS_ASSUME_NONNULL_END
