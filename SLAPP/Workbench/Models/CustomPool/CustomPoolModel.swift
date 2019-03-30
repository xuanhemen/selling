//
//  CustomPoolModel.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomPoolModel: NSObject {
    
    var isSelected = false
    
    var idString : String?
    
    var companyNameString : String?
    
    var sendBackTimesString : String?
    
    var createTimeString : String?
    
    var sendBackReasonString : String?
    
    class func customPoolModel(json:JSON) -> CustomPoolModel {
        
        let customPoolModel = CustomPoolModel()
        
        customPoolModel.idString = json["id"].string
        customPoolModel.companyNameString = json["name"].string
        customPoolModel.sendBackTimesString = json["send_back_count"].string
        customPoolModel.createTimeString = json["addtime_str"].string
        customPoolModel.sendBackReasonString = json["reason"].string
        
        return customPoolModel
    }
    
}
