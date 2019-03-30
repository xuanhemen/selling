//
//  HYChooseTagVC.m
//  SLAPP
//
//  Created by yons on 2018/10/24.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "HYChooseTagVC.h"
#import "HYBaseRequest.h"
#import "SLAPP-Swift.h"
#import "HYTagView.h"
#import "HYAddTagVC.h"


@interface HYChooseTagVC ()<HYTagViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray  *dataArray;

@property (nonatomic,strong)NSMutableArray  *delSelectArray;
@property (nonatomic,strong)UIBarButtonItem *rightItem;

@property (nonatomic,strong)UIButton *sureButton;


@end

@implementation HYChooseTagVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.alreadyArray = [NSMutableArray array];
        self.delSelectArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择类型";
    
   
    [self configUI];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self dataInit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (void)dataInit{
    
    __weak HYChooseTagVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    NSDictionary *params = @{@"token":model.token,@"fo_id":@""};
    NSString *urlString = @"pp.followup.followup_class_list";
    [self showProgress];
    [HYBaseRequest getPostWithMethodName:urlString Params:params showToast:YES Success:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        NSArray *array = result[@"data"];
        if ([array isKindOfClass:[NSArray class]]&&array.count>0) {
            [weakSelf.dataArray removeAllObjects];
            for (int i=0; i<array.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:array[i]];
                NSInteger type = [dict[@"id"] integerValue]-1;
                if (type>4) {
                    type = 4;
                }
                [dict setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
                [weakSelf.dataArray addObject:dict];
            }
            NSMutableArray *tagarray = [NSMutableArray arrayWithArray:weakSelf.alreadyArray];
            for(NSString *idStr in tagarray){
                BOOL isExist = NO;
                for (NSDictionary *subDict in weakSelf.dataArray) {
                    if ([idStr isEqualToString:[NSString stringWithFormat:@"%@",subDict[@"id"]]]) {
                        isExist = YES;
                    }
                }
                if (isExist == NO) {
                    [weakSelf.alreadyArray removeObject:idStr];
                }
            }
            if ([weakSelf.rightItem.title isEqualToString:@"编辑"]) {
                [weakSelf.dataArray addObject:@{@"name":@"+ 自定义标签",@"id":@"",@"type":@"5"}];
            }
            [weakSelf refreshUI];
        }
        
    } fail:^(NSDictionary *result) {
        [weakSelf dismissProgress];
        
    }];
}
- (void)configUI{
    self.view.backgroundColor = UIColorFromRGB(0xEFEFF4);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-QFTopHeight-40-30)];
    [self.view addSubview:self.scrollView];
    
    self.rightItem =  [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    self.sureButton = [[UIButton alloc] initWithFrame:CGRectMake(40, kScreenHeight-60-QFTopHeight, kScreenWidth-80, 40)];
    self.sureButton.backgroundColor = UIColorFromRGB(0x6AB476);
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureButton.layer.cornerRadius = 4;
    self.sureButton.clipsToBounds = YES;
    [self.view addSubview:self.sureButton];
    
    NSArray *array = @[@{@"name":@"拜访",@"id":@"1",@"type":@"0"},
                       @{@"name":@"联系",@"id":@"2",@"type":@"1"},
                       @{@"name":@"商务",@"id":@"3",@"type":@"2"},
                       @{@"name":@"方案",@"id":@"4",@"type":@"3"},
                       @{@"name":@"+ 自定义标签",@"id":@"",@"type":@"5"}
                       ];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self refreshUI];
    
}
- (void)refreshUI{
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[HYTagView class]]) {
            HYTagView *tagV = (HYTagView *)subView;
            tagV.delegate = nil;
        }
        [subView removeFromSuperview];
    }
    CGFloat height = 30;
    CGFloat width = (kScreenWidth-30-15)/4.0;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dict = self.dataArray[i];
        HYTagView *tagView = [[HYTagView alloc] initWithFrame:CGRectMake(15+(width+5)*(i%4),  10+(height+5)*(i/4),width, height)];
        tagView.tag = i+1000;
        [tagView configTitle:dict[@"name"] andType:[dict[@"type"] integerValue] andIsEdit:[self.rightItem.title isEqualToString: @"完成"]];
        
        [tagView select:NO];
        for (NSString *idString in self.alreadyArray) {
            if ([[NSString stringWithFormat:@"%@",dict[@"id"]] isEqualToString:idString]) {
                [tagView select:YES];
            }
        }
        tagView.delegate = self;
        [self.scrollView addSubview:tagView];
        
    }
    
    NSInteger cnt = 0;
    if (self.dataArray.count%4 == 0) {
        cnt = self.dataArray.count/4;
    }else{
        cnt = self.dataArray.count+1;
    }
    self.scrollView.contentSize = CGSizeMake(0, cnt*height+(cnt-1)*5+20);
}

- (void)rightItemClick{
    [self.delSelectArray removeAllObjects];
    if ([self.rightItem.title isEqualToString:@"编辑"]) {
        self.rightItem.title = @"完成";
        self.sureButton.backgroundColor = UIColorFromRGB(0xDE483F);
        [self.sureButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.dataArray removeLastObject];
    }else if ([self.rightItem.title isEqualToString:@"完成"]) {
        self.rightItem.title = @"编辑";
        self.sureButton.backgroundColor = UIColorFromRGB(0x6AB476);
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.dataArray addObject:@{@"name":@"+ 自定义标签",@"id":@"",@"type":@"5"}];
    }
    [self refreshUI];
}
- (void)sureButtonClick:(UIButton *)sender{
    __weak HYChooseTagVC *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    if ([self.rightItem.title isEqualToString:@"编辑"]) {
        if (self.action) {
            
            NSMutableArray *nameArray = [NSMutableArray array];
            
            for (NSString *idString in self.alreadyArray) {
                for (NSDictionary *dict in self.dataArray) {
                    if ([idString isEqualToString:dict[@"id"]]) {
                        [nameArray addObject:[NSString stringWithFormat:@"%@", dict[@"name"]]];
                        break;
                    }
                }
            }
            
            self.action(self.alreadyArray, nameArray);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //删除
        if (self.delSelectArray.count<=0) {
            return;
        }
        NSMutableArray *idArray = [NSMutableArray array];
        for (NSDictionary *dict in self.delSelectArray) {
            [idArray addObject:dict[@"id"]];
        }
        
        NSDictionary *params = @{@"token":model.token,@"class_id":[idArray componentsJoinedByString:@","]};
        NSString *urlString = @"pp.followup.class_del";
        [self showProgress];
        [HYBaseRequest getPostWithMethodName:urlString Params:params showToast:YES Success:^(NSDictionary *result) {
            [weakSelf dismissProgress];
            [self dataInit];
        } fail:^(NSDictionary *result) {
            [weakSelf dissmissWithError];
        }];
    }
    
}

#pragma mark - tagView
- (void)addTagView:(HYTagView *)tagView{
    HYAddTagVC *addVC = [[HYAddTagVC alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)tagViewEditSelect:(HYTagView *)tagView{
    NSDictionary *dict = self.dataArray[tagView.tag-1000];
    BOOL isExist = NO;
    for (NSDictionary *subDict in self.delSelectArray) {
        if ([subDict[@"id"] isEqualToString:dict[@"id"]]) {
            [self.delSelectArray removeObject:subDict];
            isExist = YES;
            break;
        }
    }
    if (isExist) {
        tagView.editImageView.image = [UIImage imageNamed:@"qf_select_statusdefault"];
    }else{
        tagView.editImageView.image = [UIImage imageNamed:@"qf_select_statuschoose"];
        [self.delSelectArray addObject:dict];
    }
}
- (void)tagViewSelect:(HYTagView *)tagView{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.dataArray[tagView.tag-1000]];
    BOOL isExist = NO;
    for (NSString *idString in self.alreadyArray) {
        if ([[NSString stringWithFormat:@"%@",dict[@"id"]] isEqualToString:idString]) {
            isExist = YES;
        }
    }
    if (isExist) {
        [tagView select:NO];
        [self.alreadyArray removeObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    }else{
        [tagView select:YES];
        [self.alreadyArray addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
    }
}
@end
