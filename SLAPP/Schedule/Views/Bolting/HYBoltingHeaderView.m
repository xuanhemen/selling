//
//  HYBoltingHeaderView.m
//  SLAPP
//
//  Created by apple on 2019/2/1.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYBoltingHeaderView.h"

@implementation HYBoltingHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        _left = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, frame.size.height)];
        [self addSubview:_left];
        
        _right = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-150, 0, 150, frame.size.height)];
        [self addSubview:_right];
        _right.textAlignment = NSTextAlignmentRight;
        _right.font = [UIFont systemFontOfSize:14];
        _right.textAlignment = NSTextAlignmentRight;
        _right.textColor = kgreenColor;
        
    }
    return self;
}

@end
