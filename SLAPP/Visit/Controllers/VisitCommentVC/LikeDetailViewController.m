//
//  LikeDetailViewController.m
//  CLApp
//
//  Created by rms on 17/1/12.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//

#import "LikeDetailViewController.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "LoginAndIncrementWebService.h"
#import "LikeDetailCell.h"



@interface LikeDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LikeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赞过的人";
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerStartFefresh)];
    self.tableView = tableView;
}
-(void)setCommentModel:(HYCommentModel *)commentModel{

    _commentModel = commentModel;
//    NSMutableArray *commenderArr = [NSMutableArray array];
//    if ([commentModel.commenders isNotEmpty]) {
//        if ([commentModel.commenders containsString:@","]) {
//            [commenderArr addObjectsFromArray:[commentModel.commenders componentsSeparatedByString:@","]];
//        }else{
//            [commenderArr addObject:commentModel.commenders];
//        }
//    }
//
//    self.memberModels = [MemberModel objectsWhere:@"userid IN %@",commenderArr];

}
///**
// *  下拉刷新
// */
//-(void)headerStartFefresh
//{
//    kWeakS(weakSelf);
//
//    [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
//     {
//         [weakSelf.tableView.mj_header endRefreshing];
//         dispatch_async(dispatch_get_main_queue(), ^{
//             if (weakSelf.visitModel.isInvalidated) {
//                 [weakSelf toastWithText:@"该拜访已不存在"];
//                 NSInteger index = weakSelf.navigationController.childViewControllers.count - 2;
//                 for (int i = (int)weakSelf.navigationController.childViewControllers.count - 1; i < weakSelf.navigationController.childViewControllers.count; i--) {
//
//                     UIViewController *vc = weakSelf.navigationController.childViewControllers[i];
//                     if ([vc isKindOfClass:[VisitCommentViewController class]]) {
//                         index = i - 1;
//                     }
//                     if ([vc isKindOfClass:[VisitDetailViewController class]]) {
//                         index = i - 1;
//                     }
//                     if ([vc isKindOfClass:[MessageCenterViewController class]]) {
//                         index = i;
//                     }
//                 }
//                 UIViewController *vc = weakSelf.navigationController.childViewControllers[index];
//                 [weakSelf.navigationController popToViewController:vc animated:YES];
//
//                 return;
//             }
//
//             if (weakSelf.commentModel.isInvalidated) {
//                 [weakSelf toastWithText:@"该评论已不存在"];
//                 UIViewController *vc = weakSelf.navigationController.childViewControllers[weakSelf.navigationController.childViewControllers.count - 3];
//                 [weakSelf.navigationController popToViewController:vc animated:YES];
//                 return;
//             }
//             weakSelf.commentModel = weakSelf.commentModel;
//
//             [weakSelf.tableView reloadData];
//         });
//
//     } fail:^(NSDictionary *result)
//     {
//         [weakSelf dismiss];
//         [weakSelf.tableView.mj_header endRefreshing];
//     }];
//
//}

#pragma mark tableview dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.commentModel) {
        if ([self.commentModel.commenderUsers isNotEmpty]) {
            return [self.commentModel.commenderUsers  count];
        }
    }
    return  0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LikeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeDetailCell"];
    if (!cell) {
        cell = [[LikeDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LikeDetailCell"];
    }
    NSDictionary *dic = self.commentModel.commenderUsers[indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head"]]] placeholderImage:[UIImage imageNamed:@"mine_avatar"]];
    cell.nameLabel.text = dic[@"realname"];
    
//    MemberModel *model = [self.memberModels objectAtIndex:indexPath.row];
//    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
@end
