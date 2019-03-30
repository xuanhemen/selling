//
//  FriendsModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/3.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

//好友表

class FriendsModel: BaseRealMModel {
    
    @objc dynamic var userid = ""    // 用户ID
    @objc dynamic var im_userid = ""    // 用户融云ID
    @objc dynamic var realname = "" // 昵称
    @objc dynamic var avater = "" // 头像
    @objc dynamic var type:NSNumber = 0//1 互粉  2单粉我 3我粉 4陌生人(3和4都属于陌生人)
    override static func primaryKey()->String
    {
        return "userid";
    }

}
