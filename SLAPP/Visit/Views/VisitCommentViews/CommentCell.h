//
//  MessageCell.h
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGGView.h"
#import "ReplyCell.h"
#import "HYCommentModel.h"
#import "HYReplyModel.h"
@class CommentCell;

@protocol CommentCellDelegate <NSObject>

- (void)passCellHeightWithCommentModel:(HYCommentModel *)commentModel replyModel:(HYReplyModel *)replyModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight replyCell:(ReplyCell *)replyCell commentCell:(CommentCell *)commentCell;
@end



@interface CommentCell : UITableViewCell

@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) JGGView *jggView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *replyDetailBtn;

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
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(NSIndexPath * indexPath);

/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;

@property (nonatomic, weak) id<CommentCellDelegate> delegate;

- (void)configCellWithModel:(HYCommentModel *)model indexPath:(NSIndexPath *)indexPath;

@end
