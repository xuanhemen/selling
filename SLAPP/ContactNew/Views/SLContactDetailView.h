//
//  SLContactDetailView.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLContactDetailModel.h"
#import "SLProjectModel.h"
@interface SLContactDetailView : UIView

/** 联系人姓名 */
@property(nonatomic,strong)UILabel * name;
/** 联系人 */
@property(nonatomic,strong)UILabel * position;
/** 联系人部门 */
@property(nonatomic,strong)UILabel * department;
/** 负责 */
@property(nonatomic,strong)UILabel * responsible;
/** 名片 */
@property(nonatomic,strong)UIImageView * imageView;

-(void)setCellWithModel:(SLContactDetailModel *)model;

@end
@interface SLContactDetailHead : UIView

/** 联系人姓名 */
@property(nonatomic,strong)UILabel * title;

@end

/**联系人详情cell*/
@interface SLContactDetailCell : UITableViewCell

/** title */
@property(nonatomic,strong)UILabel * title;
/** content */
@property(nonatomic,strong)UILabel * content;

@end


@protocol clickButton
-(void)passBtnTag:(NSInteger)tag;
@end
/**联系人详情底部按钮视图*/
@interface SLContactBottomView : UIView

/**<#annotation>*/
@property (nonatomic,weak) id<clickButton> delegate;

@end




