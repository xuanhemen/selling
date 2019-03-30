//
//  GlobalDefines.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/12.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#ifndef GlobalDefines_h
#define GlobalDefines_h

#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

#define Global_mainBackgroundColor SDColor(248, 248, 248, 1)

//#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

#define TimeLineCellHighlightedColor [UIColor colorWithRed:106/255.f green:181/255.f blue:118/255.f alpha:1.0f]

#define DAY @"day"

#define NIGHT @"night"

//跟进记录接口

// MARK: - *********** 客户相关 **************

//客户-跟进记录-我收到的最新消息数量
static NSString * client_new_message_num = @"pp.followup.client_new_message_num";
//客户-跟进按钮右上角的小红点
static NSString * client_red_point = @"pp.followup.client_red_point";
//与我相关的消息
static NSString * client_my_follow_message = @"pp.followup.client_my_follow_message";
//客户-跟进记录-添加-联系人列表
static NSString * client_contacts = @"pp.followup.client_contacts";
//添加
static NSString * client_followup_add = @"pp.followup.client_followup_add";
//客户跟进记录
static NSString * client_followup = @"pp.followup.client_followup";

//联系人-与我相关的消息
static NSString * contact_followup_message = @"pp.followup.contact_my_follow_message";
//联系人-跟进记录-我收到的最新消息数量
static NSString * contact_newMessage_num = @"pp.followup.contact_new_message_num";
//联系人-跟进按钮右上角的小红点
static NSString * contact_red_point = @"pp.followup.contact_red_point";
//联系人-跟进记录
static NSString * contact_followup = @"pp.followup.contact_followup";
//联系人-添加跟进记录
static NSString * contact_add_followup = @"pp.followup.contact_followup_add";

//客户详情
static NSString * contact_customerDetail = @"pp.clientContact.client_one";

//回复某一条评论
static NSString * QF_Reply_Comments = @"pp.followup.reply_add";
//跟进详情
static NSString * QF_FollowUp_Detail = @"pp.followup.fo_detail";
//点赞
static NSString * QF_FollowUp_Comment = @"pp.followup.support";
//删除跟进
static NSString * QF_FollowUp_Delete = @"pp.followup.followup_del";
//添加评论
static NSString * QF_FollowUp_Add_Comment = @"pp.followup.comment_add";
//删除评论
static NSString * QF_FollowUp_Del_Comment = @"pp.followup.comment_del";
#endif
