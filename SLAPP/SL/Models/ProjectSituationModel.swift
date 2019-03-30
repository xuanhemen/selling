//
//  ProjectSituationModel.swift
//  SLAPP
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectSituationModel: BaseModel {

    var config_id:String?
    var closerate:String?
    var chief_contact_id:String?
 @objc   var client_id:String?
    var amount:Double = 0
    var trade_name:String?
    var trade_parent_id:String?
    var trade_parent_name:String?
    var stage:String?
    var trade_id:String?
    var partners:String?
    var logic_situation:Array<LogicSituationModel> = []
    
    var situation_logic:Array<LogicSituationModel> = []
    var procedure_logic:Array<LogicSituationModel> = []
    
    var dealtime:String?
    @objc var deps_name:String = ""
    @objc var id:String?
 @objc    var client_name:String?
    var down_payment:Double = 0
    var dealtime_str:String?
    var userid:String?
    var chief_contact:String?
    var project_product:Array<ProjectProductModel> = []
    var partners_arr:Array<Dictionary<String,Any>> = []
  @objc   var name:String?
    var dep_id:String?
    var save_pro_userid:String? //转移项目使用
    var other_contact_ids:String?
    var corpid:String?

    var realname:String?

    var chief_contact_phone:String?
   //是否体检过  1体检过
    var spbe:String?
   //是否生成报告
    var pro_anaylse_logic_id:String?
    
    var new_consult_id:String?

     var other_contact_arr_new:Array<Dictionary<String,Any>> = []
     var principal_auth:String = "0" //用于修改  参与人  观察员 权限   有
     var logic_people:Array<LogicPeopleModel> = []
     var consult_style:String?
     var observer_arr:Array<Dictionary<String,Any>> = []
     var save_auth:String = "0" //联系人  1有    //自己和参与者的权限   联系人/角色信息  形势流程编辑权限
     var observer:String?
     var close_status:String?
    //关闭开启的判断条件
    var close_open_auth:String = "0"
    
     var carry_down:String = "0"
    
    
    
    required init() {
        
    }
    
    func configPartners()->([MemberModel]){
        
        var array:Array<MemberModel> = Array()
        for dic in self.partners_arr {
            let model = MemberModel()
            model.id = JSON(dic["id"]).stringValue
            model.name = JSON(dic["realname"]).stringValue
            model.head = JSON(dic["head"]).stringValue
            array.append(model)
        }
        
        
        for dic in self.observer_arr {
            let model = MemberModel()
            model.id = JSON(dic["id"]).stringValue
            model.name = JSON(dic["realname"]).stringValue
            model.head = JSON(dic["head"]).stringValue
            array.append(model)
        }
        
//        let model = MemberModel()
//        model.id = self.userid
//        model.name = self.realname
//        model.head = ""
//        array.append(model)
        
        
        if self.userid == UserModel.getUserModel().id {
            
            let model = MemberModel()
            model.id = UserModel.getUserModel().id
            model.name = UserModel.getUserModel().realname
            model.head = UserModel.getUserModel().avater ?? "" + imageSuffix
            array.insert(model, at: 0)
        }
        
        return array
    }
    
    
    func logicPeopleId(name:String)->(String){
        let array = self.logic_people.filter { (model) -> Bool in
            return model.name == name
        }
        
        if array.count > 0{
            return (array.first?.id)!
        }else{
            return "0"
        }
    }
    
    
    //获取角色名称
    func logicPeopleTitles(uid:String?)->(Array<String>){
        if uid == nil {
            return self.logic_people.map({ (model) -> String in
                return model.name!
            })
        }
        else{
            let array = self.logic_people.filter { (model) -> Bool in
                return model.id != uid!
            }
            return array.map({ (model) -> String in
                DLog("查看-------"+model.id!+"******"+model.name!)
                return model.name!
            })
        }
        
    }
    
    
    
    
    //是否是创建者
    func isCreater()->(Bool){
        if self.userid == UserModel.getUserModel().id {
            return true
        }
        return false
    }
    
//    //是否有权限做项目编辑   和  体检分析
//    func isAuthority()->(Bool){
//
//        let myId = UserModel.getUserModel().id
//        if self.userid ==  myId {
//            return true
//        }
//
//        let array = self.partners_arr.filter { (model) -> Bool in
//            return String.noNilStr(str: model["id"]) == myId
//        }
//
//        if array.count > 0 {
//            return true
//        }
//
//        return false
//    }
//
    
    
}
