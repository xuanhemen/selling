//
//  SLRealContactCell.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/19.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLRealContactModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SLRealContactCell : UITableViewCell
/** 选中标识 */
@property(nonatomic,strong)UIButton * chooseBtn;
/** name */
@property(nonatomic,strong)UILabel * name;
/** 公司 */
@property(nonatomic,strong)UILabel * company;
/** 职务 */
@property(nonatomic,strong)UILabel * position;

-(void)setCellWithModel:(SLRealContactModel *)model;

@end

NS_ASSUME_NONNULL_END
