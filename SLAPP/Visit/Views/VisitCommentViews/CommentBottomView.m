//
//  CommentBottomView.m
//  CLApp
//
//  Created by rms on 16/12/29.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "CommentBottomView.h"
#define LEFT_PADDING 15
#define BTN_TITLE_COLOR HexColor(@"333333")
@implementation CommentBottomView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HexColor(@"F1F1F1");
        [self initChildView];
    }
    return self;
}
-(void)initChildView{

    [self addSubview:self.commentBtn];
    [self addSubview:self.detailBtn];
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LEFT_PADDING);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(30);
    }];
    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-LEFT_PADDING);
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(30);
    }];
}
-(void)setCommentNum:(NSUInteger)commentNum{

    _commentNum = commentNum;
    [self.detailBtn setTitle:[NSString stringWithFormat:@"  评论数(%lu)",(unsigned long)self.commentNum] forState:UIControlStateNormal];
    [self.detailBtn sizeToFit];
    CGRect frame = self.detailBtn.frame;
    frame.size = CGSizeMake(frame.size.width, 30);
    self.detailBtn.frame = frame;
    kWeakS(weakSelf);
    [self.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - LEFT_PADDING * 2 - weakSelf.detailBtn.frame.size.width - 15);
    }];
}
-(void)commentBtnClick:(UIButton *)sender{
    if (self.commentBtnClickBlock) {
        self.commentBtnClickBlock();
    }
    
}
-(void)detailBtnClick:(UIButton *)sender{
    if (self.detailBtnClickBlock) {
        self.detailBtnClickBlock();
    }
    
}
-(UIButton *)commentBtn{

    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc]init];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.layer.cornerRadius = 15;
        _commentBtn.layer.borderWidth = 0.5;
        _commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _commentBtn.backgroundColor = [UIColor whiteColor];
        [_commentBtn setImage:[UIImage imageNamed:@"comment_write_icon"] forState:UIControlStateNormal];
         [_commentBtn setImage:[UIImage imageNamed:@"comment_write_icon"] forState:UIControlStateHighlighted];
        [_commentBtn setTitle:@"  评论一下" forState:UIControlStateNormal];
        [_commentBtn setTitleColor:BTN_TITLE_COLOR forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = kFont(15);
        _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _commentBtn;
}
-(UIButton *)detailBtn{
    
    if (!_detailBtn) {
        _detailBtn = [[UIButton alloc]init];
        [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_detailBtn setImage:[UIImage imageNamed:@"comment_ico"] forState:UIControlStateNormal];
        [_detailBtn setImage:[UIImage imageNamed:@"comment_ico"] forState:UIControlStateHighlighted];
        [_detailBtn setTitleColor:BTN_TITLE_COLOR forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = kFont(15);

    }
    return _detailBtn;
}
@end
