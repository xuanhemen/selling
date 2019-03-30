//
//  MyCustomListModel.swift
//  SLAPP
//
//  Created by fank on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CustomInfoEnum : String {
    
    case idString = "id"
    case nameString = "name"
    case responsibleString = "realname"
    case responsibleIdString = "userid"
    case tradeString = "trade_name"
    case tradeIdString = "trade_id"
    case urlString = "url"
    case emailString = "email"
    case phoneString = "phone"
    case faxString = "fax"
    case countString = "peoples"
    case postcodeString = "postcode"
    case capitalString = "registered_capital"
    case remarksString = "note"
    
    case timeString = "addtime_str"
    case addressString = "dir"
    case placeString = "place"
    
    case publicSeaString = "gonghai_name"
    case publicSeaIdString = "gonghai"
    
    init(type: String) {
        switch type {
        case "nameString": self = .nameString
        case "responsibleString": self = .responsibleString
        case "tradeString": self = .tradeString
        case "urlString": self = .urlString
        case "emailString": self = .emailString
        case "phoneString": self = .phoneString
        case "faxString": self = .faxString
        case "countString": self = .countString
        case "postcodeString": self = .postcodeString
        case "capitalString": self = .capitalString
        case "remarksString": self = .remarksString
        case "timeString": self = .timeString
        case "addressString": self = .addressString
        case "placeString": self = .placeString
        case "publicSeaString": self = .publicSeaString
        default: self = .idString // def, no value
        }
    }
    
    var value : String {
        return self.rawValue
    }
    
    func description() -> String {
        switch self {
        case .nameString:
            return "客户"
        case .responsibleString:
            return "负责"
        case .tradeString:
            return "行业"
        case .urlString:
            return "网址"
        case .emailString:
            return "邮件"
        case .phoneString:
            return "电话"
        case .faxString:
            return "传真"
        case .countString:
            return "员工数"
        case .postcodeString:
            return "邮编"
        case .capitalString:
            return "注册资本"
        case .remarksString:
            return "备注"
        case .timeString:
            return "创建时间"
        case .addressString:
            return "地址"
        case .publicSeaString:
            return "所属公海"
        default:
            return ""
        }
    }
}

class MyCustomListModel: NSObject {
    
    var isSelected = false
    
    var idString : String?
    
    var nameString : String?
    
    var responsibleString : String?     // 负责
    
    var responsibleIdString : String?   // 负责id
    
    var tradeString : String?           // 行业
    
    var tradeIdString : String?         // 行业id
    
    var urlString : String?             // 网址
    
    var emailString : String?           // 邮箱
    
    var phoneString : String?           // 电话
    
    var faxString : String?             // 传真
    
    var countString : String?           // 员工数
    
    var postcodeString : String?        // 邮编
    
    var capitalString : String?         // 注册资本
    
    var remarksString : String?         // 备注
    
    var timeString : String?            // 创建时间
    
    var addressString : String?         // 地址
    
    var placeString : String?           // 详细地址
    
    var publicSeaString : String?       // 公海名
    
    var publicSeaIdString : String?     // 公海id
    
    var provinceIdString : String?      // 省id
    var cityIdString : String?          // 市id
    var areaIdString : String?          // 区id
    
    var recycleString : String?         // 回收时间
    
    var msgCountString : String?        // 消息数量
    
    var foCountString : String?         // 跟进数量
    
    class func myCustomListModel(json:JSON) -> MyCustomListModel {
        
        let myCustomListModel = MyCustomListModel()
        
        myCustomListModel.idString = json[CustomInfoEnum.idString.value].string
        myCustomListModel.nameString = json[CustomInfoEnum.nameString.value].string
        myCustomListModel.responsibleString = json[CustomInfoEnum.responsibleString.value].string
        myCustomListModel.responsibleIdString = json[CustomInfoEnum.responsibleIdString.value].string
        myCustomListModel.tradeString = json[CustomInfoEnum.tradeString.value].string
        myCustomListModel.tradeIdString = json[CustomInfoEnum.tradeIdString.value].string
        myCustomListModel.urlString = json[CustomInfoEnum.urlString.value].string
        myCustomListModel.emailString = json[CustomInfoEnum.emailString.value].string
        myCustomListModel.phoneString = json[CustomInfoEnum.phoneString.value].string
        myCustomListModel.faxString = json[CustomInfoEnum.faxString.value].string
        myCustomListModel.countString = json[CustomInfoEnum.countString.value].string
        myCustomListModel.postcodeString = json[CustomInfoEnum.postcodeString.value].string
        myCustomListModel.capitalString = json[CustomInfoEnum.capitalString.value].string
        myCustomListModel.remarksString = json[CustomInfoEnum.remarksString.value].string
        
        myCustomListModel.timeString = json[CustomInfoEnum.timeString.value].string
        myCustomListModel.addressString = json[CustomInfoEnum.addressString.value].string
        myCustomListModel.placeString = json[CustomInfoEnum.placeString.value].string
        
        myCustomListModel.publicSeaString = json[CustomInfoEnum.publicSeaString.value].string
        myCustomListModel.publicSeaIdString = json[CustomInfoEnum.publicSeaIdString.value].string
        
        myCustomListModel.provinceIdString = json["province"].string
        myCustomListModel.cityIdString = json["city"].string
        myCustomListModel.areaIdString = json["area"].string
        
        myCustomListModel.recycleString = json["definition"].string
        
        myCustomListModel.msgCountString = json["msg_count"].string
        myCustomListModel.foCountString = json["fo_count"].string
        
        return myCustomListModel
    }
}
