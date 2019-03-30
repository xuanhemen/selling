//
//  SLCluesSectionModel.swift
//  SLAPP
//
//  Created by 董建伟 on 2018/12/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import HandyJSON
class SLCluesSectionModel: SLModel {

    /**分组名*/
    var name:String?
    /**组下人数*/
    var count:String?
    /**条目id*/
    var id:String?
    /**自定义*/
    var is_custom:String?
    /**创建用户id*/
    var create_userid:String?
    /**装组下对象*/
    var list:[SLCluesModel] = []
    /**是否展开*/
    var isShow:Bool?
//    func mapping(mapper: HelpingMapper) {
//        // 指定 id 字段用 "cat_id" 去解析
//        mapper.specify(property: &name, name: "cat_id")
//        // 指定 parent 字段用这个方法去解析
//        mapper.specify(property: &parent) { (rawString) -> (String, String) in
//            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
//            return (parentNames[0], parentNames[1])
//        }
//    }
    
    
}
