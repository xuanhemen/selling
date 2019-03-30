//
//  BottleneckAnalysisVC.m
//  SLAPP
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "BottleneckAnalysisVC.h"
#import "SLAPP-Swift.h"
#import "QFChooseDateView.h"
#import "PBottleneckTopView.h"
#import "NSString+AttributedString.h"
#import "QFRiskHeaderView.h"
#import "ProRiskListVC.h"
@interface BottleneckAnalysisVC ()
@property (nonatomic,strong) QFChooseDateView *chooseDateView;
@property (nonatomic,strong) PBottleneckTopView *top;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)UIScrollView *backScrollView;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIView *leftView;
@property (nonatomic,strong) QFRiskHeaderView *riskView;

@property (nonatomic,strong) NSString *monthString;
@property (nonatomic,strong) NSString *quarterString;
@property (nonatomic,strong) NSString *yearString;
@property (nonatomic,strong) NSString *weekString;

@property (nonatomic,assign)BOOL isSelectLeft;
@end

@implementation BottleneckAnalysisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"瓶颈分析";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.isSelectLeft = YES;
    [self configUI];
    [self configData];
}


-(void)configUI{
    
    _monthString = @"";
    _yearString = @"";
    _weekString = @"";
    _quarterString = @"";
    
    
    kWeakS(weakSelf);
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kMain_screen_height_px-kNav_height)];
    [self.view addSubview:_backScrollView];
    
    _backScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _chooseDateView = [[QFChooseDateView alloc] initWithType:0 andFrame:CGRectMake(0, 0, kScreenWidth, 70)];
    _chooseDateView.currentSelect = 1;
    [_chooseDateView configUI];

    _chooseDateView.block = ^(NSString *week, NSString *month, NSString *quarter, NSString *year) {
        NSLog(@"周：%@,月：%@,季度：%@,年：%@",week,month,quarter,year);
        weakSelf.weekString = week;
        weakSelf.monthString = month;
        weakSelf.quarterString = quarter;
        weakSelf.yearString = year;
        [weakSelf configData];
    };
    [_backScrollView addSubview:_chooseDateView];
    
}


-(void)configData{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if([_yearString isNotEmpty]){
        params[@"year"] = _yearString;
    }
    if([_monthString isNotEmpty]){
        params[@"month"] = _monthString;
    }
    if([_quarterString isNotEmpty]){
        params[@"quarter"] = _quarterString;
    }
    if([_weekString isNotEmpty]){
        params[@"week"] = _weekString;
    }
    
    UserModel *model = UserModel.getUserModel;
    params[@"token"] = model.token;
    [self showProgress];
    [LoginRequest getPostWithMethodName:p_bottleneck_analysis params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        DLog(@"%@",a);
        weakSelf.data = a;
        [weakSelf showDismiss];
        
        
        weakSelf.chooseDateView.thisMonth = [NSString stringWithFormat:@"%@",a[@"this_month"]];
        weakSelf.chooseDateView.thisQuarter = [NSString stringWithFormat:@"%@",a[@"this_quarter"]];
        ;
       weakSelf.chooseDateView.thisWeek = [NSString stringWithFormat:@"%@",a[@"this_week"]];
        ;
        weakSelf.chooseDateView.thisYear = [NSString stringWithFormat:@"%@",a[@"this_year"]];
        [weakSelf refresh];
    }];
}

-(void)refresh{
    
    kWeakS(weakSelf);
    float height = [(NSArray *)_data[@"re_stage_arr"] count]*80 +40;
    if (!_top) {
        _top = [[PBottleneckTopView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth-20, height)];
        _top.btnClick = ^(NSInteger tag) {
            [weakSelf addLeftViewWithTag:tag];
            [weakSelf addRiskViewWithTag:tag];
            if (weakSelf.isSelectLeft == NO) {
                [weakSelf btnClick:weakSelf.rightBtn];
            }
        };
        [_backScrollView addSubview:_top];
    }else{
        if (_top.frame.size.height < height) {
            [_top removeFromSuperview];
            _top = [[PBottleneckTopView alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth-20, height)];
            _top.btnClick = ^(NSInteger tag) {
                [weakSelf addLeftViewWithTag:tag];
                [weakSelf addRiskViewWithTag:tag];
                
                if (weakSelf.isSelectLeft == NO) {
                    [weakSelf btnClick:weakSelf.rightBtn];
                }
            };
            [_backScrollView addSubview:_top];
        }
        
    }
    
    _top.data = _data;
    [_backScrollView bringSubviewToFront:_chooseDateView];
    
    [self addOtherView];
}


-(void)addOtherView{
    
    float width = (kScreenWidth -30)/2;
    
    if (_leftBtn) {
        [_leftBtn removeFromSuperview];
        [_rightBtn removeFromSuperview];
    }
    
  
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(10, CGRectGetMaxY(_top.frame)+10, width, 40);
        [_backScrollView addSubview:_leftBtn];
        [_leftBtn setTitle:@"对比" forState:UIControlStateNormal];
        _leftBtn.layer.borderWidth = 0.3;
        _leftBtn.layer.borderColor = [UIColor lightTextColor].CGColor;
        _leftBtn.backgroundColor = UIColorFromRGB(0x4DAC61);
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(20+width,CGRectGetMaxY(_top.frame)+10, width, 40);
        [_backScrollView addSubview:_rightBtn];
        [_rightBtn setTitle:@"风险" forState:UIControlStateNormal];
        _rightBtn.layer.borderWidth = 0.3;
        _rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _rightBtn.backgroundColor = [UIColor whiteColor];
        [_rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [_backScrollView addSubview:_leftBtn];
        [_backScrollView addSubview:_rightBtn];
        
        [_leftBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addLeftViewWithTag:_top.pjTag];
    [self addRiskViewWithTag:_top.pjTag];
}

-(void)btnClick:(UIButton *)btn{
    
    if (btn == _leftBtn) {
        _leftBtn.backgroundColor = UIColorFromRGB(0x4DAC61);
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.backgroundColor = [UIColor whiteColor];
        [_rightBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _riskView.hidden = YES;
        _leftView.hidden = NO;
        [_backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(_leftView.frame))];
        self.isSelectLeft = YES;
    }else{
        _rightBtn.backgroundColor = UIColorFromRGB(0x4DAC61);
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.backgroundColor = [UIColor whiteColor];
        [_leftBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        _leftView.hidden = YES;
        _riskView.hidden = NO;
        [_backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(_riskView.frame))];
        self.isSelectLeft = NO;
    }
    
}


-(void)addRiskViewWithTag:(NSInteger )tag{
    if (_riskView) {
        [_riskView removeFromSuperview];
    }
    
    NSDictionary *dic  = _data[@"dispose_arr"][tag];
    
    _riskView = [[QFRiskHeaderView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_leftBtn.frame)+10, kScreenWidth-20, 300)];
    NSArray *array = dic[@"risk_number"];
    CGFloat height = [self.riskView configUIWithData:array];
    CGRect riskFrame = self.riskView.frame;
    riskFrame.size.height = height;
    self.riskView.frame = riskFrame;
    [_backScrollView addSubview:_riskView];
    _riskView.tipLabel.text= dic[@"risk_number_name"];
    _riskView.hidden = YES;
    kWeakS(weakSelf);
    _riskView.clickIds = ^(NSString *ids) {
        ProRiskListVC *vc = [[ProRiskListVC alloc] init];
        vc.ids = ids;
        [weakSelf.navigationController pushViewController:vc animated:true];
    };
    
    
}


-(void)addLeftViewWithTag:(NSInteger )tag{
    
    if (_leftView) {
        [_leftView removeFromSuperview];
    }
    
    
    NSDictionary *dic  = _data[@"dispose_arr"][tag];
    NSArray *subArray = dic[@"contrast"];
    float height = 40*subArray.count + 40;
    
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(_leftBtn.frame)+10,kScreenWidth-20, height)];
    _leftView.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_leftView];
    
    [_backScrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(_leftView.frame))];
    
    for (int i = 0; i<[subArray count] ; i++) {
    
        UILabel *lab0 = [[UILabel alloc] init];
        lab0.frame = CGRectMake(10,20+i*40 ,_leftView.frame.size.width-10, 40);
        [_leftView addSubview:lab0];
        lab0.attributedText = [NSString htmlStr:subArray[i]];
        
        
//        lab.attributedText = [NSString ]
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
