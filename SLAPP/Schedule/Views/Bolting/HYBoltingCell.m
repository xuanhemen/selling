//
//  HYBoltingCell.m
//  SLAPP
//
//  Created by apple on 2019/1/30.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYBoltingCell.h"

@implementation HYBoltingCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _content = [[UILabel alloc] init];
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        _content.textAlignment = NSTextAlignmentCenter;
        _content.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _content.layer.cornerRadius = 15;
        _content.clipsToBounds = YES;
        _content.font = [UIFont systemFontOfSize:13];
        _content.textColor = [UIColor darkTextColor];
    }
    return self;
}


-(void)selectWithStatus:(BOOL)status{
    
    if (status) {
        _content.textColor = kgreenColor;
        _content.layer.borderColor = kgreenColor.CGColor;
        _content.layer.borderWidth = 0.5;
    }else{
        _content.textColor = [UIColor darkTextColor];
        _content.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _content.layer.borderWidth = 0.5;
    }
}

@end
