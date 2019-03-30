//
//  HYScheduleListModel.h
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYScheduleListModel : NSObject <NSMutableCopying>

@property(nonatomic,strong)NSString *dep_id;
@property(nonatomic,assign)double end_time;
@property(nonatomic,assign)double begin_time;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *is_del;
@property(nonatomic,strong)NSString *more;
@property(nonatomic,strong)NSString *reminder_time;
@property(nonatomic,strong)NSString *save_time;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *realname;


@property(nonatomic,strong)NSString *showTime;//显示的时间
@property(nonatomic,strong)NSString *showDay; //显示的日期
@property(nonatomic,strong)NSString *showWeek;    //显示的星期
@property(nonatomic,assign)double monthTime;
@property(nonatomic,strong)NSString *showEndTime;

@end

NS_ASSUME_NONNULL_END
