//
//  RCIMDelegate.swift
//  SLAPP
//
//  Created by 柴进 on 2018/3/1.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
import UserNotifications
class RCIMDelegate: NSObject,RCIMReceiveMessageDelegate {
    //融云收消息单例
    static let shared = RCIMDelegate.init()
    override init() {
        super.init()
        RCIM.shared().receiveMessageDelegate = self
    }
    
    var isBack = false
    
    //发送通知消息
    func scheduleNotification(title:String,body:String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent.init()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        
        let date = NSDate().timeIntervalSince1970
        let request = UNNotificationRequest.init(identifier: String.init(format: "localPush+%ld", date), content: content, trigger: trigger)
        
        
        
        center.add(request) { (error) in
            
        }
    }
    
    
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeGroupRedCount"), object: message)
        if isBack == true {
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = Int(RCIMClient.shared().getTotalUnreadCount())
            }
            let model = RCMessageModel.init(message: message)
            if model?.objectName == "RC:GrpNtf" {
                
            }
            if model?.objectName == "RC:TxtMsg" {
                self.scheduleNotification(title: "收到一条新消息", body: (model?.content as! RCTextMessage).content)
            }
            if model?.objectName == "RC:ImgMsg" {
                self.scheduleNotification(title: "收到一条新消息", body: "[图片]")
            }
            if model?.objectName == "RC:VcMsg" {
                self.scheduleNotification(title: "收到一条新消息", body: "[语音]")
            }
            if model?.objectName == "RC:FileMsg" {
                self.scheduleNotification(title: "收到一条新消息", body: "[文件]")
            }
            if model?.objectName == "ProjectVoiceMessageContent" {
                self.scheduleNotification(title: "收到一条新消息", body: "[语音备忘消息]")
            }
            if model?.objectName == "ProjectReportMessageContent" {
                self.scheduleNotification(title: "收到一条新消息", body: "[分析报告]")
            }
        }
        
        DLog(left)
        DLog(message)
        DLog(message.conversationType.rawValue)
        DLog(message.targetId)
        DLog(message.messageId)
        DLog(message.messageDirection.rawValue)
        DLog(message.senderUserId)
        DLog(message.receivedStatus.rawValue)
        DLog(message.sentStatus.rawValue)
        DLog(message.receivedTime)
        DLog(message.sentTime)
        DLog(message.objectName)
        DLog(message.content)
        DLog(message.extra)
        DLog(message.messageUId)
        DLog(message.readReceiptInfo)
        
        
        if message.senderUserId == "system2" {
            getSystemMessage(message: message)
        }
        let deleteArrayName = UserModel.getUserModel().id! + UserModel.getUserModel().corpid! + "deleteArray"
        if UserDefaultRead(key: deleteArrayName) != nil {
            var deleteArray = UserDefaultRead(key: deleteArrayName) as! Array<String>
            if deleteArray.contains(String(message.conversationType.rawValue) + message.targetId){
                deleteArray.remove(at: deleteArray.index(of: String(message.conversationType.rawValue) + message.targetId)!)
                UserDefaultWrite(id: deleteArray, key: deleteArrayName)
            }
        }
    }
    
    func getSystemMessage(message: RCMessage!) {
        let extra = JSON(((message.content as! RCTextMessage).extra as! String).data(using: String.Encoding.utf8, allowLossyConversion: false)!)//JSON.init((message.content as! RCTextMessage).extra)
        DLog(extra)
        if extra["type"].string == "consult" {//商量
            if extra["act"].string == "invite_teacher" //新建邀请导师
                || extra["act"].string == "teacher_accept" //导师接受辅导
                || extra["act"].string == "teacher_refuse" //导师拒绝辅导
                || extra["act"].string == "user_apply_change" //用户申请修改
                || extra["act"].string == "teacher_accept_change" //导师接受修改
                || extra["act"].string == "teacher_refuse_change" //导师拒绝修改
                || extra["act"].string == "user_apply_cancel" //用户申请取消
                || extra["act"].string == "teacher_accept_cancel" //导师接受取消
                || extra["act"].string == "teacher_refuse_cancel" //导师拒绝取消
                || extra["act"].string == "teacher_start" //导师开始辅导
                || extra["act"].string == "user_finish" //用户结束辅导
            {
                DispatchQueue.main.async(execute: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "coachrefresh"), object: extra)
                if extra["act"].string == "user_finish" {
                    
                    //自己结束的辅导不弹出提醒
                    if String.noNilStr(str: extra["act_sso_userid"]) == UserModel.getUserModel().id{
                        return
                    }
                    
                    
                }
//
                    
                    let alert = UIAlertController.init(title: nil, message: (message.content as! RCTextMessage).content, preferredStyle: UIAlertControllerStyle.alert, okAndCancel: ("查看辅导", "我知道了"), btnActions: { (action, key) in
                        if key == "ok" {
                            //详情
                            let vc = TutoringDetailVC()
                            let getid = extra["data"].dictionary?["id"]?.int
                            if getid == nil{
                                vc.new_consult_id = String(describing: extra["data"].dictionary?["id"]?.string as! String)
                            }else{
                                vc.new_consult_id = String(describing: extra["data"].dictionary?["id"]?.int as! Int)
                            }
                            sharePublicDataSingle.publicTabbar?.selectedWithIndex(index: 2)
                            (sharePublicDataSingle.publicTabbar?.childViewControllers[2] as! BaseNavigationController).popToRootViewController(animated: false)
                            (sharePublicDataSingle.publicTabbar?.childViewControllers[2] as! BaseNavigationController).pushViewController(vc, animated: true)
                        }
                    })
                    if PublicMethod.appChildViewController() is SmallTalkVC{
                        let av = PublicMethod.appChildViewController() as! SmallTalkVC
                        av.parent?.present(alert, animated: true, completion: nil)
                    }else{
                        PublicMethod.appChildViewController().present(alert, animated: true, completion: nil)
                        //                    sharePublicDataSingle.publicTabbar?.present(alert, animated: true, completion: nil)
                    }
                })
                
            }
//            else if extra["act"].string == "user_finish" //用户结束辅导
//            {
//                let view = EvaluateTeacherView.init(consultId: (self.gModel?.consult_info?.consult_id)!, teacherId: (self.gModel?.consult_info?.teacher_sso_userid)!, frame: UIScreen.main.bounds)
//                self.view.addSubview(view)
//            }
        }
    }
    

    
}
