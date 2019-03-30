//
//  DataOperation.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/3/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataOperation: DataBaseOperation {
    
    
    class func saveInitData(success:@escaping (_ success:Dictionary<String, Any>) ->()) -> (Dictionary<String, Any>) ->() {
        func temp(dic:Dictionary<String, Any>) ->(){
            sharePublicDataSingle.failNum = 0;
            sharePublicDataSingle.updateTime = "0";
            DataBaseOperation.addDataWithArray(rlmObjects: dic["groupList"] as! Array<Any>, aClass: GroupModel.self)
            DataBaseOperation.addDataWithArray(rlmObjects: dic["groupUserList"] as! Array<Any>, aClass: GroupUserModel.self)
            DataBaseOperation.addDataWithArray(rlmObjects: dic["subGroupList"] as! Array<Any>, aClass: GroupModel.self)
            
            DLog(dic["groupList"])
            
            DLog("---------------------------------------------")
            DLog(dic["userList"])
            DLog("---------------------------------------------")
//            let json_userList = JSON(dic["userList"])
            DataBaseOperation.addDataWithArray(rlmObjects: dic["userList"] as! Array<Any>, aClass: UserModelTcp.self)
           
            //保存时间戳
           let time = String.changeToString(inValue: dic["updateTime"] as Any)
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            DLog(time)
            DLog("保存的时间戳")
            UserDefaults.standard.set(time, forKey: username)
            success(dic)
        }
        return temp
    }
    
    
    
    class func saveFriendsData(success:@escaping (_ success:Dictionary<String, Any>) ->()) -> (Dictionary<String, Any>) ->() {
        
        
        func temp(dic:Dictionary<String, Any>) ->(){
            
            DLog(dic)
            if dic["list"] != nil{
                DataBaseOperation.addDataWithArray(rlmObjects: dic["list"] as! Array<Any>, aClass: FriendsModel.self)
            }
            success(dic)
        }
        
         return temp
    }
    class func saveSimpleListDataWithTable(table:AnyClass, success:@escaping (_ success:Dictionary<String, Any>) ->()) -> (Dictionary<String, Any>) ->() {
        
        
        func temp(dic:Dictionary<String, Any>) ->(){
            
            DLog(dic)
            if dic["list"] != nil{
                DataBaseOperation.addDataWithArray(rlmObjects: dic["list"] as! Array<Any>, aClass: table)
            }
            success(dic)
        }
        
        return temp
    }
    
    
    class func saveThemeInfoData(success:@escaping (_ success:Dictionary<String, Any>) ->()) -> (Dictionary<String, Any>) ->() {
        
        
        func temp(dic:Dictionary<String, Any>) ->(){
            
            
            var myDic = Dictionary<String, AnyObject>()
            myDic.updateValue( dic["is_delete"]  as AnyObject, forKey: "is_delete")
            myDic.updateValue(dic["groupid"]  as AnyObject, forKey: "groupid")
            let array:Array = dic["titleFileList"] as! Array<Any>
            myDic.updateValue(dic["group_name"] as AnyObject, forKey: "group_name")
            myDic.updateValue(array.count  as AnyObject, forKey: "imageNum")
            myDic.updateValue(BaseRequest.makeJsonStringWithObject(object: array as Any)  as AnyObject, forKey: "imageArray")
            
            let arrayf = [myDic]
           
            DataBaseOperation.addDataWithArray(rlmObjects:arrayf, aClass: ThemeInfoModel.self)
            
            success(dic)
        }
        
        return temp
    }

}
