//
//  CLVisitSimpleVC.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/17.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//
#import "HYReservationVC.h"
#import "CLVisitSimpleVC.h"
#import "TopGuideView.h"
#import "CLVisitSimpleBottomView.h"
#import "CLVisitInputView.h"

#import "CLSimpleExpectView.h"   //认知期望
#import "CLActionCommitmentView.h" //行动承诺
#import "CLAppointmentReasonView.h" //约见理由
#import "CLUnknownListingView.h" //未知清单
#import "CLAdvantagesListingView.h" //优势清单
//#import "CLSimpleVisitService.h"

#import <IQKeyboardManager/IQKeyboardManager.h>
#import "HYVisitHomeVC.h"

#define TopGuideHeight  60
#define bottomHeight  50

@interface CLVisitSimpleVC ()<CLVisitSimpleBottomViewDelegate,TopGuideViewDelegate>
@property(nonatomic,strong)UIScrollView *backView;
@property(nonatomic,strong)TopGuideView *guideView;
@property(nonatomic,strong)CLVisitSimpleBottomView *bottomView;
@property(nonatomic,strong)CLSimpleExpectView *input1;
@property(nonatomic,strong)CLActionCommitmentView *input2;
@property(nonatomic,strong)CLAppointmentReasonView *input3;
@property(nonatomic,strong)CLUnknownListingView *input4;
@property(nonatomic,strong)CLAdvantagesListingView *input5;

//@property(nonatomic,strong)Visit_readyModel *model1;
//@property(nonatomic,strong)Visit_readyModel *model2;
//@property(nonatomic,strong)Visit_readyModel *model3;
//@property(nonatomic,strong)Visit_readyModel *model4;
//@property(nonatomic,strong)Visit_readyModel *model5;

@end

@implementation CLVisitSimpleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configData];
    self.navigationItem.title = @"认知期望";
}


-(void)configData{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = _visitId;
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kLook_visit_ready Params:params showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
        DLog(@"%@",result);
        [weakSelf configDataToUI:result];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
    
    
    
    //信息类型，expect 认知期望，actionpromise 行动承诺，specialadvantage 优势清单，unknownlist 未知清单，visitreason 约见理由
//    RLMResults *result1 = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,@"expect"];
//    if (result1.count > 0) {
//        _model1 = result1.firstObject;
//        self.guideView.historyTag = 1000;
//    }else{
//        _model1 = [[Visit_readyModel alloc] init];
//        self.guideView.historyTag = 1000;
//    }
    
    
    
//    RLMResults *result2 = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,@"actionpromise"];
//    if (result2.count > 0) {
//        _model2 = result2.firstObject;
//        self.guideView.historyTag = 1001;
//    }else{
//        _model2 = [[Visit_readyModel alloc] init];
//
//    }
    
    
    
//    RLMResults *result3 = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,@"visitreason"];
//    if (result3.count > 0) {
//        _model3 = result3.firstObject;
//        self.guideView.historyTag = 1002;
//    }else{
//        _model3 = [[Visit_readyModel alloc] init];
//
//    }
//
//
//    RLMResults *result4 = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,@"unknownlist"];
//    if (result4.count > 0) {
//        _model4 = result4.firstObject;
//        self.guideView.historyTag = 1003;
//    }else{
//        _model4 = [[Visit_readyModel alloc] init];
//
//    }
    
//    RLMResults *result5 = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,@"specialadvantage"];
//    if (result5.count > 0) {
//        _model5 = result5.firstObject;
//        self.guideView.historyTag = 1004;
//    }else{
//        _model5 = [[Visit_readyModel alloc] init];
//    }

    [self.guideView configWith:self.guideView.historyTag-1000];
    
}


- (void)configDataToUI:(NSDictionary *)result{
    
    NSString *visitNames = @"";
    
    visitNames = [result[@"visit_contacts"] toString];
    
    
    
//    RLMResults *visiters = [Visit_to_usersModel objectsWhere:@"visit_id == %@",self.visitId];
//    if (visiters.count) {
//        for (int i = 0 ; i < visiters.count ; i++) {
//            Visit_to_usersModel *user = visiters[i];
//            visitNames =  [visitNames stringByAppendingString:user.contact_name];
//            if ([user.position_name isNotEmpty]){
//                 visitNames =  [visitNames stringByAppendingString:[NSString stringWithFormat:@"（%@）",user.position_name]];
//            }
//
//            if (i != visiters.count -1) {
//
//                visitNames =  [visitNames stringByAppendingString:@","];
//            }
//
//
//        }
//
//
//    }
//    else{
//        [self toastWithText:@"错误数据，没有产找到拜访对象" andDruation:5];
//        return;
//    }
    
    
    
    
    _input1.labTitle.text = @"认知期望";
    _input1.inputText1.text = [result[@"expect"][@"content"] toString];
    _input1.labContent.text = visitNames;
    _input1.inputText1.placeholder = @"请填写认知期望";
    
    
    [_input1 refreshSizeWithTextView:_input1.inputText1];
    
    _input2.labTitle.text = @"获得的最佳行动承诺是：";
    _input2.inputText1.text = [result[@"actionpromise"][@"content"] toString];
    _input2.labTitle2.text = @"获得的最低行动承诺是：";
    _input2.inputText2.text = [result[@"actionpromise"][@"des"] toString];
    _input2.labContent.text = visitNames;
    [_input2 refreshSizeWithTextView:_input2.inputText1];
    [_input2 refreshSizeWithTextView:_input2.inputText2];
    
    
    
    _input3.labTitle.text = @"约见理由";
    _input3.inputText1.text = [result[@"visitreason"][@"content"] toString];
    _input3.labContent.text = visitNames;
    [_input3 refreshSizeWithTextView:_input3.inputText1];
    _input3.inputText1.placeholder = @"请填写约见理由";
    
    _input4.labTitle.text = @"未知信息与提问清单：";
     _input4.inputText1.placeholder = @"请填写未知信息与提问清单";
    
    _input4.inputText1.text = [result[@"unknownlist"][@"content"] toString];
    _input4.labContent.text = visitNames;
   
    [_input4 refreshSizeWithTextView:_input4.inputText1];
   
    
    
    
    _input5.labTitle.text = @"优势清单";
    _input5.inputText1.placeholder = @"请填写优势清单";
   _input5.inputText1.text = [result[@"specialadvantage"][@"content"] toString];
    _input5.labContent.text = visitNames;
    [_input5 refreshSizeWithTextView:_input5.inputText1];
}


-(void)configUI{
    
    self.navigationItem.title = @"未知清单";
//   顶端步骤导航
    _guideView = [[TopGuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopGuideHeight)];
    
    [self.view addSubview:_guideView];
    [_guideView configUI];
    _guideView.delegate = self;
//
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,TopGuideHeight, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [self.view addSubview:_backView];
    _backView.pagingEnabled = true;
    _backView.scrollEnabled = false;
//    _backView.backgroundColor  = [UIColor redColor];
    _backView.contentSize = CGSizeMake(5 * kScreenWidth, 0);
    
// 底端上一步  下一步
    _bottomView = [[CLVisitSimpleBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_backView.frame), kScreenWidth, bottomHeight)];
    [self.view addSubview:_bottomView];
    _bottomView.delegate = self;
    
    [self addInputView];
}


/**
 添加输入界面
 */
-(void)addInputView{
    
    kWeakS(weakSelf);
    _input1 = [[CLSimpleExpectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [_backView addSubview:_input1];
    [_input1 configUI];
    
    
    _input2 = [[CLActionCommitmentView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [_backView addSubview:_input2];
    _input2.labTitle.text = @"";
     [_input2 configUI];
    
    _input3 = [[CLAppointmentReasonView alloc] initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [_backView addSubview:_input3];
    [_input3 configUI];
    
    _input4 = [[CLUnknownListingView alloc] initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [_backView addSubview:_input4];
    [_input4 configUI];
    
    
    _input5 = [[CLAdvantagesListingView alloc] initWithFrame:CGRectMake(kScreenWidth*4, 0, kScreenWidth, kMain_screen_height_px-kNav_height-TopGuideHeight-bottomHeight)];
    [_backView addSubview:_input5];
    [_input5 configUI];
    
    
    
    _input1.textDidChange = ^{
        weakSelf.isChanged = true;
    };
    
    _input2.textDidChange = ^{
        weakSelf.isChanged = true;
    };
    
    _input3.textDidChange = ^{
        weakSelf.isChanged = true;
    };
    
    _input4.textDidChange = ^{
        weakSelf.isChanged = true;
    };
    
    _input5.textDidChange = ^{
        weakSelf.isChanged = true;
    };
    
}




/**
 底端上一步下一步  点击后的响应

 @param tag 0 左边按钮点击（上一步） 1 有变按钮点击（下一步）
 @return 返回值 （第一步和最后一步可能需要做处理）
 */
- (BOOL)bottomClickWithView:(CLVisitSimpleBottomView *)bottomView Tag:(NSInteger)tag{
    
//    NSArray *array = @[@"认知期望",@"行动承诺",@"约见理由",@"未知清单",@"优势清单"];
    
    kWeakS(weakSelf);
    if (tag == 0) {
        if ([self.guideView currentPageTag] == 0) {
            //当前是第一步
        }else{
            
            [self clickTotag:[self.guideView currentPageTag] - 1];
//            [self.guideView changeBtnWithPage:[self.guideView currentPageTag] - 1];
            
        }
//        self.backView.contentOffset = CGPointMake(MAIN_SCREEN_WIDTH * [self.guideView currentPageTag], 0);
//        self.navigationItem.title = array[[self.guideView currentPageTag]];
        
    }
    else if (tag == 2){
        //完成
        bottomView.finishBtn.hidden = false;
        
        if (![_input5.inputText1.text isNotEmpty]) {
            [self toastWithText:@"请填写优势清单"];
            return false;
        }
        
        //当前是最后一步
    
        [self showProgress];
        [HYBaseRequest getPostWithMethodName:kUpdate_visitReady Params:[self configParamsWithTag:[self.guideView currentPageTag]] showToast:true Success:^(NSDictionary *result) {
            [weakSelf showDismiss];
            [weakSelf showRemind];
            
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        
    }
    else{
        
        
        [self clickTotag:[self.guideView currentPageTag] + 1];
       
//            if ([self.guideView currentPageTag] >= 3) {
//                bottomView.finishBtn.hidden = false;
//            }
//
        
        
        
        

        
            
            
        
        
    }
    
    
    
    
    return false;
}

-(void)showRemind{
    
    kWeakS(weakSelf);
    [self addAlertViewWithTitle:@"温馨提示" message:@"是否立即预约？" actionTitles:@[@"是的",@"不需要"] okAction:^(UIAlertAction *action) {
            HYReservationVC * reservationVC = [[HYReservationVC alloc] init];
            reservationVC.isPopToRoot = YES;
            reservationVC.isReservation = YES;
            reservationVC.visitId = weakSelf.visitId ;
            [weakSelf.navigationController pushViewController:reservationVC animated:true];
    } cancleAction:^(UIAlertAction *action) {
        
        [weakSelf popToList];
    }];
    
    
}



/**
 返回  要求有拜访列表就返回到拜访列表
 */
-(void)popToList{
    
    if (self.navigationController.childViewControllers.count > 2) {
        if ([self.navigationController.childViewControllers[1] isKindOfClass:[HYVisitHomeVC class]]) {
//            从工作台进入
            HYVisitHomeVC *vc = self.navigationController.childViewControllers[1];
            [self.navigationController popToViewController:vc animated:true];
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:true];
    
}



-(NSDictionary *)configParamsWithTag:(NSInteger)tag{
    
    //信息类型，expect 认知期望，actionpromise 行动承诺，specialadvantage 优势清单，unknownlist 未知清单，visitreason 约见理由
    NSArray *array = @[@"expect",@"actionpromise",@"visitreason",@"unknownlist",@"specialadvantage"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
     params[@"visit_id"] = self.visitId;
     params[@"catalog"] = array[tag];
    if (tag == 0) {
       params[@"content"] = _input1.inputText1.text;
    }else if (tag == 1){
        params[@"content"] = _input2.inputText1.text;
        params[@"des"] = _input2.inputText2.text;
    }else if (tag == 2){
        params[@"content"] = _input3.inputText1.text;
    }else if (tag == 3){
        
        params[@"content"] = _input4.inputText1.text;
    }else if (tag == 4){
        params[@"content"] = _input5.inputText1.text;
    }
    return params;
}



-(void)topGuideView:(TopGuideView *)topGuideView BtnClick:(UIButton *)btn{
    DLog(@"%ld",btn.tag);
    
    if (btn.tag == [self.guideView currentPageTag]) {
        return;
    }
    [self clickTotag:btn.tag-1000];
}


-(void)showLastBtn{
    
    self.bottomView.finishBtn.hidden = [self.guideView currentPageTag] != 4;
    
}


-(void)clickTotag:(NSInteger)tag{
    
    if(self.guideView.historyTag < 1000+tag ){
        [self changeWithTag:tag];
        return;
    }
    
    NSArray *array = @[@"认知期望",@"行动承诺",@"约见理由",@"未知清单",@"优势清单"];
    kWeakS(weakSelf);

    if (self.isChanged) {
        
        [self addAlertViewWithTitle:@"温馨提示" message:@"当前数据有变动,您是否要保存" actionTitles:@[@"保存",@"不保存"] okAction:^(UIAlertAction *action) {
            [weakSelf changeWithTag:tag];
        } cancleAction:^(UIAlertAction *action) {
            [weakSelf configData];
            weakSelf.isChanged = false;
            [weakSelf.guideView changeBtnWithPage:tag];
            weakSelf.backView.contentOffset = CGPointMake(kScreenWidth * [weakSelf.guideView currentPageTag], 0);
            weakSelf.navigationItem.title = array[[weakSelf.guideView currentPageTag]];
            [weakSelf showLastBtn];
        }];
        
    }else{
        [weakSelf.guideView changeBtnWithPage:tag];
        weakSelf.backView.contentOffset = CGPointMake(kScreenWidth * [weakSelf.guideView currentPageTag], 0);
        weakSelf.navigationItem.title = array[[weakSelf.guideView currentPageTag]];
        [self showLastBtn];
    }
    
}



-(void)changeWithTag:(NSInteger)tag{
    NSArray *array = @[@"认知期望",@"行动承诺",@"约见理由",@"未知清单",@"优势清单"];
    kWeakS(weakSelf);
   
   
        
        NSInteger myTag = [self.guideView currentPageTag];
        if (myTag == 0) {
            
            if (![_input1.inputText1.text isNotEmpty]) {
                [self toastWithText:@"请填写认知期望"];
                return;
            }
            
        }else if (myTag == 1){
            if (![_input2.inputText1.text isNotEmpty] && ![_input2.inputText2.text isNotEmpty]) {
                [self toastWithText:@"请填写行动承诺"];
                return;
            }
        }else if (myTag == 2){
            
            
            if (![_input3.inputText1.text isNotEmpty]) {
                [self toastWithText:@"请填写约见理由"];
                return;
            }
        }else if (myTag == 3){
            
            
            
//            if (![_input4.inputText1.text isNotEmpty]) {
//                [self toastWithText:@"请填写未知信息与提问清单"];
//                return;
//            }
        }else if (myTag == 4){
           
            
            if (![_input5.inputText1.text isNotEmpty]) {
                [self toastWithText:@"请填写优势清单"];
                return;
            }
        }
        
    
     [self showProgress];
    [HYBaseRequest getPostWithMethodName:kUpdate_visitReady Params:[self configParamsWithTag:[self.guideView currentPageTag]] showToast:true Success:^(NSDictionary *result) {
                weakSelf.isChanged = false;
                [weakSelf dismissProgress];
                [weakSelf.guideView changeBtnWithPage:tag];
                weakSelf.backView.contentOffset = CGPointMake(kScreenWidth * [weakSelf.guideView currentPageTag], 0);
                weakSelf.navigationItem.title = array[[weakSelf.guideView currentPageTag]];
                [weakSelf showLastBtn];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
//    [CLSimpleVisitService visitUpdateVisitReadynewWithParams:[self configParamsWithTag:[self.guideView currentPageTag]] Success:^(NSDictionary *result) {
//        weakSelf.isChanged = false;
//        [weakSelf dismiss];
//        [weakSelf.guideView changeBtnWithPage:tag];
//        weakSelf.backView.contentOffset = CGPointMake(MAIN_SCREEN_WIDTH * [weakSelf.guideView currentPageTag], 0);
//        weakSelf.navigationItem.title = array[[weakSelf.guideView currentPageTag]];
//        [weakSelf showLastBtn];
//    } fail:^(NSDictionary *result) {
//        [weakSelf dismissWithError];
//    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
