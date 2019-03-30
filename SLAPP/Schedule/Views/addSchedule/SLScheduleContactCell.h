//
//  SLScheduleContactCell.h
//  SLAPP
//
//  Created by 董建伟 on 2019/2/18.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLScheduleContactCell : UITableViewCell

/** btn */
@property(nonatomic,strong)UIButton * chooseBtn;
/** 名字 */
@property(nonatomic,strong)UILabel * name;
/** 职务 */
@property(nonatomic,strong)UILabel * position;
@end

NS_ASSUME_NONNULL_END
