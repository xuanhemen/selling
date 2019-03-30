//
//  HYLookVisitEvaluationDelegate.m
//  SLAPP
//
//  Created by apple on 2018/10/17.
//  Copyright © 2018 柴进. All rights reserved.
//

#import "HYLookVisitEvaluationDelegate.h"
#import "HYRaderCell.h"
#import "HYLookEvaluationCell.h"
@implementation HYLookVisitEvaluationDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return kScreenWidth;
    }
    
    return 120;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count+1;
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0)
    {
        static NSString *cellIde = @"rCell";
        HYRaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
        if (!cell) {
            cell = [[HYRaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
        }
        cell.type = self.type;
        cell.dataArray = self.dataArray;
        return cell;
    }else{
        
        static NSString *cellName = @"HYLookEvaluationCell";
        HYLookEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[HYLookEvaluationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        DLog(@"%@",indexPath);
        cell.model = self.dataArray[indexPath.row-1];
        return cell;
        
    }
    
}



@end
