//
//  CLUnknownListingView.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "CLUnknownListingView.h"

@implementation CLUnknownListingView

//- (void)configUI{
//    
//    kWeakS(weakSelf);
//    self.labVisitRole = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [self.backView addSubview:self.labVisitRole];
//    self.labVisitRole.numberOfLines = 0;
//    [self.labVisitRole mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.backView).offset(kInputSpace);
//        //        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
//        make.top.equalTo(weakSelf.backView).offset(kInputSpace);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(90);
//    }];
//    self.labVisitRole.text = @"拜访对象：";
//    
//    self.labContent = [[UILabel alloc] init];
//    [self.backView addSubview:self.labContent];
//    
//    self.labContent.text = @"";
//    self.labContent.numberOfLines = 0;
//    [self.labContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.labVisitRole.mas_right).offset(5);
//        make.top.equalTo(weakSelf.labVisitRole);
//        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
//        //        make.height.mas_equalTo(50);
//    }];
//    
//    self.labTitle = [[UILabel alloc] init];
//    [self.backView addSubview:self.labTitle];
//    self.labTitle.text = @"";
//    
//    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.labVisitRole);
//        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(kInputSpace);
//        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
//        make.height.mas_equalTo(30);
//    }];
//    
//    
//    
//    self.inputText1 = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, kInputViewHeight)];
//    [self.backView addSubview:self.inputText1];
//    
//    [self.inputText1  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.labTitle);
//        make.right.equalTo(weakSelf.labTitle);
//        make.top.equalTo(weakSelf.labTitle.mas_bottom).offset(kInputSpace);
//        make.height.mas_equalTo(kInputViewHeight);
//        //        make.bottom.equalTo(weakSelf.backView);
//    }];
//    
//    
////    [self.inputText1.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
////        [weakSelf.inputText1 mas_updateConstraints:^(MASConstraintMaker *make) {
////            
////            make.height.mas_equalTo(weakSelf.inputText1.contentSize.height > kInputViewHeight ? weakSelf.inputText1.contentSize.height : kInputViewHeight);
////            
////        }];
////    }];
//    
//    
//    self.labTitle2 = [[UILabel alloc] init];
//    [self.backView addSubview:self.labTitle2];
//    
//    self.labTitle2.text = @"";
//    
//    [self.labTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.labTitle);
//        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
//        make.height.mas_equalTo(30);
//        make.top.equalTo(weakSelf.inputText1.mas_bottom).offset(kInputSpace);
//    }];
//    
//    
//    self.inputText2 = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-20, kInputViewHeight)];
//    [self.backView addSubview:self.inputText2];
//    
//    
//    
//    [self.inputText2  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.labTitle2);
//        make.right.equalTo(weakSelf.labTitle2);
//        make.top.equalTo(weakSelf.labTitle2.mas_bottom).offset(kInputSpace);
//        make.height.mas_equalTo(kInputViewHeight);
//        make.bottom.equalTo(weakSelf.backView.mas_bottom).offset(-kInputSpace);
//        make.width.equalTo(weakSelf.backView.mas_width).offset(-2*kInputSpace);
//    }];
//    
//    
////    [self.inputText2.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
////        [weakSelf.inputText2 mas_updateConstraints:^(MASConstraintMaker *make) {
////
////            make.height.mas_equalTo(weakSelf.inputText2.contentSize.height > kInputViewHeight ? weakSelf.inputText2.contentSize.height : kInputViewHeight);
////
////        }];
////    }];
//    
//    [self.inputText1 configInputStyle];
//    [self.inputText2 configInputStyle];
//    
//    self.inputText2.delegate = self;
//    self.inputText1.delegate = self;
//}
@end
