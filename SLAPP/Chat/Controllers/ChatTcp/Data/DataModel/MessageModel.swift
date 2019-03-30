//
//  MessageModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/2.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class MessageModel: BaseRealMModel {
    
    //字段说明： 字段是照着融云的消息类型搬过来的字段  具体打开下边网址
    //http://www.rongcloud.cn/docs/api/ios/imlib/index.html
    //http://www.rongcloud.cn/docs/api/ios/imlib/Classes/RCMessage.html
    
    
     @objc dynamic var conversationType = "" //会话类型
     @objc dynamic var targetId = ""         //目标id
     @objc dynamic var content = ""          //消息内容
     @objc dynamic var messageId = ""      //消息id
     @objc dynamic var messageDirection = "" //消息方向
     @objc dynamic var senderUserId = ""    //发送者id
     @objc dynamic var receivedStatus = ""   //消息的接收状态
     @objc dynamic var sentStatus = ""         //发送状态
     @objc dynamic var receivedTime = ""     //接收时间
     @objc dynamic var objectName = ""      //消息类型名
     @objc dynamic var extra = ""           //附加字段
     @objc dynamic var  messageUId = ""     //全局唯一ID
     @objc dynamic var readReceiptInfo = "" //阅读回执状态
     @objc dynamic var imageUrl = ""       //
     @objc dynamic var thumbnailImage = "" //缩略图
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
//      dynamic var readReceiptInfo = "" //阅读回执状态
    
}
