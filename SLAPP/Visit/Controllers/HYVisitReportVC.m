//
//  HYVisitReportVC.m
//  SLAPP
//
//  Created by apple on 2018/10/24.
//  Copyright © 2018 柴进. All rights reserved.
//
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import <MJRefresh/MJRefresh.h>
#import "HYVisitReportVC.h"
#import "HYVisitReportDelegate.h"
#import "HYVisitReportModel.h"
#import "VisitReportCell.h"
#import "SLAPP-Swift.h"
#import "UITableView+Category.h"
@interface HYVisitReportVC ()<UIDocumentInteractionControllerDelegate>
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)HYVisitReportDelegate * delegate;
@property(nonatomic,strong)UIButton *creatBtn;
@property(nonatomic,strong) UIButton * selBtn;
@property(nonatomic,strong)UIDocumentInteractionController *documentController;
@end

@implementation HYVisitReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self configData];
}


-(void)configUI{
    
    if ([self.type integerValue] == 0) {
        self.title = @"拜访准备报告";
         [self creatTab];
        
    }else{
        self.title = @"拜访总结报告";
        UIButton * selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:selBtn];
        [selBtn setImage:[UIImage imageNamed:@"checkbox_normal"] forState:UIControlStateNormal];
        [selBtn setImage:[UIImage imageNamed:@"checkbox_selected"] forState:UIControlStateSelected];
        [selBtn setTitle:@"包括拜访准备内容" forState:UIControlStateNormal];
        [selBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        selBtn.titleLabel.font = kFont(14);
        selBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.selBtn = selBtn;
        [selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(-10);
        }];
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:line];
//        kWeakS(weakSelf);
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(50.5);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(0.5);
        }];
        
        
        
        [self creatTab];
        
    }
}


-(void)selBtnClick:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    
}

-(void)creatTab{
    
    CGFloat top = 100;
    NSString *creatStr = @"";
    if ([self.type integerValue] == 0) {
        top = 10;
        creatStr = @"生成拜访准备报告";
    }else{
        top = 60.5;
        creatStr = @"生成拜访总结报告";
        
    }
    
    UIButton *creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:creatBtn];
    [creatBtn setBackgroundColor:HexColor(@"28b8cf")];
    [creatBtn setTitle:creatStr forState:UIControlStateNormal];
    
    [creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
        
    }];
    self.creatBtn = creatBtn;
    
    [creatBtn addTarget:self action:@selector(creatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    kWeakS(weakSelf);
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(weakSelf.creatBtn.mas_bottom).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    
    UILabel *lab = [UILabel new];
    [self.view addSubview:lab];
    __weak typeof(line)weakLine = line;
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(20);
        make.top.equalTo(weakLine.mas_bottom).offset(0);
    }];
    lab.font = kFont(14);
    lab.text = @"历史报告";
    lab.textColor = [UIColor darkTextColor];
    UIView *greenLine = [UIView new];
    greenLine.backgroundColor = kgreenColor;
    [self.view addSubview:greenLine];
    
    
    __weak typeof(lab) weaklab = lab;
    [greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.centerY.equalTo(weaklab);
    }];
    
    
    
    _table = [[UITableView alloc] init];
    [self.view addSubview:_table];
   
    UIView *view = [UIView new];
    _table.tableFooterView = view;
    _table.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weaklab.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(kTab_height-49);
        
    } ];
    
    _delegate = [[HYVisitReportDelegate alloc] initWithCellIde:@"VisitReportCell" AndAutoCellHeight:110 modelKey:nil AndDidSelectIndexWith:^(NSIndexPath *indexPath, UITableView *tableView, id model) {
        
    }];
    
    
    _delegate.configCell = ^(VisitReportCell * cell, NSIndexPath *index) {
        __weak typeof(cell)weakCell = cell;
        __weak typeof(index)weakIndex = index;
        cell.bottomClickWithTag = ^(NSInteger tag) {
            [weakSelf bottomClickWithModel:weakCell.model index:weakIndex tag:tag];
        };
    };
    
    _table.delegate = _delegate;
    _table.dataSource = _delegate;
    
    
    [_table addEmptyViewAndClickRefresh:^{
        [weakSelf configData];
    }];
    
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf configData];
    }];
}





/**
 cell按钮点击
 tag  0 1 2 分享  下载  删除
 @param model <#model description#>
 @param index <#index description#>
 */
-(void)bottomClickWithModel:(HYVisitReportModel *)model index:(NSIndexPath *)index tag:(NSInteger)tag{
    
    
    switch (tag) {
        case 0:
        {
            [self shareWithFile:model];
        }
            break;
        case 1:
        {
            [self downFileWithModel:model];
        }
            break;
        case 2:
        {
            kWeakS(weakSelf);
            [self addAlertViewWithTitle:@"温馨提示" message:@"确定要删除吗？" actionTitles:@[@"确定",@"取消"] okAction:^(UIAlertAction *action) {
                
                
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"id"] = model.id;
                [weakSelf showProgress];
               
                [HYBaseRequest getPostWithMethodName:kDel_VisitReport Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
                    [weakSelf dismissProgress];
                    
                    [weakSelf.delegate.dataArray removeObject:model];
                    [weakSelf.table reloadData];
                    
                } fail:^(NSDictionary *result) {
                    [weakSelf dissmissWithError];
                }];
                
                
                
                
            } cancleAction:^(UIAlertAction *action) {
                
            }];
           
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}





-(void)downFileWithModel:(HYVisitReportModel *)model{
    
    [self showProgress];
    kWeakS(weakSelf);
    [HYBaseRequest downLoadFileWithUrl:model.newfilename showToast:true Success:^(NSString *filePath) {
        
        [weakSelf dismissProgress];
        DLog(@"成功-----%@",filePath);
        
        if (filePath) {
            NSArray *arr = [filePath componentsSeparatedByString:@"://"];
            NSString *str = [arr.lastObject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [weakSelf openFileWithPath:str];
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
       
    } ];
    
}


-(void)openFileWithPath:(NSString *)filePath{
    
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    self.documentController.delegate = self;
    
    BOOL canOpen = [self.documentController presentPreviewAnimated:YES];
    if (!canOpen) {
        [self toastWithText:@"无法打开该类型文件"];
    }
}


#pragma mark --UIDocumentInteractionControllerDelegate
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    return self;
}
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    
    return self.view.frame;
}



-(void)creatBtnClick{
    [self creatReport];
}

-(void)creatReport{
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visit_id"] = _visitId;
    if ([self.type integerValue] == 0) {
        params[@"catalog"] = @"Prepare";
    }else{
        
        if (self.selBtn.isSelected) {
            params[@"catalog"] = @"PrepareSummary";
        }else{
            params[@"catalog"] = @"Summary";
        }
        
    }
    
//    params[@"mark"] = @([self.type integerValue] + 1);
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kCreat_VisitReport Params:[params addToken] showToast:true Success:^(NSDictionary *result) {
        DLog(@"%@",result)
        
        if ([result isNotEmpty]) {
            [weakSelf toastWithText:@"生成报告成功"];
            HYVisitReportModel *model = [HYVisitReportModel mj_objectWithKeyValues:result];
            [weakSelf.delegate.dataArray insertObject:model atIndex:0];
            [weakSelf.table reloadData];
        }
        
        
        [weakSelf showDismiss];
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
    }];
    
    
    
    
}



-(void)configData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"visitid"] = _visitId;
    params[@"mark"] = @([self.type integerValue] + 1);
    kWeakS(weakSelf);
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:kGet_visitReport Params: [params addToken] showToast:true Success:^(NSDictionary *result) {
        [weakSelf.delegate.dataArray removeAllObjects];
        [weakSelf.table.mj_header endRefreshing];
        [weakSelf showDismiss];
        if ([result[@"data"] isNotEmpty]) {
            
            for (NSDictionary *sub in result[@"data"]) {
                HYVisitReportModel *model = [HYVisitReportModel mj_objectWithKeyValues:sub];
                [weakSelf.delegate.dataArray insertObject:model atIndex:0];
            }
            [weakSelf.table reloadData];
        }
        
        
    } fail:^(NSDictionary *result) {
        [weakSelf showDismissWithError];
        [weakSelf.table.mj_header endRefreshing];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)shareWithFile:(HYVisitReportModel *)onefile
{
    
    
    NSString *str = onefile.newfilename;//[NSString stringWithFormat:@"%@/Application/uploads/pdf/%@/%@",BASE_REQUEST__FILE_URL,onefile.corpid,onefile.newfilename];
    str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    kWeakS(weakSelf);
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [weakSelf runShareWithType:platformType AndFilename:onefile.filename url:str];
    }];
    
    
    
    
    
}




- (void)runShareWithType:(UMSocialPlatformType)type AndFilename:(NSString *)name url:(NSString *)url
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:name descr:@" " thumImage:[UIImage imageNamed:@"pdf"]];
    shareObject.webpageUrl = url;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
    
    
    
}
@end
