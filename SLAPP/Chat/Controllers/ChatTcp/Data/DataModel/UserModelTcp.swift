//
//  UserModelTcp.swift
//  SLAPP
//
//  Created by rms on 2018/2/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class UserModelTcp: BaseRealMModel {
    @objc dynamic var userid = ""    // 用户ID
    @objc dynamic var realname = "" // 昵称
    @objc dynamic var avater = "" // 头像
    @objc dynamic var corpid = "" // 企业id
    @objc dynamic var updatetime = "" // 更新时间
    @objc dynamic var is_delete = "" // 是否删除
    @objc dynamic var im_userid = ""
    override static func primaryKey()->String
    {
        return "userid";
    }
}
