//
//  HYScheduleBoltingView.m
//  SLAPP
//
//  Created by apple on 2019/1/28.
//  Copyright © 2019 柴进. All rights reserved.
//


#import "HYBoltingHeaderView.h"
#import "HYScheduleBoltingView.h"
#import "HYBoltingCell.h"
#import "HYBoltingDepAndMemberView.h"
@interface HYScheduleBoltingView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSMutableArray *proArray;
@property(nonatomic,strong)HYBoltingDepAndMemberView *depMemberView;

//选中的人员与部门
@property(nonatomic,strong)HYDepMemberModel *selectModel;
//选中的日程
@property(nonatomic,strong)HYScheduleListModel *selectSchedulemodel;

@end

@implementation HYScheduleBoltingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _proArray = [NSMutableArray array];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        [self configUI];
    }
    return self;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch
{
    return [touch.view isEqual:self];
}


-(void)configUI{
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth+40, kNav_height, kScreenWidth-40, kScreenHeight-kNav_height - kTab_height +49)];
    [self addSubview:_backView];
    _backView.backgroundColor = [UIColor whiteColor];
   
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(_backView.frame.size.width-10, 50.0f);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 0, _backView.frame.size.width-10, _backView.frame.size.height-49) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[HYBoltingCell class] forCellWithReuseIdentifier:@"Cell"];
    [_collectionView registerClass:[HYBoltingHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
   
    [_backView addSubview:_collectionView];
    
    layout.itemSize = CGSizeMake((_backView.frame.size.width-20)/3, 30);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    kWeakS(weakSelf);
    [UIView animateWithDuration: 1 animations:^{
        weakSelf.backView.frame = CGRectMake(40, kNav_height, kScreenWidth-40, kScreenHeight-kNav_height - kTab_height + 49);

    }];
    
    CGFloat width = _backView.frame.size.width/2;
    UIButton * reSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reSetBtn.frame = CGRectMake(0, _backView.frame.size.height-49,width,49);
    [reSetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [reSetBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_backView addSubview:reSetBtn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.backgroundColor = kgreenColor;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(width, _backView.frame.size.height-49, width, 49);
    [_backView addSubview:sureBtn];
    
    [reSetBtn addTarget:self action:@selector(reSetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HYBoltingHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    headerView.right.text = @"";
    headerView.left.text =  indexPath.section == 0 ? @"部门和人员": @"相关日程" ;
    if (indexPath.section == 0) {
        if ([_selectModel.id isNotEmpty]) {
            headerView.right.text = _selectModel.name;
        }
    }
    
    if (indexPath.section == 1) {
        if ([_selectSchedulemodel.id isNotEmpty]) {
            headerView.right.text = _selectSchedulemodel.title;
        }
    }
    
    
    
    return headerView;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        if ([self.model.dep_member isNotEmpty]) {
            return  [self.model.dep_member count];
        }
        return 0;
    }
    
    return [_proArray count];
    
}


//-(CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    return  CGSizeMake(100, 40);
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HYBoltingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        HYDepMemberModel *model = self.model.dep_member[indexPath.row];
        cell.content.text = model.name;
        if (_selectModel && [_selectModel.key isEqualToString:model.key] && [_selectModel.id isEqualToString:model.id]) {
            [cell selectWithStatus:YES];
        }else{
            [cell selectWithStatus:NO];
        }
        
        
    }else{
        HYScheduleListModel *model = _proArray[indexPath.row];
        cell.content.text = model.title;
        if (_selectSchedulemodel && [_selectSchedulemodel.id isEqualToString:model.id] ){
            [cell selectWithStatus:YES];
        }else{
            [cell selectWithStatus:NO];
        }
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HYDepMemberModel *model = self.model.dep_member[indexPath.row];
        
        if (_selectModel && [_selectModel.id isEqualToString:model.id] && [model.key isEqualToString:model.key]) {
            
        }else{
            
            _selectSchedulemodel = nil;
            if (![model.name isEqualToString:@"更多"] && ![model.id isEqualToString:@""]) {
                _selectModel = model;
                
            }
            [self getScheduleWithModel:model];
        }
        
        
    }else{
        HYScheduleListModel *model = _proArray[indexPath.row];
        _selectSchedulemodel = model;
    }
    
    [collectionView reloadData];
    
    
}


-(void)setModel:(HYBoltingModel *)model{
    _model = model;
    
   if ([model.is_more integerValue] == 1) {
         HYDepMemberModel * mmodel = [[HYDepMemberModel alloc] init];
        mmodel.name = @"更多";
        mmodel.key = @"";
        NSMutableArray * array = [NSMutableArray arrayWithArray:model.dep_member];
        [array addObject:mmodel];
       _model.dep_member = array;
   }
    
    if ([_model.dep_member isNotEmpty]) {
        _selectModel = _model.dep_member.firstObject;
    }
    
   
    
    
    _proArray = [NSMutableArray arrayWithArray:model.list];
    
}

/**
 把历史选中的赋值
 
 @param depModel 部门或者成员
 @param selectSchedulemodel 日程
 */
-(void)configWithSelectDepModel:(HYDepMemberModel *)depModel AndSelectScheduleModel:(HYScheduleListModel *)selectSchedulemodel{
    if ([depModel isNotEmpty] && [selectSchedulemodel isNotEmpty]) {
        _selectModel = depModel;
        _selectSchedulemodel = selectSchedulemodel;
        
        [self getScheduleWithModel:depModel];
    }
}


-(void)tapClick:(UITapGestureRecognizer *)tap{
        if (self.result) {
            self.result(_selectModel, _selectSchedulemodel);
        }
     [self removeFromSuperview];
}


-(void)reSetBtnClick{
    _selectModel  = nil;
    _selectSchedulemodel = nil;
//    if (self.result) {
//        self.result(_selectModel, _selectSchedulemodel);
//    }
    [_collectionView reloadData];
    
}

-(void)sureBtnClick{
    if (self.result) {
        self.result(_selectModel, _selectSchedulemodel);
    }
    
}






-(void)getScheduleWithModel:(HYDepMemberModel *)model{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([model.key isEqualToString:@"dep"]) {
        //部门
        params[@"inquire_dep_id"] = model.id;
    }else if ([model.key isEqualToString:@"member"]){
        //人员
        params[@"inquire_member_id"] = model.id;
    }else{
        [self toShowDepAndMember];
        return;
    }
    
    [self showOCProgress];
    kWeakS(weakSelf);
    [HYBaseRequest getPostWithMethodName:kScheduleDepMemberList Params:[params addToken]showToast:YES Success:^(NSDictionary *result) {
        
        
        [weakSelf showDismiss];
        [weakSelf.proArray removeAllObjects];
        if ([result[@"list"] isNotEmpty]) {
            [weakSelf.proArray addObjectsFromArray:[HYScheduleListModel mj_objectArrayWithKeyValuesArray:result[@"list"]]];
            
        }
        [weakSelf.collectionView reloadData];
        
    } fail:^(NSDictionary *result) {
        
        [weakSelf showDismissWithError];
    }];
    
    
}


/**
 点击更多后弹出部门与人员界面
 */
-(void)toShowDepAndMember{
    kWeakS(weakSelf);
    [self.backView addSubview:self.depMemberView];
    
    
    self.depMemberView.result = ^(HYDepMemberModel * _Nonnull selectModel) {
        weakSelf.selectModel = selectModel;
        [weakSelf.depMemberView removeFromSuperview];
        weakSelf.depMemberView = nil;
        
        if ([selectModel.key isNotEmpty] && [selectModel.id isNotEmpty]) {
            [weakSelf getScheduleWithModel:selectModel];
        }else{
            [weakSelf.proArray removeAllObjects];
            [weakSelf.collectionView reloadData];
        }
        
    };
    
    
    [UIView animateWithDuration: 1 animations:^{
        weakSelf.depMemberView.frame = CGRectMake(0, 0, weakSelf.backView.bounds.size.width, weakSelf.backView.bounds.size.height);
    }];
    
}





-(HYBoltingDepAndMemberView *)depMemberView{
   if (!_depMemberView) {
        _depMemberView = [[HYBoltingDepAndMemberView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, self.backView.bounds.size.width, self.backView.bounds.size.height)];
        _depMemberView.model = _model;
    }
    
    return _depMemberView;
}

@end
