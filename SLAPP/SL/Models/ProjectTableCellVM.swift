//
//  ProjectTableCellVM.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import HandyJSON
class ProjectTableCellVM: HandyJSON {
    var height:CGFloat{
        get{
            return 80.0
        }
    }
    
    var id=""
    var name=""
    var amount=""
    var userid=""
    var realname=""
    var dep_id=""
    var trade_id=""
    var trade_name=""
    var edittime=""
    var create_time=""
    var dealtime=""
    var close_status=""
    var analyse_update_time=""
    var stage="1"
    var stagename=""
    var consult_style="1"
    var new_consult_id=""
    var client_id=""
    var client_name=""
    var createuserid=""
    var logic_id=""
    var status=""
    var role=""
    var observer = ""
    var partners = ""
    var fo_count = "0"
    var msg_count = "0"
    required init(){}
}
