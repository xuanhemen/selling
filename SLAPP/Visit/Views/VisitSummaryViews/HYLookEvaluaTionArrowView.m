//
//  HYLookEvaluaTionArrowView.m
//  SLAPP
//
//  Created by apple on 2018/10/18.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookEvaluaTionArrowView.h"

@interface HYLookEvaluaTionArrowView()
@property(nonatomic,assign)CGPoint origin;
@end

@implementation HYLookEvaluaTionArrowView


-(id)initWithFrame:(CGRect)frame origin:(CGPoint)origin text:(NSString *)text{
    
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.origin = origin;
        
        UILabel *lab = [UILabel new];
        lab.backgroundColor = kgreenColor;
        lab.font = kFont(14);
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = text;
        [lab sizeToFit];
        lab.layer.cornerRadius = 3;
        lab.layer.masksToBounds = YES;
        CGRect rect = lab.frame;
        CGSize size = CGSizeMake(lab.frame.size.width+20, 30);
        rect.size = size;
        lab.frame = CGRectMake((origin.x - lab.frame.size.width *0.5) >= 0 && ((origin.x + lab.frame.size.width * 0.5) <= frame.size.width) ? (origin.x - lab.frame.size.width * 0.5) : ((origin.x + lab.frame.size.width * 0.5) > frame.size.width ? frame.size.width - lab.frame.size.width : 0), origin.y + 5, lab.frame.size.width, 30);
        [self addSubview:lab];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGFloat startX = self.origin.x;
    CGFloat startY = self.origin.y;
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(startX, startY)];
    [path addLineToPoint:CGPointMake(startX + 5, startY + 5)];
    [path addLineToPoint:CGPointMake(startX - 5, startY + 5)];
    [path closePath];
    [kgreenColor setStroke];
    [kgreenColor set];
    CGContextAddPath(contextRef, path.CGPath);
//    CGContextStrokePath(contextRef);
    CGContextFillPath(contextRef);
}

@end
