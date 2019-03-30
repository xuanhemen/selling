//
//  GroupModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class Consult_info: BaseRealMModel {
    @objc dynamic var consult_id = ""    //在线辅导ID
    @objc dynamic var real_begintime = ""    //辅导实际开始时间戳
    @objc dynamic var real_endtime = ""    //辅导实际结束时间戳
    @objc dynamic var consult_status = ""    // 在线辅导状态
    @objc dynamic var teacher_sso_userid = ""    // 导师的通行证用户id
    
    override static func primaryKey()->String
    {
        return "consult_id";
    }
}

//群组表

class GroupModel: BaseRealMModel {
    @objc dynamic var is_open = ""    // 是否开放（0:私有;1:公开）
    @objc dynamic var user_max = ""   // 用户上限
    @objc dynamic var group_name = "" // 群组名
    @objc dynamic var owner_id = ""   // 群主用户ID
    @objc dynamic var groupid = ""    // 群组ID
    @objc dynamic var user_num = ""   // 用户数
    @objc dynamic var qr_url = ""     // 二维码
    @objc dynamic var auth_code = ""  // 验证码
    @objc dynamic var corpid = ""
    @objc dynamic var inputtime = ""
    @objc dynamic var icon_url = ""
    @objc dynamic var is_delete = ""
    @objc dynamic var updatetime = ""
    @objc dynamic var is_remove = "0" //会话是否被移除,默认值为0(0:否,1:是)
    
    //2.0新增字段
    @objc dynamic var parentid = "" //父群组id
    @objc dynamic var type = "" //类型(0:群组,1:话题)
    @objc dynamic var from_msg_uid = "" //融云消息id
    @objc dynamic var img_url = "" //话题图片url
    
    //在线辅导新增字段
    @objc dynamic var is_consult = NSNumber(value: 0)//是否在线辅导群组（0：否；1：是）;是否在线辅导话题（0：否；1：是）
    /// 1.consult_id在线辅导ID
    /// 2.real_begintime辅导实际开始时间戳
    /// 3.real_endtime辅导实际结束时间戳
    ///4.consult_status 在线辅导状态
    /*1 4 取消
     2 5 辅导中
     3 6 辅导结束*/
    @objc dynamic var consult_info:Consult_info?

    
    
    //新增字段   云教练 1.0 对应迁移版本 2
    @objc dynamic var project_id:String = ""
    
    
    
    
    override static func primaryKey()->String
    {
        return "groupid";
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
