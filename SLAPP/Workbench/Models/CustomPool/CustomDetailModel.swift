//
//  CustomDetailModel.swift
//  SLAPP
//
//  Created by fank on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomDetailModel: NSObject {
    
    var isSelected = false
    
    var idString : String?
    
    var nameString : String?
    
    var titleString : String?
    
    var phoneString : String?
    
    var imageString : String?
    
    var companyString : String? // 客户联系人
    
    class func customDetailModel(json:JSON) -> CustomDetailModel {
        
        let customDetailModel = CustomDetailModel()
        
        customDetailModel.idString = json["userid"].string ?? json["contact_id"].string
        customDetailModel.nameString = json["contact_name"].string ?? json["realname"].string
        customDetailModel.titleString = json["position_name"].string
        customDetailModel.phoneString = json["phone_arr"].array?.first?.string ?? json["phone"].string
        customDetailModel.imageString = json["head"].string
        customDetailModel.companyString = json["client_name"].string
        
        return customDetailModel
    }
    
}
