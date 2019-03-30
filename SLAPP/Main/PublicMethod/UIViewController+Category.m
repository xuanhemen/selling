//
//  UIViewController+Category.m
//  CLApp
//
//  Created by 吕海瑞 on 16/8/15.
//  Copyright © 2016年 xslp_ios. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)
 static char myKey;
- (void)setRightBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 35, 50);
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.titleLabel.font = kFont(15);
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setRightBtnWith:(UIButton *)btn
{
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)leftClick:(UIButton *)btn
{
    
}

- (void)rightClick:(UIButton *)btn
{
    if (self.rightBtnDidClick) {
        self.rightBtnDidClick();
    }
}

-(void (^)())rightBtnDidClick{

     return objc_getAssociatedObject(self, &myKey);
}

-(void)setRightBtnDidClick:(void (^)())rightBtnDidClick{
   
    objc_setAssociatedObject(self, &myKey, rightBtnDidClick, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setRightBtnsWithArray:(NSArray *)titleArray
{
    if (![titleArray isNotEmpty])
    {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i <titleArray.count;i++)
    {
        NSString *titleStr = titleArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 50, 50);
        btn.tag = 1000+i;
        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [array addObject:rightItem];
    }
    self.navigationItem.rightBarButtonItems = array;

}


- (void)setRightBtnsWithImages:(NSArray *)imageArray
{
    if (![imageArray isNotEmpty])
    {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i <imageArray.count;i++)
    {
        NSString *titleStr = imageArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.tag = 1000+i;
//        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:titleStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [array addObject:rightItem];
    }
    self.navigationItem.rightBarButtonItems = array;

}

- (void)setleftBtnsWithImages:(NSArray *)imageArray{
    if (![imageArray isNotEmpty])
    {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i <imageArray.count;i++)
    {
        NSString *imageStr = imageArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 25, 25);
        btn.tag = 2000+i;
        //        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        [array addObject:leftItem];
    }
    self.navigationItem.leftBarButtonItems = array;

}
-(void)addAlertViewWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles okAction:(void (^)(UIAlertAction *action))ok cancleAction:(void (^)(UIAlertAction *action))cancle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < actionTitles.count; i++) {
        if (i == 0) {
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ok(action);
            }];
            [alertController addAction:okAction];
            
            

            
        }
        if (i > 0 && i == actionTitles.count - 1) {
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionTitles[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                cancle(action);
            }];
            [alertController addAction:cancelAction];
            
        }
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
