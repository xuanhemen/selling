//
//  SDTimeLineCellModel.h
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
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

#import <Foundation/Foundation.h>

@class SDTimeLineCellLikeItemModel, SDTimeLineCellCommentItemModel;

@interface SDTimeLineCellModel : NSObject
@property (nonatomic, copy) NSString *createname;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *msgContent;
@property (nonatomic, strong) NSArray *picNamesArray;
@property (nonatomic, copy)NSString *otherPeople;
@property (nonatomic,copy)NSString *addTime; //创建时间
@property (nonatomic,copy)NSString *createuserid;

@property (nonatomic, assign, getter = isLiked) BOOL liked;

@property (nonatomic, strong) NSArray<SDTimeLineCellLikeItemModel *> *likeItemsArray;
@property (nonatomic, strong) NSArray<SDTimeLineCellCommentItemModel *> *commentItemsArray;




@property (nonatomic, assign) BOOL isOpening;

@property (nonatomic, assign, readonly) BOOL shouldShowMoreButton;
@property (nonatomic, copy) NSString *id; //自己的id


@property (nonatomic, copy) NSString *remind_user_name; //提醒谁看名字
@property (nonatomic, copy) NSString *remind_user; //提醒谁看id
@property (nonatomic, copy) NSString *contactids; //联系人id
@property (nonatomic, copy) NSString *contactnames; //联系人名字

@property (nonatomic, copy) NSString *proId; //项目id
@property (nonatomic, copy) NSString *proName; //项目名称
@property (nonatomic, copy) NSString *client_id; //客户id
@property (nonatomic, copy) NSString *client_name; //客户名称

@property (nonatomic, copy) NSString *special_type; //特殊类型  行动计划   项目体检分析
@property (nonatomic, copy) NSDictionary *special_value;
@property (nonatomic, copy) NSArray *class_list; //标签列表

@end


@interface SDTimeLineCellLikeItemModel : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSAttributedString *attributedContent;

@end


@interface SDTimeLineCellCommentItemModel : NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;
@property (nonatomic, copy) NSString *id; //自己的id
@property (nonatomic, copy) NSString *fo_id;
@property (nonatomic, copy) NSAttributedString *attributedContent;

@end
