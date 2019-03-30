//
//  PublicPush.swift
//  SLAPP
//
//  Created by qwp on 2018/7/5.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit

class PublicPush: NSObject {
    
    @objc public  func pushToUserInfo(imId:String,userId:String,vc:UIViewController){
        DLog("----- 跳转个人中心 ------")
        DLog("imId:"+imId)
        DLog("userId:"+userId)
        
        if (userId.range(of: "system") != nil) {
            return
        }
        if (imId.range(of: "system") != nil) {
            return
        }
        let pVc = PersonalCenterVC()
        pVc.tcpUserid = imId
        pVc.userId = userId
        vc.navigationController?.pushViewController(pVc, animated: true)
        
        
    }
    
    class func addressPushToUserInfoForDetailVC(userId: String, vc: UIViewController) {
        
        if (userId.range(of: "system") != nil) {
            return
        }
        
        let pVc = PersonalCenterVC()
        pVc.tcpUserid = ""
        pVc.userId = userId
        pVc.is_Address = 1
        vc.navigationController?.pushViewController(pVc, animated: true)
    }
    
    @objc public  func addressPushToUserInfo(userId:String,vc:UIViewController){
        
        if (userId.range(of: "system") != nil) {
            return
        }
        
        let pVc = PersonalCenterVC()
        pVc.tcpUserid = ""
        pVc.userId = userId
        pVc.is_Address = 1
        vc.navigationController?.pushViewController(pVc, animated: true)
        
        
    }
    
    @objc public  func centerPushToUserInfo(userId:String,vc:UIViewController,model:Dictionary<String,Any>?){
        
        if (userId.range(of: "system") != nil) {
            return
        }
        
        let pVc = PersonalCenterVC()
        pVc.tcpUserid = ""
        pVc.userId = userId
        pVc.is_Address = 2
        pVc.infoModel = model
        vc.navigationController?.pushViewController(pVc, animated: true)
        
        
    }
    
    @objc public  func pushToProjectVC(id:String){
        
        PublicMethod.showProgress()
        
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: id)].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectSituationTabVC()
                tab.model = model;
                PublicMethod.appCurrentViewController().navigationController?.pushViewController(tab, animated: true)
            }
        }
        
    }
    
    @objc public  func pushToProjectAnalyzeVC(id:String,logic_id:String){
    
        LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: id)].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            DLog(dic)
            PublicMethod.dismiss()
            if let model = ProjectSituationModel.deserialize(from: dic){
                let tab = ProjectAnalyzeVC()
                tab.model = model
                tab.logicId = logic_id
                tab.isHistory = true
                PublicMethod.appCurrentViewController().navigationController?.pushViewController(tab, animated: true)
            }
        }
        
    }
    
    @objc public class func pushToSpecail(type:String,value:Dictionary<String,Any>,vc:UIViewController,model:ProjectSituationModel?){
        
        if type == "pro_analyse" {
            
            if model != nil {
                let pvc = ProjectAnalyzeVC()
                pvc.model = model;
                
                pvc.isHistory = true;
                pvc.logicId = String.noNilStr(str: value["logic_id"]);
                vc.navigationController?.pushViewController(pvc, animated: true)
            }else{
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: value["project_id"])].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismissWithError()
                }) {[weak vc] (dic) in
                    PublicMethod.dismiss()
                    if let modelN = ProjectSituationModel.deserialize(from: dic){
                        
                        let pvc = ProjectAnalyzeVC()
                        pvc.model = modelN;
                        
                        pvc.isHistory = true;
                        pvc.logicId = String.noNilStr(str: value["logic_id"]);
                        vc?.navigationController?.pushViewController(pvc, animated: true)
                    }
                }
                
            }
            
            
            
        }else if type == "action_plan"{
            
            if model != nil {
                let pvc = QFProjectPlanDetailVC()
                pvc.isProjectIn = false
                //            vc.id = String.noNilStr(str: model["type_id"])
                //            vc.model = mymodel
                pvc.model = model;
                pvc.id = String.noNilStr(str: value["action_id"])
                vc.navigationController?.pushViewController(pvc, animated: true)
                
                
            }else{
                
                PublicMethod.showProgress()
                LoginRequest.getPost(methodName: PROJECT_DETAIL, params: ["project_id":String.noNilStr(str: value["project_id"])].addToken(), hadToast: true, fail: { (dic) in
                    PublicMethod.dismissWithError()
                }) {[weak vc] (dic) in
                    PublicMethod.dismiss()
                    if let modelN = ProjectSituationModel.deserialize(from: dic){
                        
                        let pvc = QFProjectPlanDetailVC()
                        pvc.isProjectIn = false
                        //            vc.id = String.noNilStr(str: model["type_id"])
                        //            vc.model = mymodel
                        pvc.model = modelN;
                        pvc.id = String.noNilStr(str: value["action_id"])

                        vc?.navigationController?.pushViewController(pvc, animated: true)
                    }
                }
                
            }
            
            
        }
    }
    
}
