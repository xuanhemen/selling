//
//  PersonalModel.swift
//  SLAPP
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class PersonalModel: BaseModel {
    
    //个人信息
    var member = PmemberModel()
    var auth = ""
    var results_list:Array<Presults_listModel> = []
    var results_map:Array<Presults_mapModel> = []
    var performance_completion_rate = Pperformance_completion_rateModel()
    var pro_funnel_list:Array<Ppro_funnel_listModel> = []
    
    
    
    
    
    /// 获取业绩完成率相关数据   0月 1，已经完成   2目标
    func getMapArray()->(([String],[Double],[String])){
        let mArray = self.results_map.map { (m) -> String in
            return m.month
        }
        
        let cArray = self.results_map.map { (m) -> Double in
           
            return Double(m.completion_rate)!
        }
        
        let dArray = self.results_map.map { (m) -> String in
            return m.down_payment
        }
        
        return (mArray,cArray,dArray)
    }
    
    
    required init() {
        
    }
}



class Ppro_funnel_listModel: BaseModel {
    
    var amount:Double = 0
    var down_payment:Double = 0
    var name = ""
    var pro_num:Double = 0
    var list:Array<Dictionary<String,Any>> = []
    
    required init() {
        
    }
}


class Ppro_funnel_listSubModel: BaseModel {
    
    var amount = ""
    var client_id = ""
    var client_name = ""
    var close_status = ""
    var dealtime = ""
    var down_payment = ""
    var edittime = ""
    var id = ""
    var name = ""
    var stage = ""
    
    required init() {
        
    }
    
    
    
}



class Pperformance_completion_rateModel: BaseModel {
    
    var completion_rate:Double = 0
    var planamount:Double = 0
    var win_down_payment:Double = 0
    required init() {
        
    }
}


class Presults_mapModel: BaseModel {
    var completion_rate = ""
    var down_payment = ""
    var month = ""
    required init() {
        
    }
    
    
    
    
    
}



class Presults_listModel: BaseModel {
    var amount = ""
    var dealtime = ""
    var down_payment = ""
    var edittime = ""
    var meet_requirement = ""
    var name = ""
    var total_performance = ""
    var id = ""
    required init() {
        
    }
}



class PmemberModel: BaseModel {
    //个人信息
    var dep_name = ""
    var email = ""
    var head = ""
    var im_userid = ""
    var mobile = ""
    var realname = ""
    var userid = ""
    
    
    required init() {
        
    }
}
