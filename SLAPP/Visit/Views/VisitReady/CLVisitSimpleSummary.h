//
//  CLVisitSimpleSummary.h
//  CLAppWithSwift
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextView+Category.h"
#import "HYGetVisitSummaryModel.h"
@interface CLVisitSimpleSummary : UIView<UITextViewDelegate>

@property(nonatomic,strong)HYGetVisitSummaryModel *summaryModel;

@property(nonatomic,copy)NSString *visitId;

@property(nonatomic,strong)UIScrollView *backView;
@property(nonatomic,strong)UILabel *labVisitRole;
@property(nonatomic,strong)UILabel *labContent;
@property(nonatomic,strong)UILabel *labTitle1;
@property(nonatomic,strong)UITextView *inputText1;

@property(nonatomic,strong)UILabel *labTitle2;
@property(nonatomic,strong)UITextView *inputText2;


@property(nonatomic,strong)UILabel *labTitle3;
@property(nonatomic,strong)UITextView *inputText3;


@property(nonatomic,strong)UILabel *labTitle4;
@property(nonatomic,strong)UITextView *inputText4;

@property(nonatomic,strong)UILabel *labTitle5;
@property(nonatomic,strong)UITextView *inputText5;

@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)UIButton *myCopyBtn;


/**
 发送拜访总结
 */
@property(nonatomic,copy)void (^sendFinish)(void);


/**
 保存  网络提交在内容已经完成，该block是提交服务器完成后续操作
 */
@property(nonatomic,copy)void (^saveFinish)(void);


/**
 新建拜访   这里的新建是将现在的拜访复制一份  直接为下一次拜访做准备
 */
@property(nonatomic,copy)void (^myCopyFinish)(NSString * visitId);


/**
 是否是编辑状态

 @param status 1 是完成  不可编辑
 */
-(void)isfinish:(NSString *)status;
@end
