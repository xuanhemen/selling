//
//  HYContactNewCell.m
//  SLAPP
//
//  Created by yons on 2018/10/26.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYContactNewCell.h"
#import "SLAPP-Swift.h"
@implementation HYContactNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.redView.layer.cornerRadius = 4;
    self.redView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cellPhoneButtonClick:(id)sender {
    NSString *phoneNum = [self.dict[@"phone"] toString];
    
    if (!phoneNum.isNotEmpty){
        [PublicMethod toastWithText:@"电话号码不能为空" andDruation:1];
        return;
    }else{
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

@end
