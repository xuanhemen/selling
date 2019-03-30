//
//  HYWeikeVC.m
//  SLAPP
//
//  Created by yons on 2018/10/31.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYWeikeVC.h"
#import <Masonry/Masonry.h>

@interface HYWeikeVC ()<UIWebViewDelegate,WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation HYWeikeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] init];
    [self.view addSubview:self.webView];
    self.title = @"微课";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tcp.xslp.cn/weike/win"]]];
    self.webView.navigationDelegate = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
    }];
    
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    UIView *line = [[UIView alloc] init];
    [view addSubview:line];
    line.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qf_closeVC"] style:UIBarButtonItemStylePlain target:self action:@selector(closeVCButtonClick)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    UIButton *refreshButton = [[UIButton alloc] init];
    [refreshButton setImage:[UIImage imageNamed:@"qf_web_refresh"] forState:UIControlStateNormal];
    [view addSubview:refreshButton];
    refreshButton.tag = 1000;
    [refreshButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48.5);
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(view.mas_centerX);
    }];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"qf_web_back"] forState:UIControlStateNormal];
    [view addSubview:backButton];
    backButton.tag = 2000;
    [backButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48.5);
        make.bottom.mas_equalTo(0);
        make.right.equalTo(refreshButton.mas_left).mas_offset(-30);
    }];
    
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setImage:[UIImage imageNamed:@"qf_web_next"] forState:UIControlStateNormal];
    [view addSubview:nextButton];
    nextButton.tag = 3000;
    [nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48.5);
        make.bottom.mas_equalTo(0);
        make.left.equalTo(refreshButton.mas_right).mas_offset(30);
    }];
    
    //监听UIWindow隐藏
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)closeVCButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
            {
                [self.webView reload];
            }
            break;
        case 2000:
        {
            if ([self.webView canGoBack]) {
                [self.webView goBack];
            }
        }
            break;
        case 3000:
        {
            if ([self.webView canGoForward]) {
                [self.webView goForward];
            }
        }
            break;
        default:
            break;
    }
    
}


//WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"是否允许这个导航");
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    //    Decides whether to allow or cancel a navigation after its response is known.
    
    NSLog(@"知道返回内容之后，是否允许加载，允许加载");
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载");
    //[self showProgress];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"跳转到其他的服务器");
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页开始接收网页内容");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"网页导航加载完毕");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //self.title = webView.title;
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable ss, NSError * _Nullable error) {
        NSLog(@"----document.title:%@---webView title:%@",ss,webView.title);
    }];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
}


-(void)endFullScreen{
    NSLog(@"退出全屏");
    [[UIApplication sharedApplication]setStatusBarHidden:false animated:false];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    
}
@end
