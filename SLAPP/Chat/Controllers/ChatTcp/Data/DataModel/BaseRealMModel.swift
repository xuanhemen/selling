//
//  BaseRealMModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class BaseRealMModel: RLMObject {

    override func value(forUndefinedKey key: String) -> Any? {
        print("meiyou",key)
        return true
    }
}
