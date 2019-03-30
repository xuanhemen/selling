//
//  ReplyCell.h
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYReplyModel.h"

@interface ReplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;

- (void)configCellWithModel:(HYReplyModel *)model;

@end

