//
//  WorkbenchVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/10.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "HYScheduleVC.h"
#import "WorkbenchVC.h"
#import "QFHeader.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"

#import "HYContactVC.h"
#import "HYClientVC.h"
#import "HYClientPoolVC.h"
#import "DashboardVC.h"
#import "QFProjectViewController.h"
#import "HYWeikeVC.h"
#import "HYVisitHomeVC.h"

#import "HYSubFenxiVC.h"
#import "HYCarryDownVC.h"
@interface WorkbenchVC ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)NSMutableArray *topArray;
@property (nonatomic,strong)NSMutableArray *bodyArray;

@property (nonatomic,strong)HYRecordView *recordView;
@property (nonatomic,assign)BOOL is_root;

@end

@implementation WorkbenchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.topArray = [NSMutableArray array];
    self.bodyArray = [NSMutableArray array];
    
    NSArray *topArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"QF_TOPARRAY"];
    if (topArray) {
        [self.topArray addObjectsFromArray:topArray];
        [self configTopView];
    }
    NSArray *bodyArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"QF_BODYARRAY"];
    if (bodyArray) {
        [self.bodyArray addObjectsFromArray:bodyArray];
        [self configOtherView];
    }
    
    self.is_root = NO;
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)fetchData{
    __weak WorkbenchVC *weakSelf = self;
    //    UserModel *model = [UserModel getUserModel];
    //    版本号加00  从这版开始添加结转功能
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"number"] = @"17000";
    params[@"platform"] = @"ios";
    [HYBaseRequest getPostWithMethodName:@"pp.workbench.index" Params:[params addToken] showToast:YES Success:^(NSDictionary *result) {
        
        [weakSelf.topArray removeAllObjects];
        [weakSelf.bodyArray removeAllObjects];
        [weakSelf.topArray addObjectsFromArray:result[@"top"][@"list"]];
        [weakSelf.bodyArray addObjectsFromArray:result[@"body"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.topArray forKey:@"QF_TOPARRAY"];
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.bodyArray forKey:@"QF_BODYARRAY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (UIView *view in weakSelf.view.subviews) {
            [view removeFromSuperview];
        }
        [weakSelf configTopView];
        [weakSelf configOtherView];
        weakSelf.is_root = [[NSString stringWithFormat:@"%@",result[@"is_root"]] boolValue];
    } fail:^(NSDictionary *result) {
    }];
}
- (void)configUI{
    
    self.view.backgroundColor = kBackColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, 34)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightMedium];
    titleLabel.text = @"工作台";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    self.navigationItem.leftBarButtonItem = item;
    
}
- (void)configTopView{
    
    CGFloat width = kScreenWidth/4;
    
    for (int i=0; i<self.topArray.count; i++) {
        NSDictionary *dict = self.topArray[i];
        UIView *view = [self configButtonWithFrame:CGRectMake(width*i, 0, width, width) andTag:1000+i andDict:dict andisHaveGround:NO];
        [self.view addSubview:view];
    }
    
}
- (void)configOtherView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenWidth/4, kScreenWidth, kScreenHeight-QFTopHeight-QFTabBarHeight-kScreenWidth/4)];
    self.scrollView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.view addSubview:self.scrollView];
    
    CGFloat y = 0;
    for (int i=0; i<self.bodyArray.count; i++) {
        NSArray *subArray = self.bodyArray[i][@"list"];
        NSString *title = self.bodyArray[i][@"name"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y+10, kScreenWidth,29)];
        label.text = title;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        
        y = y+40;
        CGFloat width = (kScreenWidth-3)/4.0;
        
        for (int j=0; j<subArray.count; j++) {
            NSDictionary *dict = subArray[j];
            UIView *view = [self configButtonWithFrame:CGRectMake((width+1)*(j%4), y+(width+1)*(j/4), width, width) andTag:1000+i*1000+4+j andDict:dict andisHaveGround:YES];
            [self.scrollView addSubview:view];
        }
        CGFloat cnt = 0;
        if (subArray.count%4==0) {
            cnt = subArray.count/4;
        }else{
            cnt = subArray.count/4+1;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake((subArray.count%4)*(width+1), width*(cnt-1)+cnt-1 + y, kScreenWidth-(subArray.count%4)*width-1, width)];
            view.backgroundColor = UIColorFromRGB(0xFFFFFF);
            [self.scrollView addSubview:view];
        }
        y = width*cnt+cnt-1 + y;
    }
    self.scrollView.contentSize = CGSizeMake(0, y);
    
}
- (UIView *)configButtonWithFrame:(CGRect)frame andTag:(NSInteger)tag andDict:(NSDictionary *)dict andisHaveGround:(BOOL)isHave{
    BOOL isGray = NO;
    if ([dict[@"exists"] integerValue]==1) {
        isGray =YES;
    }
    NSString *key = dict[@"key"];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/4, (frame.size.height/2-20)/2, frame.size.width/2, frame.size.height/2)];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"qf_%@_img",key]];
    [view addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y, frame.size.width, 20)];
    titleLabel.text = dict[@"name"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLabel];
    
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.8;
    whiteView.hidden = YES;
    [view addSubview:whiteView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    if (isHave) {
        view.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:13];
        if (isGray) {
            whiteView.hidden = NO;
        }else{
            whiteView.hidden = YES;
        }
    }else{
        whiteView.hidden = YES;
        view.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        if (isGray) {
            imageView.alpha = 0.5;
            titleLabel.alpha = 0.5;
        }else{
            imageView.alpha = 1;
            titleLabel.alpha = 1;
        }
    }
    
    return view;
}

- (void)buttonAction:(UIButton *)sender{
    NSDictionary *dict;
    if (sender.tag<1004) {
        dict = self.topArray[sender.tag-1000];
    }else{
        NSInteger section = (sender.tag-1004)/1000;
        NSInteger row = (sender.tag-1004)%1000;
        dict = self.bodyArray[section][@"list"][row];
    }
    
    NSString *key = dict[@"key"];
    NSString *name = dict[@"name"];
    NSLog(@"%@--%@",key,name);
    // 处理跳转 **********  **********  **********  **********
    if ([key isEqualToString:@"clue"]) {//线索
        
                SLMyCluesVC * cvc = [[SLMyCluesVC alloc]init];
                cvc.title = @"我的线索";
                cvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:cvc animated:YES];
        
       // [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"client"]) {//客户
        
        MyCustomListViewController *vc = [[UIStoryboard storyboardWithName:@"CustomPool" bundle:nil] instantiateViewControllerWithIdentifier:@"MyCustomListViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
        //        HYClientVC *vc = [[HYClientVC alloc] init];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:vc animated:YES];
        //        return;
    }
    if ([key isEqualToString:@"project"]) {//项目
        QFProjectViewController *vc = [[QFProjectViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"contact"]) {//联系人
        HYContactVC *vc = [[HYContactVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"cl"]) {//拜访
        //        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        HYVisitHomeVC *visitHomeVC = [[HYVisitHomeVC alloc] init];
        [self.navigationController pushViewController:visitHomeVC animated:true];
        
        return;
    }
    if ([key isEqualToString:@"schedule"]) {//日程
        HYScheduleVC * vc = [[HYScheduleVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
        
        //        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        //        return;
    }
    if ([key isEqualToString:@"clues_circle"]) {//线索圈
        
                SLPublicCluesPoolVC * pvc = [[SLPublicCluesPoolVC alloc]init];
                pvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pvc animated:YES];
        
    //    [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"client_pool"]) {//客户池
        //        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        //        return;
        // 之前写的客户池
        //        HYClientPoolVC *vc = [[HYClientPoolVC alloc] init];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:vc animated:YES];
        
        CustomPoolListViewController *vc = [[UIStoryboard storyboardWithName:@"CustomPool" bundle:nil] instantiateInitialViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"statistics_analyze"]) {//统计分析
        DashboardVC *vc = [[DashboardVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"activity"]) {//活动
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"small_class"]) {//微课
        HYWeikeVC *weikeVC = [[HYWeikeVC alloc] init];
        [self.navigationController pushViewController:weikeVC animated:YES];
        return;
    }
    if ([key isEqualToString:@"compact"]) {//合同
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"invoice"]) {//发票
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"product_library"]) {//产品库
        ProductInformationVC *vc = [[ProductInformationVC alloc] init];
        vc.is_root = self.is_root;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"file"]) {//文件
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
        
    }
    if ([key isEqualToString:@"address_list"]) {//通讯录
        DepartmentVC *vc = [[DepartmentVC alloc] init];
        vc.is_root = self.is_root;
        vc.is_Address = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([key isEqualToString:@"sweep_card"]) {//扫名片
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"knowledge_base"]) {//知识库
        [self toastWithText:@"别急别急，很快上线 ~ " andDruation:0.5];
        return;
    }
    if ([key isEqualToString:@"consult"]) {//辅导
        TutoringVC *vc = [[TutoringVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    if ([key isEqualToString:@"carry_down"]) {//结转
        
        HYCarryDownVC *vc = [[HYCarryDownVC alloc] init];
        [self.navigationController pushViewController:vc animated:true];
        
    }
    
    if ([key isEqualToString:@"record"]) {//纪录
        
        if (![self canRecord]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的麦克风。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:sureAction];
            [self presentViewController:alertVC animated:YES completion:^{
            }];
            
            return;
            
        }
        
        
        
        
        
        if (self.recordView) {
            [self.recordView removeFromSuperview];
        }
        self.recordView = [[HYRecordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight)];
        self.recordView.target = self;
        [self.view addSubview:self.recordView];
        return;
    }
    
    
    
}



- (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
            }
        }];
    }
    return bCanRecord;
    
}


@end

