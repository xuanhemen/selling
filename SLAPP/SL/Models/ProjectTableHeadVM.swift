//
//  ProjectTableHeadVM.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import HandyJSON
class ProjectTableHeadVM: HandyJSON {
    var height:CGFloat{
        get{
            return 50.0
        }
    }
    
    var stage=1
    var total=0
    var field="edittime"
    var sort_type="desc"
    var amount=0
    var name=""
    
    var isShow = "1"
    
    
    required init(){}
}
