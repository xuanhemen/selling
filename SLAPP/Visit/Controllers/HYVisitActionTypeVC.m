//
//  HYVisitActionTypeVC.m
//  SLAPP
//
//  Created by apple on 2018/12/5.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitActionTypeVC.h"
#import "SLAPP-Swift.h"
@interface HYVisitActionTypeVC ()<QFChooseTypeDelegate>
@property(nonatomic,strong)QFChooseTypeView *starView;
@end

@implementation HYVisitActionTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行动类型";
    
    _starView = [[QFChooseTypeView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kMain_screen_height_px-kNav_height)];
    [self.view addSubview:_starView];
    [_starView uiConfig];
    _starView.projectId = _proId;
    [_starView getStar];
    _starView.delegate = self;
    
}

- (void)chooseModelWithModel:(ProjectPlanStarModel *)model{
    if (self.starViewClick) {
        self.starViewClick(model);
    }
    [self.navigationController popViewControllerAnimated:true];
}

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
