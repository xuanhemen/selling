//
//  MessageCenterModel.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/1.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class MessageCenterModel: BaseRealMModel {
    /*!
     全局唯一ID
     
     @discussion 服务器消息唯一ID（在同一个Appkey下全局唯一）
     */
    @objc dynamic var messageUId = ""
    /*!
     目标会话ID
     */
    @objc dynamic var targetId = ""
    /*!
     消息的ID
     
     @discussion 本地存储的消息的唯一值（数据库索引唯一值）
     */
    @objc dynamic var messageId = ""
    
    /*!
     消息组群的ID（话题里的消息才需要）
     
     @discussion 本地存储的消息的唯一值（数据库索引唯一值）
     */
    @objc dynamic var parentId = ""
}
