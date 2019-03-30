//
//  CLVisitSimpleDetailEditVC.m
//  CLAppWithSwift
//
//  Created by apple on 2018/9/19.
//  Copyright © 2018年 销售罗盘. All rights reserved.
//

#import "CLVisitSimpleDetailEditVC.h"
#import "CLSimpleExpectView.h"
#import "CLActionCommitmentView.h"
//#import "CLSimpleVisitService.h"
@interface CLVisitSimpleDetailEditVC ()
//@property(nonatomic,strong)Visit_readyModel *model;
@property(nonatomic,strong)CLSimpleExpectView *input1;
@property(nonatomic,strong)CLActionCommitmentView *input2;
@end

@implementation CLVisitSimpleDetailEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
    [self configData];
    
}

-(void)configUI{
     //信息类型，expect 认知期望，actionpromise 行动承诺，specialadvantage 优势清单，unknownlist 未知清单，visitreason 约见理由
    NSArray *typeArray = @[@"actionpromise"];
    if ([typeArray containsObject:_typeStr]) {
        _input2 = [[CLActionCommitmentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height-50)];
        [self.view addSubview:_input2];
        [_input2 configUI];
    }else{
        _input1 = [[CLSimpleExpectView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height-50)];
        [self.view addSubview:_input1];
        [_input1 configUI];
    }
    
    
    
   UIButton* _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _finishBtn.frame  = CGRectMake(0,kMain_screen_height_px-kNav_height-50, kScreenWidth,50);
    [_finishBtn setBackgroundColor:kgreenColor];
    [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = kFont(15);
    [self.view addSubview:_finishBtn];
   
    [_finishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)configData{
    
    
    if (![_visitId isNotEmpty] || ![_typeStr isNotEmpty]) {
        [self toastWithText:@"数据有误" andDruation:5];
        return;
    }
    
//    RLMResults *result = [Visit_readyModel objectsWhere:@"visit_id == %@ && catalog == %@",_visitId,_typeStr];
//    if (result.count > 0) {
//        _model = result.firstObject;
//    }else{
//        _model = [[Visit_readyModel alloc] init];
////        [self toastWithText:@"数据有误" andDruation:5];
////        return;
//    }
    
    [self configDataToUI];
}




- (void)configDataToUI{
    
    NSString *visitNames = @"";
    
    visitNames = _visiters;
//    RLMResults *visiters = [Visit_to_usersModel objectsWhere:@"visit_id == %@",self.visitId];
//    if (visiters.count) {
//        for (int i = 0 ; i < visiters.count ; i++) {
//            Visit_to_usersModel *user = visiters[i];
//            visitNames =  [visitNames stringByAppendingString:user.contact_name];
//            if ([user.position_name isNotEmpty]){
//                visitNames =  [visitNames stringByAppendingString:[NSString stringWithFormat:@"（%@）",user.position_name]];
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
    
//    }
//    else{
//        [self toastWithText:@"错误数据，没有产找到拜访对象" andDruation:5];
//        return;
//    }
    
    //信息类型，expect 认知期望，actionpromise 行动承诺，specialadvantage 优势清单，unknownlist 未知清单，visitreason 约见理由
    
    if (![_model isNotEmpty]) {
        return;
    }
    if ([_typeStr isEqualToString:@"expect"]) {
        self.navigationItem.title = @"认知期望";
        _input1.labTitle.text = @"认知期望";
        _input1.inputText1.text = _model.content;
        _input1.labContent.text = visitNames;
        _input1.inputText1.placeholder = @"请填写认知期望";
    }else if ([_typeStr isEqualToString:@"actionpromise"]){
        self.navigationItem.title = @"行动承诺";
        _input2.labTitle.text = @"最佳行动承诺";
        _input2.inputText1.text = _model.bestContent;
        _input2.inputText1.placeholder = @"请填写最佳行动承诺";
        _input2.labTitle2.text = @"最低行动承诺";
       _input2.inputText2.text = _model.lowestContent;
        _input2.inputText2.placeholder = @"请填写最低行动承诺";
        _input2.labContent.text = visitNames;
        
    }else if ([_typeStr isEqualToString:@"visitreason"]){
        self.navigationItem.title = @"约见理由";
        _input1.labTitle.text = @"约见理由";
        _input1.inputText1.text = _model.content;
        _input1.labContent.text = visitNames;
        _input1.inputText1.placeholder = @"请填写约见理由";
    }
    else if ([_typeStr isEqualToString:@"unknownlist"]){
        self.navigationItem.title = @"未知清单";
        _input1.labTitle.text = @"未知信息与提问清单：";
        _input1.inputText1.text = _model.content;
        _input1.labContent.text = visitNames;
        _input1.inputText1.placeholder = @"请填写未知信息与提问清单";
    }
    else if ([_typeStr isEqualToString:@"specialadvantage"]){
        self.navigationItem.title = @"优势清单";
        _input1.labTitle.text = @"优势清单";
        _input1.inputText1.text = _model.content;
        _input1.labContent.text = visitNames;
        _input1.inputText1.placeholder = @"请填写优势清单";
    }

}


-(void)btnClick:(UIButton *)btn{
    if ([self.typeStr isEqualToString:@"actionpromise"]) {
        
        if (![_input2.inputText1.text isNotEmpty] && ![_input2.inputText2.text isNotEmpty] ) {
            [self toastWithText:@"内容不能为空"];
            return;
        }
        
    }else{
        
        if (![_input1.inputText1.text isNotEmpty]) {
            [self toastWithText:@"内容不能为空"];
            return;
        }
        
    }
    
    
    
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kUpdate_visitReady Params:[[self configParams] addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf showDismiss];
        
                if (weakSelf.okBtnClickBlock) {
                    weakSelf.okBtnClickBlock();
                }
        [weakSelf.navigationController popViewControllerAnimated:true];
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
    
//    [CLSimpleVisitService visitUpdateVisitReadynewWithParams:[self configParams] Success:^(NSDictionary *result) {
//        if (weakSelf.okBtnClickBlock) {
//            weakSelf.okBtnClickBlock();
//        }
//        [weakSelf dismiss];
//        [weakSelf.navigationController popToRootViewControllerAnimated:true];
//    } fail:^(NSDictionary *result) {
//        [weakSelf dismissWithError];
//    }];
    
    
}




-(NSDictionary *)configParams{
    
    //信息类型，expect 认知期望，actionpromise 行动承诺，specialadvantage 优势清单，unknownlist 未知清单，visitreason 约见理由
//    NSArray *array = @[@"expect",@"actionpromise",@"visitreason",@"unknownlist",@"specialadvantage"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visitid"] = self.visitId;
    params[@"catalog"] = _typeStr;
    if ([_typeStr isEqualToString:@"expect"]) {
        params[@"content"] = _input1.inputText1.text;
    }else if ([_typeStr isEqualToString:@"actionpromise"]){
        params[@"content"] = _input2.inputText1.text;
        params[@"des"] = _input2.inputText2.text;
    }else if ([_typeStr isEqualToString:@"visitreason"]){
        params[@"content"] = _input1.inputText1.text;
    }else if ([_typeStr isEqualToString:@"unknownlist"]){
        params[@"content"] = _input1.inputText1.text;
//        params[@"des"] = _input2.inputText2.text;
    }else if ([_typeStr isEqualToString:@"specialadvantage"]){
        params[@"content"] = _input1.inputText1.text;
    }
    
    params[@"visit_id"] = _visitId;
    
    
    return params;
}







//let typeArray = ["expect","actionpromise","visitreason","unknownlist","specialadvantage"]

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
