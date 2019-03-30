//
//  HYLoginBuyVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/14.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLoginBuyVC.h"
#import "QFHeader.h"
#import "QFProjectNavBar.h"

@interface HYLoginBuyVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *webString;
@property (nonatomic,strong) NSString *currentString;
@end

@implementation HYLoginBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak HYLoginBuyVC *weakSelf = self;
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *isOnline  =  [NSString stringWithFormat:@"%@",info[@"EnvironmentIsOnline"]];
    
    self.webString = @"http://t-oppo.xslp.cn/h5/product/intro.html?id=1&src=app&src_d=ios";
    if ([isOnline isEqualToString: @"1"]) {
        self.webString = @"https://oppo.xslp.cn/h5/product/intro.html?id=1&src=app&src_d=ios";
    }else{
        
    }
    self.currentString = self.webString;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, QFTopHeight, kScreenWidth, kScreenHeight-QFTopHeight)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webString]]];
    
    [self.view addSubview:self.webView];
    QFProjectNavBar *navBar = [[QFProjectNavBar alloc] init];
    [navBar configOnlyTitle:@"产品介绍" andHaveRight:NO];
    [navBar addBack];
    navBar.backBtnClick = ^{
        [weakSelf backClick];
    };
    [self.view addSubview:navBar];
    
    UIButton *goBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 20, 44, 44)];
    [goBackBtn setImage:[UIImage imageNamed:@"qf_close"] forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(gobackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:goBackBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showProgress];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissProgress];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self dissmissWithError];
}
    
-(void)backClick{
    if ([self.webString isEqualToString:self.currentString]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.webView goBack];
    }
}
- (void)gobackButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    self.currentString = [request.URL relativeString];
    
    return YES;
}



@end
