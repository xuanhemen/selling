//
//  HYAddTagVC.m
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYAddTagVC.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
@interface HYAddTagVC ()<UITextFieldDelegate>

@end

@implementation HYAddTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义类型";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightItemClick{
    [self.textField resignFirstResponder];
    if (!self.textField.text.isNotEmpty) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    __weak HYAddTagVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    NSDictionary *params = @{@"token":model.token,@"name":[NSString stringWithFormat:@"%@",self.textField.text]};
    NSString *urlString = @"pp.followup.add_followup_class";
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlString Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
}


#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}
- (void)textFieldEditChanged:(UITextField *)textField{
    //    if (textField.text.length>=8) {
    //        textField.text = [textField.text substringWithRange:NSMakeRange(0, 8)];
    //    }
    
    NSString * temp = textField.text;
    
    
    if (textField.markedTextRange ==nil){
        
        while(1){
            if ([self convertToInt:temp] <= 16) {
                break;
            }else{
                temp = [temp substringToIndex:temp.length-1];
            }
        }
        textField.text=temp;
    }
}
- (int)convertToInt:(NSString*)strtemp{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
@end
