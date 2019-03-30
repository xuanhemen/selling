//
//  ChatVC+EXtension.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 2017/7/4.
//  Copyright © 2017年 柴进. All rights reserved.
//

import Foundation

extension UIViewController {
    
    // MARK: - 注册自定义消息
    func registerCustomerMessageContent(){
        RCIM.shared().registerMessageType(ThemeMessageContent.self)
        RCIM.shared().registerMessageType(HistoryMessageContent.self)
        RCIM.shared().registerMessageType(FollowMessageContent.self)
        RCIM.shared().registerMessageType(ProjectVoiceMessageContent.self)
      RCIM.shared().registerMessageType(ProjectReportMessageContent.self)
    }
    
}
