//
//  ProRoleRadarModel.swift
//  SLAPP
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProRoleRadarModel: BaseModel {

    var roleEutcRadarParams:Array<ProRoleRadarSubModel> = []
    
    func titles()->([String]){
        return roleEutcRadarParams.map({ (model) -> String in
            return model.name
        })
    }
    
    func values()->([CGFloat]){
        return roleEutcRadarParams.map({ (model) -> CGFloat in
            return CGFloat(truncating: model.value)
        })
    }
    
    func maxValue() -> CGFloat {
       let array = self.values().sorted(by: >)
        return array.first! + 10
    }
    
    required init() {
        
    }
}

class ProRoleRadarSubModel: BaseModel {
    
    var id:String = ""
    var name:String = ""
    var value:NSNumber = 0
    
    required init() {
        
    }
}
