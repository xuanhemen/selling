//
//  MemberModel.swift
//  SLAPP
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class MemberModel: BaseModel {
    @objc var id:String?
    @objc var name:String?
    @objc var head:String = ""
    var classStr:String?
    var position:String?
    var phone:String?
    var pid:String?
    required init() {
        
    }
    
    
  static  func configWithDic(dic:Dictionary<String,Any>)->(MemberModel){
        
        let model = MemberModel()
        model.id = JSON(dic["id"]).stringValue
        model.name = JSON(dic["realname"]).stringValue
        model.head = JSON(dic["head"]).stringValue
        return model
        
    }
    
    static  func configWithOtherDic(dic:Dictionary<String,Any>)->(MemberModel){
        
        let model = MemberModel()
        model.id = JSON(dic["id"]).stringValue
        model.name = JSON(dic["name"]).stringValue
        model.head = JSON(dic["head"]).stringValue
        return model
        
    }
    
    class func memberModel(json:JSON) -> MemberModel {
        let model = MemberModel()
        model.id = json["userid"].stringValue
        model.name = json["realname"].stringValue
        model.head = json["head"].stringValue
        return model
    }
}
