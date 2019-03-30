//
//  CLVisitInputView.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "CLVisitInputView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
@implementation CLVisitInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height)];
        _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _backView.scrollEnabled = true;
        [self addSubview:_backView];
        
        kWeakS(weakSelf);
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(weakSelf);
//            make.width.equalTo(weakSelf);
//            make.left.equalTo(weakSelf);
//            make.right.equalTo(weakSelf);
//            make.bottom.equalTo(weakSelf);
            make.edges.equalTo(weakSelf).offset(0);
            make.width.mas_equalTo(weakSelf.frame.size.width);
        }];
        

        
    }
    return self;
}

- (void)configUI{
    
    kWeakS(weakSelf);
    self.labVisitRole = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_backView addSubview:self.labVisitRole];
    self.labVisitRole.numberOfLines = 0;
    [self.labVisitRole mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).offset(kInputSpace);
//        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.top.equalTo(weakSelf.backView).offset(kInputSpace);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    self.labVisitRole.text = @"拜访对象：";
    
    self.labContent = [[UILabel alloc] init];
    [_backView addSubview:self.labContent];
    
    self.labContent.text = @"";
    self.labContent.numberOfLines = 0;
    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.labVisitRole.mas_right).offset(5);
        make.top.equalTo(weakSelf.labVisitRole.mas_top).offset(0);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
    }];
    
    self.labTitle = [[UILabel alloc] init];
    [_backView addSubview:_labTitle];
    self.labTitle.text = @"认知期望";
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.labVisitRole);
        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(kInputSpace);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(30);
    }];
    
    
    
    self.inputText1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, kInputViewHeight)];
    [_backView addSubview:_inputText1];
    
    [self.inputText1  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.labTitle);
        make.right.equalTo(weakSelf.labTitle);
        make.top.equalTo(weakSelf.labTitle.mas_bottom).offset(kInputSpace);
        make.height.equalTo(@(kInputViewHeight));
        make.bottom.equalTo(weakSelf.backView.mas_bottom).offset(-20);
        make.width.equalTo(weakSelf.backView.mas_width).offset(-2*kInputSpace);
    }];
    
//    [self.inputText1.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText1 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText1.contentSize.height > kInputViewHeight ? weakSelf.inputText1.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    [self.inputText1 configInputStyle];
    [self.inputText1 setContentInset:UIEdgeInsetsZero];
    self.inputText1.delegate = self;
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (self.textDidChange) {
        self.textDidChange();
    }
    [self refreshSizeWithTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    textView.scrollEnabled = false;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.scrollEnabled = true;
}

-(void)refreshSizeWithTextView:(UITextView *)textView {
   

    textView.scrollEnabled = false;

    CGSize constraintSize = CGSizeMake(kScreenWidth-2*kInputSpace, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(size.height > kInputViewHeight ? size.height : kInputViewHeight);
        [textView scrollRangeToVisible:textView.selectedRange];
        
    }];
    
}


@end
