//
//  QFAnalysisHistoryCell.m
//  SLAPP
//
//  Created by qwp on 2018/8/1.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFAnalysisHistoryCell.h"

@implementation QFAnalysisHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numLabel.layer.cornerRadius = 12;
    self.numLabel.clipsToBounds = YES;
    
    [self.checkView configDefaultCheckView];
    __weak QFAnalysisHistoryCell *weakSelf = self;
    self.checkView.checkBlock = ^(BOOL isCheck,QFCheckView *sender) {
        if (isCheck) {
            NSLog(@"选中");
            if (weakSelf.checkAction) {
                weakSelf.checkAction(weakSelf.indexPathRow, YES);
            }
        }else{
            NSLog(@"取消选中");
            if (weakSelf.checkAction) {
                weakSelf.checkAction(weakSelf.indexPathRow, NO);
            }
        }
    };
}
- (IBAction)cellButtonClick:(id)sender {
    if (self.action) {
        self.action(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellSelectStatus:(BOOL)isCheck{
    if (isCheck) {
        self.backViewX.constant = 15+30;
    }else{
        self.backViewX.constant = 15;
    }
    
    
}
@end
