//
//  VisitCommentViewController.m
//  CLApp
//
//  Created by rms on 17/1/5.
//  Copyright © 2017年 xslp_ios. All rights reserved.
//
#import "SLAPP-Swift.h"
#import <MJExtension/MJExtension.h>
#import "HYCommentListModel.h"
#import "NSString+AttributedString.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "UploadManager.h"
#import "VisitCommentViewController.h"
#import "VisitBaseInfoHeaderView.h"
#import "CommentCell.h"
#import "ReplyCell.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "TZImagePickerController.h"
//#import "CorrelationVC.h"
//#import "CorrelationModel.h"
#import "VisitCommentDetailViewController.h"
#import "MJRefresh.h"
//#import "LoginAndIncrementWebService.h"
#import "CommentBottomView.h"
//#import "NoDataView.h"
//#import "MessageCenterViewController.h"
//#import "VisitDetailViewController.h"

#define HEADERVIEW_HEIGHT 100.0
#define HEADERLABEL_HEIGHT 36.0
#define CommentBottomView_Height 44.0

@interface VisitCommentViewController ()<UITableViewDelegate, UITableViewDataSource,CommentCellDelegate,ChatKeyBoardDelegate, ChatKeyBoardDataSource,TZImagePickerControllerDelegate>
@property(nonatomic,strong) VisitBaseInfoHeaderView *headerView;
@property(nonatomic,strong) UITableView *commentTableView;
//@property (nonatomic, strong) NSMutableArray *dataSource;
//@property(nonatomic,strong)RLMResults *commentModels;

@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y
@property (nonatomic, assign) CGFloat seletedCellHeight;//记录点击cell的高度，高度由代理传过来
@property (nonatomic, assign) CGFloat keyboardHeight;
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
@property(nonatomic,assign)BOOL isComment;

//// 通过这个值,无限家在数据.
@property (nonatomic,assign) NSInteger index;
//@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property(nonatomic,strong) UILabel *commentNumLabel;
//@property (strong, nonatomic) NoDataView *nodataView;

@property(nonatomic,strong)HYCommentListModel *model;


@end
static BOOL hasPic;

@implementation VisitCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论列表";
    self.isComment = NO;
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
    [self dealData];
    [self initHeaderView];
    [self initTableView];
    [self initBottomView];
    [self configData];
}




-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.commentTableView reloadData];
//    self.commentNumLabel.text = self.commentModels.count?[NSString stringWithFormat:@" 最新评论(%ld)",self.commentModels.count ]:@" 暂无评论";
    [self showNodata];
}




-(void)configData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visit_id"] = self.visitId;
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kVisitCommentList Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        [weakSelf.commentTableView.mj_header endRefreshing];
        
        if ([result isNotEmpty]) {
            HYCommentListModel *model = [HYCommentListModel mj_objectWithKeyValues:result];
            weakSelf.model = model;
            [weakSelf refreshUI];
            
        }
        
        [weakSelf dismissProgress];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
}

-(void)refreshUI{
    [self dealData];
    [self.commentTableView reloadData];
    [self.commentTableView layoutIfNeeded];
    [self.commentTableView setContentOffset:CGPointMake(0,0) animated:NO];
     self.commentNumLabel.text = self.model.comment ? [NSString stringWithFormat:@" 最新评论(%ld)",self.model.comment.count ]:@" 暂无评论";
    self.headerView.commentListModel = self.model;
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
-(void)initHeaderView{

    self.headerView = [[VisitBaseInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, HEADERVIEW_HEIGHT)];
//    self.headerView.model = self.visitModel;
    [self.view addSubview:self.headerView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), MAIN_SCREEN_WIDTH, HEADERLABEL_HEIGHT)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = HexColor(@"333333");
//    label.text = self.commentModels.count?[NSString stringWithFormat:@" 最新评论(%ld)",self.commentModels.count ]:@" 暂无评论";
    label.font = kFont_Big;
    self.commentNumLabel = label;
    UIView *lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) - 0.5, MAIN_SCREEN_WIDTH, 0.5)];
//    lineViewBottom.backgroundColor = kSepLineColor;
    [self.view addSubview:label];
    [self.view addSubview:lineViewBottom];
}

-(void)initTableView{

    self.commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerStartFefresh)];
    [self.commentTableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    [self.view addSubview:self.commentTableView];
}
-(void)initBottomView{

    kWeakS(weakSelf);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(window) weakWindow= window;
    self.commentBottomView.commentBtnClickBlock = ^(){
        weakSelf.isComment = YES;
       weakSelf.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = NO;
        weakSelf.chatKeyBoard.placeHolder = @"写点什么吧";
        weakSelf.history_Y_offset = [weakSelf.commentBottomView.commentBtn convertRect:weakSelf.commentBottomView.commentBtn.bounds toView:weakWindow].origin.y;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    
    [self.view addSubview:self.commentBottomView];
}
/**
 *  下拉刷新
 */
-(void)headerStartFefresh
{
    [self configData];
//    kWeakS(weakSelf);
//    BOOL hasShowAll = NO;
//    if (self.commentModels.count == self.index) {
//        hasShowAll = YES;
//    }
//    [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
//     {
//         [self dismiss];
//         [weakSelf dismiss];
//         [weakSelf.commentTableView.mj_header endRefreshing];
//         if (weakSelf.visitModel.isInvalidated) {
//             [weakSelf toastWithText:@"该拜访已不存在"];
//             NSInteger index = weakSelf.navigationController.childViewControllers.count - 2;
//
//             for (int i = (int)weakSelf.navigationController.childViewControllers.count - 1; i < weakSelf.navigationController.childViewControllers.count; i--) {
//
//                 UIViewController *vc = weakSelf.navigationController.childViewControllers[i];
//
//                 if ([vc isKindOfClass:[VisitDetailViewController class]]) {
//                     index = i - 1;
//                 }
//
//                 if ([vc isKindOfClass:[MessageCenterViewController class]]) {
//                     index = i;
//                 }
//             }
//             UIViewController *vc = weakSelf.navigationController.childViewControllers[index];
//
//             [weakSelf.navigationController popToViewController:vc animated:YES];
//
//             return;
//         }
//
//         if (hasShowAll) {
//             weakSelf.index += (weakSelf.commentModels.count - weakSelf.index);
//         }
//         dispatch_async(dispatch_get_main_queue(), ^{
//             [weakSelf.commentTableView reloadData];
//             weakSelf.commentNumLabel.text = weakSelf.commentModels.count?[NSString stringWithFormat:@" 最新评论(%ld)",weakSelf.commentModels.count ]:@" 暂无评论";
//             [weakSelf showNodata];
//
//         });
//
//     } fail:^(NSDictionary *result)
//     {
//         [weakSelf dismiss];
//         [weakSelf.commentTableView.mj_header endRefreshing];
//     }];
//
}

#pragma mark 处理测试数据
-(void)dealData{
//    self.commentModels = [[HYCommentModel objectsWhere:@"visit_id == %@",self.visitModel.id] sortedResultsUsingKeyPath:@"addtime" ascending:NO];
    if (!self.model) {
        return;
    }
    if (!self.model.comment) {
        return;
    }
//    if (self.model.comment.count > 10 ) {
//        self.index = 10;
//    }else{
        self.index = self.model.comment.count;
//    }
}
-(void)showNodata
{
//    if (self.commentModels.count == 0)
//    {
//        kWeakS(weakSelf);
//        if (!self.nodataView)
//        {
//            self.nodataView = [NoDataView loadBundleNib];
//            self.nodataView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - HEADERVIEW_HEIGHT - HEADERLABEL_HEIGHT - CommentBottomView_Height);
//            [self.commentTableView addSubview:self.nodataView];
////            self.nodataView.resetBtn.hidden = YES;
//            self.nodataView.titleLable.text = @"暂无评论";
//            [self.nodataView.resetBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
//            self.nodataView.resetBtnClick = ^(){
//                [weakSelf showProgress];
//                [weakSelf headerStartFefresh];
//            };
//
//        }
//        else
//        {
////            self.nodataView.resetBtn.hidden = YES;
//            self.nodataView.titleLable.text = @"暂无评论";
//            [self.nodataView.resetBtn setTitle:@"刷新数据" forState:UIControlStateNormal];
//            self.nodataView.resetBtnClick = ^(){
//                [weakSelf showProgress];
//                [weakSelf headerStartFefresh];
//            };
//
//        }
//    }
//    else
//    {
//        if (self.nodataView) {
//            [self.nodataView removeFromSuperview];
//            self.nodataView = nil;
//        }
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.comment.count == self.index) {
        
        self.commentTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
    }
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        
    }
    cell.delegate = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    __weak __typeof(window) weakWindow= window;
    __weak __typeof(self) weakSelf= self;
    __weak typeof(cell)weakCell = cell;
    __weak typeof(tableView)weakTable = tableView;
    __block HYCommentModel *model = [self.model.comment objectAtIndex:indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
//    if (indexPath.row == self.index - 1 && (self.model.comment.count - self.index) > 0) {
//
//        self.index +=((self.model.comment.count - self.index)/10 > 0)?10:(self.model.comment.count - self.index);
//
//        // 加载后续的数据
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [weakSelf.commentTableView reloadData];
//        });
//    }
//    回复
    cell.ReplyBtnClickBlock = ^(UIButton *replyBtn,NSIndexPath * indexPath)
    {
        //不是点击cell进行回复，则置空replayTheSeletedCellModel，因为这个时候是点击回复按钮进行回复，
        weakSelf.isComment = NO;
        weakSelf.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = NO;
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",model.realname];
        weakSelf.history_Y_offset = [replyBtn convertRect:replyBtn.bounds toView:weakWindow].origin.y;
        NSIndexPath *index= [weakTable indexPathForCell:weakCell];
        weakSelf.currentIndexPath = index;
     
       
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    //点赞
    cell.LikeBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        NSIndexPath *index= [weakTable indexPathForCell:weakCell];
        if (index) {
            [weakSelf likeVisitComment:index];
        }
        
    };
    
   
    //删除
    cell.DeleteBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        NSIndexPath *index= [weakTable indexPathForCell:weakCell];
        if (index) {
             [weakSelf delVisitComment:index];
        }
       
    };
    //更多
    cell.MoreBtnClickBlock = ^(NSIndexPath * indexPath)
    {
        
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        VisitCommentDetailViewController *vc = [[VisitCommentDetailViewController alloc]init];
//        vc.commentId = weakCell.
////        vc.visitModel = weakSelf.visitModel;
////        vc.model = model;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //点击九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource,NSIndexPath *indexpath){
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.model || !self.model.comment) {
        return 0;
    }
    
    return self.index < self.model.comment.count ? self.index : self.model.comment.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    HYCommentModel *commentModel = [self.model.comment objectAtIndex:indexPath.row];
    CGFloat h = [CommentCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
       CommentCell *cell = (CommentCell *)sourceCell;
        [cell configCellWithModel:commentModel indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : commentModel.id,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(YES)};
        return cache;
    }];

//    CGFloat h = [tableView fd_heightForCellWithIdentifier:@"CommentCell" configuration:^(CommentCell  *cell) {
//        cell.tableView.hidden = YES;
//        [cell configCellWithModel:commentModel indexPath:indexPath];
//    }];
    
    return h;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
    VisitCommentDetailViewController *vc = [[VisitCommentDetailViewController alloc]init];
//    vc.visitModel = self.visitModel;
    HYCommentModel *model = [self.model.comment objectAtIndex:indexPath.row];
    vc.commentId = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - passCellHeightWithModel

- (void)passCellHeightWithCommentModel:(HYCommentModel *)commentModel replyModel:(HYReplyModel *)replyModel atCommentIndexPath:(NSIndexPath *)commentIndexPath cellHeight:(CGFloat )cellHeight replyCell:(ReplyCell *)replyCell commentCell:(CommentCell *)commentCell{
    
     self.currentIndexPath = [self.commentTableView indexPathForCell:commentCell];
    
    if ([replyModel.delete integerValue] == 1 ) {
        [self delVisitReply:replyModel];
    }else{
        self.isComment = NO;
        self.needUpdateOffset = NO;
        self.replayTheSeletedCellModel = replyModel;
//        self.currentIndexPath = [self.commentTableView indexPathForCell:commentCell];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",replyModel.realname];
        self.history_Y_offset = [replyCell.contentLabel convertRect:replyCell.contentLabel.bounds toView:window].origin.y;
        self.seletedCellHeight = cellHeight;
        [self.chatKeyBoard keyboardUpforComment];
    }
}
- (void)reloadCellHeightForModel:(HYCommentModel *)model atIndexPath:(NSIndexPath *)indexPath{
    [self.commentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    self.keyboardHeight = keyboardHeight;
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
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight-kChatToolBarHeight);
    }else{//点击评论按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.commentTableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.commentTableView setContentOffset:offset animated:YES];
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
-(UITableView *)commentTableView{

    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEADERVIEW_HEIGHT + HEADERLABEL_HEIGHT, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT_PX - NAV_HEIGHT - HEADERVIEW_HEIGHT - HEADERLABEL_HEIGHT - CommentBottomView_Height) style:UITableViewStylePlain];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
//        if (self.commentModels.count > 10) {
//
//            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44)];
//            lb.text = @"正在加载...";
//            lb.textColor = [UIColor blackColor];
//            lb.font = kFont_Big;
//            lb.textAlignment = NSTextAlignmentCenter;
//            _commentTableView.tableFooterView = lb;
//        }else{
//            _commentTableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 0.1)];
//
//        }
        

    }
    return _commentTableView;
}

//- (UIActivityIndicatorView *)activity
//{
//    if (!_activity) {
//        _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//
//        _activity.center = self.view.center;
//
//        _activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//
//        [self.view addSubview:_activity];
//    }
//    return _activity;
//}

-(CommentBottomView *)commentBottomView{
    
    if (!_commentBottomView) {
        _commentBottomView = [[CommentBottomView alloc]initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT_PX - CommentBottomView_Height - NAV_HEIGHT, MAIN_SCREEN_WIDTH, CommentBottomView_Height)];
        _commentBottomView.detailBtn.hidden = YES;
        [_commentBottomView.commentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MAIN_SCREEN_WIDTH - 2 * 15);
        }];
        [_commentBottomView.commentBtn setTitle:@"  评论一下" forState:UIControlStateNormal];
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
        [self toastWithText:self.isComment?@"请输入评论内容":@"请输入回复内容"];
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
            if (weakSelf.isComment) {
                [weakSelf addVisitComment:content Files:sendImage];
            }else{
                [weakSelf addVisitReply:content Files:sendImage];
            }
            
        } success:^(NSDictionary *imgDic, int idx) {
            [imageSuccess setObject:imgDic forKey:[NSString stringWithFormat:@"%d",idx]];
        } failure:^(NSError *error, int idx) {
            
        }];
    }else{
       
        if (self.isComment) {
            [self addVisitComment:content Files:nil];
        }else{
            [self addVisitReply:content Files:nil];
        }
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
//        __block NSString *tempText = text;
        
        [self showProgressWithStr:@"正在发送..."];
//        for (int i = 0; i < self.selectedPhotos.count; i++) {
//            UIImage *image = self.selectedPhotos[i];
//            NSMutableArray *tempPhotoArr = [NSMutableArray array];
//            [SolutionWebService solutionAddFileWithImagePic:image Success:^(NSDictionary *result)
//             {
//                 [tempPhotoArr addObject:@"0"];
//                 [tempPhotoArr addObject:result[@"data"][@"filename"]];
//                 [tempPhotoArr addObject:result[@"data"][@"filenewname"]];
//                 [photoArr addObject:tempPhotoArr];
//                 if (photoArr.count == self.selectedPhotos.count) {
//                     dispatch_async(dispatch_get_main_queue(), ^{
//
//                         if (weakSelf.isComment) {
//                             [weakSelf addVisitComment:text Files:photoArr];
//
//                         }else{
//                             [weakSelf addVisitReply:text Files:photoArr];
//                         }
//
//                     });
//
//                 }
//             } fail:^(NSDictionary *result)
//             {
//
//             }];
//
//        }
        
//    }else{
//        [self showProgressWithStr:@"正在发送..."];
//
//        if (self.isComment) {
//            [weakSelf addVisitComment:text Files:nil];
//        }else{
//            [weakSelf addVisitReply:text Files:nil];
//
//        }
//    }
    
//        [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
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
//-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectFaceBtnClick:(BOOL)select{
//    CGPoint offset = self.commentTableView.contentOffset;
//    if (select) {
//
//        offset.y -= (self.keyboardHeight - kFacePanelHeight);
//    }else{
//        offset.y += (self.keyboardHeight - kFacePanelHeight);
//    }
////    if (offset.y < 0) {
////        offset.y = 0;
////    }
//    if (self.needUpdateOffset) {
//        [self.commentTableView setContentOffset:offset animated:YES];
//    }
//
//}
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
//-(void)addVisitComment:(NSString *)text Files:(NSMutableArray *)files{
//    kWeakS(weakSelf);
//    NSString *senders = @"";
////    for (int i = 0; i < self.sendersArr.count; i++) {
////        CorrelationModel *model = self.sendersArr[i];
////        if (i == 0) {
////            senders = model.id;
////        }else{
////            senders = [senders stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
////        }
////        //            text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",model.name] withString:@""];
////    }
////
////    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
////    dic[@"visit_id"] = self.visitModel.id;
////    dic[@"content"] = text;
////    dic[@"senders"] = senders;
////    dic[@"files"] = files;
////    [VisitWebService addVisitCommentWithParams:dic Success:^(NSDictionary *result) {
////        [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
////         {
////             [weakSelf dismiss];
////             dispatch_async(dispatch_get_main_queue(), ^{
////                 weakSelf.commentNumLabel.text = weakSelf.commentModels.count?[NSString stringWithFormat:@" 最新评论(%ld)",weakSelf.commentModels.count ]:@" 暂无评论";
////                 [weakSelf showNodata];
////                 weakSelf.index += 1;
////                 [weakSelf.commentTableView reloadData];
////             });
////             [weakSelf.chatKeyBoard keyboardDownForComment];
////             weakSelf.chatKeyBoard.placeHolder = nil;
////             if (hasPic) {
////
////                 CGRect frame =  weakSelf.chatKeyBoard.chatToolBar.frame;
////                 frame.size.height -= kPicViewHeight + 5;
////                 weakSelf.chatKeyBoard.chatToolBar.frame = frame;
////                 hasPic = NO;
////             }
////             weakSelf.chatKeyBoard.chatToolBar.allowPic = NO;
////             [weakSelf.chatKeyBoard.chatToolBar clearTextViewContent];
////             [weakSelf.sendersArr removeAllObjects];
////         } fail:^(NSDictionary *result){
////
////         }];
////
////    } fail:^(NSDictionary *result) {
////
////    }];
//
//}



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


-(void)addVisitReply:(NSString *)text Files:(NSMutableArray *)files{
    kWeakS(weakSelf);
//    NSString *senders = @"";
    
    
    HYCommentModel *commentModel = [self.model.comment objectAtIndex:self.currentIndexPath.row];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"comment_id"] = commentModel.id;
    params[@"content"] = text;
    params[@"files"] = files;
    params[@"parent_id"] = [self.replayTheSeletedCellModel isNotEmpty]?self.replayTheSeletedCellModel.id:@"0";
    if (self.sendersArr && self.sendersArr.count) {
        NSArray *idsArray  = [self.sendersArr valueForKeyPath:@"id"];
        params[@"senders"] = [idsArray componentsJoinedByString:@","];
    }
    
    [self showProgress];
   
    [HYBaseRequest getPostWithMethodName:kAddCommentReply Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf clearKeyBoard];
        [weakSelf updateCellWithIndex:weakSelf.currentIndexPath Result:result];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
    
    
//    for (int i = 0; i < self.sendersArr.count; i++) {
//        CorrelationModel *model = self.sendersArr[i];
//        if (i == 0) {
//            senders = model.id;
//        }else{
//            senders = [senders stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
//        }
//        //            text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",model.name] withString:@""];
//    }

//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    CommentModel *commentModel = [self.commentModels objectAtIndex:self.currentIndexPath.row];
//    dic[@"comment_id"] = commentModel.id;
//    dic[@"content"] = text;
//    dic[@"senders"] = senders;
//    dic[@"parent_id"] = [self.replayTheSeletedCellModel isNotEmpty]?self.replayTheSeletedCellModel.id:@"0";
//    dic[@"files"] = files;
//    [VisitWebService addVisitReplyWithParams:dic Success:^(NSDictionary *result) {
//        [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
//         {
//             [weakSelf dismiss];
//             dispatch_async(dispatch_get_main_queue(), ^{
////                 [weakSelf reloadCellHeightForModel:commentModel atIndexPath:weakSelf.currentIndexPath];
//                 [weakSelf.commentTableView reloadData];
//             });
//             
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
-(void)delVisitComment:(NSIndexPath *)indexPath{
    kWeakS(weakSelf);
    [self addAlertViewWithTitle:@"温馨提示" message:@"您确定要删除该评论吗?" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction * _Nonnull action) {
        HYCommentModel *cModel = weakSelf.model.comment[indexPath.row];
        
        [weakSelf showProgressWithStr:@"正在删除..."];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = cModel.id;
        if (weakSelf.sendersArr && weakSelf.sendersArr.count) {
            NSArray *idsArray  = [weakSelf.sendersArr valueForKeyPath:@"id"];
            params[@"senders"] = [idsArray componentsJoinedByString:@","];
        }
        [HYBaseRequest getPostWithMethodName:kVisitDelegateComment Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            
            [weakSelf toDelCommentWith:indexPath];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        
    } cancleAction:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
}


/**
 删除评论成功后 更新本地数据，刷新UI

 @param indexPath <#indexPath description#>
 */
-(void)toDelCommentWith:(NSIndexPath *)indexPath{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.comment];
    [array removeObjectAtIndex:indexPath.row];
    self.model.comment = array;
    [self.commentTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

}


-(void)likeVisitComment:(NSIndexPath *)indexPath{
    kWeakS(weakSelf);
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    HYCommentModel *model = [weakSelf.model.comment objectAtIndex:indexPath.row];
    dic[@"id"] = model.id;
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kPraiseVisitComment Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
//        [weakSelf configData];
        [weakSelf updateCellWithIndex:indexPath Result:result];
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
    }];
    
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
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.model.comment];
            array[index.row] = model;
            self.model.comment = array;
            [self.commentTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}



/**
 删除回复

 @param replyModel <#replyModel description#>
 */
-(void)delVisitReply:(HYReplyModel *)replyModel{
    kWeakS(weakSelf);
    [self addAlertViewWithTitle:@"温馨提示" message:@"您确定要删除该条回复吗?" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic[@"id"] = replyModel.id;
        [weakSelf showProgressWithStr:@"正在删除..."];
        
        [HYBaseRequest getPostWithMethodName:kVisitDelegateReply Params:[dic addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            [weakSelf deleteReply:replyModel];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
    } cancleAction:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
}



/**
 回复删除更新UI

 @param model <#model description#>
 */
-(void)deleteReply:(HYReplyModel *)model{
    
    if (self.currentIndexPath.row < self.model.comment.count) {
        
        HYCommentModel *cModel = self.model.comment[self.currentIndexPath.row];
        NSMutableArray *array = [NSMutableArray arrayWithArray:cModel.replys];
        [array removeObject:model];
        cModel.replys = array;
        [self.commentTableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
}


/**
 添加拜访评论

 @param text <#text description#>
 @param files <#files description#>
 */
-(void)addVisitComment:(NSString *)text Files:(NSArray *)files{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"visit_id"] = self.visitId;
        params[@"content"] = text;
        params[@"files"] = files;
        [self showProgress];
        kWeakS(weakSelf);
        [HYBaseRequest getPostWithMethodName:kAddVisitComment Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            [weakSelf clearKeyBoard];
            [weakSelf configData];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        
        
    }
@end
