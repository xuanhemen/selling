//
//  PraiseCell.m
//  CLApp
//
//  Created by harry on 17/2/13.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "PraiseCell.h"

@implementation PraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.timeLable.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    self.timeLable.layer.cornerRadius = 6;
    self.timeLable.clipsToBounds = YES;
    [self.timeLable setText:@"2016-08-11"];
    [self.timeLable setFont:[UIFont systemFontOfSize:12.0f]];
    [self.timeLable setTextColor:[UIColor whiteColor]];
    
    [self.titleLable setTextColor:kgreenColor];
    
    
    self.backView.layer.cornerRadius = 8;
    self.backView.clipsToBounds = YES;
    
    self.redView = [[UIView alloc]initWithFrame:CGRectMake(1, 5, 5, 5)];
    [self.redView setBackgroundColor:[UIColor clearColor]];
    [self.backView addSubview:self.redView];
}

-(void)setModel:(RCMessage *)model{
    _model = model;
    if ([model.content isKindOfClass:[RCTextMessage class]]) {
        self.titleLable.text = ((RCTextMessage *)model.content).content;
    }
    self.desLable.text = @"详情";
    
    
//    [self.titleLable setText:model.subject];
//    //    if ([model.read_status isEqualToString:@"0"]) {
//    //        [self.textLabel showBadgeWithStyle:WBadgeStyleRedDot value:0 animationType:WBadgeAnimTypeBounce];
//    //    }
//    NSString *strTemp = [[_model.content stringByReplacingOccurrencesOfString:@"+" withString:@"%20"]stringByRemovingPercentEncoding];
//    if (strTemp.length > 50) {
//        strTemp = [strTemp substringToIndex:50];
//        strTemp = [strTemp stringByAppendingString:@"..."];
//    }
//    [self.desLable setText:strTemp];
////    [self.titleLable setText:model.stamp];
//    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
//
    NSTimeInterval time = model.sentTime/1000;
//    
    NSDate *tempDate = [NSDate dateWithTimeIntervalSince1970:time];
//    
    self.timeLable.text = time > 0 ? [format stringFromDate:tempDate] : @"";


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
