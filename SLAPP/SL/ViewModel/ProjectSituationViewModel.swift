//
//  ProjectSituationViewModel.swift
//  SLAPP
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class ProjectSituationViewModel: NSObject {
    
    var isAuth:Bool = false
    var creatUserid:String = ""
    var isdelete:String?
    var membersIsdelete:Array<Bool> = [false,false,false]
    @objc var membersHeight:Array<CGFloat> = [70,70,70]
    @objc var membersArray:Array<Array<MemberModel>> = [[],[],[]]
    var membersTitles:Array<String> = ["参与人","观察员","联系人"]
    
    var headerTitles:Array<String> = ["参与者/观察员","项目形势","采购流程","角色信息"]
    
    //形势 流程 高度
    var logicSituationHeightArray = Array<CGFloat>()
    
    func configWithModel(model:ProjectSituationModel){
        
        if model.close_status != "0" {
            isAuth = false
        }else{
            isAuth = true
        }
        
        creatUserid = model.userid ?? ""
        
        for logicSituationModel in model.logic_situation {
            let height = UILabel.getHeightWith(str: logicSituationModel.name, font: 14,width: MAIN_SCREEN_WIDTH-130)
            
            logicSituationHeightArray.append(height<44 ?44:height)
            
        }
        var array = Array<MemberModel>()
        for observer in model.partners_arr{
            array.append(MemberModel.configWithDic(dic: observer))
        }
        membersArray[0] = array
        membersHeight[0] = self.memberHeight(count: array.count)
        array = Array<MemberModel>()
        for observer in model.observer_arr{
            array.append(MemberModel.configWithDic(dic: observer))
        }
        membersArray[1] = array
        membersHeight[1] = self.memberHeight(count: array.count)
        array = Array<MemberModel>()
        for observer in model.other_contact_arr_new{
            array.append(MemberModel.configWithOtherDic(dic: observer))
        }
        membersArray[2] = array
        membersHeight[2] = self.memberHeight(count: array.count)
    }
    
    
    func memberHeight(count:Int)->(CGFloat){
        let num = count/3
        let height = (num+1)*30 + (num+2)*5 + 30
        return CGFloat(height)<70.0 ? 70.0 :CGFloat(height)
    }
    
    
//    //是否有修改编辑的权限
//    func isEditAuth(model:ProjectSituationModel)->(Bool){
//      
//        let myId = UserModel.getUserModel().id
//        if model.userid == myId {
//            return true
//        }
//        
//        
//        if !self.membersArray[0].filter({ (model) -> Bool in
//            return  model.id == myId
//        }).isEmpty {
//            return true
//        }
//    
//        return false
//    }
    
    
    //是否有权限做项目编辑   和  体检分析
//    func isAuthority()->(Bool){
//        if isAuth == false {
//            return isAuth
//        }
//        
//        
//        let myId = UserModel.getUserModel().id
//        if creatUserid ==  myId {
//            return true
//        }
//        let array = membersArray[0].filter { (model) -> Bool in
//            return model.id == myId
//        }
//        if array.count > 0 {
//            return true
//        }
//        
//        return false
//    }
}
