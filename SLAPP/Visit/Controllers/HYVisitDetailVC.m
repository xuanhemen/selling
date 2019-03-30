//
//  HYVisitDetailVC.m
//  SLAPP
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018 柴进. All rights reserved.
//
#import "HYVisitModel.h"
#import "VisitCommentViewController.h"
//#import "VisitCommentDetailViewController.h"
#import "HYReservationVC.h"
#import "HYVisitDetailSectionHeaderView.h"
#import "HYVisitDetailVC.h"
#import "HYVisitDetailViewModel.h"
#import "HYVisitDetailCell.h"
#import "HYVisitReadyDetailCell.h"
#import "HYVisitDetailActionCell.h"
#import <UITableView_FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>
#import "HYAddVisitVC.h"
#import "CLVisitSimpleDetailEditVC.h"
#import <YBPopupMenu/YBPopupMenu.h>
#import "HYVisitReportVC.h"
#import "HYSummaryVC.h"
#import "CommentBottomView.h"
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "NSString+AttributedString.h"
#import "TZImagePickerController.h"
#import "UploadManager.h"
#import "SLAPP-Swift.h"

@interface HYVisitDetailVC ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)HYVisitDetailViewModel *viewModel;

//选中的section
@property(nonatomic,strong)NSMutableArray *sectionSelectArray;
@property(nonatomic,strong)NSArray *dataArray;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property(nonatomic,assign)BOOL isChange;


//关于评论的  直接拷贝的拜访罗盘
@property(nonatomic,assign)BOOL hasPic;
@property (nonatomic, strong) CommentBottomView *bottomView;
@property(nonatomic,assign)BOOL selectAtBtn;
@property(nonatomic,strong)NSMutableArray *selectedAssets;
@property(nonatomic,strong)NSMutableArray *selectedPhotos;
@property(nonatomic,strong)NSMutableArray *sendersArr;//@的对象
@property(nonatomic,strong)NSMutableArray *faceNameArr;
@end

@implementation HYVisitDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拜访信息详情";
    [self configUI];
    self.sendersArr = [NSMutableArray array];
    self.faceNameArr = [NSMutableArray array];
    _hasPic = NO;
    _viewModel = [[HYVisitDetailViewModel alloc] init];
    _sectionSelectArray = [NSMutableArray array];
    [_sectionSelectArray addObject:_viewModel.sectionTitles[0]];
    
//    [self configData];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configData];
    self.isChange = NO;
//    if (self.isChange) {
//        [self configData];
//        self.isChange = NO;
//    }
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self clearKeyBoard];
}



-(void)configUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
    
    UIView *view = [UIView new];
    _table.tableFooterView = view;
    
    kWeakS(weakSelf);
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTab_height+49-44);
        
    } ];
    
    
    [_table registerClass:[HYVisitDetailCell class] forCellReuseIdentifier:@"HYVisitDetailCell"];
    [_table registerClass:[HYVisitReadyDetailCell class] forCellReuseIdentifier:@"HYVisitReadyDetailCell"];
    [_table registerClass:[HYVisitDetailActionCell class] forCellReuseIdentifier:@"HYVisitDetailActionCell"];
    _table.delegate = self;
    _table.dataSource = self;
    
    
    
    
//    评论界面
    CommentBottomView *bottomView = [[CommentBottomView alloc] initWithFrame:CGRectMake(0,kMain_screen_height_px-44-kNav_height, kScreenWidth,44)];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kTab_height+49);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [bottomView setCommentNum:0];
    
    bottomView.commentBtnClickBlock = ^{
//        评论点击
        
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    bottomView.detailBtnClickBlock = ^{
//    详情点击
        VisitCommentViewController *vc = [[VisitCommentViewController alloc] init];
        vc.visitId = weakSelf.visit_id;
        [weakSelf.navigationController pushViewController:vc animated:true];
        
    };
}

-(void)configData{
    
   
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = self.visit_id;
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kgetVisitReadyBase Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        
        DLog(@"%@",result);
        
         weakSelf.dataArray = [weakSelf.viewModel configWithJason:result];
         [weakSelf addRightBtn];
        [weakSelf.table reloadData];
        
        [weakSelf showDismiss];
        [weakSelf.bottomView setCommentNum:[weakSelf.viewModel.comment_count intValue]];
        
//        if (!weakSelf.showKeyboard) {
//             [weakSelf.bottomView setCommentNum:[weakSelf.viewModel.comment_count intValue]];
//        }else{
//
//        }
//        weakSelf.showKeyboard = NO;
        
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
    
    
//    _dataArray = [_viewModel configWithJason:nil];
//    [_table reloadData];
    
}

#pragma mark- 📚 *********** table 代理 **************

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HYVisitDetailSectionHeaderView *header = [[HYVisitDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    header.content.text = _viewModel.sectionTitles[section];
    header.img_icon.image = [UIImage imageNamed:_viewModel.sectionImages[section]];
    kWeakS(weakSelf);
    
    if ([_sectionSelectArray containsObject:header.content.text]) {
        [header.upDownBtn setImage:[UIImage imageNamed:@"chooseDown"] forState:UIControlStateNormal];
        
    }else{
        [header.upDownBtn setImage:[UIImage imageNamed:@"chooseUp"] forState:UIControlStateNormal];
    }
    
    
    header.upDownBtnClick = ^(NSString *str) {
        if ([weakSelf.sectionSelectArray containsObject:str]) {
            [weakSelf.sectionSelectArray removeObject:str];
        }else{
            [weakSelf.sectionSelectArray addObject:str];
        }
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    
    if([self.viewModel.visitStatus integerValue] == 1){
        header.editBtn.hidden = true;
    }else{
        header.editBtn.hidden =  ![self.viewModel.authModel.edit integerValue];
    }
    header.editBtnClick = ^{
        [weakSelf toEditWithTag:section];
    };
    
    return header;
}









-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    return line;
    
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    kWeakS(weakSelf);
    if ([_viewModel.sectionTitles[indexPath.section] isEqualToString:@"基本信息"]) {
        
        static NSString * cellIde = @"HYVisitDetailCell";
        
        return [tableView fd_heightForCellWithIdentifier:cellIde configuration:^(HYVisitDetailCell *cell)
                {
                    cell.model = weakSelf.dataArray[indexPath.section][indexPath.row];
                    [cell configUIWithModel];
                }];
        
        
    }else if ([_viewModel.sectionTitles[indexPath.section] isEqualToString:@"行动承诺"]){
        
        
        static NSString * cellIde = @"HYVisitDetailActionCell";
        return [tableView fd_heightForCellWithIdentifier:cellIde configuration:^(HYVisitDetailActionCell *cell)
                {
                    cell.model = weakSelf.dataArray[indexPath.section][indexPath.row];
                    [cell configUIWithModel];
                }];
        
        
    }else{
        
        static NSString * cellIde = @"HYVisitReadyDetailCell";
        return [tableView fd_heightForCellWithIdentifier:cellIde configuration:^(HYVisitReadyDetailCell *cell)
                {
                    cell.model = weakSelf.dataArray[indexPath.section][indexPath.row];
                    [cell configUIWithModel];
                }];  
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _viewModel.sectionTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.sectionSelectArray containsObject:_viewModel.sectionTitles[section]]) {
        return [(NSArray *)self.dataArray[section] count];
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_viewModel.sectionTitles[indexPath.section] isEqualToString:@"基本信息"]) {
        
        static NSString * cellIde = @"HYVisitDetailCell";
        HYVisitDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYVisitDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        [cell configUIWithModel];
        return cell;
        
    }else if ([_viewModel.sectionTitles[indexPath.section] isEqualToString:@"行动承诺"]){
        
        
        static NSString * cellIde = @"HYVisitDetailActionCell";
        HYVisitDetailActionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYVisitDetailActionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        [cell configUIWithModel];
        return cell;
        
        
    }else{
        
        static NSString * cellIde = @"HYVisitReadyDetailCell";
        HYVisitReadyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYVisitReadyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        
        cell.model = self.dataArray[indexPath.section][indexPath.row];
        [cell configUIWithModel];
        return cell;
        
        
    }
    
}


/**
 去修改
 
 @param tag <#tag description#>
 */
-(void)toEditWithTag:(NSInteger)tag{
    
    
    NSArray *array = @[@"expect",@"actionpromise",@"visitreason",@"unknownlist",@"specialadvantage"];
    if (tag == 0) {
        

        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = self.visit_id;
        [self showProgress];
        kWeakS(weakSelf);
        [HYBaseRequest getPostWithMethodName:kGetVisitBase Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            HYVisitModel * vModel = [[HYVisitModel alloc] init];
            vModel.editVisitResult = result;
            HYAddVisitVC *vc = [[HYAddVisitVC alloc] init];
            vc.visitModel = vModel;
            [weakSelf.navigationController pushViewController:vc animated:true];
            
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
        
        
    }else{
        CLVisitSimpleDetailEditVC *vc = [[CLVisitSimpleDetailEditVC alloc] init];
        vc.typeStr = array[tag-1];
        vc.visitId = self.visit_id;
        HYVisitDetailModel *model = self.dataArray[0][3];

        vc.visiters = model.content;
        vc.model = self.dataArray[tag][0];
        kWeakS(weakSelf);
        vc.okBtnClickBlock = ^{
            weakSelf.isChange = YES;
        };
        
        [self.navigationController pushViewController:vc animated:true];
    }
    
    
    
}

- (void)addRightBtn{
    
    if ([self.viewModel.rightTitles isNotEmpty]) {
        [self setRightBtnsWithImages:@[@"promore"]];
    }else{
        self.navigationItem.rightBarButtonItems = nil;
       
    }
}


- (void)rightClick:(UIButton *)btn{
    if ([self.viewModel.rightTitles isNotEmpty]) {
        [YBPopupMenu showRelyOnView:btn titles:self.viewModel.rightTitles icons:nil menuWidth:120 delegate:self];
    }
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    if ([self.viewModel.rightTitles isNotEmpty]) {
        NSString *str = self.viewModel.rightTitles[index];
        if ([str isEqualToString:@"完成"]) {
//            跳转到拜访总结
            HYSummaryVC *vc = [[HYSummaryVC alloc] init];
            vc.visit_id = _visit_id;
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"预约"]){
            
           
            HYReservationVC *vc = [[HYReservationVC alloc] init];
            vc.visitId = _visit_id;
            vc.isReservation = YES;
            [self.navigationController pushViewController:vc animated:true];
            
            
            
        }else if ([str isEqualToString:@"删除"]){
            kWeakS(weakSelf);
            [self addAlertViewWithTitle:@"温馨提示" message:@"您确定删除该拜访？" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction *action) {
                [weakSelf toDeleteVisit];
            } cancleAction:^(UIAlertAction *action) {
                
            }];
            
        }else if ([str isEqualToString:@"发送总结"]){
            HYReservationVC *vc = [[HYReservationVC alloc] init];
            vc.visitId = _visit_id;
            vc.isReservation = NO;
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"准备报告"]){
            HYVisitReportVC *vc = [[HYVisitReportVC alloc] init];
            vc.visitId = _visit_id;
            vc.type = @"0";
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"总结报告"]){
            HYVisitReportVC * vc = [[HYVisitReportVC alloc] init];
            vc.visitId = _visit_id;
            vc.type = @"1";
            [self.navigationController pushViewController:vc animated:true];
            
        }else if ([str isEqualToString:@"重新打开"]){
            
            [self showProgress];
            kWeakS(weakSelf);
            [HYBaseRequest getPostWithMethodName:kVisit_reOpen Params:[@{@"visitid":_visit_id} addToken] showToast:true Success:^(NSDictionary *result) {
                [weakSelf showDismiss];
                [weakSelf configData];
                [weakSelf toastWithText:@"打开成功"];
            } fail:^(NSDictionary *result) {
                [weakSelf showDismissWithError];
            }];
            
            
        }
    }
    
}


/**
 拜访删除
 */
-(void)toDeleteVisit{
    
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName: kVisit_delete Params:[@{@"visitid":_visit_id} addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf showDismiss];
        [weakSelf toastWithText:@"删除成功"];
        [weakSelf.navigationController popViewControllerAnimated:true];
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
}


#pragma mark- 📚 ***********  **************


-(ChatKeyBoard *)chatKeyBoard{
    
    if (!_chatKeyBoard) {
        _chatKeyBoard = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
//        _chatKeyBoard.allowPic = YES;
        _chatKeyBoard.allowCamera = YES;
//        _chatKeyBoard.allowFace = YES;
        
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"写点什么吧";
        
    }
    return _chatKeyBoard;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.chatKeyBoard keyboardDownForComment];
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
    
    if (!_hasPic && !text.length) {
        [self toastWithText:@"请输入评论内容"];
        return;
    }
    
    NSString * content = [NSString base64EncodeString:text];
    kWeakS(weakSelf);
    if (_hasPic) {
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
            
            [weakSelf addVisitComment:content Files:sendImage];
        } success:^(NSDictionary *imgDic, int idx) {
            [imageSuccess setObject:imgDic forKey:[NSString stringWithFormat:@"%d",idx]];
        } failure:^(NSError *error, int idx) {
            
        }];
        
        
        //        NSMutableArray *photoArr = [NSMutableArray array];
        //
        //        [self showProgressWithStr:@"正在发送..."];
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
        //                         [weakSelf addVisitComment:text Files:photoArr];
        //                     });
        //
        //                 }
        //             } fail:^(NSDictionary *result)
        //             {
        //
        //             }];
        //
        //        }
        
    }else{
        
        [self addVisitComment:content Files:nil];
    }
}



-(void)addVisitComment:(NSString *)text Files:(NSArray *)files{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visit_id"] = self.visit_id;
    params[@"content"] = text;
    params[@"files"] = files;
    
    if (self.sendersArr && self.sendersArr.count) {
        NSArray *idsArray  = [self.sendersArr valueForKeyPath:@"id"];
        params[@"senders"] = [idsArray componentsJoinedByString:@","];
    }
    
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


-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectPicBtnClick:(UIButton *)btn{
    kWeakS(weakSelf);
    [self.chatKeyBoard keyboardDownForComment];
   
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    //
        if (_hasPic) {
            // 1.设置目前已经选中的图片数组
            imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
        }
    // 3. 设置是否可以选择视频/图片/原图/Gif
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    //
    //    // You can get the photos by block, the same as by delegate.
    //    // 你可以通过block或者代理，来得到用户选择的照片.
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (weakSelf.hasPic == NO) {
            CGRect frame =  weakSelf.chatKeyBoard.chatToolBar.frame;
            frame.size.height += kPicViewHeight + 5;
            weakSelf.chatKeyBoard.chatToolBar.frame = frame;
            weakSelf.chatKeyBoard.allowPic = YES;
            weakSelf.hasPic = YES;
            
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
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
   
    
}
-(void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard delPicBtnDidClick:(UIButton *)btn{
        [self.selectedAssets removeObjectAtIndex:btn.tag - 10];
        [self.selectedPhotos removeObjectAtIndex:btn.tag - 10];
        if (self.selectedPhotos.count == 0) {
    
            CGRect frame =  self.chatKeyBoard.chatToolBar.frame;
            frame.size.height -= kPicViewHeight + 5;
            self.chatKeyBoard.chatToolBar.frame = frame;
            _hasPic = NO;
            self.chatKeyBoard.chatToolBar.allowPic = NO;
        }
        self.chatKeyBoard.chatToolBar.picView.picsArr = self.selectedPhotos;
    
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
        [self.faceNameArr addObject:faceName];;
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
////    }
////
////    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
////    dic[@"visit_id"] = weakSelf.model.id;
////    dic[@"content"] = text;
////    dic[@"senders"] = senders;
////    dic[@"files"] = files;
////
////    [VisitWebService addVisitCommentWithParams:dic Success:^(NSDictionary *result) {
////        [LoginAndIncrementWebService incrementSuccess:^(NSDictionary *result)
////         {
////             [weakSelf dismiss];
////             weakSelf.commentBottomView.commentNum = [CommentModel objectsWhere:@"visit_id == %@",weakSelf.model.id].count;
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
////
//}



-(void)clearKeyBoard{
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
    if (_hasPic) {
        
        CGRect frame =  self.chatKeyBoard.chatToolBar.frame;
        frame.size.height -= kPicViewHeight + 5;
        self.chatKeyBoard.chatToolBar.frame = frame;
        _hasPic = NO;
    }
    self.chatKeyBoard.chatToolBar.allowPic = NO;
    [self.chatKeyBoard.chatToolBar clearTextViewContent];
    [self.sendersArr removeAllObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
