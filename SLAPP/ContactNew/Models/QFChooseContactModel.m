//
//  QFChooseContactModel.m
//  SLAPP
//
//  Created by yons on 2018/10/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

#import "QFChooseContactModel.h"

@implementation QFChooseContactModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.id = @"";
        self.name = @"";
        self.phone = @"";
        self.email = @"";
        self.realname = @"";
        self.client_name = @"";
        self.client_id = @"";
        self.addtime = @"";
        self.position_name = @"";
        self.have_projects = @"";
        self.dep = @"";
        self.corpid = @"";
        self.userid = @"";
        self.phone_other = @"";
        self.key = @"";
        self.pinyin = @"";
        self.trade_id_one = @"";
        self.trade_name_one = @"";
        self.trade_id_two = @"";
        self.trade_name_two = @"";
        self.fo_count = @"";
        self.msg_count = @"";
        self.head = @"";
        self.headerImage = [NSData data];
        self.qf_select_status = @"";
    }
    return self;
}

- (void)setAllContactModelWithDict:(NSDictionary *)dict{
    self.addtime = [NSString stringWithFormat:@"%@",dict[@"addtime"]];
    self.client_id = [NSString stringWithFormat:@"%@",dict[@"client_id"]];
    self.client_name = [NSString stringWithFormat:@"%@",dict[@"client_name"]];
    self.corpid = [NSString stringWithFormat:@"%@",dict[@"corpid"]];
    self.dep = [NSString stringWithFormat:@"%@",dict[@"dep"]];
    self.email = [NSString stringWithFormat:@"%@",dict[@"email"]];
    self.fo_count = [NSString stringWithFormat:@"%@",dict[@"fo_count"]];
    self.id = [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.key = [NSString stringWithFormat:@"%@",dict[@"key"]];
    self.msg_count = [NSString stringWithFormat:@"%@",dict[@"msg_count"]];
    self.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
    self.phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
    self.phone_other = [NSString stringWithFormat:@"%@",dict[@"phone_other"]];
    self.position_name = [NSString stringWithFormat:@"%@",dict[@"position_name"]];
    self.realname = [NSString stringWithFormat:@"%@",dict[@"realname"]];
    self.trade_id_one = [NSString stringWithFormat:@"%@",dict[@"trade_id_one"]];
    self.trade_id_two = [NSString stringWithFormat:@"%@",dict[@"trade_id_two"]];
    self.trade_name_one = [NSString stringWithFormat:@"%@",dict[@"trade_name_one"]];
    self.trade_name_two = [NSString stringWithFormat:@"%@",dict[@"trade_name_two"]];
    self.userid = [NSString stringWithFormat:@"%@",dict[@"userid"]];
    self.qf_select_status = @"default";
}

- (void)setAdressContactModelWithPerson:(LJPerson *)person{
    LJPhone *phones = [person.phones firstObject];
    LJEmail *emails = [person.emails firstObject];
    NSData *imageData = person.thumbnailImageData;
    if (imageData == nil) {
        imageData = [NSData data];
    }
    self.qf_select_status = @"default";
    self.name = [NSString stringWithFormat:@"%@",person.fullName];
    self.phone = [NSString stringWithFormat:@"%@",phones.phone];
    self.email =  [NSString stringWithFormat:@"%@",emails.email];
   // self.pinyin = [NSString stringWithFormat:@"%@",person.pinyin];
    self.headerImage = imageData;
}
- (void)setAlreadyModelWithDict:(NSDictionary *)dict{
    self.qf_select_status = @"default";
    self.dep = [NSString stringWithFormat:@"%@",dict[@"dep"]];
    self.have_projects = [NSString stringWithFormat:@"%@",dict[@"have_projects"]];
    self.id =  [NSString stringWithFormat:@"%@",dict[@"id"]];
    self.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
    self.position_name = [NSString stringWithFormat:@"%@",dict[@"position_name"]];;
}
@end
