//
//  SLChooseView.h
//  SLAPP
//
//  Created by 董建伟 on 2018/12/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import <UIKit/UIKit.h>
/**定义类型*/
typedef void(^PassOpitionDic)(NSMutableDictionary *dic);

typedef void(^CommitInfo)(void);
@interface SLChooseView : UIWindow<UITableViewDelegate,UITableViewDataSource>


/** 数据列表 */
@property(nonatomic,strong)UITableView * tableView;
/** 数据源 */
@property(nonatomic,strong)NSMutableArray * dataArr;
/**传值*/
@property(nonatomic,copy)PassOpitionDic passOpitionDic;
/**提交*/
@property(nonatomic,copy)CommitInfo commitInfo;
/**展示视图*/
+(void)showViewWithArr:(NSMutableArray *)dataArr passVlue:(PassOpitionDic)dic commit:(CommitInfo)commit;

@end
