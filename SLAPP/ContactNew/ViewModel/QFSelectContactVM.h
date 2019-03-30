//
//  QFSelectContactVM.h
//  SLAPP
//
//  Created by yons on 2018/10/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QFChooseContactModel.h"

typedef enum : NSUInteger {
    QF_ChooseContactType_address,
    QF_ChooseContactType_add,
    QF_ChooseContactType_minus,
} QF_ChooseContactType;



@interface QFSelectContactVM : NSObject

- (void)fetchClientContact:(NSString *)clientid andNeedDistinct:(NSArray *)alreadyArray andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block;

- (void)fetchAllContactAndNeedDistinct:(NSArray *)alreadyArray andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block;

- (void)fetchAdressBookWithContacts:(NSArray *)contacts andKeys:(NSArray *)keys andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block;


- (void)fetchDeleteArrayWithAlreadyArray:(NSArray *)array andBlock:(void(^)(BOOL isSuccess,NSArray *dataArray,NSArray *keyArray))block;

@end
