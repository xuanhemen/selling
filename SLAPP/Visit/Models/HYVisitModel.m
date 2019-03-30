//
//  HYVisitModel.m
//  SLAPP
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYVisitModel.h"
#import "SLAPP-Swift.h"
@implementation HYVisitModel


- (void)setEditVisitResult:(NSDictionary *)editVisitResult{
    _editVisitResult = editVisitResult;
    
    if ([_editVisitResult isNotEmpty]) {
        
        _client_id = [_editVisitResult[@"client_id"] toString];
        _client_name = [_editVisitResult[@"client_name"] toString];
        _id = [_editVisitResult[@"id"] toString];
        _project_id = [_editVisitResult[@"project_id"] toString];
        _project_name = [_editVisitResult[@"project_name"] toString];
        _timeStamp = [_editVisitResult[@"visit_date"] doubleValue];
        
        
        NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
        [fomatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _visit_date =  [fomatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_timeStamp]] ;
        
        ProjectPlanStarModel *sModel = [[ProjectPlanStarModel alloc] init];
        sModel.name = [_editVisitResult[@"actiontypename"] toString];
        sModel.id = [_editVisitResult[@"actiontype"] toString];
        _starModel = sModel;
        
        
        
    }
    
}



/**
 获取我方参与   只有修改用
 
 @return <#return value description#>
 */
-(NSArray *)oursMember{
    
    if ([_editVisitResult isNotEmpty]) {
        
        if ([_editVisitResult[@"ouruser"] isNotEmpty]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *sub in _editVisitResult[@"ouruser"]) {
//                MemberModel *subModel = [MemberModel mj_objectWithKeyValues:sub];
                MemberModel *subModel = [[MemberModel alloc] init];
                subModel.id = [sub[@"userid"] toString];
                subModel.head = [sub[@"head"] toString];
                subModel.name = [sub[@"realname"] toString];
                [array addObject:subModel];
            }
            return array;
        }else{
            return @[];
        }
    }else{
        return @[];
    }
    
}

/**
 获取拜访对象  只有修改用
 
 @return <#return value description#>
 */
-(NSArray *)visitersMember{
    
    if ([_editVisitResult isNotEmpty]) {
        if ([_editVisitResult[@"visit_contacts"] isNotEmpty]) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *sub in _editVisitResult[@"visit_contacts"]) {
//                MemberModel *subModel = [MemberModel mj_objectWithKeyValues:sub];
                
                MemberModel *subModel = [[MemberModel alloc] init];
                subModel.id = [sub[@"id"] toString];
                subModel.head = [sub[@"head"] toString];
                subModel.name = [sub[@"name"] toString];
                [array addObject:subModel];
            }
            return array;
        }else{
            return @[];
        }
        
        
    }else{
        return @[];
    }
    
}

@end
