//
//  VisitBaseInfoFooterView.m
//  CLApp
//
//  Created by xslp on 16/8/30.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "VisitBaseInfoFooterView.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@interface VisitBaseInfoFooterView ()
@property (strong, nonatomic) UILabel *lbLeft;
@property (strong, nonatomic) UILabel *lbRight;

@end
@implementation VisitBaseInfoFooterView{

    MDRadialProgressView *imgLeft;
    MDRadialProgressView *imgRight;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}
-(void)initSubViews{

//    UIView *vwLine = [[UIView alloc] init];
//    
//    [self addSubview:vwLine];
//    
//    [vwLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_WIDTH - 30, .7));
//        
//        make.left.mas_equalTo(0);
//        
//        make.top.mas_equalTo(2);
//        
//    }];
//    
//    vwLine.backgroundColor = HexColor(@"C7C7CC");
    
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visit_evaluate_top_back"]];
    bgImageV.frame = self.bounds;
    [self addSubview:bgImageV];
    
    imgLeft = [[MDRadialProgressView alloc]init];
//    imgLeft.progressTotal = 50;
//    imgLeft.progressCounter = 0;
    imgLeft.theme.sliceDividerHidden = YES;
    imgLeft.label.hidden = YES;
    imgLeft.theme.incompletedColor = HexColor(@"93bdf0");
    imgLeft.theme.completedColor = [UIColor whiteColor];

    
    [self addSubview:imgLeft];
    
    [imgLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        
        make.left.mas_equalTo(86 / 2);
        
        make.size.mas_equalTo(kReal(250));
        
    }];
    
    //    imgLeft.image = [UIImage imageNamed:@"visit_result_evaluate"];
    
    imgRight = [[MDRadialProgressView alloc]init];
//    imgRight.progressTotal = 50;
//    imgRight.progressCounter = 0;
    imgRight.theme.sliceDividerHidden = YES;
    imgRight.label.hidden = YES;
    imgRight.theme.incompletedColor = HexColor(@"93bdf0");
    imgRight.theme.completedColor = [UIColor whiteColor];

    [self addSubview:imgRight];
    
    
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        
        make.right.mas_equalTo(-86 / 2);
        
        make.size.mas_equalTo(kReal(250));
        
    }];
    
    
//        imgRight.image = [UIImage imageNamed:@"visit_trust_evaluate"];
    
    _lbLeft = [[UILabel alloc] init];
    
    [self addSubview:_lbLeft];
    __weak typeof(imgLeft) weakImgLeft = imgLeft;
    [_lbLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakImgLeft);
        
    }];
    
    
    _lbLeft.font = kFont(30);
    
    _lbLeft.textColor = [UIColor whiteColor];
    
    _lbLeft.textAlignment = NSTextAlignmentCenter;
    
    //
    _lbRight = [[UILabel alloc] init];
    
    [self addSubview:_lbRight];
    
    __weak typeof(imgRight) weakImgRight = imgRight;
    [_lbRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(weakImgRight);
        
    }];
    
    
    _lbRight.font = kFont(30);
    
    _lbRight.textColor = [UIColor whiteColor];
    
    _lbRight.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lbResult = [[UILabel alloc] init];
    
    [self addSubview:lbResult];
    
    [lbResult mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakImgLeft.mas_bottom).offset(15);
        
        make.centerX.equalTo(weakImgLeft);
        
    }];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(pushToRadarView:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 1000;
    [self addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        
        make.left.mas_equalTo(86 / 2);
        
        make.size.mas_equalTo(kReal(250));
        
    }];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1001;
    [rightBtn addTarget:self action:@selector(pushToRadarView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(15);
        
        make.right.mas_equalTo(-86 / 2);
        
        make.size.mas_equalTo(kReal(250));
        
    }];
    
    
    
    lbResult.text = @"效果评估";
    
    lbResult.textColor = [UIColor whiteColor];
    
    lbResult.textAlignment = NSTextAlignmentCenter;
    
    lbResult.font = kFont(17);
    
    UILabel *lbTrust = [[UILabel alloc] init];
    
    [self addSubview:lbTrust];
    
    [lbTrust mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakImgRight.mas_bottom).offset(15);
        
        make.centerX.equalTo(weakImgRight);
        
    }];
    
    lbTrust.text = @"信任评估";
    
    lbTrust.textColor = [UIColor whiteColor];
    
    lbTrust.textAlignment = NSTextAlignmentCenter;
    
    lbTrust.font = kFont(17);
    

}

-(void)pushToRadarView:(UIButton *)button{
    if (self.pushRadarViewBlock) {
        self.pushRadarViewBlock(button.tag);
    }
}


- (void)setSelectEvaModel:(HYSelectEvaluationModel *)selectEvaModel{
    
    _selectEvaModel = selectEvaModel;
    imgLeft.progressTotal = [[_selectEvaModel.effectnum toString] floatValue] + [[_selectEvaModel.effect_othernum toString] floatValue];
    imgLeft.progressCounter = [[_selectEvaModel.effectnum toString] floatValue];
    
    imgRight.progressTotal = [[_selectEvaModel.trustnum toString] floatValue] + [[_selectEvaModel.trust_othernum toString] floatValue];;
    imgRight.progressCounter = [[_selectEvaModel.trustnum toString] floatValue];
    
    
    _lbLeft.text = [NSString stringWithFormat:@"%@分",[self notRounding:[[_selectEvaModel.effectnum toString] floatValue] afterPoint:1]];
    
    _lbRight.text = [NSString stringWithFormat:@"%@分",[self notRounding:[[_selectEvaModel.trustnum toString] floatValue] afterPoint:1]];
    
}

//-(void)setVisitModel:(VisitModel *)visitModel{
//    _visitModel = visitModel;
//    imgLeft.progressTotal = 5;//总分
//    imgRight.progressTotal = 5;
//    RLMResults *effectRes = [Visit_evaluateModel objectsWhere:@" visit_id == %@ AND mark == %@",visitModel.id,@"0"];
//    if (effectRes.count != 0) {
//        float point = [[effectRes valueForKeyPath:@"evaluatesetModel.@avg.evaluatevalue"] floatValue];
//        _lbLeft.text = [NSString stringWithFormat:@"%@分",[self notRounding:point afterPoint:1]];
//        imgLeft.progressCounter = point;//评估得分
//
//    }else{
//        _lbLeft.text = @"0.0分";
//        imgLeft.progressCounter = 0.0;
//    }
//    RLMResults *trustRes = [Visit_evaluateModel objectsWhere:@" visit_id == %@ AND mark == %@",visitModel.id,@"1"];
//    if (trustRes.count != 0) {
//        float point = [[trustRes valueForKeyPath:@"evaluatesetModel.@avg.evaluatevalue"] floatValue];
//        _lbRight.text = [NSString stringWithFormat:@"%@分",[self notRounding:point afterPoint:1]];
//        imgRight.progressCounter = point;
//
//    }else{
//        _lbRight.text = @"0.0分";
//        imgRight.progressCounter = 0.0;
//    }
//
//}
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
