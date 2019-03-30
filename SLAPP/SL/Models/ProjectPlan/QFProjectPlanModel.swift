//
//  QFProjectPlanModel.swift
//  SwiftStudy
//
//  Created by qwp on 2018/4/20.
//  Copyright © 2018年 祁伟鹏. All rights reserved.
//

import UIKit

class QFProjectPlanModel: BaseModel {
    
    @objc var action_style:String = ""
    @objc var action_style_name:String = ""
    @objc var action_target:String = ""
    @objc var corpid:String = ""
    @objc var date:String = ""
    @objc var date_d:String = ""
    @objc var date_m:String = ""
    @objc var date_n:String = ""
    @objc var date_y:String = ""
    @objc var id:String = ""
    @objc var is_achieve:String = ""
    @objc var logic_id:String = ""
    @objc var overtime:String = ""
    @objc var people_name:String = ""
    @objc var peopleid:String = ""
    @objc var projectid:String = ""
    var logic_people_arr:Array<Dictionary<String,Any>> = []
    //权限
    var save_auth:String = ""
    required init() {
        
    }
    
}

class QFActionTypeModel: BaseModel {
    var imageName:String = "project_message.png"
    var title:String = "常规交流"
    var star:Int = 5

}

class QFPlanUserModel: BaseModel {
    var userName:String = "安红"
    var userDetail:String = "提供样板案例,制造焦虑感"
    var isSelect:Bool = false
    var userId:Int = 0
}
