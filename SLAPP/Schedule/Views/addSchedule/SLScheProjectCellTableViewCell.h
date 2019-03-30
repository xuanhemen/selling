//
//  SLScheProjectCellTableViewCell.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLScheProjectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLScheProjectCellTableViewCell : UITableViewCell

/** 选中按钮 */
@property(nonatomic,strong)UIButton * chooseBtn;
/** 项目名称 */
@property(nonatomic,strong)UILabel * projectName;
/** 公司 */
@property(nonatomic,strong)UILabel * company;
/** 钱 */
@property(nonatomic,strong)UILabel * money;
/** 时间 */
@property(nonatomic,strong)UILabel * time;

-(void)setCellWithModel:(SLScheProjectModel *)model;
@end

NS_ASSUME_NONNULL_END
