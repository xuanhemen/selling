//
//  SLRepeatInfoCell.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "SLRepeatInfoModel.h"

/*************************能合并的cell**************************************/
@interface SLRepeatInfoCell : UITableViewCell

/** 联系人姓名 */
@property(nonatomic,strong)UILabel * name;
/** 联系人的客户 */
@property(nonatomic,strong)UILabel * customer;
/** 联系人电话 */
@property(nonatomic,strong)UILabel * phone;
/** 合并联系人 */
@property(nonatomic,strong)UIButton * mergeBtn;

-(void)setCellWithModel:(SLRepeatInfoModel *) model;

@end
/*************************不能合并的cell**************************************/
@interface SLRepeatCell : UITableViewCell

/** 联系人姓名 */
@property(nonatomic,strong)UILabel * name;
/** 联系人的客户 */
@property(nonatomic,strong)UILabel * customer;
/** 联系人电话 */
@property(nonatomic,strong)UILabel * phone;

-(void)setCellWithModel:(SLRepeatInfoModel *) model;
@end


/*************************弹出视图的cell**************************************/
@interface SLChooseCell : UITableViewCell

/** title */
@property(nonatomic,strong)UILabel * title;
/** 选项一文字 */
@property(nonatomic,strong)UILabel * firName;
/** 选项二文字 */
@property(nonatomic,strong)UILabel * secName;
/** 选项一按钮 */
@property(nonatomic,strong)UIButton * firBtn;
/** 选项二按钮 */
@property(nonatomic,strong)UIButton * secBtn;

@end

