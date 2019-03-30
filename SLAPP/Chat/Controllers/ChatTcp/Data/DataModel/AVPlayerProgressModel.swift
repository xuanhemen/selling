//
//  AVPlayerProgressModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/29.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class AVPlayerProgressModel: RLMObject {
    @objc dynamic var messageId = ""
    @objc dynamic var progress:Double = 0.0
    
    override static func primaryKey()->String
    {
        return "messageId";
    }
}
