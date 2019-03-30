//
//  HYReservationVC.m
//  SLAPP
//
//  Created by apple on 2018/10/25.
//  Copyright © 2018 柴进. All rights reserved.
//
#define kMenuViewHeight 120
#import "OrderEmailVC.h"
#import "HYReservationVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <UMSocialCore/UMSocialCore.h>
#import "HYVisitHomeVC.h"
@interface HYReservationVC ()<UITextViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UIView *menuView;
@end

@implementation HYReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    if (self.isReservation) {
        self.title = @"预约";
    }else{
        self.title = @"发送总结";
    }
    
    [self configData];
}

-(void)configData{
    
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kVisit_Template Params:[@{@"":@""} addToken] showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf dismissProgress];
        
        if ([result isNotEmpty]) {
            weakSelf.textView.text = weakSelf.isReservation == true ? [result[@"reservationtemp"] toString ]:[result[@"summarytemp"] toString ] ;
        }
        
        DLog(@"%@",result);
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
}


- (void)configUI{
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, kMain_screen_height_px-kNav_height-kMenuViewHeight)];
    self.textView.font = kFont(15);
    self.textView.delegate = self;
    [self.view addSubview:self.textView];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.textView.typingAttributes = attributes;
    
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, kMain_screen_height_px-kMenuViewHeight-kNav_height, kScreenWidth, kMenuViewHeight)];
    self.menuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.menuView];
    NSArray *array = @[@"qq",@"wechat",@"mail",@"msg"];
    NSArray *arrayTitle = @[@"QQ",@"微信",@"邮件",@"短信"];
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 150, 20)];
    lbTitle.text = @"发送到 :";
    lbTitle.font = kFont(14);
    lbTitle.textColor = [UIColor darkTextColor];
    [self.menuView addSubview:lbTitle];
    for (int i = 0 ; i<4; i ++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+(kScreenWidth/4.)*i, 40, kScreenWidth/4., kMenuViewHeight - 40);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/8.-16, 8, 32, 32)];
        imageView.image =[UIImage imageNamed:[NSString stringWithFormat:@"share_%@",array[i]]];
        [btn addSubview:imageView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, kScreenWidth/4., 20)];
        [title setFont:[UIFont systemFontOfSize:13]];
        title.textAlignment = NSTextAlignmentCenter;
        [title setTextColor:[UIColor darkTextColor]];
        title.text = arrayTitle[i];
        [btn addSubview:title];
        [self.menuView addSubview:btn];
        
        
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    if (_isPopToRoot) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"icon-arrow-left"] style:(UIBarButtonItemStylePlain) target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    
    
}


-(void)backClick{
    
    if (_isPopToRoot) {
        
        BOOL isHave = NO;
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[HYVisitHomeVC class]])
            {
                isHave = YES;
                [self.navigationController popToViewController:vc animated:true];
                break;
            }
        }
        
        if (!isHave) {
            [self.navigationController popToRootViewControllerAnimated:true];
        }
       
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}


-(void)btnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    switch (btn.tag) {
        case 1000:
        {
            [self shareToQq];
            
        }
            break;
        case 1001:
        {
            [self shareToWechat];
        }
            break;
        case 1002:
        {
            [self shareToEmail];
        }
            break;
        case 1003:
        {
            [self sendMSM];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)runShareWithType:(UMSocialPlatformType)type AndText:(NSString *)text
{
    if (![text isNotEmpty]) {
        [self toastWithText:@"内容不能为空"];
        return;
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = text;
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
//            NSLog(@"************Share fail with error %@*********",error);
        }else{
//            NSLog(@"response data is %@",data);
        }
    }];
    
    
}


-(void)shareToQq
{
    [self runShareWithType:UMSocialPlatformType_QQ AndText:_textView.text];
}

-(void)shareToWechat
{
    [self runShareWithType:UMSocialPlatformType_WechatSession AndText:_textView.text];
    
}

-(void)shareToEmail
{
    if (!self.visitId) {
        [self toastWithText:@"拜访id为空，请返回上一级刷新数据重新进入" andDruation:5];
        return;
    }
    OrderEmailVC *vc = [[OrderEmailVC alloc]init];
    vc.isSummarytemp = !self.isReservation;
    vc.visitId = self.visitId;
    vc.emailBodyStr = self.textView.text;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  发送短信
 */
- (void)sendMSM
{
    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
        mc.messageComposeDelegate = self;
        mc.body = _textView.text;
        [self presentViewController:mc animated:YES completion:nil];
    }
    else
    {
        [self toastWithText:@"模拟器没有该功能，别点了，换真机试试"];
        
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            [self toastWithText:@"取消发送"];
        }
            break;
        case MessageComposeResultSent:
        {
            [self toastWithText:@"已发送"];
            
        }
            break;
        case MessageComposeResultFailed:
        {
            [self toastWithText:@"发送出现错误"];
            
        }
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification

{
    NSDictionary *info = [notification userInfo];
    
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect inputFieldRect = _menuView.frame;
    inputFieldRect.origin.y += yOffset;
    kWeakS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        
        if (inputFieldRect.origin.y <kScreenWidth-50) {
            weakSelf.menuView.frame = inputFieldRect;
        }
        else
        {
            weakSelf.menuView.frame = CGRectMake(0, kScreenWidth-50, kScreenWidth, 50);
        }
        
        weakSelf.textView.frame = CGRectMake(0, 64, kScreenWidth, CGRectGetMidY(weakSelf.menuView.frame)-100);
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
