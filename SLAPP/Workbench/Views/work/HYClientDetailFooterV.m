//
//  HYClientDetailFooterV.m
//  SLAPP
//
//  Created by yons on 2018/10/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYClientDetailFooterV.h"
#import <Masonry/Masonry.h>

@interface HYClientDetailFooterV()
@property (nonatomic,strong)UIView *backView;
@end

@implementation HYClientDetailFooterV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xFFFFFF);
        [self configTitle];
    }
    return self;
}
- (void)configTitle{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
    line.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:line];
    
    UIView *bottomline = [[UIView alloc] init];
    bottomline.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self addSubview:bottomline];
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-30, 30)];
    titleLabel.text = @"联系人";
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:titleLabel];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 70)];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(-10);
    }];
    
}
- (void)refreshUIWithArray:(NSArray *)array{
    for (UIView *subView in self.backView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat height = 0;
    NSInteger cnt = 0;
    CGFloat finalHeight = 50;
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        QFMemberV *memberV = [[QFMemberV alloc] init];
        if ([dict[@"qf_member_Type"] isEqualToString:@"add"]) {
            memberV.currentType = QF_Add;
        }
        if ([dict[@"qf_member_Type"] isEqualToString:@"minus"]) {
            memberV.currentType = QF_Minus;
        }
        if ([dict[@"qf_member_Type"] isEqualToString:@"default"]) {
            memberV.currentType = QF_Default;
            memberV.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
            memberV.idString = [NSString stringWithFormat:@"%@",dict[@"id"]];
        }
        
        __weak HYClientDetailFooterV *weakSelf = self;
        
        memberV.action = ^(QFMemberType type, NSString *idString) {
            if (weakSelf.action) {
                weakSelf.action(type, idString);
            }
        };
        height = [memberV configMinWidth:70];
        cnt = kScreenWidth/height;
        [memberV configUIWithPoint:CGPointMake(height*(i%cnt), height*(i/cnt))];
        [self.backView addSubview:memberV];
    }
    if (array.count%cnt == 0) {
        finalHeight = finalHeight + (array.count/cnt)*height;
    }else{
        finalHeight = finalHeight + (array.count/cnt+1)*height;
    }
    self.frame = CGRectMake(0, 0, self.frame.size.width, finalHeight);
    
    
}

@end
