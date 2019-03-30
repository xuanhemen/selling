//
//  ProjectReportMessageContent.swift
//  SLAPP
//
//  Created by apple on 2018/4/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ProjectReportMessageContent: RCMessageContent {
    var projectId:String = ""
    var projectName:String = ""
    var projectScore:String = ""
    var projectWinIndex:String = ""
    var projectRisk:String = ""
    var url:String = ""
    var extra:String = ""
    var logicId:String = ""
    
    override class func getObjectName() -> String{
        return "ProjectReportMessageContent"
    }
    
    override func encode() -> Data! {
        var dataDict = Dictionary<String, String>.init()
        dataDict["projectId"] = self.projectId
        dataDict["extra"] = self.extra
        dataDict["projectName"] = self.projectName
        dataDict["projectScore"] = self.projectScore
        dataDict["projectWinIndex"] = self.projectWinIndex
        dataDict["projectRisk"] = self.projectRisk
        dataDict["url"] = self.url
        dataDict["logicId"] = self.logicId
        
        let data = try? JSONSerialization.data(withJSONObject: dataDict, options: [])
        return data
    }
    
    
    
    override func decode(with data: Data!) {
        
        let str =  NSString(data:data! ,encoding: String.Encoding.utf8.rawValue)
        
        if !(str?.contains("null"))!{
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            if json == nil {
                return
            }
            let jsonDic = json!
            if jsonDic["projectId"] == nil {
                self.projectId = ""
            }else{
                self.projectId = jsonDic["projectId"]! as! String
            }
            if jsonDic["extra"] == nil {
                self.extra = ""
            }else{
                self.extra = jsonDic["extra"]! as! String
            }
            if jsonDic["url"] == nil {
                self.url = ""
            }else{
                self.url = jsonDic["url"]! as! String
            }
            if jsonDic["projectName"] == nil {
                self.projectName = ""
            }else{
                self.projectName = jsonDic["projectName"]! as! String
            }
            if jsonDic["projectScore"] == nil {
                self.projectScore = ""
            }else{
                self.projectScore = jsonDic["projectScore"]! as! String
            }
            if jsonDic["projectRisk"] == nil {
                self.projectRisk = ""
            }else{
                self.projectRisk = String.noNilStr(str: jsonDic["projectRisk"])
            }
            if jsonDic["projectWinIndex"] == nil {
                self.projectWinIndex = ""
            }else{
                self.projectWinIndex = String.noNilStr(str: jsonDic["projectWinIndex"])
            }
            if jsonDic["logicId"] == nil {
                self.logicId = ""
            }else{
                self.logicId = String.noNilStr(str: jsonDic["logicId"])
            }
        }
        else{
//            self.content = "android发的不能解析" //文字内容
//            self.extra = "android发的不能解析" //扩展信息
//            self.imageURL = "android发的不能解析" //图片url
//            self.thumbnailUrl = "android发的不能解析"//缩略图url
//            self.url = "android发的不能解析" //点击后连接地址
//            self.groupId = "android发的不能解析" //所在组群id
//            self.themeId = "android发的不能解析" //跳转话题id
            DLog("特殊消息出错了----------------")
        }
        
    }
    
    override func getSearchableWords() -> [String]! {
        //        RCMessageContent.persistentFlag()
        return ["projectName"]
    }
    
    override class func persistentFlag() -> RCMessagePersistent{
        return RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override func conversationDigest() -> String! {
        return "[特殊消息]"
    }
    
}
