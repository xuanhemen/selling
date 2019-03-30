//
//  HYBaseDelegate.m
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//
#import <objc/runtime.h>
#import "HYBaseDelegate.h"

#import "SLAPP-Swift.h"
@interface HYBaseDelegate ()


@end

@implementation HYBaseDelegate


- (instancetype)initWithCellIde:(NSString *)cellIde AndAutoCellHeight:(CGFloat)autoHeight modelKey:(NSString *)modelKey AndDidSelectIndexWith:(void (^)(NSIndexPath *indexPath,UITableView * tableView,id model))didSelect{
    self = [super init];
    if (self){
        _cellIde = cellIde;
        _cellHeight = autoHeight;
        _dataArray = [NSMutableArray array];
        _myDidSelect = [didSelect copy];
        _modelKey = modelKey;
        if (![_modelKey isNotEmpty]){
            _modelKey = @"model";
        }
    }
    
    return self;
}




//- (CGFloat)fd_heightForCellWithIdentifier:(NSString *)identifier configuration:(void (^)(id cell))configuration


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_cellHeight <= 0) {
        kWeakS(weakSelf);
        return [tableView fd_heightForCellWithIdentifier:_cellIde configuration:^(UITableViewCell *cell)
                {
                    
                    if (indexPath.row <weakSelf.dataArray.count) {
                        [cell setValue:weakSelf.dataArray[indexPath.row] forKey:weakSelf.modelKey];
                    }
                    
                }];
        
    }
    
    return _cellHeight;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_cellIde){
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIde];
    if (!cell){
        NSString * path = [[NSBundle mainBundle]pathForResource:_cellIde ofType:@"nib"];
        if  (!path || path.length == 0)
        {
            cell = [[NSClassFromString(_cellIde) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_cellIde];
        }
        else
        {
            cell = [NSClassFromString(_cellIde) loadBundleNib];
        }
    }
    
    if (indexPath.row<[self.dataArray count]) {
        [cell setValue:[self.dataArray objectAtIndex:indexPath.row] forKey:_modelKey];
    }
    if (_configCell){
        _configCell(cell,indexPath);
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (_myDidSelect){
        _myDidSelect(indexPath,tableView,_dataArray[indexPath.row]);
        
    }
}



/**
 判断是否有某个属性
 
 @return <#return value description#>
 */
- (BOOL)isHasIvar{
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList(NSClassFromString(_cellIde), &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        if ([[NSString stringWithFormat:@"%s",name] isEqualToString:@"model"]) {
            free(ivars);
            return YES;
        }
    }
    free(ivars);
    return NO;
    
}


@end

