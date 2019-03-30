//
//  ProAnalysisModel.swift
//  SLAPP
//
//  Created by apple on 2018/3/29.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProAnalysisModel: BaseModel {
    
    var key:String = ""
    var list:Array<ProAnalySubModel> = []
    var title:String = ""
    var value:String = ""
    var select:ProAnalySubModel?
    required init() {
        
    }

    //获取所有条目内容
    func contents()->(Array<String>){
        var array = Array<String>()
        for model in self.list {
            array.append(model.name)
        }
      return array
    }
    
}


class ProAnalySubModel: BaseModel {
    var index:String = ""
    var index_id:String = ""
    var name:String = ""
    var shortname:String = ""
    required init() {
        
    }
}
