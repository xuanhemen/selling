//
//  ProjectAnalyzeModel.swift
//  SLAPP
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectAnalyzeModel: BaseModel {

    var xiaoluo:Xiaoluo?
    var pro_defen:String = ""
    var planSuggestion:PlanSuggestion?
    var three_broad_axe:Three_broad_axe?
    var Winindex:String = ""
    var risk_warning_count:String = ""
    var risk_warning:risk_warningModel?
    var percentage:Dictionary<String,PercentageModel>?
    required init() {
    }
}

class risk_warningModel: BaseModel {
    var title:String = ""
    var risk_warning:Array<risk_warningSubModel> = []
    func riskTitles()->([String]){
        return risk_warning.map({ (model) -> String in
            return model.title
        })
        
    }
    required init() {
        
    }
}

class risk_warningSubModel: BaseModel {
    var final_score:String = ""
    var number:String = ""
    var str_val:String = ""
    var title:String = ""
    var total:String = ""
    var arr_val:Array<String> = []
    required init() {
        
    }
    
}


class PercentageModel: BaseModel {
    var percentage:String = "0"
    var title:String = ""
    var name:Array<String> = []
    required init() {
        
    }
    
}



class PlanSuggestion: BaseModel {
    
    var planSuggestion:Array<PlanSuggestionModel> = []
    var title:String = ""
    
    func planSuggestionTitles()->([String]){
        return planSuggestion.map({ (model) -> String in
            return model.name
        })
    }
    
    
    required init() {
        
    }
}


class three_broadModel: BaseModel {
    var str_val:String = ""
    var str_val_people:String = ""
    var sub_name:String = ""
    var sub_shortname:String = ""
    var str_people : Array<str_peopleModel> = []
    var arr_val:Array<String> = []
    required init() {
        
    }
}


class str_peopleModel: BaseModel {
    var id:String = ""
    var name:String = ""
    var circle_color:String = ""
    required init() {
        
    }
}

class Three_broad_axe: BaseModel {
    var title:String = ""
    var three_broad_axe : Array<three_broadModel> = []
    
    func threeTitles()->([String]){
        return three_broad_axe.map({ (model) -> String in
            return model.sub_shortname
        })
    }
    required init() {
        
    }
}


class PlanSuggestionModel:BaseModel {
    
    var actionorder:String = ""
    var actionstyle:String = ""
    var circle_color:String = ""
    var circle_color_val:String = ""
    var circle_engagement:String = ""
    var circle_size:String = ""
    var circle_support:String = "" //
    var coach:String = ""
    var coach2:String = ""
    var contact_id:String = ""
    var corpid:String = ""
    var department:String = ""
    var engagement:CGFloat = 0
    var engagement2:String = ""
    var eutc:String = ""
    var events:String = ""
    var feedback:String = ""
    var feedback2:String = ""
    var feedback_name:String = ""
    var group_id:String = ""
    var id:String = ""
    var impact:String = ""
    var level:String = ""
    var logic_id:String = ""
    var name:String = ""
    var orgresult:String = ""
    var orgresult2:String = ""
    var overtime:String = ""
    var parentid:String = ""
    var people_id:String = ""
    var personalwin:String = ""
    var personalwin2:String = ""
    var plan:Array<PlanModel> = []
    var politicalrelation:String = ""
    var position:String = ""
    var position_name:String = ""
    var project_id:String = ""
    var relationpeople:String = ""
    var status:String = ""
    var style:String = ""
    var sub:String = ""
    var support:CGFloat = 0 //支持度
    var support2:String = ""
    var target:String = ""
    var userid:String = ""
    var visit_feedback:String = ""
    var plan_title:String = ""
    required init() {
        
    }
    
}

class PlanModel: BaseModel {
    
    var config_id:String = ""
    var desc:String = ""
    var id:String = ""
    var index_id:String = ""
    var key:String = ""
    
    required init() {
        
    }
}

class Xiaoluo: BaseModel {
    
    var content:String = ""
    var no_suitable:String = ""
    var suitable:String = ""
    var title:String = ""
    var title_two:String = ""
    
    required init() {
        
    }
}
