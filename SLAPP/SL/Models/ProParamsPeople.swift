//
//  ProParamsPeople.swift
//  SLAPP
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProParamsPeople: BaseModel {

     var personalwin:Array<ProContentModel> = []
     var sub:Array<ProContentModel> = []
     var support:Array<ProContentModel> = []
     var eutc:Array<ProContentModel> = []
     var feedback:Array<ProContentModel> = []
    //影响
     var impact:Array<ProContentModel> = []
     var level:Array<ProContentModel> = []
     var style:Array<ProContentModel> = []
     var coach:Array<ProContentModel> = []
    //组织结果
    var orgresult:Array<ProContentModel> = []
    //参与
    var engagement:Array<ProContentModel> = []
    
    func orgresultId(str:String)->([ProContentModel]){
        return orgresult.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    func engagementId(str:String)->([ProContentModel]){
        return engagement.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    
    func personalwinId(str:String)->([ProContentModel]){
        return personalwin.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    
    func subId(str:String)->([String]){
        var result = Array<String>()
        let strArray = str.split(separator: ",")
        for str in strArray {
            for  model in sub {
                if model.name == str {
                    result.append(model.index)
                }
            }
        }
        return result
    }
    
    func supportId(str:String)->([ProContentModel]){
        return support.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    func eutcId(str:String)->([ProContentModel]){
        return eutc.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    func feedbackId(str:String)->([ProContentModel]){
        return feedback.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    func impactId(str:String)->([ProContentModel]){
        return impact.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    
    func levelId(str:String)->([ProContentModel]){
        return level.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    func styleId(str:String)->([ProContentModel]){
        return style.filter({ (model) -> Bool in
            return model.name == str
        })
    }
    
    func coachId(str:String)->([ProContentModel]){
        return coach.filter({ (model) -> Bool in
            return model.name == str
        })
        }
    
    
    
    
    
    required init() {
        
    }
    
    
    //组织结果
    func orgresultTitles()->([String]){
        return orgresult.map({ (model) -> String in
            return model.name
        })
    }
    
    
    //coach知道级别
    func coachTitles()->([String]){
        return coach.map({ (model) -> String in
            return model.name
        })
    }
    
    
    //获取参与选项
    func engagementTitles()->([String]){
        return engagement.map({ (model) -> String in
            return model.name
        })
    }
    
    
    //获取级别选项
    func levelTitles()->([String]){
        return level.map({ (model) -> String in
            return model.name
        })
    }
    
    //获取影响级别
    func impactTitles()->([String]){
        return impact.map({ (model) -> String in
            return model.name
        })
    }
    
    //风格选项
    func styleTitles()->([String]){
        return style.map({ (model) -> String in
            return model.name
        })
    }
    
    
    
    //获取个人赢选项
    func personalwinTitles()->([String]){
        return personalwin.map({ (model) -> String in
            return model.name
        })
    }
    
    
    //获取支持度选项
    func supportTitles()->([String]){
        return support.map({ (model) -> String in
            return model.name
        })
    }
    
    
    //反馈
    func feedbackTitles()->([String]){
        return feedback.map({ (model) -> String in
            return model.name
        })
    }
   
    
    //细分角色
    func subTitles()->([String]){
        return sub.map({ (model) -> String in
            return model.name
        })
    }
    //角色
    func eutcTitles()->([String]){
        return eutc.map({ (model) -> String in
            return model.name
        })
    }
    
    
}

class ProContentModel: BaseModel {
    
    var index:String = ""
    var index_id:String = ""
    var name:String = ""
    var shortname:String = ""
    required init() {
        
    }
}

