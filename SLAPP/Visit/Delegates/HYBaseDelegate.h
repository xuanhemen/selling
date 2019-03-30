//
//  HYBaseDelegate.h
//  SLAPP
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+LoadNib.h"
#import "UITableView+FDTemplateLayoutCell.h"
@interface HYBaseDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *cellIde;
@property(nonatomic,strong)NSString *modelKey;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,copy)void (^myDidSelect)(NSIndexPath *indexPath,UITableView * tableView,id model);
@property(nonatomic,strong)void (^configCell)(id cell,NSIndexPath *index);


/**
 实例对象
 
 @param cellIde cellIdel 必须是对应的cell 类名
 @param autoHeight cell 的高度，  传入 0 将 UITableView+FDTemplateLayoutCell 自动算，否则就是你传入的高度
 @return
 */

/**
 实例对象
 
 @param cellIde 必须是对应的cell 类名
 @param autoHeight cell 的高度，  传入 0 将 UITableView+FDTemplateLayoutCell 自动算，否则就是你传入的高度
 @param modelKey 注意！！！！！cell的model 对应属性名称  不传会默认model cell最好继承HYBaseCell 继承后没有定义key对应的model会有日志提醒，某则直接崩溃
 @param didSelect 点击了某个cell  model为对应的参数
 @return 实例对象
 */


- (instancetype)initWithCellIde:(NSString *)cellIde AndAutoCellHeight:(CGFloat)autoHeight modelKey:(NSString *)modelKey AndDidSelectIndexWith:(void (^)(NSIndexPath *indexPath,UITableView * tableView,id model))didSelect;



@end
