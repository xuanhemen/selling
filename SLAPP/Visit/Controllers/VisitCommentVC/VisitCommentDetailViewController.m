//
//  VisitCommentDetailViewController.m
//  CLApp
//
//  Created by rms on 17/1/9.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//
#import "SLAPP-Swift.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "VisitCommentDetailViewController.h"
#import "CommentCell.h"
#import "ReplyDetailCell.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "TZImagePickerController.h"
//#import "CorrelationVC.h"
//#import "CorrelationModel.h"
#import "CommentBottomView.h"
//#import "LoginAndIncrementWebService.h"
#import "MJRefresh.h"
#import "LikeView.h"
#import "LikeDetailViewController.h"
//#import "NoDataView.h"
//#import "MessageCenterViewController.h"
#import "VisitCommentViewController.h"
//#import "VisitDetailViewController.h"
#import "NSString+AttributedString.h"
#import "UploadManager.h"
#define HEADERLABEL_HEIGHT 36.0
#define CommentBottomView_Height 44.0

@interface VisitCommentDetailViewController ()<UITableViewDelegate, UITableViewDataSource,ReplyDetailCellDelegate,ChatKeyBoardDelegate, ChatKeyBoardDataSource,TZImagePickerControllerDelegate>
@property(nonatomic,strong) UITableView *commentDetailTableView;
//@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y
@property (nonatomic, assign) CGFloat seletedCellHeight;//记录点击cell的高度，高度由代理传过来
//专门用来回复选中的cell的model
@property (nonatomic, strong) HYReplyModel *replayTheSeletedCellModel;


@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset

@property (nonatomic,copy)NSIndexPath *currentIndexPath;

@property(nonatomic,assign)BOOL selectAtBtn;
@property(nonatomic,strong)NSMutableArray *selectedAssets;
@property(nonatomic,strong)NSMutableArray *selectedPhotos;
@property(nonatomic,strong)NSMutableArray *sendersArr;//@的对象
@property(nonatomic,strong)NSMutableArray *faceNameArr;
@property(nonatomic,strong) CommentBottomView *commentBottomView;
//@property(nonatomic,strong)RLMResults *replyModels;
//@property (strong, nonatomic) NoDataView *nodataView;
@property(nonatomic,strong)HYCommentModel *model;
@end
static BOOL hasPic;

@implementation VisitCommentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论详情";
    
    hasPic = NO;
    self.sendersArr = [NSMutableArray array];
    self.faceNameArr = [NSMutableArray array];
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self initSubViews];
    [self configData];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.commentDetailTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.selectAtBtn) {
        [self.chatKeyBoard keyboardUpforComment];
        self.selectAtBtn = NO;
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.chatKeyBoard keyboardDownForComment];
}
-(void)initSubViews{
    
    self.commentDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerStartFefresh)];
    [self.view addSubview:self.commentDetailTableView];
    
//    [self.commentDetailTableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.commentDetailTableView registerClass:[ReplyDetailCell class] forCellReuseIdentifier:@"ReplyDetailCell"];
    
    
    kWeakS(weakSelf);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(window) weakWindow= window;
    self.commentBottomView.commentBtnClickBlock = ^(){
        //不是点击cell进行回复，则置空replayTheSeletedCellModel，因为这个时候是点击回复按钮进行回复，
        weakSelf.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = NO;
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",weakSelf.model.realname];
        weakSelf.history_Y_offset = [weakSelf.commentBottomView.commentBtn convertRect:weakSelf.commentBottomView.commentBtn.bounds toView:weakWindow].origin.y;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    
    [self.view addSubview:self.commentBottomView];
}




-(void)configData{
    
//    kVisitCommentDetail
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] =  self.commentId;
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kVisitCommentDetail Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf.commentDetailTableView.mj_header endRefreshing];
        [weakSelf dismissProgress];
        if ([result isNotEmpty]) {
            weakSelf.model = [HYCommentModel mj_objectWithKeyValues:result];
            [weakSelf.commentDetailTableView reloadData];
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
}




/**
 *  下拉刷新
 */
-(void)headerStartFefresh
{
//    kWeakS(weakSelf);
    [self configData];
//    [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
//     {
//         [weakSelf dismiss];
//         [weakSelf.commentDetailTableView.mj_header endRefreshing];
//         if (weakSelf.visitModel.isInvalidated) {
//             [weakSelf toastWithText:@"该拜访已不存在"];
//             NSInteger index = weakSelf.navigationController.childViewControllers.count - 2;
//             for (int i = (int)weakSelf.navigationController.childViewControllers.count - 1; i < weakSelf.navigationController.childViewControllers.count; i--) {
//
//                 UIViewController *vc = weakSelf.navigationController.childViewControllers[i];
//                 if ([vc isKindOfClass:[VisitCommentViewController class]]) {
//                     index = i - 1;
//                 }
//                 if ([vc isKindOfClass:[VisitDetailViewController class]]) {
//                     index = i - 1;
//                 }
//                 if ([vc isKindOfClass:[MessageCenterViewController class]]) {
//                     index = i;
//                 }
//             }
//             UIViewController *vc = weakSelf.navigationController.childViewControllers[index];
//             [weakSelf.navigationController popToViewController:vc animated:YES];
//             return;
//         }
//
//         if (weakSelf.model.isInvalidated) {
//             [weakSelf toastWithText:@"该评论已不存在"];
//             [weakSelf.navigationController popViewControllerAnimated:YES];
//
//             return;
//         }
//
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [weakSelf.commentDetailTableView reloadData];
//         });
//
//     } fail:^(NSDictionary *result)
//     {
//         [weakSelf dismiss];
//         [weakSelf.commentDetailTableView.mj_header endRefreshing];
//     }];
    
}

#pragma mark 处理测试数据
-(void)dealData{

//    self.replyModels = [[ReplyModel objectsWhere:@"comment_id == %@",self.model.id] sortedResultsUsingKeyPath:@"addtime" ascending:NO];

}
/*
-(void)showNodata:(CGFloat)y
{
    if (self.replyModels.count == 0)
    {
        kWeakS(weakSelf);
        if (!self.nodataView)
        {
            self.nodataView = [NoDataView loadBundleNib];
            self.nodataView.frame = CGRectMake(0, y, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - y - CommentBottomView_Height);
            [self.commentDetailTableView addSubview:self.nodataView];
//            self.nodataView.resetBtn.hidden = YES;
            self.nodataView.titleLable.text = @"暂无回复";
            [self.nodataView.resetBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
            self.nodataView.resetBtnClick = ^(){
                [weakSelf showProgress];
                [weakSelf headerStartFefresh];
            };

        }
        else
        {
//            self.nodataView.resetBtn.hidden = YES;
            self.nodataView.titleLable.text = @"暂无回复";
            [self.nodataView.resetBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
            self.nodataView.resetBtnClick = ^(){
                [weakSelf showProgress];
                [weakSelf headerStartFefresh];
            };
            
        }
    }
    else
    {
        if (self.nodataView) {
            [self.nodataView removeFromSuperview];
            self.nodataView = nil;
        }
    }
    
}
*/
#pragma mark tableview dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model) {
        return self.model.replys.count;
    }
//    if (self.replyModels.count == 0) {
//        return 1;
//    }
//    return self.replyModels.count;
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
   CommentCell *cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    cell.deleteBtn.hidden = YES;
    cell.replyBtn.hidden = YES;
    cell.tableView.hidden = YES;
    if (self.model) {
        [cell configCellWithModel:self.model indexPath:nil];
    }
    
    cell.replyDetailBtn.hidden = YES;
    cell.backgroundColor = HexColor(@"F1F1F1");
    //点击九宫格
    kWeakS(weakSelf);
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    //点赞
    cell.LikeBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        [weakSelf likeVisitComment:weakSelf.model];
    };
    //删除
    cell.DeleteBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        [weakSelf delVisitComment:indexPath];
    };
   
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor whiteColor];
    label.text = self.model.replys.count?@"      全部回复":@"     暂无回复";
    label.font = kFont_Big;
    label.textColor = HexColor(@"333333");
    [cell addSubview:label];
    __weak typeof(cell)weakCell = cell;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(weakCell.mas_bottom);
        make.height.mas_equalTo(HEADERLABEL_HEIGHT);
    }];
    //绿色bar
    UIView *bar = [[UIView alloc] init];
    bar.backgroundColor = kgreenColor;
    [cell addSubview:bar];
    [bar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kGAP);
        make.centerY.equalTo(label);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(17);
    }];

//    NSMutableArray *commenderArr = [NSMutableArray array];
    NSMutableArray *imgStrArr = [NSMutableArray array];
    if ([self.model.commenderUsers isNotEmpty]) {
//         [commenderArr addObject:self.model.commenderUsers];
//        if ([self.model.commenders containsString:@","]) {
//            [commenderArr addObjectsFromArray:[self.model.commenders componentsSeparatedByString:@","]];
//        }else{
//            [commenderArr addObject:self.model.commenders];
//        }
        
        for (NSDictionary *dic in self.model.commenderUsers) {
            [imgStrArr addObject:[dic[@"head"] toString]];
        }
    }
    
//    for (NSString *str in commenderArr) {
//        MemberModel *memberModel = [MemberModel objectsWhere:@"userid == %@",str].firstObject;
//        [imgStrArr addObject:memberModel.head];
//    }
    LikeView *likeView = [[LikeView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44) dataSource:imgStrArr];
    likeView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:likeView];
    [likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(label.mas_top);
        make.height.mas_equalTo(44);
    }];
    
    [likeView.rightBtn addTarget:self action:@selector(lookLikersClick) forControlEvents:UIControlEventTouchUpInside];
//    [[likeView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        LikeDetailViewController *likeVc = [[LikeDetailViewController alloc]init];
//        likeVc.visitModel = weakSelf.visitModel;
//        likeVc.commentModel = weakSelf.model;
//        [weakSelf.navigationController pushViewController:likeVc animated:YES];
//    }];
    return cell;
}

-(void)lookLikersClick{
    
            LikeDetailViewController *likeVc = [[LikeDetailViewController alloc]init];
//            likeVc.visitModel = weakSelf.visitModel;
            likeVc.commentModel = self.model;
            [self.navigationController pushViewController:likeVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    kWeakS(weakSelf);
    
//    CGFloat h = [tableView fd_heightForCellWithIdentifier:@"CommentCell" configuration:^(CommentCell * cell) {
//        if (weakSelf.model) {
//            cell.tableView.hidden = YES;
//            [cell configCellWithModel:self.model indexPath:nil];
//        }
//    }];
    
    if (!self.model) {
        return 0;
    }
    
    CGFloat h = [CommentCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        CommentCell *cell = (CommentCell *)sourceCell;
        cell.tableView.hidden = YES;
        [cell configCellWithModel:self.model indexPath:nil];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : weakSelf.model.id,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(NO)};
        return cache;
    }];

//    CGFloat h = 100;
    return h + HEADERLABEL_HEIGHT + 44;

}
#pragma mark- tableView sectionFooterHeight
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (void)reloadCellHeightForModel:(HYReplyModel *)model atIndexPath:(NSIndexPath *)indexPath{
    [self.commentDetailTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.model) {
        return nil;
    }
//    if (self.model.replys.count == 0) {
//        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noDataViewCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
////        self.nodataView = [NoDataView loadBundleNib];
//        //            self.nodataView.resetBtn.hidden = YES;
////        self.nodataView.titleLable.text = @"暂无回复";
////        [self.nodataView.resetBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
////        kWeakS(weakSelf);
////        self.nodataView.resetBtnClick = ^(){
////            [weakSelf showProgress];
////            [weakSelf headerStartFefresh];
////        };
//
//        [cell.contentView addSubview:self.nodataView];
//        [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(0);
//            make.height.mas_equalTo((MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - [self tableView:tableView heightForHeaderInSection:0] - CommentBottomView_Height) > CGRectGetMaxY(self.nodataView.resetBtn.frame) + 45 ? (MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - [self tableView:tableView heightForHeaderInSection:0] - CommentBottomView_Height) : CGRectGetMaxY(self.nodataView.resetBtn.frame) + 45);
//        }];
//
//        return cell;
//
//    }
    ReplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReplyDetailCell"];
    if (!cell) {
        cell = [[ReplyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReplyDetailCell"];
        
    }
    cell.delegate = self;
    __weak __typeof(self) weakSelf= self;
//    __weak typeof(tableView)weakTable = tableView;
//    __weak typeof(cell)weakCell = cell;
     HYReplyModel *model = [self.model.replys objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    //点赞
    cell.LikeBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        [weakSelf likeVisitReply:model];
    };
    //删除
    cell.DeleteBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        [weakSelf delVisitReply:model];
    };

    //点击九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.model) {
        return 0;
    }
    if (self.model.replys.count > 0) {

        HYReplyModel *replyModel = [self.model.replys objectAtIndex:indexPath.row];
//        CGFloat h = [tableView fd_heightForCellWithIdentifier:@"ReplyDetailCell" configuration:^(ReplyDetailCell * cell) {
//            [cell configCellWithModel:replyModel indexPath:indexPath];
//        }];
        CGFloat h = [ReplyDetailCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            ReplyDetailCell *cell = (ReplyDetailCell *)sourceCell;
            [cell configCellWithModel:replyModel indexPath:indexPath];
        } cache:^NSDictionary *{
            NSDictionary *cache = @{kHYBCacheUniqueKey : replyModel.id,
                                    kHYBCacheStateKey  : @"",
                                    kHYBRecalculateForStateKey : @(YES)};
            return cache;
        }];
        return h;
    }
    return 0;
//    return (MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - [self tableView:tableView heightForHeaderInSection:0] - CommentBottomView_Height) > CGRectGetMaxY(self.nodataView.resetBtn.frame) + 45 ? (MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - [self tableView:tableView heightForHeaderInSection:0] - CommentBottomView_Height) : CGRectGetMaxY(self.nodataView.resetBtn.frame) + 45;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.replyModels.count > 0) {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        ReplyModel *replyModel = [self.replyModels objectAtIndex:indexPath.row];
//
//        if ([replyModel.userid isEqualToString:[UserModel getUserModel].id]) {
//            [self delVisitReply:replyModel];
//        }else{
//            CGFloat cell_height = [ReplyDetailCell hyb_heightForTableView:self.commentDetailTableView config:^(UITableViewCell *sourceCell) {
//                ReplyDetailCell *cell = (ReplyDetailCell *)sourceCell;
//                [cell configCellWithModel:replyModel indexPath:indexPath];
//            } cache:^NSDictionary *{
//                NSDictionary *cache = @{kHYBCacheUniqueKey : replyModel.id,
//                                        kHYBCacheStateKey : @"",
//                                        kHYBRecalculateForStateKey : @(NO)};
//                return cache;
//            }];
//            self.needUpdateOffset = NO;
//            self.replayTheSeletedCellModel = replyModel;
//            self.currentIndexPath = indexPath;
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",replyModel.realname];
//            ReplyDetailCell *cell = [self.commentDetailTableView cellForRowAtIndexPath:indexPath];
//            self.history_Y_offset = [cell.descLabel convertRect:cell.descLabel.bounds toView:window].origin.y;
//            self.seletedCellHeight = cell_height;
//            [self.chatKeyBoard keyboardUpforComment];
//        }
//    }
}

#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight<=271) {//解决搜狗输入法三次调用此方法的bug、
        //        IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        //        获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次:282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    if (self.seletedCellHeight){//点击某行，进行回复某人
        delta = self.history_Y_offset  - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight-kChatToolBarHeight);
    }else{//点击回复按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.commentDetailTableView.contentOffset;
    offset.y += (delta - CommentBottomView_Height);
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.commentDetailTableView setContentOffset:offset animated:YES];
    }
}

#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
    }];
    self.needUpdateOffset = NO;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.chatKeyBoard keyboardDownForComment];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.chatKeyBoard keyboardDownForComment];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(UITableView *)commentDetailTableView{
    
    if (!_commentDetailTableView) {
        _commentDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - CommentBottomView_Height) style:UITableViewStyleGrouped];
        _commentDetailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _commentDetailTableView.backgroundColor = [UIColor whiteColor];
        _commentDetailTableView.delegate = self;
        _commentDetailTableView.dataSource = self;
        _commentDetailTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _commentDetailTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 0.1)];
        
    }
    return _commentDetailTableView;
}

-(CommentBottomView *)commentBottomView{
    
    if (!_commentBottomView) {
        _commentBottomView = [[CommentBottomView alloc]initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT_PX - CommentBottomView_Height - NAV_HEIGHT, MAIN_SCREEN_WIDTH, CommentBottomView_Height)];
        _commentBottomView.detailBtn.hidden = YES;
        [_commentBottomView.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenWidth - 2 * 15);
        }];
        [_commentBottomView.commentBtn setTitle:@"  回复两句" forState:UIControlStateNormal];
    }
    return _commentBottomView;
}
-(ChatKeyBoard *)chatKeyBoard{
    
    if (!_chatKeyBoard) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowCamera = YES;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        
    }
    return _chatKeyBoard;
}
#pragma mark -- ChatKeyBoardDataSource

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemCamera normal:@"add_image_default" high:@"add_image_focus" select:nil];
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"add_emoj_default" high:@"add_emoj_focus" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemAt normal:@"at_default" high:@"at_focus" select:nil];
    
    return @[item1, item2, item3];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
#pragma mark -- ChatKeyBoardDelegate


- (void)chatKeyBoardSendText:(NSString *)text{
    if (!hasPic && !text.length) {
        [self toastWithText:@"请输入回复内容"];
        return;
    }
    
    NSString * content = [NSString base64EncodeString:text];
    kWeakS(weakSelf);
    if (hasPic) {
        NSString *passport;
        NSDictionary *info = [NSBundle mainBundle].infoDictionary;
        NSString *isOnline = [info[@"EnvironmentIsOnline"] toString];
        if ([isOnline integerValue] == 1){
            passport = @"https://passport.xslp.cn/index.php?s=";
        }else{
            passport = @"https://t-passport.xslp.cn/index.php?s=";
        }
        
        NSString *imageUrl = @"User/Upload/only_upload";
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"dir"] = @"Followup";
        
        NSMutableDictionary *imageSuccess = [NSMutableDictionary dictionary];
        [self showProgress];
        DLog(@"%@",[passport stringByAppendingString:imageUrl]);
        [UploadManager uploadImagesWith:self.selectedPhotos :[passport stringByAppendingString:imageUrl] :[params addToken] uploadFinish:^{
            [weakSelf dismissProgress];
            if (imageSuccess.count == 0) {
                [self toastWithText:@"图片上传失败，请重新上传" andDruation:5];
                return ;
            }
            NSArray * imageArray = [imageSuccess.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 intValue] > [obj2 intValue];
            }];
            NSMutableArray *sendImage = [NSMutableArray array];
            for (NSString * key in imageArray) {
                [sendImage addObject:imageSuccess[key]];
            }

                [weakSelf addVisitReply:content Files:sendImage];
            
            
        } success:^(NSDictionary *imgDic, int idx) {
            [imageSuccess setObject:imgDic forKey:[NSString stringWithFormat:@"%d",idx]];
        } failure:^(NSError *error, int idx) {
            
        }];
    }else{
        
            [self addVisitReply:content Files:nil];
        
    }
    
    
    
    
    
    
    
    
    
//    for (NSString *faceName in self.faceNameArr) {
//        if ([text containsString:faceName]) {
//            NSString *faceNameTemp = [NSString stringWithString:[faceName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            
//            text = [text stringByReplacingOccurrencesOfString:faceName withString:faceNameTemp];
//        }
//    }
//    text = [NSString stringWithString:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    text = [text urlEncode];
//    kWeakS(weakSelf);
//    if (hasPic) {
//        NSMutableArray *photoArr = [NSMutableArray array];
//
//        [self showProgressWithStr:@"正在发送..."];
//        for (int i = 0; i < self.selectedPhotos.count; i++) {
//            UIImage *image = self.selectedPhotos[i];
//            NSMutableArray *tempPhotoArr = [NSMutableArray array];
//            [SolutionWebService solutionAddFileWithImage:image Success:^(NSDictionary *result)
//             {
//                 [tempPhotoArr addObject:@"0"];
//                 [tempPhotoArr addObject:result[@"data"][@"filename"]];
//                 [tempPhotoArr addObject:result[@"data"][@"filenewname"]];
//                 [photoArr addObject:tempPhotoArr];
//                 if (photoArr.count == self.selectedPhotos.count) {
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                         [weakSelf addVisitReply:text Files:photoArr];
//                     });
//
//                 }
//             } fail:^(NSDictionary *result)
//             {
//
//             }];
//
//        }
//
//    }else{
//        [self showProgressWithStr:@"正在发送..."];
//        [self addVisitReply:text Files:nil];
//    }
    
}
-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectPicBtnClick:(UIButton *)btn{
    kWeakS(weakSelf);
    [self.chatKeyBoard keyboardDownForComment];
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    if (hasPic) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    }
    // 3. 设置是否可以选择视频/图片/原图/Gif
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (hasPic == NO) {
            CGRect frame =  weakSelf.chatKeyBoard.chatToolBar.frame;
            
            frame.size.height += kPicViewHeight + 5;
            weakSelf.chatKeyBoard.chatToolBar.frame = frame;
            weakSelf.chatKeyBoard.allowPic = YES;
            hasPic = YES;
            
        }
        weakSelf.chatKeyBoard.chatToolBar.picView.picsArr = photos;
        weakSelf.selectedAssets = [NSMutableArray arrayWithArray:assets];
        weakSelf.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        [weakSelf.chatKeyBoard keyboardUpforComment];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard atBtnDidClick:(UIButton *)btn{
   
    
    [self.chatKeyBoard keyboardDownForComment];
    self.selectAtBtn = YES;
    HYColleaguesVC *vc = [[HYColleaguesVC alloc] init];
    
    kWeakS(weakSelf);
    [self.navigationController pushViewController:vc animated:true];
    __block NSString *tempStr = @"";
    vc.selectWithMembers = ^(NSArray<MemberModel *> * _Nonnull array) {
        if (array) {
            for (MemberModel *model in array) {
                tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"@%@",[model.name toString]]];
                [weakSelf.sendersArr addObject:model];
            }
        }
        
        [weakSelf.chatKeyBoard.chatToolBar setTextViewContent:[NSString stringWithFormat:@"%@%@",weakSelf.chatKeyBoard.chatToolBar.textView.text,tempStr]];
        weakSelf.chatKeyBoard.sendersArr = weakSelf.sendersArr;
    };
    
//    CorrelationVC *vc = [[CorrelationVC alloc]init];
//    vc.type = 3;//为了不执行其他type的操作,这里是写死的数字
//    vc.visitModel = self.visitModel;
//    vc.isAt = YES;
//    vc.title = @"选择同事";
//    kWeakS(weakSelf);
//    vc.result = ^(NSArray *array){
//        if (array.count) {
//            NSString *tempStr = @"";
//            for (int i = 0; i < array.count; i++) {
//                CorrelationModel *tempModel = array[i];
//                tempStr = [tempStr stringByAppendingFormat:@"@%@",tempModel.name];
//                [weakSelf.sendersArr addObject:tempModel];
//            }
//            [weakSelf.chatKeyBoard.chatToolBar setTextViewContent:[NSString stringWithFormat:@"%@%@",weakSelf.chatKeyBoard.chatToolBar.textView.text,tempStr]];
//            weakSelf.chatKeyBoard.sendersArr = weakSelf.sendersArr;
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard delPicBtnDidClick:(UIButton *)btn{
    [self.selectedAssets removeObjectAtIndex:btn.tag - 10];
    [self.selectedPhotos removeObjectAtIndex:btn.tag - 10];
    if (self.selectedPhotos.count == 0) {
        
        CGRect frame =  self.chatKeyBoard.chatToolBar.frame;
        frame.size.height -= kPicViewHeight + 5;
        self.chatKeyBoard.chatToolBar.frame = frame;
        hasPic = NO;
        self.chatKeyBoard.chatToolBar.allowPic = NO;
    }
    self.chatKeyBoard.chatToolBar.picView.picsArr = self.selectedPhotos;
    
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    [self.faceNameArr addObject:faceName];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    
    [self.chatKeyBoard keyboardUpforComment];
}

-(void)delVisitComment:(NSIndexPath *)indexPath{
    kWeakS(weakSelf);
    [self addAlertViewWithTitle:@"温馨提示" message:@"您确定要删除该评论吗?" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"id"] = weakSelf.model.id;
        [weakSelf showProgressWithStr:@"正在删除..."];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = weakSelf.commentId;
        [HYBaseRequest getPostWithMethodName:kVisitDelegateComment Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        
        
//        [VisitWebService delVisitCommentWithParams:dic Success:^(NSDictionary *result) {
//            [weakSelf dismissWithSuccess:@"删除成功"];
//            [DataBaseOperation removeData:weakSelf.model];
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            });
//        } fail:^(NSDictionary *result) {
//
//        }];
    } cancleAction:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
}

-(void)likeVisitComment:(HYCommentModel *)model{
    kWeakS(weakSelf);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"id"] = model.id;
    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:kPraiseVisitComment Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf configData];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
//    [VisitWebService setGoodVisitCommentWithParams:dic Success:^(NSDictionary *result) {
//        [weakSelf dismissWithSuccess:@"操作成功"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [weakSelf.commentDetailTableView reloadData];
//        });
//    } fail:^(NSDictionary *result) {
//
//    }];
    
}
-(void)addVisitReply:(NSString *)text Files:(NSMutableArray *)files{
    
    kWeakS(weakSelf);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    
    dic[@"comment_id"] = self.model.id;
    dic[@"content"] = text;
    if (self.sendersArr && self.sendersArr.count) {
        NSArray *idsArray  = [self.sendersArr valueForKeyPath:@"id"];
        dic[@"senders"] = [idsArray componentsJoinedByString:@","];
    }
    dic[@"parent_id"] = [self.replayTheSeletedCellModel isNotEmpty]?self.replayTheSeletedCellModel.id:@"0";
    dic[@"files"] = files;
    
    

    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:kAddCommentReply Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf clearKeyBoard];
        [weakSelf configData];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
    
    
    
//    [VisitWebService addVisitReplyWithParams:dic Success:^(NSDictionary *result) {
//        [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
//         {
//             [weakSelf dismiss];
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 [weakSelf.commentDetailTableView reloadData];
//             });
//             [weakSelf.chatKeyBoard keyboardDownForComment];
//             weakSelf.chatKeyBoard.placeHolder = nil;
//             if (hasPic) {
//
//                 CGRect frame =  weakSelf.chatKeyBoard.chatToolBar.frame;
//                 frame.size.height -= kPicViewHeight + 5;
//                 weakSelf.chatKeyBoard.chatToolBar.frame = frame;
//                 hasPic = NO;
//             }
//             weakSelf.chatKeyBoard.chatToolBar.allowPic = NO;
//             [weakSelf.chatKeyBoard.chatToolBar clearTextViewContent];
//             [weakSelf.sendersArr removeAllObjects];
//         } fail:^(NSDictionary *result){
//
//         }];
//
//    } fail:^(NSDictionary *result) {
//
//    }];

}


/**
 更新本地某一条评论数据  刷新UI
 
 @param index <#index description#>
 @param result 最近的数据
 */
-(void)updateCellWithIndex:(NSIndexPath *)index Result:(NSDictionary*)result{
    if ([result isNotEmpty]) {
        HYCommentModel * model = [HYCommentModel mj_objectWithKeyValues:result];
        if (model){
//            NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.comment];
//            array[index.row] = model;
//            self.model. = array;
            self.model = model;
            [self.commentDetailTableView reloadData];
        }
    }
    
}



-(void)likeVisitReply:(HYReplyModel *)model{
    kWeakS(weakSelf);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[@"id"] = model.id;
    [self showProgress];
    
    [HYBaseRequest getPostWithMethodName:kPraiseVisitReply Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
       
        NSInteger index = [self.model.replys indexOfObject:model];
        
        HYReplyModel *model = [HYReplyModel mj_objectWithKeyValues:result];
        NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.model.replys];
        if (index < array.count) {
            array[index] = model;
            self.model.replys = array;
            [weakSelf.commentDetailTableView reloadData];
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
//    [VisitWebService setGoodVisitReplyWithParams:dic Success:^(NSDictionary *result) {
//        [weakSelf dismissWithSuccess:@"操作成功"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [weakSelf.commentDetailTableView reloadData];
//        });
//    } fail:^(NSDictionary *result) {
//
//    }];
    
}

-(void)delVisitReply:(HYReplyModel *)replyModel{
    kWeakS(weakSelf);
    
    [self addAlertViewWithTitle:@"温馨提示" message:@"您确定要删除该条回复吗?" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"id"] = replyModel.id;
        [weakSelf showProgressWithStr:@"正在删除..."];
        
        [HYBaseRequest getPostWithMethodName:kVisitDelegateReply Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            [weakSelf configData];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        

    } cancleAction:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
}


-(void)clearKeyBoard{
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
    if (hasPic) {
        ////
        CGRect frame =  self.chatKeyBoard.chatToolBar.frame;
        frame.size.height -= kPicViewHeight + 5;
        self.chatKeyBoard.chatToolBar.frame = frame;
        hasPic = NO;
    }
    self.chatKeyBoard.chatToolBar.allowPic = NO;
    [self.chatKeyBoard.chatToolBar clearTextViewContent];
    [self.sendersArr removeAllObjects];
    
}
@end
