//
//  HYVisitNotificationsVC.m
//  SLAPP
//
//  Created by apple on 2018/11/28.
//  Copyright © 2018 柴进. All rights reserved.
//
#import <RongIMLib/RCIMClient.h>
#import "HYVisitNotificationsVC.h"
#import "HYVisitNotificationsDelegate.h"
#import "PraiseCell.h"
#import "VisitCommentDetailViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface HYVisitNotificationsVC ()
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)HYVisitNotificationsDelegate *delegate;
@end

@implementation HYVisitNotificationsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.nameStr;
    [self configUI];
    [self configData];
    
    [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_SYSTEM targetId:self.id];
}


-(void)configUI{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_table];
    _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTab_height+49);
    } ];
    
    _table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
    
    UIView *nilView = [[UIView alloc] init];
    _table.tableFooterView = nilView;
    [_table registerNib:[UINib nibWithNibName:@"PraiseCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PraiseCell"];
    _delegate = [[HYVisitNotificationsDelegate alloc] initWithCellIde:@"PraiseCell" AndAutoCellHeight:0 modelKey:@"model" AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, id model) {
        
        RCMessage *cModel = (RCMessage *)model;
        
        if ([cModel.content isKindOfClass:[RCTextMessage class]]) {
            NSDictionary *dic =  [self makeStringJson:((RCTextMessage *)cModel.content).extra];
            if ([dic[@"data"] isNotEmpty] && [dic[@"data"][@"id"] isNotEmpty]) {
                VisitCommentDetailViewController *vc = [[VisitCommentDetailViewController alloc] init];
                vc.commentId = [NSString stringWithFormat:@"%@",dic[@"data"][@"id"]];
                [weakSelf.navigationController pushViewController:vc animated:true];
            }
            
        }

        
    }];
    
    
    _table.delegate = _delegate;
    _table.dataSource = _delegate;
}


-(id)makeStringJson:(NSString *)value{
    NSData * data = [value dataUsingEncoding:NSUTF8StringEncoding];
    if (![data isNotEmpty]) {
        return @"";
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return result;
}


-(void)configData{
    
    if (_delegate.dataArray.count > 0) {
        
        RCMessage *model = _delegate.dataArray.lastObject;
        NSArray *array = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_SYSTEM targetId:self.id objectName:nil baseMessageId:model.messageId isForward:true count:20];
        [_delegate.dataArray addObjectsFromArray:array];
       
        
    }else{
        NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_SYSTEM targetId:self.id count:20];
        [_delegate.dataArray addObjectsFromArray:array];
    }
    
    
    [_table.mj_footer endRefreshing];
    [_table reloadData];
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
