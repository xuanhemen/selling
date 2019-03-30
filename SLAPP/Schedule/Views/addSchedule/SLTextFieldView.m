//
//  SLTextFieldView.m
//  SLAPP
//
//  Created by 董建伟 on 2019/2/28.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "SLTextFieldView.h"

@implementation SLTextFieldView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
 
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _textView = [[UITextView alloc]init];
        _textView.delegate = self;
        _textView.font = font(16);
        _textView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(7, 80, 7, 0));
        }];
        _title = [[UILabel alloc]init];
        _title.font = font(16);
        _title.textColor = color_normal;
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        _placeHoder = [[UILabel alloc]init];
        _placeHoder.textColor = [UIColor lightGrayColor];
        _placeHoder.font = font(16);
        [self addSubview:_placeHoder];
        [_placeHoder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 80, 0, 0));
        }];
    }
    return self;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
     _placeHoder.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length==0) {
        _placeHoder.text = @"请输入标题";
    }
    self.passContent(textView.text);
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-80, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    if (bounds.size.height<=50) {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, 50);
        textView.frame = CGRectMake(80, 7, SCREEN_WIDTH-80, 50);
    }else
    {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, bounds.size.height);
        textView.frame = CGRectMake(80, 7,SCREEN_WIDTH-80, bounds.size.height);
    }

    
}
-(void)seterSelfHeight{
    CGRect bounds = _textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH-80, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    bounds.size = newSize;
    self.bounds = bounds;
    if (bounds.size.height<=50) {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, 50);
        _textView.frame = CGRectMake(80, 7, SCREEN_WIDTH-80, 50);
    }else
    {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH, bounds.size.height);
        _textView.frame = CGRectMake(80, 7,SCREEN_WIDTH-80, bounds.size.height);
    }
}
@end
