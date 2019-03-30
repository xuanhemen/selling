//
//  ProBublesModel.swift
//  SLAPP
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProBublesModel: BaseModel {
    
    var xiaoluo:xiaoluoModel?
    var parameter:parameterModel?
    var allarray:Array<bublesPeopleModel> = []
    var people:Array<bublesPeopleSubModel> = []
   
    func currentModel(userid:String)->(bublesPeopleSubModel){
        let array = people.filter({ (model) -> Bool in
            return model.id == userid
        })
        if array.count > 0 {
            return array.first!
        }else{
            let model = bublesPeopleSubModel()
            model.id = userid
            return model
        }
        
    }
    
    required init() {
        
    }
}


class bublesPeopleModel: BaseModel {
    var name:String = ""
    var value:Array<bublesPeopleSubModel> = []
    
    func titles()->([String]){
        return value.map({ (model) -> String in
            return model.name
        })
    }
    
}


@objc class bublesPeopleSubModel: BaseModel {
    var actionorder:String = ""
    var actionstyle:String = ""
    @objc var circle_color:String = ""
    @objc var circle_color_val:String = ""
    var circle_engagement:NSNumber = 0
    var circle_size:NSNumber = 0
    var circle_support:NSNumber = 0
    var coach:String = ""
    var coach2:String = ""
    var contact_id:String = ""
    var corpid:String = ""
    var department:String = ""
    var engagement:NSNumber = 0
    var engagement2:String = ""
    var eutc:String = ""
    @objc var name:String = ""
    var events:String = ""
    var feedback:String = ""
    var feedback2:String = ""
    var feedback_name:String = ""
    var group_id:String = ""
    @objc var id:String = ""
    var impact:String = ""
    var level:String = ""
    var logic_id:String = ""
    var orgresult:String = ""
    var orgresult2:String = ""
    var overtime:String = ""
    var parentid:String = ""
    var people_id:String = ""
    var personalwin:String = ""
    var personalwin2:String = ""
    var politicalrelation:String = ""
    var position:String = ""
    var position_name:String = ""
    var project_id:String = ""
    var relationpeople:String = ""
    var status:String = ""
    var style:String = ""
    var sub:String = ""
    var support:NSNumber = 0
    var support2:String = ""
    var target:String = ""
    var userid:String = ""
    var visit_feedback:String = ""
    var hierarchy:Int = 0
    var plan_title:String = ""
    var plan:Array<planModel> = []
}

class planModel: BaseModel {
    
    var desc:String = ""
    
    required init() {
        
    }
}


class parameterModel: BaseModel {
    var circle_color_max:String = ""
    var circle_color_min:String = ""
    var circle_size_max:NSNumber = 0
    var circle_size_min:NSNumber = 0
    var engagement_max:CGFloat = 0
    var engagement_min:CGFloat = 0
    var support_max:CGFloat = 0
    var support_min:CGFloat = 0
    required init() {
        
    }
}


class xiaoluoModel: BaseModel {
    var content:String = ""
    var title:String = ""
    var title_two:String = ""
    required init() {
        
    }
}
