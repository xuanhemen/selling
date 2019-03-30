//
//  CLVisitSimpleSummary.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "CLVisitSimpleSummary.h"
//#import "CLSimpleVisitService.h"
//#import "LoginAndIncrementWebService.h"
#define kInputSpace 10
#define kInputViewHeight 100
@implementation CLVisitSimpleSummary

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
        [self configUI];
    }
    return self;
}


-(void)configUI{
    
    
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
    
    
    _labTitle1 = [[UILabel alloc] init];
    [_backView addSubview:_labTitle1];
    _labTitle1.text = @"获得的未知信息：";
    
    
    
    [_labTitle1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labContent.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(20);
    }];
    
    _inputText1 = [[UITextView alloc] init];
    [_backView addSubview:_inputText1];
    
    [_inputText1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labTitle1.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
//    [_inputText1.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText1 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText1.contentSize.height > kInputViewHeight ? weakSelf.inputText1.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    
    
    _labTitle2 = [[UILabel alloc] init];
    [_backView addSubview:_labTitle2];
     _labTitle2.text = @"双方达成的共识：";
    
    [_labTitle2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText1.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(20);
    }];
    
    
    
    _inputText2 = [[UITextView alloc] init];
    [_backView addSubview:_inputText2];
    [_inputText2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labTitle2.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
//    [_inputText2.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText2 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText2.contentSize.height > kInputViewHeight ? weakSelf.inputText2.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    
    
    
    _labTitle3 = [[UILabel alloc] init];
    _labTitle3.text = @"客户存在的顾虑：";
    [_backView addSubview:_labTitle3];
    
    [_labTitle3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText2.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(20);
    }];
    
    
    
    
    
    _inputText3 = [[UITextView alloc] init];
    [_backView addSubview:_inputText3];
    
    [_inputText3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labTitle3.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
//    [_inputText3.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText3 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText3.contentSize.height > kInputViewHeight ? weakSelf.inputText3.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    
    _labTitle4 = [[UILabel alloc] init];
    _labTitle4.text = @"获得的行动承诺：";
    [_backView addSubview:_labTitle4];
    [_labTitle4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText3.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(20);
    }];
    
    
    
    _inputText4 = [[UITextView alloc] init];
    [_backView addSubview:_inputText4];
    [_inputText4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labTitle4.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(kInputViewHeight);
    }];
    
//    [_inputText4.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText4 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText4.contentSize.height > kInputViewHeight ? weakSelf.inputText4.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    
    
    _labTitle5 = [[UILabel alloc] init];
    _labTitle5.text = @"其他：";
    [_backView addSubview:_labTitle5];
    [_labTitle5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText4.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(20);
    }];
    
    
    
    _inputText5 = [[UITextView alloc] init];
    [_backView addSubview:_inputText5];
    [_inputText5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labTitle5.mas_bottom).offset(kInputSpace);
        make.left.equalTo(weakSelf.labVisitRole);
        make.right.equalTo(weakSelf.backView).offset(-kInputSpace);
        make.height.mas_equalTo(kInputViewHeight);
        make.width.equalTo(weakSelf.backView.mas_width).offset(-2*kInputSpace);
    }];
    
    
//    [_inputText5.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        [weakSelf.inputText5 mas_updateConstraints:^(MASConstraintMaker *make) {
//
//            make.height.mas_equalTo(weakSelf.inputText5.contentSize.height > kInputViewHeight ? weakSelf.inputText5.contentSize.height : kInputViewHeight);
//
//        }];
//    }];
    
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _saveBtn.backgroundColor = kgreenColor;
    [_backView addSubview:_saveBtn];
    
    CGFloat width = (kScreenWidth-4*kInputSpace)/3.0;
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText5.mas_bottom).offset(kInputSpace*2);
        make.width.mas_equalTo(width);
        make.left.equalTo(weakSelf.inputText5);
        //        make.centerX.equalTo(weakSelf);
        make.height.mas_equalTo(30);
//        make.bottom.equalTo(weakSelf.backView).offset(-kInputSpace);
    }];
    [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"发送拜访总结" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendBtn.backgroundColor = kgreenColor;
    [_backView addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.saveBtn);
        make.width.mas_equalTo(width);
        make.centerX.equalTo(weakSelf);
        make.height.mas_equalTo(30);
//        make.bottom.equalTo(weakSelf.backView).offset(-kInputSpace*2);
    }];
    
    [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _myCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myCopyBtn setTitle:@"新建拜访" forState:UIControlStateNormal];
    [_myCopyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _myCopyBtn.backgroundColor = kgreenColor;
    [_backView addSubview:_myCopyBtn];
    [_myCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputText5.mas_bottom).offset(kInputSpace*2);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(30);
        make.right.equalTo(weakSelf.inputText5);
        make.bottom.equalTo(weakSelf.backView).offset(-kInputSpace*2);
    }];
    
    [_myCopyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    [_inputText1 configInputStyle];
    [_inputText2 configInputStyle];
    [_inputText3 configInputStyle];
    [_inputText4 configInputStyle];
    [_inputText5 configInputStyle];
    
    _inputText1.delegate = self;
    _inputText2.delegate = self;
    _inputText3.delegate = self;
    _inputText4.delegate = self;
    _inputText5.delegate = self;
}

-(void)setVisitId:(NSString *)visitId{
    _visitId = visitId;
    
    NSString *visitNames = @"";
    _labContent.text = visitNames;
    
    [self configData];
}



-(void)configData{
    
    
    _labContent.text = [_summaryModel.visit_contacts toString];
    
    _inputText1.text = [_summaryModel.unknownlist toString];
    [self refreshSizeWithTextView:_inputText1];
    
    _inputText2.text = [_summaryModel.agreement toString];
    [self refreshSizeWithTextView:_inputText2];
    
    _inputText3.text = [_summaryModel.visitworry toString];
    [self refreshSizeWithTextView:_inputText3];
    
    _inputText4.text = [_summaryModel.obtainpromise toString];
    [self refreshSizeWithTextView:_inputText4];
    
    _inputText5.text = [_summaryModel.nextplan toString];
    [self refreshSizeWithTextView:_inputText5];
    
}




/**
 保存按钮点击
 */
-(void)saveBtnClick{
    [self endEditing:YES];
    [self showProgressWithStr:@"正在保存"];
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"list"] = [self configParams];
    params[@"visit_id"] = _visitId;
    
    [HYBaseRequest getPostWithMethodName:kUpdateSummary Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf showDismiss];
        [weakSelf toastWithText:@"保存成功"];
        if (weakSelf.saveFinish) {
            weakSelf.saveFinish();
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
//    [CLSimpleVisitService updateVisitSummaryWithParams:params Success:^(NSDictionary *result) {
//        [weakSelf dismiss];
//        [weakSelf toastWithText:@"保存成功"];
//        if (weakSelf.saveFinish) {
//            weakSelf.saveFinish();
//        }
//    } fail:^(NSDictionary *result) {
//        [weakSelf dismissWithError];
//    } ];
    
    
}


/**
 发送拜访总结
 */
-(void)sendBtnClick{
    [self endEditing:YES];
            if (self.sendFinish) {
                self.sendFinish();
            }
}




/**
 新建拜访
 */
-(void)copyBtnClick{
    [self endEditing:YES];
    if (self.myCopyFinish) {
        self.myCopyFinish(_visitId);
    }
    
//    [self showProgress];
//    kWeakS(weakSelf);
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"list"] = [self configParams];
//    params[@"visitid"] = _visitId;
//    [CLSimpleVisitService copyVisitBaseWithParams:params Success:^(NSDictionary *result) {
////        [weakSelf dismiss];
//        DLog(@"%@",result);
//        NSString *idStr = [NSString stringWithFormat:@"%@",result];
//
//        [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result) {
//
//            [weakSelf dismiss];
//            if (weakSelf.myCopyFinish) {
//                weakSelf.myCopyFinish(idStr);
//            }
//
//        } fail:^(NSDictionary *result) {
//            [weakSelf dismissWithError];
//        }];
//
//
//    } fail:^(NSDictionary *result) {
//        [weakSelf dismissWithError];
//    } ];
//
}


- (void)textViewDidChange:(UITextView *)textView{
    
    [self refreshSizeWithTextView:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.scrollEnabled = false;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.scrollEnabled = true;
}

-(void)refreshSizeWithTextView:(UITextView *)textView{
    textView.scrollEnabled = false;
    CGSize constraintSize = CGSizeMake(kScreenWidth-2*kInputSpace, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
   
    [textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height > kInputViewHeight ? size.height : kInputViewHeight);
    }];
    
}


-(NSDictionary *)configParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"unknownlist"] = _inputText1.text;
    params[@"agreement"] = _inputText2.text;
    params[@"visitworry"] = _inputText3.text;
    params[@"obtainpromise"] = _inputText4.text;
    params[@"nextplan"] = _inputText5.text;
    return params;
}


-(void)setSummaryModel:(HYGetVisitSummaryModel *)summaryModel{
    
    _summaryModel = summaryModel;
    [self configData];
}


/**
 是否是编辑状态
 
 @param status 1 是完成  不可编辑
 */
-(void)isfinish:(NSString *)status{
    
    if ([status integerValue] == 1) {
        //完成
        
        [_inputText1 setEditable:NO];
        [_inputText2 setEditable:NO];
        [_inputText3 setEditable:NO];
        [_inputText4 setEditable:NO];
        [_inputText5 setEditable:NO];
        
        _inputText1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputText2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputText3.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputText4.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _inputText5.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        [_saveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
      
        [_sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];

        _sendBtn.hidden = YES;
        _saveBtn.hidden = YES;
        
        [_myCopyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth-20);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(10);
        }];
    }else{
        
        [_inputText1 setEditable:YES];
        [_inputText2 setEditable:YES];
        [_inputText3 setEditable:YES];
        [_inputText4 setEditable:YES];
        [_inputText5 setEditable:YES];
        
        CGFloat width = (kScreenWidth-4*kInputSpace)/3.0;
        kWeakS(weakSelf);
        _sendBtn.hidden = NO;
        _saveBtn.hidden = NO;
        
        [_saveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.inputText5.mas_bottom).offset(kInputSpace*2);
            make.width.mas_equalTo(width);
            make.left.equalTo(weakSelf.inputText5);
             make.height.mas_equalTo(30);
        }];
        
    
        [_sendBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.saveBtn);
            make.width.mas_equalTo(width);
            make.centerX.equalTo(weakSelf);
            make.height.mas_equalTo(30);
        }];
    
        
        
        [_myCopyBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.inputText5.mas_bottom).offset(kInputSpace*2);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(30);
            make.right.equalTo(weakSelf.inputText5);
            make.bottom.equalTo(weakSelf.backView).offset(-kInputSpace*2);
        }];
    }
    
    
    
    
}


@end
