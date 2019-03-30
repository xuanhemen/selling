//
//  ReplyCell.m
//  WeChat
//
//  Created by zhengwenming on 16/6/4.
//  Copyright © 2016年 zhengwenming. All rights reserved.
//
#import "NSString+AttributedString.h"
#import "ReplyCell.h"
#import "JGGView.h"
//#import "CommentCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#define kContentColor HexColor(@"333333")
@implementation ReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        kWeakS(weakSelf);
        // contentLabel
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.backgroundColor  = [UIColor clearColor];
        self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - kGAP-kAvatar_Size - 2*kGAP;

        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = kFont(15);
        self.contentLabel.textColor = kContentColor;
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(weakSelf.contentView);
            make.top.mas_equalTo(weakSelf.contentView).offset(3.0);//cell上部距离为3.0个间隙
//            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-3);
        }];
        
        self.hyb_lastViewInCell = self.contentLabel;
        self.hyb_bottomOffsetToCell = 3.0;//cell底部距离为3.0个间隙
    }
    
    return self;
}

- (void)configCellWithModel:(HYReplyModel *)model {
    NSString *str  = nil;
//    NSString *transString = [NSString stringWithString:[[model.content stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding]];
    NSString *transString = [NSString base64DecodeString:[model.code_content toString]];
   
//
    if ([model.replyrealname isNotEmpty]) {
        str= [NSString stringWithFormat:@"%@回复%@：%@",
              model.realname, @"asd", transString];
    }else{
        str= [NSString stringWithFormat:@"%@：%@",
              model.realname, transString];
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    [text addAttribute:NSForegroundColorAttributeName
                 value:kgreenColor
                 range:NSMakeRange(0, model.realname.length)];
    if ([model.replyrealname isNotEmpty]) {
        [text addAttribute:NSForegroundColorAttributeName
                     value:kgreenColor
                     range:NSMakeRange(model.realname.length + 2, model.replyrealname.length)];
    }
//    DLog(@"ssssssssssss===============%@",text);
    self.contentLabel.attributedText = text;
}

@end

