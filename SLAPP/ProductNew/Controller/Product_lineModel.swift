//
//  Product_lineModel.swift
//  SLAPP
//
//  Created by 柴进 on 2018/4/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class Product_lineModel:BaseModel {
    var id:String?
    var name:String?//         名称
    var parentid:String?
    //该字段由海瑞添加，数据库不需要存任何数据，只是在做界面显示时做一个层级的记录
    var level:Int = 0
    var child:Array<Product_lineModel>?
    
    var amount:String?
    
//    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        super.setValue(value, forUndefinedKey: key)
//    }
    
//    var parentProduct:Product_lineModel?
//    var childrenProduct:RLMResults<Product_lineModel>{
//        return Product_lineModel.objects(with: NSPredicate.init(format: "parentProduct.id == %@", self.id!)) as! RLMResults<Product_lineModel>
//    }
    
//    override static func primaryKey()->String
//    {
//        return "id";
//    }
}
