//
//  SDTimeLineCell.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "SDTimeLineCellModel.h"
@protocol SDTimeLineCellDelegate <NSObject>

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell;
- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell;

- (void)didClickCommentWithModel:(SDTimeLineCellCommentItemModel *)model cell:(UITableViewCell *)cell;

//@property (nonatomic, copy) void (^didClickCommentWithModel)(SDTimeLineCellCommentItemModel *model,UITableViewCell *myCell);

//新增项目点击  客户点击
- (void)didClickProjectWithModel:(SDTimeLineCellModel *)model;
- (void)didClickUserWithModel:(SDTimeLineCellModel *)model;

@end

@class SDTimeLineCellCommentItemModel;
@interface SDTimeLineCell : UITableViewCell

@property (nonatomic, weak) id<SDTimeLineCellDelegate> delegate;

@property (nonatomic, strong) SDTimeLineCellModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic,copy)void (^clickSpecailView)(NSString *type,NSDictionary *value);
@property (nonatomic, copy) void (^editButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^deleteButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^imageFinish)(NSIndexPath *indexPath);
@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow, NSIndexPath *indexPath);


//点击了某个人
@property (nonatomic, copy) void (^didClickPerson)(NSString *userid);

@property (nonatomic, strong)TTTAttributedLabel *peopleLable;

@property (nonatomic,assign)BOOL isOnlyShow;


@property(nonatomic,copy)void (^longPregress)(UIView *lw);
@end
