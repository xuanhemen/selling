//
//  GroupUserModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/3/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class GroupUserModel: BaseRealMModel {
    
    @objc dynamic var userid = ""    // 用户ID
    @objc dynamic var realname = "" // 昵称
    @objc dynamic var avater = "" // 头像
    @objc dynamic var groupid = "" // 所在组群id
    @objc dynamic var id = "" // id
    @objc dynamic var updatetime = "" // 更新时间
    @objc dynamic var is_delete = "" // 是否删除
    @objc dynamic var inputtime = "" // 插入时间
    @objc dynamic var join_type = "" // 插入时间
    @objc dynamic var im_userid = ""
    override static func primaryKey()->String
    {
        return "id";
    }

}
