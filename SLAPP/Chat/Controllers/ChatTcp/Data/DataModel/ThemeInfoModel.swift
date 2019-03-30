//
//  ThemeInfoModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/7/5.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ThemeInfoModel: BaseRealMModel {

    @objc dynamic var is_delete = ""    // 用户ID
    @objc dynamic var groupid = ""    // 用户融云ID
    @objc dynamic var imageNum:NSNumber = 0 //图片个数
    @objc dynamic var imageArray = "" //图片数据json串
    @objc dynamic var group_name = ""
    override static func primaryKey()->String
    {
        return "groupid";
    }

    
}
