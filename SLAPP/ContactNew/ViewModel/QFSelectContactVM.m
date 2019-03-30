//
//  QFSelectContactVM.m
//  SLAPP
//
//  Created by yons on 2018/10/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFSelectContactVM.h"
#import "SLAPP-Swift.h"
#import "HYBaseRequest.h"

#import <LJContactManager/LJContactManager.h>


@implementation QFSelectContactVM
#pragma mark - 数据获取

- (void)fetchClientContact:(NSString *)clientid andNeedDistinct:(NSArray *)alreadyArray andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block{
    __weak QFSelectContactVM *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.customer_contact" Params:@{@"token":model.token,@"client_id":clientid} showToast:YES Success:^(NSDictionary *result) {
        
        NSArray *array = result[@"list"];
        NSMutableArray *delArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            QFChooseContactModel *model = [[QFChooseContactModel alloc] init];
            [model setAllContactModelWithDict:dict];
            for (NSDictionary *dic in alreadyArray) {
                if ([model.id isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {
                    model.qf_select_status = @"already";
                }
            }
            [delArray addObject:model];
        }
        array = delArray;
        NSArray *keyArray = [weakSelf arraySortASCWithArray:array];
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSString *key in keyArray) {
            NSMutableArray *memberArray = [NSMutableArray array];
            for (QFChooseContactModel *model in array) {
                if ([model.key isEqualToString:key]) {
                    [memberArray addObject:model];
                }
            }
            NSSortDescriptor *nameSD = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *newArray = [[memberArray sortedArrayUsingDescriptors:@[nameSD]] mutableCopy];
            [dataArray addObject:newArray];
        }
        block(YES,dataArray,keyArray);
    } fail:^(NSDictionary *result) {
        block(NO,nil,nil);
    }];
}

- (void)fetchAllContactAndNeedDistinct:(NSArray *)alreadyArray andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block{
    __weak QFSelectContactVM *weakSelf = self;
    UserModel *model = [UserModel getUserModel];
    
    [HYBaseRequest getPostWithMethodName:@"pp.clientContact.contact" Params:@{@"token":model.token} showToast:YES Success:^(NSDictionary *result) {
        
        NSArray *array = result[@"list"];
        NSMutableArray *delArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            QFChooseContactModel *model = [[QFChooseContactModel alloc] init];
            [model setAllContactModelWithDict:dict];
            for (NSDictionary *dic in alreadyArray) {
                if ([model.id isEqualToString:[NSString stringWithFormat:@"%@",dic[@"id"]]]) {
                    model.qf_select_status = @"already";
                }
            }
            [delArray addObject:model];
        }
        array = delArray;
        NSArray *keyArray = [weakSelf arraySortASCWithArray:array];
        NSMutableArray *dataArray = [NSMutableArray array];
        
        for (NSString *key in keyArray) {
            NSMutableArray *memberArray = [NSMutableArray array];
            for (QFChooseContactModel *model in array) {
                if ([model.key isEqualToString:key]) {
                    [memberArray addObject:model];
                }
            }
            NSSortDescriptor *nameSD = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
            NSArray *newArray = [[memberArray sortedArrayUsingDescriptors:@[nameSD]] mutableCopy];
            [dataArray addObject:newArray];
        }
        block(YES,dataArray,keyArray);
    } fail:^(NSDictionary *result) {
        block(NO,nil,nil);
    }];
}
- (NSArray *)arraySortASCWithArray:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (QFChooseContactModel *model in array) {
        [tempArray addObject:model.key];
    }
    NSSet *set = [NSSet setWithArray:tempArray];
    NSArray *result = [[set allObjects] sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    return result;
}


#pragma mark - 通讯录获取
- (void)fetchAdressBookWithContacts:(NSArray *)contacts andKeys:(NSArray *)keys andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block{
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i=0; i<contacts.count; i++) {
        LJSectionPerson *sectionP = contacts[i];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int j=0; j<sectionP.persons.count; j++) {
            QFChooseContactModel *model = [[QFChooseContactModel alloc] init];
            LJPerson *person = sectionP.persons[j];
            [model setAdressContactModelWithPerson:person];
            [tempArray addObject:model];
        }
        [dataArray addObject:tempArray];
    }
    block(YES,dataArray,keys);
}

#pragma mark - 本地传联系人
- (void)fetchDeleteArrayWithAlreadyArray:(NSArray *)array andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        QFChooseContactModel *model = [[QFChooseContactModel alloc] init];
        [model setAlreadyModelWithDict:dict];
        [dataArray addObject:model];
    }
    block(YES,@[dataArray],@[@"QF"]);
}
@end
