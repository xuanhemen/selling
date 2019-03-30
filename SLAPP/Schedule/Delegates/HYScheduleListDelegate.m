//
//  HYScheduleListDelegate.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//
#import "NSDate+Method.h"
#import "HYScheduleListDelegate.h"
#import "HYScheduleListModel.h"
@implementation HYScheduleListDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.cellHeight <= 0) {
        kWeakS(weakSelf);
        return [tableView fd_heightForCellWithIdentifier:self.cellIde configuration:^(UITableViewCell *cell)
                {
                    NSArray *subArray = weakSelf.dataArray[indexPath.section];
                    
                    if (indexPath.row <subArray.count) {
                        [cell setValue:subArray[indexPath.row] forKey:weakSelf.modelKey];
                    }
                    
                }];
        
    }
    
    return self.cellHeight;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSArray *array = (NSArray *)self.dataArray[section];
    if (array.count) {
        HYScheduleListModel *model = array.firstObject;
        lab.text = [NSString stringWithFormat:@"     %@",[NSDate getDateStyleYMWithTime:model.monthTime]];
    }
    return lab;
//    lab.text =
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.cellIde){
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIde];
    if (!cell){
        NSString * path = [[NSBundle mainBundle]pathForResource:self.cellIde ofType:@"nib"];
        if  (!path || path.length == 0)
        {
            cell = [[NSClassFromString(self.cellIde) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIde];
        }
        else
        {
            cell = [NSClassFromString(self.cellIde) loadBundleNib];
        }
    }
    NSArray *subArray = self.dataArray[indexPath.section];
    if (indexPath.row<[subArray count]) {
        [cell setValue:[subArray objectAtIndex:indexPath.row] forKey:self.modelKey];
    }
    if (self.configCell){
        self.configCell(cell,indexPath);
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.myDidSelect){
        
         NSArray *subArray = self.dataArray[indexPath.section];
    self.myDidSelect(indexPath,tableView,subArray[indexPath.row]);
        
    }
}




@end
