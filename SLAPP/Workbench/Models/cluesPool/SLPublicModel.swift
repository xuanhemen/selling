//
//  SLPublicModel.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class SLPublicModel: SLModel {
    /**条目id*/
    var id:String?
    /**名字*/
    var name:String?
    /**公司*/
    var corp_name:String?
    /**退回次数*/
    var return_times:String?
    /**原因*/
    var reason:String?
    /**时间*/
    var addtime_str:String?
    /**是否被选中*/
    var selected:Bool = false
    
//    "id":"6919",
//    "name":"省市区",
//    "corp_name":"北京畅游天下网络技术有限公司",
//    "return_times":"0",
//    "reason":"",
//    "addtime_str":"1970-01-01 08:00:00"
}
