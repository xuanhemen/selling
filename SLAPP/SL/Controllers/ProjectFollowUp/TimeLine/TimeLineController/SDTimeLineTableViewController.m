//
//  SDTimeLineTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
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

#import "SDTimeLineTableViewController.h"

#import "SDTimeLineCell.h"
#import "SDTimeLineCellModel.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"
#import "LEETheme.h"
#import "GlobalDefines.h"

#define kTimeLineTableViewCellId @"SDTimeLineCell"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "SLAPP-Swift.h"

#import "HYFollowFiltrateV.h"


static CGFloat textFieldH = 40;


@interface SDTimeLineTableViewController () <SDTimeLineCellDelegate, UITextFieldDelegate,ChatKeyBoardDataSource,ChatKeyBoardDelegate>

@property (nonatomic, strong) NSIndexPath *currentEditingIndexthPath;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong)SDTimeLineCellCommentItemModel *currentEditModel;
@property (nonatomic, strong)FollowuoMsgView *myMsgView;

@property (nonatomic, strong)NSString *currentType;
@end

@implementation SDTimeLineTableViewController

{
    CGFloat _lastScrollViewOffsetY;
    CGFloat _totalKeybordHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.title = @"项目跟进记录";
   // self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addFiltrateView];
    
    self.tableView.frame = CGRectMake(0, 40,MAIN_SCREEN_WIDTH ,MAIN_SCREEN_HEIGHT -NAV_HEIGHT-kTab_height-40);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    kWeakS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
    
   
    [self configUI];
    
    
    //LEETheme 分为两种模式 , 独立设置模式 JSON设置模式 , 朋友圈demo展示的是独立设置模式的使用 , 微信聊天demo 展示的是JSON模式的使用
    
    [self configData];
//    [self getMsgNum];
    //为self.view 添加背景颜色设置
    
    self.view.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor whiteColor]);
    
    [LEETheme startTheme:DAY];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
   
    //添加分隔线颜色设置
    
    self.tableView.lee_theme
    .LeeAddSeparatorColor(DAY , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f])
    .LeeAddSeparatorColor(NIGHT , [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f]);
    
    [self.tableView registerClass:[SDTimeLineCell class] forCellReuseIdentifier:kTimeLineTableViewCellId];
    [self addEmptyAndClickRefresh:^{
        [weakSelf configData];
    }];
    
    
    
}


- (void)configUI{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(-5, 0, 21, 21);
    [btn setImage:[UIImage imageNamed:@"icon-arrow-left"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barItem;
    
    
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addbtn.frame = CGRectMake(0, 0, 21, 21);
    [addbtn setImage:[UIImage imageNamed:@"proFollowAdd"] forState:UIControlStateNormal];
    [addbtn sizeToFit];
    [addbtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * addbarItem = [[UIBarButtonItem alloc]initWithCustomView:addbtn];
    self.navigationItem.rightBarButtonItem = addbarItem;
    
}

- (void)btnClick{
    [self.tabBarController.navigationController popViewControllerAnimated:true];
}

- (void)addBtnClick{
    AddCustomerFollowUpVC *vc = [[AddCustomerFollowUpVC alloc]init];
    [vc configTypeWithT:2];
    vc.proId = self.proID;
    
    [self hiddenTab];
    
    __weak typeof(self) weakSelf = self;
    vc.needRefresh = ^{
        [weakSelf configData];
    };
    
    [self.navigationController pushViewController:vc animated:true];
}


/**
 应酬TAb
 */
- (void)hiddenTab{
    if ([self.navigationController.tabBarController isKindOfClass:[ProjectSituationTabVC class]]) {
        ProjectSituationTabVC *tab = (ProjectSituationTabVC *)self.navigationController.tabBarController;
        [tab.tab setHidden:YES];
    }
}


-(void)toEditFollowup:(SDTimeLineCellModel *)model{
    
    AddCustomerFollowUpVC *vc = [[AddCustomerFollowUpVC alloc]init];
    [vc configTypeWithT:2];
    vc.proId = self.proID;
    vc.model = model;
    
   
//    if ([self.navigationController.tabBarController isKindOfClass:[ProjectSituationTabVC class]]) {
//        ProjectSituationTabVC *tab = (ProjectSituationTabVC *)self.navigationController.tabBarController;
//        [tab.tab setHidden:YES];
//    }
    
    [self hiddenTab];
    
    __weak typeof(self) weakSelf = self;
    vc.needRefresh = ^{
        [weakSelf configData];
    };
    
    [self.navigationController pushViewController:vc animated:true];
}



- (void)configData{
    
    UserModel *model = UserModel.getUserModel;
    
    kWeakS(weakSelf);
    
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.followup.followup" params:@{@"id":self.proID,@"token":model.token,@"class_id":self.currentType} hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [self showDismissWithError];
      [weakSelf.tableView.mj_header endRefreshing];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        
        //NSLog(@"%@",a);
        
        [weakSelf showDismiss];
        [weakSelf.tableView.mj_header endRefreshing];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:[self creatModelsWithDataArray:a[@"list"]]];
        [self.tableView reloadData];
        
        if ([a isNotEmpty]) {
//            SDTimeLineCellModel *model = self.dataArray.firstObject;
           [self showNewMsg:[NSString stringWithFormat:@"%@",a[@"new_message_total"]] head:a[@"head"]];
        }
        
        
    }];
//    pp.project.followup
}






- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

    [self.chatKeyBoard removeFromSuperview];
    self.chatKeyBoard = nil ;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showTab];
}


- (void)showTab{
    if ([self.navigationController.tabBarController isKindOfClass:[ProjectSituationTabVC class]]) {
        ProjectSituationTabVC *tab = (ProjectSituationTabVC *)self.navigationController.tabBarController;
        [tab.tab setHidden:NO];
        [tab.tabBar setHidden:YES];
    }
}


- (void)dealloc
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







// 右栏目按钮点击事件

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender{
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        
        [LEETheme startTheme:NIGHT];
        
    } else {
        [LEETheme startTheme:DAY];
    }
}


- (NSArray *)creatModelsWithDataArray:(NSArray *)data{
    NSMutableArray *array = [NSMutableArray array];
//    UserModel *uModel = [UserModel getUserModel];
    for (NSDictionary *dic in data) {
        
        SDTimeLineCellModel *model = [self getFollowupDetailModel:dic];
        
        [array addObject:model];
    }
    
    
    return array;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDTimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeLineTableViewCellId forIndexPath:indexPath];
    cell.isOnlyShow = self.isOnlyShow;
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    __weak typeof(cell) weakCell = cell;
    cell.imageFinish = ^(NSIndexPath *indexPath) {
//        NSArray *cellArray = [weakSelf.tableView visibleCells];
//        if ([cellArray containsObject:weakCell]) {
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
    };
    
    
    cell.clickSpecailView = ^(NSString *type, NSDictionary *value) {
        [PublicPush pushToSpecailWithType:type value:value vc:weakSelf model:weakSelf.model];
    };
    
    
    if (!cell.moreButtonClickedBlock) {
        [cell setMoreButtonClickedBlock:^(NSIndexPath *index) {
            SDTimeLineCellModel *model = weakSelf.dataArray[index.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }];
        

        __weak typeof(cell) weakCell = cell;
        cell.editButtonClickedBlock = ^(NSIndexPath *index) {
            
            [weakSelf toEditFollowup:weakCell.model];
        };
        cell.deleteButtonClickedBlock = ^(NSIndexPath *index) {
            [weakSelf showRemind:^{
                [weakSelf deleteFollowup:weakCell.model];
            }];
            
        };
        
        
        
        cell.didClickPerson = ^(NSString *userid) {
            PublicPush *push = [[PublicPush alloc]init];
            
            [weakSelf hiddenTab];
            
//            ProjectSituationTabVC *tab = (ProjectSituationTabVC *)weakSelf.navigationController.tabBarController;
//            [tab.tab setHidden:YES];
            [push pushToUserInfoWithImId:@"" userId:userid vc:weakSelf];
        };
        
        cell.delegate = self;
    }
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    
    
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

///**
// 获取消息个数
// */
//- (void)getMsgNum{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    UserModel *model = UserModel.getUserModel;
//    params[@"id"] = self.proID;
//    params[@"token"] = model.token;
//    [LoginRequest getPostWithMethodName:@"pp.followup.new_message_num" params:params hadToast:false fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
//    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
//        //NSLog(@"%@",a);
//        //NSLog(@"ssssssssssss");
////        [self showNewMsg:a[@"new_message_num"]];
//    }];
//}

- (void)showNewMsg:(NSString *)num head:(NSString *)head{
    
    
    if ([num intValue] == 0) {
        return;
    }
    
    if (_myMsgView == nil) {
        FollowuoMsgView *msgView = [[FollowuoMsgView alloc]initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH-200)/2, 50, 200, 50)];
        [self.view addSubview:msgView];
        _myMsgView = msgView;
        kWeakS(weakSelf);
        msgView.click = ^{
            weakSelf.myMsgView = nil;
            FollowupMsgListVC *vc = [[FollowupMsgListVC alloc]init];
            [weakSelf hiddenTab];
//            ProjectSituationTabVC *tab = (ProjectSituationTabVC *)weakSelf.navigationController.tabBarController;
//            [tab.tab setHidden:YES];
            vc.proId = weakSelf.proID;
            [vc configTypeWithT:2];
            [weakSelf.navigationController pushViewController:vc animated:true];
        };
    }
    
    _myMsgView.nameLable.text = [NSString stringWithFormat:@"%@条新的消息",num];
    [_myMsgView setHeadStrWithHead:head];
    
    
}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"------------------%d",indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataArray[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[SDTimeLineCell class] contentViewWidth:[self cellContentViewWith]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.chatKeyBoard keyboardDownForComment];
}



- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


#pragma mark - SDTimeLineCellDelegate

-(void)didClickCommentWithModel:(SDTimeLineCellCommentItemModel *)model cell:(UITableViewCell *)cell{
     _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    UserModel *umodel = [UserModel getUserModel];
    self.currentEditModel = model;
    kWeakS(weakSelf);
    if ([umodel.id isEqualToString:model.firstUserId]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自己的评论" message:@"自己的评论是否删除?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"点击了按钮1，进入按钮1的事件");
            [weakSelf commentDeleteWithModel:model];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //NSLog(@"点击了取消");
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:true completion:nil];
    }
    else{
        //NSLog(@"回复");
        self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复%@",model.firstUserName];
        //                weakSelf.currentEditingIndexthPath = indexPath;
        [self.chatKeyBoard keyboardUpforComment];
    }
}


- (void)didClickcCommentButtonInCell:(UITableViewCell *)cell
{
//    [_textField becomeFirstResponder];
    self.currentEditModel = nil;
    _currentEditingIndexthPath = [self.tableView indexPathForCell:cell];
    self.chatKeyBoard.placeHolder = @"评论";
    [self.chatKeyBoard keyboardUpforComment];
//    [self adjustTableViewToFitKeyboard];
    
}

- (void)didClickLikeButtonInCell:(UITableViewCell *)cell
{
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
  __weak SDTimeLineCellModel *model = self.dataArray[index.row];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:model.likeItemsArray];
     UserModel *umodel = [UserModel getUserModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"token"] = umodel.token;
    params[@"fo_id"] = model.id;
    kWeakS(weakSelf);
    [self toLikeWithParams:params finish:^{
        if (!model.isLiked) {
            
            SDTimeLineCellLikeItemModel *likeModel = [SDTimeLineCellLikeItemModel new];
            likeModel.userName = umodel.realname;
            likeModel.userId =umodel.id;
            [temp addObject:likeModel];
            model.liked = YES;
        } else {
            SDTimeLineCellLikeItemModel *tempLikeModel = nil;
            for (SDTimeLineCellLikeItemModel *likeModel in model.likeItemsArray) {
                if ([likeModel.userId isEqualToString:umodel.id]) {
                    tempLikeModel = likeModel;
                    break;
                }
            }
            [temp removeObject:tempLikeModel];
            model.liked = NO;
        }
        model.likeItemsArray = [temp copy];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
    
}


- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexthPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:window];
    [self adjustTableViewToFitKeyboardWithRect:rect];
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableView setContentOffset:offset animated:YES];
}

-(ChatKeyBoard *)chatKeyBoard{
    
    if (!_chatKeyBoard) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.allowPic = NO;
        _chatKeyBoard.allowFace = YES;
        _chatKeyBoard.placeHolder = @"评论";
        
    }
    return _chatKeyBoard;
}




#pragma mark -- ChatKeyBoardDataSource

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
//    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemCamera normal:@"add_image_default" high:@"add_image_focus" select:nil];
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"add_emoj_default" high:@"add_emoj_focus" select:@"keyboard"];
    
//    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemAt normal:@"at_default" high:@"at_focus" select:nil];
    
    return @[item2];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
#pragma mark -- ChatKeyBoardDelegate

- (void)chatKeyBoardSendText:(NSString *)text{
     [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.chatToolBar.textView.text = nil;
    kWeakS(weakSelf);
    if (!text.length) {
//        [self toastWithText:@"请输入评论内容"];
        return;
    }
//    text = [NSString stringWithString:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *textStr = [NSString base64EncodeString:text];
    
    if (self.currentEditModel == nil) {
        //添加新的评论
        [self addFollowUp:textStr];
        return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = UserModel.getUserModel;
    
    params[@"fo_id"] = self.currentEditModel.fo_id;
    params[@"token"] = model.token;
//    params[@"content"] = textStr;
    params[@"encode_content"] = textStr;
    params[@"to_userid"] = self.currentEditModel.firstUserId;
    params[@"comment_id"] = self.currentEditModel.id;
//    回复某条评论
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.followup.reply_add" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
//        //NSLog(@"1111111");
//        //NSLog(@"%@",a);
        [weakSelf showDismiss];
        [weakSelf getFollowupDetail:params];
    }];
}



/**
 获取某一个跟进的详情

 @param params <#params description#>
 */
-(void)getFollowupDetail:(NSDictionary *)params{
    kWeakS(weakSelf);
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.followup.fo_detail" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        SDTimeLineCellModel *model =  [weakSelf getFollowupDetailModel:a];
        
    
        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.currentEditingIndexthPath.row withObject:model];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView reloadData];
        });
        
    }];
    
}




/**
 点赞  取消点赞

 @param params <#params description#>
 @param finish <#finish description#>
 */
-(void)toLikeWithParams:(NSDictionary *)params finish:(void (^)(void))finish{
    
    [self showOCProgress];
    kWeakS(weakSelf);
    [LoginRequest getPostWithMethodName:@"pp.followup.support" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        finish();
    }];
}



- (void)deleteFollowup:(SDTimeLineCellModel *)fmodel{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *model = UserModel.getUserModel;
    int index = [self.dataArray indexOfObject:fmodel];
    params[@"id"] = fmodel.id;
    params[@"token"] = model.token;
    [self showOCProgress];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    [LoginRequest getPostWithMethodName:@"pp.followup.followup_del" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        [weakSelf.dataArray removeObjectAtIndex:indexpath.row];
//        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableView reloadData] ;
    }];
}




/**
 添加评论

 @param str <#str description#>
 */
-(void)addFollowUp:(NSString *)str{
    kWeakS(weakSelf);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *umodel = UserModel.getUserModel;
    
    SDTimeLineCellModel * model = self.dataArray[self.currentEditingIndexthPath.row];
    
    params[@"fo_id"] = model.id;
    params[@"token"] = umodel.token;
    params[@"encode_content"] = str;
    
    [self showOCProgress];
    [LoginRequest getPostWithMethodName:@"pp.followup.comment_add" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        [weakSelf getFollowupDetail:params];
    }];
    
}



/**
 获取具体某一条跟进的model

 @param dic <#dic description#>
 @return <#return value description#>
 */
-(SDTimeLineCellModel *)getFollowupDetailModel:(NSDictionary *)dic{
    
  
    
    UserModel *uModel = [UserModel getUserModel];
    SDTimeLineCellModel *model = [SDTimeLineCellModel new];
    model.name = [dic[@"name"] toString];
    model.special_type = dic[@"special_type"];
    model.class_list = dic[@"class_list"];
    if ([dic[@"special_value"] isNotEmpty]) {
        model.special_value = [BaseRequest makeJsonWithStringWithJsonStr:dic[@"special_value"]];
    }
    
    
//    model.msgContent = dic[@"activity_note"];
    model.msgContent = [NSString base64DecodeString:[NSString stringWithFormat:@"%@",dic[@"encode_note"]]];
    model.iconName = [dic[@"head"] toString];
    model.createname = [dic[@"createname"] toString];
    model.addTime = [NSString stringWithFormat:@"%@",dic[@"addtime"]];
    
    NSString *otherPeopleStr = @"";
    
    if(![model.special_type isEqualToString:@"pro_analyse"]){
        
        if ([dic[@"remind_user_name"] isNotEmpty]) {
            otherPeopleStr = [NSString stringWithFormat:@"提到了谁：%@",dic[@"remind_user_name"]];
        }
        if ([dic[@"contactnames"] isNotEmpty]) {
            if ([otherPeopleStr isNotEmpty]) {
                otherPeopleStr = [NSString stringWithFormat:@"%@\n客户联系人：%@",otherPeopleStr,dic[@"contactnames"]];
            }
            else{
                otherPeopleStr = [NSString stringWithFormat:@"%@客户联系人：%@",otherPeopleStr,dic[@"contactnames"]];
            }
        }
        
    }
    
    if ([dic[@"realname"] isNotEmpty]) {
        if ([otherPeopleStr isNotEmpty]) {
            otherPeopleStr = [NSString stringWithFormat:@"%@\n跟进人：%@",otherPeopleStr,dic[@"realname"]];
        }else{
            otherPeopleStr = [NSString stringWithFormat:@"跟进人：%@",dic[@"realname"]];
        };
        
    }
    
    
    model.otherPeople = otherPeopleStr;
    
    DLog(@"yyyyyy------%@",otherPeopleStr);
    
    model.id = [NSString stringWithFormat:@"%@",dic[@"id"]];
    model.createuserid = [NSString stringWithFormat:@"%@",dic[@"createuserid"]];
    //
    
    model.contactids = [NSString stringWithFormat:@"%@",dic[@"contactids"]];
    model.contactnames = [NSString stringWithFormat:@"%@",dic[@"contactnames"]];
    model.remind_user = [NSString stringWithFormat:@"%@",dic[@"remind_user"]];
    model.remind_user_name = [NSString stringWithFormat:@"%@",dic[@"remind_user_name"]];
    
    NSMutableArray *subLikeArray = [NSMutableArray array];
    for (NSDictionary *subDic  in dic[@"support"]) {
        if ([subDic[@"userid"] isNotEmpty] && [subDic[@"userid"] integerValue] != 0) {
            SDTimeLineCellLikeItemModel *lmodel = [SDTimeLineCellLikeItemModel new];
            lmodel.userName = subDic[@"realname"];
            lmodel.userId = [NSString stringWithFormat:@"%@",subDic[@"userid"]];
            [subLikeArray addObject:lmodel];
            if ([lmodel.userId isEqualToString:uModel.id]) {
                model.liked = YES;
            }
        }
        
       
    }
    
    model.likeItemsArray = subLikeArray;
    
    NSMutableArray *subArray = [NSMutableArray array];
    for (NSDictionary *subDic in dic[@"comments"]) {
        SDTimeLineCellCommentItemModel *commentItemModel = [SDTimeLineCellCommentItemModel new];
        if ([subDic[@"create_userid"] isNotEmpty]) {
            commentItemModel.firstUserName = [subDic[@"create_realname"] toString];
            commentItemModel.firstUserId = [subDic[@"create_userid"] toString];
        }
        
        if ([subDic[@"to_userid"] integerValue] != 0) {
            commentItemModel.secondUserName = [subDic[@"to_realname"] toString];
            commentItemModel.secondUserId = [subDic[@"to_userid"] toString];
        }
        
        commentItemModel.commentString = [NSString base64DecodeString:[NSString stringWithFormat:@"%@",subDic[@"encode_content"]]];
        commentItemModel.id = [subDic[@"id"] toString];
        commentItemModel.fo_id = [subDic[@"fo_id"] toString];
        [subArray addObject:commentItemModel];
    }
    
    model.commentItemsArray = subArray;
    
    if ([dic[@"files"] isNotEmpty]){
        id file = [LoginRequest makeJsonWithStringWithJsonStr:[NSString stringWithFormat:@"%@",dic[@"files"]]];
        if ([file isKindOfClass:[NSArray class]] ){
            if ([file isNotEmpty]){
                
                NSMutableArray *imageArray = [NSMutableArray array];
                for (NSDictionary *fileDic in (NSArray *)file) {
                    if ([fileDic[@"type"] isEqualToString:@"image"]){
                        [imageArray addObject:fileDic];
                    }
                }
                model.picNamesArray = imageArray;
            }
            
        }
    }
    
    
//    model.picNamesArray = @[@"main_bottom_1",@"main_bottom_1",@"main_bottom_1"];
  return model;
}


/**
 删除评论
 */
- (void)commentDeleteWithModel:(SDTimeLineCellCommentItemModel *)model{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    UserModel *uModel = [UserModel getUserModel];
    params[@"token"]  = uModel.token;
    params[@"id"] = model.id;
    params[@"fo_id"] = self.currentEditModel.fo_id;
    params[@"comment_id"] = self.currentEditModel.id;
    [self showOCProgress];
    kWeakS(weakSelf);
    [LoginRequest getPostWithMethodName:@"pp.followup.comment_del" params:params hadToast:true fail:^(NSDictionary<NSString *,id > * _Nonnull a) {
        [weakSelf showDismissWithError];
    } success:^(NSDictionary<NSString *,id> * _Nonnull a) {
        [weakSelf showDismiss];
        [weakSelf delegateComment];
    }];
    
    
}


-(void)delegateComment{
    
    if (self.currentEditingIndexthPath.row < self.dataArray.count) {
        SDTimeLineCellModel *myModel =  self.dataArray[self.currentEditingIndexthPath.row];
        
        if ([myModel.id isEqualToString:self.currentEditModel.fo_id]) {
            
            NSMutableArray *cArray = [NSMutableArray arrayWithArray:myModel.commentItemsArray];
            for (SDTimeLineCellCommentItemModel *subModel in cArray) {
                
                if ([subModel.id isEqualToString:self.currentEditModel.id])
                {
                    
                    [cArray removeObject:subModel];
                    break;
                }
            }
            myModel.commentItemsArray = cArray;
            
        }
    }
    kWeakS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
    });
}



/**
 删除提示

 @param sureClick 点击确定
 */
-(void)showRemind:(void (^)(void))sureClick{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定删除吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        sureClick();
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:true completion:nil];
    
    
}
#pragma mark - 跟进筛选
- (void)addFiltrateView{
    UIView *shaixuanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    shaixuanView.backgroundColor = kBackColor;
    [self.view addSubview:shaixuanView];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 30)];
    subView.backgroundColor = UIColorFromRGB(0x393C47);
    subView.layer.cornerRadius = 4;
    subView.clipsToBounds = YES;
    [self.view addSubview:subView];
    
    UIImageView *arrowimageView = [[UIImageView alloc] initWithFrame:CGRectMake(subView.frame.size.width/2+30, 5, 20, 20)];
    arrowimageView.image = [UIImage imageNamed:@"qf_down_arrowWhite"];
    arrowimageView.contentMode = UIViewContentModeCenter;
    [subView addSubview:arrowimageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(subView.frame.size.width/2-30, 5, 60, 20)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"跟进筛选";
    label.textColor = UIColorFromRGB(0xFFFFFF);
    label.font = [UIFont systemFontOfSize:14];
    [subView addSubview:label];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, subView.frame.size.width, 30)];
    [button addTarget:self action:@selector(shaixuanButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:button];
    self.currentType = @"0";
}
- (void)shaixuanButtonClick{
    kWeakS(weakSelf);
    HYFollowFiltrateV *filtrateView = [[HYFollowFiltrateV alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    filtrateView.action = ^(NSInteger type) {
        weakSelf.currentType = [NSString stringWithFormat:@"%ld",type];
        [weakSelf configData];
    };
    [[UIApplication sharedApplication].delegate.window addSubview:filtrateView];
}




@end