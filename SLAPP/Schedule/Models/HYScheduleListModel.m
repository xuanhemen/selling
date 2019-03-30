//
//  HYScheduleListModel.m
//  SLAPP
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 柴进. All rights reserved.
//

#import "HYScheduleListModel.h"

@implementation HYScheduleListModel



- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    HYScheduleListModel *model = [[[self class] allocWithZone:zone] init];
    model.dep_id = self.dep_id;
    model.end_time = self.end_time;
    model.begin_time = self.begin_time;
    model.id = self.id;
    model.is_del = self.is_del;
    model.more = self.more;
    model.reminder_time = model.reminder_time;
    model.save_time = self.save_time;
    model.title = self.title;
    model.userid = self.userid;
    model.showDay = self.showDay;
    model.showWeek = self.showWeek;
    model.monthTime = self.monthTime;
    model.realname = self.realname;
    return model;
}

@end
