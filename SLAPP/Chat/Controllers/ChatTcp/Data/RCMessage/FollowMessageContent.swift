//
//  FollowMessageContent.swift
//  SLAPP
//
//  Created by apple on 2018/9/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class FollowMessageContent: RCMessageContent {

    var content = "" //文字内容
    var extra = "" //扩展信息
    var title = "" //标题
    var id = "" //跟进记录id
    
    override class func getObjectName() -> String{
        return "FollowMessageContent"
    }
    
    override func encode() -> Data! {
        var dataDict = Dictionary<String, String>.init()
        dataDict["content"] = self.content
        dataDict["extra"] = self.extra
        dataDict["id"] = self.id
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
                self.content = String.base64Decode(str: String.noNilStr(str: jsonDic["content"]!))
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
            if jsonDic["id"] == nil {
                self.id = ""
            }else{
               self.id = jsonDic["id"]!
            }
        }
        else{
            self.content = "android发的不能解析" //文字内容
            self.extra = "android发的不能解析" //扩展信息
            self.title = "android发的不能解析" //图片url
            self.id = "android发的不能解析" //点击后连接地址
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
        return "[跟进记录]"
    }
    
    
}
