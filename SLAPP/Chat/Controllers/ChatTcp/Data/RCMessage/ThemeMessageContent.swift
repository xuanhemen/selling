//
//  ThemeMessageContent.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/6/7.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ThemeMessageContent: RCMessageContent {
    var content = "" //文字内容
    var extra = "" //扩展信息   ///聊天记录
    var imageURL = "" //图片url
    var thumbnailUrl = ""//缩略图url
    var url = "" //点击后连接地址
    
    var groupId = "" //所在组群id
    
    var themeId = "" //跳转话题id
    
    
    override class func getObjectName() -> String{
        return "ThemeMessageContent"
    }
    
    override func encode() -> Data! {
        var dataDict = Dictionary<String, String>.init()
        dataDict["content"] = self.content
        dataDict["extra"] = self.extra
        dataDict["imageURL"] = self.imageURL
        dataDict["thumbnailUrl"] = self.thumbnailUrl
        dataDict["url"] = self.url
        dataDict["groupId"] = self.groupId
        dataDict["themeId"] = self.themeId
        
        let data = try? JSONSerialization.data(withJSONObject: dataDict, options: [])
        
        return data
    }
    
    override func decode(with data: Data!) {
        
        //        super.decode(with: data)
        DLog("222222222222222_______\(data)")
        let str =  NSString(data:data! ,encoding: String.Encoding.utf8.rawValue)
        DLog("662222222222222_______\(str)")
        if !(str?.contains("null"))!{
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, Any>
            
            DLog("111111111111111_______\(json)" )
            if json == nil {
                return
            }
            let jsonDic = json!
            
            //            self.content = jsonDic["content"]! //文字内容
            if jsonDic["content"] == nil {
                self.content = ""
            }else{
                self.content = jsonDic["content"]! as! String
            }
            if jsonDic["extra"] == nil {
                self.extra = ""
            }else{
                self.extra = jsonDic["extra"]! as! String
            }
            if jsonDic["imageURL"] == nil {
                self.imageURL = ""
            }else{
                self.imageURL = jsonDic["imageURL"]! as! String
            }
            if jsonDic["thumbnailUrl"] == nil {
                self.thumbnailUrl = ""
            }else{
                self.thumbnailUrl = jsonDic["thumbnailUrl"]! as! String
            }
            if jsonDic["url"] == nil {
                self.url = ""
            }else{
                self.url = jsonDic["url"]! as! String
            }
            if jsonDic["groupId"] == nil {
                self.groupId = ""
            }else{
                self.groupId = String.noNilStr(str: jsonDic["groupId"])
            }
            if jsonDic["themeId"] == nil {
                self.themeId = ""
            }else{
                self.themeId = String.noNilStr(str: jsonDic["themeId"])
            }
            //            self.extra = jsonDic["extra"]! //扩展信息
            //            self.imageURL = jsonDic["imageURL"]! //图片url
            //            self.thumbnailUrl = jsonDic["thumbnailUrl"]!//缩略图url
            //            self.url = jsonDic["url"]! //点击后连接地址
            //            self.groupId = jsonDic["groupId"]! //所在组群id
            //            self.themeId = jsonDic["themeId"]! //跳转话题id
        }
        else{
            self.content = "android发的不能解析" //文字内容
            self.extra = "android发的不能解析" //扩展信息
            self.imageURL = "android发的不能解析" //图片url
            self.thumbnailUrl = "android发的不能解析"//缩略图url
            self.url = "android发的不能解析" //点击后连接地址
            self.groupId = "android发的不能解析" //所在组群id
            self.themeId = "android发的不能解析" //跳转话题id
            DLog("招 恨")
        }
        
    }
    
    override func getSearchableWords() -> [String]! {
//        RCMessageContent.persistentFlag()
        return ["content"]
    }
    
    override class func persistentFlag() -> RCMessagePersistent{
        return RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override func conversationDigest() -> String! {
        return "[话题]"
    }
    
//    func awa() {
//        RCMessageContent.getObjectName()
//    }

}
