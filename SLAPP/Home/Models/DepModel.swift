//
//  DepModel.swift
//  SLAPP
//
//  Created by apple on 2018/6/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
//部门
class DepModel: BaseModel {
    var id:String = ""
    var name:String = ""
    var parentid:String = ""
    var short_name:String = ""
    var top:String = ""
    var member:Array<DepMemberModel> = []
    var whether_del = ""
    var whether_dep = ""
    required init() {
        
    }
}
