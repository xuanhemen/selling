//
//  QFAnalysisHistoryCell.h
//  SLAPP
//
//  Created by qwp on 2018/8/1.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFCheckView.h"

@class QFAnalysisHistoryCell;
typedef void(^CellButtonAction)(QFAnalysisHistoryCell *sender);
typedef void(^CellCheckAction)(NSInteger index,BOOL isCheck);

@interface QFAnalysisHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewX;
@property (weak, nonatomic) IBOutlet QFCheckView *checkView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (assign, nonatomic) NSInteger indexPathRow;
@property (copy, nonatomic) CellCheckAction checkAction;
@property (copy, nonatomic) CellButtonAction action;


- (void)cellSelectStatus:(BOOL)isCheck;

@end
