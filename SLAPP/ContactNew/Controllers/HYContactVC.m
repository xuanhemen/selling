//
//  HYContactVC.m
//  SLAPP
//
//  Created by qwp on 2018/9/12.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYContactVC.h"
#import <YBPopupMenu/YBPopupMenu.h>
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"
#import "HYAddContactVC.h"
#import "HYContactNewCell.h"
#import "UIView+NIB.h"
#import "HYContactDetailVC.h"
#import "SLContactClientModel.h"
#import "SLContactMoreClientVC.h"
@interface HYContactVC ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
}
@property (nonatomic,strong) NSMutableDictionary *contactList;
@property (nonatomic,strong) NSMutableArray *contactArray;
@property (nonatomic,strong) UITableView *tableView;



@end

@implementation HYContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self dataInit];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self contactRes];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - base
- (void)configUI{
    
    self.title = @"联系人";
    self.tableView = [[UITableView alloc] initWithFrame: CGRectMake(0,0,kScreenWidth, kScreenHeight-QFTopHeight) style:UITableViewStylePlain];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(contactRes)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"nav_add_new"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[rightBarBtn,searchItem];
}
#pragma mark - 搜索跳转
- (void)searchButtonClick:(UIButton*)sender{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.from = 4;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)rightClick:(UIButton *)btn{
    [YBPopupMenu showRelyOnView:btn titles:@[@"直接添加",@"扫名片"] icons:@[] menuWidth:100 delegate:self];
}

- (void)dataInit{
    self.contactList = [NSMutableDictionary dictionary];
    self.contactArray = [NSMutableArray array];
    
}


- (void)contactRes{
    __weak HYContactVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.contact" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.contactArray removeAllObjects];
        [weakSelf.contactList removeAllObjects];
        NSDictionary *temp = result[@"list"];
        [weakSelf.contactList setObject:result[@"viewed"] forKey:@"viewed"];
        
        for(NSDictionary *oneTemp in temp){
            if (weakSelf.contactList[oneTemp[@"key"]] != nil){
                NSMutableArray *arr = [NSMutableArray arrayWithArray:weakSelf.contactList[oneTemp[@"key"]]];
                [arr addObject:oneTemp];
                [weakSelf.contactList setObject:arr forKey:oneTemp[@"key"]];
            }else{
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObject:oneTemp];
                [weakSelf.contactList setObject:arr forKey:oneTemp[@"key"]];
                [weakSelf.contactArray addObject:oneTemp[@"key"]];
            }
        }
        
       [weakSelf.contactArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj1 compare:obj2 options:NSForcedOrderingSearch];
        }];
        //        weakSelf.contactArray.sort(by: {
        //            return $0 < $1
        //        })
        
       
        [weakSelf.tableView reloadData];
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.contactArray.count > 0) {
        if (self.contactList[@"viewed"] == nil){
            return self.contactArray.count;
        }
        NSArray *array = self.contactList[@"viewed"];
        if ([array count] == 0){
            return self.contactArray.count;
        }
    }
    return self.contactArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.contactList[@"viewed"];
    
    
    if (self.contactArray.count > 0){
        if (array == nil || [array count] == 0){
            NSArray *returnArray = self.contactList[self.contactArray[section]];
            return [returnArray count];
        }
    }
    
    if (section == 0){
        if (array == nil){
            return 0;
        }
        
        return [array count];
    }else{
        NSArray *returnArray = self.contactList[self.contactArray[section - 1]];
        return [returnArray count];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIde = @"HYContactNewCell";
    HYContactNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell = [HYContactNewCell loadBundleNib];
    }
    
    
    if (self.contactArray.count > 0) {
        NSArray *array = self.contactList[@"viewed"];
        if (array == nil || [array count] == 0){
            NSDictionary *dict = self.contactList[self.contactArray[indexPath.section]][indexPath.row];
            cell.cellNameLabel.text = [dict[@"name"] toString];
            cell.cellPositionLabel.text = [dict[@"position_name"] toString];
            cell.cellCompanylabel.text = [dict[@"client_name"] toString];
            cell.dict = dict;
            cell.redView.hidden = [dict[@"msg_count"] integerValue] + [dict[@"fo_count"] integerValue] == 0;
            return cell;
            
        }
        
    }
    if (indexPath.section == 0){
        
        
        cell.cellNameLabel.text = [self.contactList[@"viewed"][indexPath.row][@"name"] toString];
        cell.cellPositionLabel.text = [self.contactList[@"viewed"][indexPath.row][@"position_name"] toString];
        cell.cellCompanylabel.text = [self.contactList[@"viewed"][indexPath.row][@"client_name"] toString];
        cell.dict = self.contactList[@"viewed"][indexPath.row];
        NSDictionary *dic = self.contactList[@"viewed"][indexPath.row];
        cell.redView.hidden = [dic[@"msg_count"] integerValue] + [dic[@"fo_count"] integerValue] == 0;
        
    }else{
        cell.cellNameLabel.text = [self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row][@"name"] toString];
        cell.cellPositionLabel.text = [self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row][@"position_name"] toString];
        cell.cellCompanylabel.text = [self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row][@"client_name"] toString];
        //hhhjjj
        NSDictionary *dic = self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row];
        cell.dict = dic;
        cell.redView.hidden = [dic[@"msg_count"] integerValue] + [dic[@"fo_count"] integerValue] == 0;
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak HYContactVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    NSDictionary *tempDic;
    
    NSArray *viewedArray = self.contactList[@"viewed"];
    //            if contactArray.count > 0 {
    if (viewedArray == nil || viewedArray.count == 0){
        
        tempDic = self.contactList[self.contactArray[indexPath.section]][indexPath.row];
        
    }else{
        if (indexPath.section == 0){
            tempDic = self.contactList[@"viewed"][indexPath.row];
            
        }else{
            tempDic = self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row];
            
        }
    }
    /**新版跳转*/
    
    //    cvc.contact_id = [self.contactList[@"viewed"][indexPath.row][@"id"] toString];
    //    cvc.client_id = [self.contactList[@"viewed"][indexPath.row][@"client_id"]  toString];
    NSArray * arr = tempDic[@"client_all"];
    NSMutableArray * clientModels = [SLContactClientModel mj_objectArrayWithKeyValuesArray:arr];
    if ([clientModels count]==1) {
        SLContactClientModel *model = clientModels[0];
        HYContactDetailVC * cvc = [[HYContactDetailVC alloc]init];
        cvc.contact_id = model.contact_id;
        cvc.client_id = model.client_id;
        [self.navigationController pushViewController:cvc animated:YES];
    }else{
        NSArray * phoneArr = tempDic[@"phone_arr"];
        SLContactMoreClientVC *  mvc = [[SLContactMoreClientVC alloc]init];
        mvc.dataArr = clientModels;
        mvc.phoneArr = phoneArr;
        mvc.name = tempDic[@"name"];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
//    NSDictionary *tempDic;
//    NSArray *viewedArray = self.contactList[@"viewed"];
//    //            if contactArray.count > 0 {
//    if (viewedArray == nil || viewedArray.count == 0){
//
//        tempDic = self.contactList[self.contactArray[indexPath.section]][indexPath.row];
//    }else{
//        if (indexPath.section == 0){
//            tempDic = self.contactList[@"viewed"][indexPath.row];
//        }else{
//            tempDic = self.contactList[self.contactArray[indexPath.section - 1]][indexPath.row];
//        }
//    }
//
//    //            }
//
//
//
//    [self showProgressWithStr:@"获取联系人信息中..."];
//    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.contact_one" Params:@{@"token":model.token,@"contact_id":tempDic[@"id"]} showToast:YES Success:^(NSDictionary *result) {
//        [weakSelf dismissProgress];
//        NSLog(@"联系人详情:%@",result);
//
//        ContactDetailVC *vc = [[ContactDetailVC alloc] init];
//
//        vc.modelDic = result;
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    } fail:^(NSDictionary *result) {
//        [weakSelf dissmissWithError];
//    }];
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSArray * viewedArray = self.contactList[@"viewed"];
    
    if (self.contactArray.count > 0 ){
        if (viewedArray == nil){
            return self.contactArray;
        }
        
        if( viewedArray.count == 0){
            return self.contactArray;
        }
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@"最近使用"];
        [array addObjectsFromArray:self.contactArray];
        return array;
        
    }else{
        return self.contactArray;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *viewedArray = self.contactList[@"viewed"];
    if (self.contactArray.count > 0) {
        
        if (viewedArray == nil){
            return self.contactArray[section];
        }
        if (viewedArray.count == 0){
            return self.contactArray[section];
        }
        NSMutableArray *newArray = [NSMutableArray array];
        [newArray addObject:@"最近使用"];
        [newArray addObjectsFromArray:self.contactArray];
        return newArray[section];
    }else{
        return @"";
    }
    
}

#pragma mark - 名片添加
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index{
    NSArray  *array = @[@"直接添加",@"扫名片"];
    NSString *str = array[index];
    __weak HYContactVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:@"pp.user.loginer_message" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        UserModel *userModel = [UserModel getUserModel];
        userModel.is_root = [NSString stringWithFormat:@"%@",result[@"is_root"]];
        userModel.depId = [NSString stringWithFormat:@"%@",result[@"dep_id"]];
        [userModel saveUserModel];
        
        if ([str isEqualToString:@"直接添加"]){
//            AddContactVC *vc = [[AddContactVC alloc] init];
//            vc.needUpdate = ^{
//                [weakSelf contactRes];
//            };
//            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            HYAddContactVC *vc = [[HYAddContactVC alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else if([str isEqualToString:@"扫名片"]) {
            [weakSelf alertPicture];
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dissmissWithError];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
- (void)alertPicture{
    __weak HYContactVC *weakSelf = self;
    
    
    
    AVMediaType mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的相机。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }
    
    
    PHAuthorizationStatus pauthStatus = [PHPhotoLibrary authorizationStatus];
    if(pauthStatus == PHAuthorizationStatusRestricted || pauthStatus == PHAuthorizationStatusDenied){
        //无权限
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的照片。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:sureAction];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }
    
    
    UIImagePickerController *imagePickerCntroller = [[UIImagePickerController alloc] init];
    imagePickerCntroller.delegate = self;
    imagePickerCntroller.allowsEditing = NO;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerCntroller.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerCntroller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [weakSelf presentViewController:imagePickerCntroller animated:YES completion:^{
            
        }];
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerCntroller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:imagePickerCntroller animated:YES completion:^{
            
        }];
        
    }];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alert addAction:cameraAction];
    }
    [alert addAction:photosAction];
    [alert addAction:cancelAction];
    
    [weakSelf presentViewController:alert animated:YES completion:^{
        
    }];
}
// 完成图片的选取后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    /* 此处参数 info 是一个字典，下面是字典中的键值 （从相机获取的图片和相册获取的图片时，两者的info值不尽相同）
     * UIImagePickerControllerMediaType; // 媒体类型
     * UIImagePickerControllerOriginalImage; // 原始图片
     * UIImagePickerControllerEditedImage; // 裁剪后图片
     * UIImagePickerControllerCropRect; // 图片裁剪区域（CGRect）
     * UIImagePickerControllerMediaURL; // 媒体的URL
     * UIImagePickerControllerReferenceURL // 原件的URL
     * UIImagePickerControllerMediaMetadata // 当数据来源是相机时，此值才有效
     */
    
    __weak HYContactVC *weakSelf = self;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    QFVcardVC *vcardVC = [[QFVcardVC alloc] init];
    vcardVC.image = image;
    vcardVC.retakePicture = ^{
        [weakSelf alertPicture];
    };
    vcardVC.save = ^{
        [weakSelf contactRes];
    };
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [self.navigationController pushViewController:vcardVC animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
