//
//  VisitReportCellBottomView.m
//  CLApp
//
//  Created by rms on 17/3/29.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "VisitReportCellBottomView.h"

@implementation VisitReportCellBottomView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.shareBtn setTitleColor:HexColor(@"57b9f0") forState:UIControlStateNormal];
    [self.downloadBtn setTitleColor:HexColor(@"56bb65") forState:UIControlStateNormal];
    [self.delectBtn setTitleColor:HexColor(@"fb9d5f") forState:UIControlStateNormal];
    self.shareBtn.tag = 1000;
    self.downloadBtn.tag = 1001;
    self.delectBtn.tag = 1002;
    
}

@end
