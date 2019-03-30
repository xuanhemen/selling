//
//  SingleChatVC.swift
//  SLAPP
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON
class SingleChatVC: RCConversationViewController {

    var fen = "5"
    var teacherId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 4)
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 3)
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 2)
        DLog(self.targetId)
        if !self.targetId.contains("system") {
            self.add()
        }
        
        
        let targetIdArray = ["systemAtMessage","systemCommentMessage","systemPraiseMessage","system2"]
        if targetIdArray.contains(self.targetId) {
            self.chatSessionInputBarControl.isHidden = true
            
        }
        
        self.configHead()
    }
    
    
    func configHead(){
//        let usermodel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", self.targetId.components(separatedBy: "-")[0])).firstObject() as! UserModelTcp?
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func add(){
        
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage.init(named: "talkYuYinBeiwang"), title: "语音备忘", at: 2, tag: 211)
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage.init(named: "talkFenxiBaoGao"), title: "分析报告", at: 3, tag: 212)
        
        self.register(ProjectReportMessageContentCell.self, forMessageClass: ProjectReportMessageContent.self)
        self.register(ProjectVoiceMessageContentCell.self, forMessageClass: ProjectVoiceMessageContent.self)
        self.conversationMessageCollectionView.register(ProjectReportMessageContentCell.self, forCellWithReuseIdentifier: "ProjectReportMessageContent")
        self.conversationMessageCollectionView.register(ProjectVoiceMessageContentCell.self, forCellWithReuseIdentifier: "ProjectVoiceMessageContent")
    }
    
    
    
    // MARK: - 高度处理
    override func rcConversationCollectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let model:RCMessageModel = self.conversationDataRepository[indexPath.row] as! RCMessageModel
        if model.objectName == "ProjectVoiceMessageContent" {
            if model.isDisplayMessageTime == true{
                return CGSize.init(width: MAIN_SCREEN_WIDTH, height: 200)
            }
            else{
                return CGSize.init(width: MAIN_SCREEN_WIDTH, height: 120)
            }
            
        }else if model.objectName == "ProjectReportMessageContent"{
            
            if model.isDisplayMessageTime == true{
                return CGSize.init(width: MAIN_SCREEN_WIDTH, height: 280)
            }
            else{
                return CGSize.init(width: MAIN_SCREEN_WIDTH, height: 280)
            }
            
        }else{
            return super.rcConversationCollectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        if model.objectName == "RC:TxtMsg" {
            let content:RCTextMessage = model.content as! RCTextMessage
            guard content.extra != nil else {
                return
            }
            let json = JSON.init(parseJSON: content.extra)
            
            if json["type"].stringValue == "consult"{
                let vc = TutoringDetailVC()
                
                vc.new_consult_id = json["data"]["id"].stringValue
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model:RCMessageModel = self.conversationDataRepository[indexPath.row] as! RCMessageModel
         if model.objectName == "ProjectVoiceMessageContent"
        {
            let cell:ProjectVoiceMessageContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectVoiceMessageContent", for: indexPath) as! ProjectVoiceMessageContentCell
            cell.setDataModel(model)
            
            
            
            if shareAVManager.player != nil {
                
                if cell.model.messageId == shareAVManager.model?.messageId {
                    if (shareAVManager.player?.isPlaying)!{
                        cell.btn.setImage(UIImage.init(named: "proStart"), for: .normal)
                    }else {
                        if shareAVManager.player?.currentTime != 0 {
                            cell.btn.setImage(UIImage.init(named: "proStop"), for: .normal)
                        }
                    }
                }
                
            }
            
            
            cell.click = {[weak cell,weak collectionView] (model) in
                
                if cell?.model.messageId == shareAVManager.model?.messageId {
                    
                    if shareAVManager.player != nil {
                        if (shareAVManager.player?.isPlaying)!{
                            shareAVManager.stopPlay()
                            cell?.btn.setImage(UIImage.init(named: "proStart"), for: .normal)
                            cell?.progress.progress = shareAVManager.currentProgress()
                            cell?.timeLable.text = shareAVManager.currentTime()
                            return
                        }else {
                            if shareAVManager.player?.currentTime != 0 {
                                shareAVManager.startPlay()
                                cell?.btn.setImage(UIImage.init(named: "proStop"), for: .normal)
                                cell?.progress.progress = shareAVManager.currentProgress()
                                
                                cell?.timeLable.text = shareAVManager.currentTime()
                                return
                            }
                            
                        }
                    }
                    
                    
                }
                
                shareAVManager.playUrlDataWithModel(progress: 0, mModel: model, compete: { (finish) in
                    
                    
                    
                    let array = collectionView?.visibleCells
                    if (array?.count)! > 0 {
                        for mycell in array! {
                            if mycell .isKind(of: ProjectVoiceMessageContentCell.self){
                                let myCell:ProjectVoiceMessageContentCell = mycell as! ProjectVoiceMessageContentCell
                                if myCell.model.messageId == shareAVManager.model?.messageId{
                                    myCell.progress.progress = shareAVManager.currentProgress()
                                    if finish {
                                        myCell.timeLable.text = "0:00"
                                        myCell.btn.setImage(UIImage.init(named: "proStart"), for: .normal)
                                        myCell.progress.progress = 0
                                        return
                                    }
                                }
                            }
                        }
                        
                    }
                    
                }, action: {
                    let array = collectionView?.visibleCells
                    if (array?.count)! > 0 {
                        for mycell in array! {
                            if mycell .isKind(of: ProjectVoiceMessageContentCell.self){
                                let myCell:ProjectVoiceMessageContentCell = mycell as! ProjectVoiceMessageContentCell
                                if myCell.model.messageId == shareAVManager.model?.messageId{
                                    myCell.progress.progress = shareAVManager.currentProgress()
                                    
                                    cell?.timeLable.text = shareAVManager.currentTime()
                                    cell?.btn.setImage(UIImage.init(named: "proStop"), for: .normal)
                                }else{
                                    myCell.progress.progress = 0
                                    cell?.btn.setImage(UIImage.init(named: "proStart"), for: .normal)
                                }
                            }
                        }
                        
                    }
                    
                    //                        }
                    
                })
            }
            return cell
            
        }else if model.objectName == "ProjectReportMessageContent"
        {
            let cell:ProjectReportMessageContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectReportMessageContent", for: indexPath) as! ProjectReportMessageContentCell
            cell.setDataModel(model)
            return cell
        }
        else
        {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }

    
    
    
    // MARK: - 输入板点击加号后出来的按钮点击响应
    ///
    ///
    /// - Parameters:
    ///   - pluginBoardView: <#pluginBoardView description#>
    ///   - tag: <#tag description#>
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        if tag == 200 {
            
            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
            let vc = ThemeCreatVC();
            vc.groupid = self.targetId
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
        else if tag == 1101 || tag == 1102{ //语音/视频通话
            
//            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
//            let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0'", argumentArray: [self.targetId])
//            let groupUsers =  GroupUserModel.objects(with: predicate)
//
//            var vc : SelectMemberViewController?
//            if tag == 1101{
//                vc = SelectMemberViewController.init(conversationType: self.conversationType, targetId: self.targetId, mediaType: RCCallMediaType.audio, exist: [sharePublicDataSingle.publicData.im_userid], success: { [weak self](addUserIdList) in
//
//                    self?.callAudioVc = CallAudioMultiCallViewController.init(outgoingCall: (self?.conversationType)!, targetId: self?.targetId, mediaType: RCCallMediaType.audio, userIdList: addUserIdList)
//                    self?.present((self?.callAudioVc)!, animated: true, completion: nil)
//                })
//            }
//            if tag == 1102{
//                vc = SelectMemberViewController.init(conversationType: self.conversationType, targetId: self.targetId, mediaType: RCCallMediaType.video, exist: [sharePublicDataSingle.publicData.im_userid], success: { [weak self](addUserIdList) in
//
//                    self?.callVideoVc = CallVideoMultiCallViewController.init(outgoingCall: (self?.conversationType)!, targetId: self?.targetId, mediaType: RCCallMediaType.video, userIdList: addUserIdList)
//                    self?.present((self?.callVideoVc)!, animated: true, completion: nil)
//                })
//            }
//            vc?.listingUserIdList = groupUsers.value(forKeyPath: "im_userid") as! [Any]
//            self.present(vc!, animated: true, completion: nil)
        }
        else if tag == 210 {
            DLog("点击了图文")
            self.sendRichMessage()
        }
        else if tag == 211 {
            DLog("点击了语音备忘")
            self.sendProVoiceMessage()
        }
        else if tag == 212 {
            DLog("点击了赢单")
            self.sendReportMessage()
        }
        else{
            super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        }
    }
    
    // MARK: - 发送语音备份录消息
    func sendProVoiceMessage(){
        
        self.getRrojectList(userid: self.targetId) { (m) in
            
            
            
            var btnDic = Dictionary<String,String>()
            for oneDic in m["list"] as! Array<Dictionary<String,Any>>{
                btnDic[oneDic["project_id"]! as! String] = (oneDic["project_name"] as! String)
            }
            btnDic[kCancel] = "取消"
            let alert = UIAlertController.init(title: "选择项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: {[weak self] (a, key) in
                
                guard key != kCancel else {
                    return
                }
                
                        let vc  =  RecorderPlayerListViewController()
                        vc.projectId = key
                        vc.click = {[weak self](dic) in
                            DLog(dic)
                            let voice = ProjectVoiceMessageContent.init()
                            voice.projectId = key
                            voice.projectName = String.noNilStr(str: dic["parallelism_name"])
                            voice.duration = String.noNilStr(str: dic["duration"])
                            voice.url = String.noNilStr(str: dic["file"])
                            voice.extra = ""
                            self?.sendMessage(voice, pushContent: "")
                        }
                self?.navigationController?.pushViewController(vc, animated: true)
                        return
            })
            self.present(alert, animated: true, completion: nil)
            //            let alertCont = UIAlertController.init(title: "选择项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: {action,key in
            //                DLog(key)
            //                if key != kCancel{
            
            
            
            
            
            
            
            DLog(m)
        }
        
        
        
//        let vc  =  RecorderPlayerListViewController()
//        vc.projectId = gModel?.project_id
//        vc.click = {[weak self](dic) in
//            DLog(dic)
//            let voice = ProjectVoiceMessageContent.init()
//            voice.projectId = (self?.gModel?.project_id)!
//            voice.projectName = dic["parallelism_name"]!
//            voice.duration = dic["duration"]!
//            voice.url = dic["file"]!
//            voice.extra = ""
//            self?.sendMessage(voice, pushContent: "")
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//        return
        
        
        
        
    }
    
    
    // MARK: - 发送赢单
    func sendReportMessage(){
        
        DLog(self.targetId)
        self.getRrojectList(userid: self.targetId) { (m) in
            
            
            
            var btnDic = Dictionary<String,String>()
            for oneDic in m["list"] as! Array<Dictionary<String,Any>>{
                btnDic[oneDic["project_id"]! as! String] = (oneDic["project_name"] as! String)
            }
            btnDic[kCancel] = "取消"
            let alert = UIAlertController.init(title: "选择项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: {[weak self] (a, key) in
                
                guard key != kCancel else {
                    return
                }
                
                        self?.getReportInfo(pid:key) {[weak self] (model) in
                            let report = ProjectReportMessageContent.init()
                            report.projectId = model.projectId
                            report.projectName = model.projectName
                            report.projectRisk = model.projectRisk
                            report.url = model.url
                            report.extra = ""
                            report.projectWinIndex = model.projectWinIndex
                            report.projectScore = model.projectScore
                            self?.sendMessage(report, pushContent: "")
                        }
            })
            self.present(alert, animated: true, completion: nil)
//            let alertCont = UIAlertController.init(title: "选择项目", message: nil, preferredStyle: UIAlertControllerStyle.alert, btns: btnDic, btnActions: {action,key in
//                DLog(key)
//                if key != kCancel{
            
                    
                    
            
            
            
            
            DLog(m)
        }
//        self.getReportInfo(pid: (self.gModel?.project_id)!) {[weak self] (model) in
//            let report = ProjectReportMessageContent.init()
//            report.projectId = model.projectId
//            report.projectName = model.projectName
//            report.projectRisk = model.projectRisk
//            report.url = model.url
//            report.extra = ""
//            report.projectWinIndex = model.projectWinIndex
//            report.projectScore = model.projectScore
//            self?.sendMessage(report, pushContent: "")
//        }
        
        
    }
    
    // MARK: - 发送图文消息
    func sendRichMessage(){
        let rich = RCRichContentMessage.init(title: "图文消息", digest: "哈哈", imageURL: "", url: "www.baidu.com", extra: "")
        self.sendMessage(rich, pushContent: "")
    }
    
    
    override func didTapCellPortrait(_ userId: String!) {
        
        if userId.range(of: "system") != nil {
            return
        }
        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"im_userid == %@", userId)).firstObject() as! GroupUserModel?
        
        let id = (groupUserModel?.userid)!
        let myid = UserModel.getUserModel().im_userid
        if userId == myid{
            PublicPush().pushToUserInfo(imId: id, userId: "", vc: self)
            DLog("点击了用户头像--用户id--"+userId)
        }else{
            let detailVC = QFTeacherDetailVC()
            detailVC.fen = self.fen
            if self.teacherId == "" {
                self.teacherId = id
            }
            detailVC.teacherID = self.teacherId
            self.navigationController?.pushViewController(detailVC, animated: true)
            DLog("点击了教师头像--用户id--"+userId)
        }
        
        
        
        
        
    }
    
    
}
