//
//  ReplyDetailCell.h
//  CLApp
//
//  Created by rms on 17/1/12.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "ReplyCell.h"
#import "HYCommentModel.h"
#import "CommentCell.h"
@class ReplyDetailCell;

@protocol ReplyDetailCellDelegate <NSObject>

- (void)passCellHeightWithCommentModel:(HYCommentModel *)commentModel replyModel:(HYReplyModel *)replyModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight replyCell:(ReplyCell *)replyCell commentCell:(CommentCell *)commentCell;
@end

@interface ReplyDetailCell : UITableViewCell

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) JGGView *jggView;
@property (nonatomic, strong) UILabel *descLabel;

/**
 *  回复按钮的block
 */
@property (nonatomic, copy)void(^ReplyBtnClickBlock)(UIButton *replyBtn,NSIndexPath * indexPath);
/**
 *  点赞按钮的block
 */
@property (nonatomic, copy)void(^LikeBtnClickBlock)(NSIndexPath * indexPath);

/**
 *  删除按钮的block
 */
@property (nonatomic, copy)void(^DeleteBtnClickBlock)(NSIndexPath * indexPath);

/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;

@property (nonatomic, weak) id<ReplyDetailCellDelegate> delegate;

- (void)configCellWithModel:(HYReplyModel *)model indexPath:(NSIndexPath *)indexPath;

@end
