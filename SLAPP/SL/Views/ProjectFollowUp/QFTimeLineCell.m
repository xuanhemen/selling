//
//  QFTimeLineCell.m
//  SLAPP
//
//  Created by qwp on 2018/7/19.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "QFTimeLineCell.h"
#import "ChatKeyBoardMacroDefine.h"
@interface QFTimeLineCell()<TTTAttributedLabelDelegate>



@end

@implementation QFTimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)addSuperWithUserName:(NSString *)userName andProjectName:(NSString *)projectName{
    NSMutableAttributedString *tempPname = [[NSMutableAttributedString alloc] init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.tailIndent = 0;
    paragraphStyle.headIndent = 0;
    [tempPname appendAttributedString:[[NSAttributedString alloc] initWithString:self.peopleLable.text attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:12]}]];

    
    
    

    if (projectName != nil&&![projectName isEqualToString:@""]) {
        NSRange proRange = [self.peopleLable.text rangeOfString:@"项目名称："];
        [self.peopleLable addLinkToURL:[NSURL URLWithString:@"http://www.xiangmu.com"] withRange:NSMakeRange(proRange.location+proRange.length,projectName.length)];
        [tempPname addAttribute:NSForegroundColorAttributeName value:kgreenColor range:NSMakeRange(proRange.location+proRange.length,projectName.length)];
    }
    if (userName != nil&&![userName isEqualToString:@""]) {
        NSRange proRange = [self.peopleLable.text rangeOfString:@"客户名称："];
        [self.peopleLable addLinkToURL:[NSURL URLWithString:@"http://www.kehu.com"] withRange:NSMakeRange(proRange.location+proRange.length,userName.length)];
        [tempPname addAttribute:NSForegroundColorAttributeName value:kgreenColor range:NSMakeRange(proRange.location+proRange.length,userName.length)];
    }
    self.peopleLable.attributedText = tempPname;
    self.peopleLable.delegate = self;
    self.peopleLable.linkAttributes = @{NSForegroundColorAttributeName:kgreenColor ,NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:12]};
    [self.peopleLable sizeToFit];
    
    
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{
    if ([url.relativeString isEqualToString:@"http://www.kehu.com"]) {
        [self.delegate didClickUserWithModel:self.model];
    }
    if ([url.relativeString isEqualToString:@"http://www.xiangmu.com"]) {
        [self.delegate didClickProjectWithModel:self.model];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
