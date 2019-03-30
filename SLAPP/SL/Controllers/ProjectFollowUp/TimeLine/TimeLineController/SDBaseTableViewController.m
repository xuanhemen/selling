//
//  SDBaseTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */
#import "ChatKeyBoardMacroDefine.h"
#import "SDBaseTableViewController.h"

@interface SDBaseTableViewController ()

@end

@implementation SDBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,MAIN_SCREEN_WIDTH ,MAIN_SCREEN_HEIGHT_PX-NAV_HEIGHT)];
    
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(void)addEmptyAndClickRefresh:(void (^)(void))refresh{
    
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"noDataRemind"
                                                             titleStr:@"暂无数据"
                                                            detailStr:nil
                                                          btnTitleStr:@"刷新试试"
                                                        btnClickBlock:^{
                                                            refresh();
                                                        }];
    emptyView.subViewMargin = 36.f;
    
    emptyView.titleLabFont = [UIFont systemFontOfSize:15.f];
    emptyView.titleLabTextColor = kgreenColor;
    
    emptyView.actionBtnFont = [UIFont systemFontOfSize:15.f];
    emptyView.actionBtnTitleColor = [UIColor whiteColor];
    emptyView.actionBtnHeight = 40.f;
    emptyView.actionBtnHorizontalMargin = 74.f;
    emptyView.actionBtnCornerRadius = 20.f;
    emptyView.actionBtnBackGroundColor = kgreenColor;
    
    self.tableView.ly_emptyView = emptyView;
    
}


- (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    
    
    
    NSString *outputStr =
    
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL, /* allocator */
                                                                 
                                                                 (__bridge CFStringRef)input,
                                                                 
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 
                                                                 kCFStringEncodingUTF8);
    
    return outputStr;
    
}
@end
