//
//  HYScheduleSearchBaseVC.h
//  SLAPP
//
//  Created by apple on 2019/1/25.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface HYScheduleSearchBaseVC : UIViewController <UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar *searchView;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataArray;//数据源

-(void)configData;

@end

NS_ASSUME_NONNULL_END
