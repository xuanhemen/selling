//
//  HistoryMessageContent.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/6/30.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class HistoryMessageContent: RCMessageContent {
    var content = "" //文字内容
    var extra = "" //扩展信息
    var title = "" //图片url
    var url = "" //点击后连接地址
    
    override class func getObjectName() -> String{
        return "HistoryMessageContent"
    }
    
    override func encode() -> Data! {
        var dataDict = Dictionary<String, String>.init()
        dataDict["content"] = self.content
        dataDict["extra"] = self.extra
        dataDict["url"] = self.url
        dataDict["title"] = self.title
        
        let data = try? JSONSerialization.data(withJSONObject: dataDict, options: [])
        
        return data
    }
    
    override func decode(with data: Data!) {
        let str =  NSString(data:data! ,encoding: String.Encoding.utf8.rawValue)
        if !(str?.contains("null"))!{
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Dictionary<String, String>
            if json == nil {
                return
            }
            let jsonDic = json!
            
            //            self.content = jsonDic["content"]! //文字内容
            if jsonDic["content"] == nil {
                self.content = ""
            }else{
                self.content = jsonDic["content"]!
            }
            if jsonDic["extra"] == nil {
                self.extra = ""
            }else{
                self.extra = jsonDic["extra"]!
            }
            if jsonDic["title"] == nil {
                self.title = ""
            }else{
                self.title = jsonDic["title"]!
            }
            if jsonDic["url"] == nil {
                self.url = ""
            }else{
                self.url = jsonDic["url"]!
            }
        }
        else{
            self.content = "android发的不能解析" //文字内容
            self.extra = "android发的不能解析" //扩展信息
            self.title = "android发的不能解析" //图片url
            self.url = "android发的不能解析" //点击后连接地址
            DLog("招 恨")
        }
        
    }
    
    override func getSearchableWords() -> [String]! {
        return ["content"]
    }
    
    override class func persistentFlag() -> RCMessagePersistent{
        return RCMessagePersistent.MessagePersistent_ISCOUNTED
    }
    
    override func conversationDigest() -> String! {
        return "[聊天记录]"
    }

}
