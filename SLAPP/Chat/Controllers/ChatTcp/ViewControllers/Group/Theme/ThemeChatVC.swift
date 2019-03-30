//
//  ThemeChatVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/9.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
import IQKeyboardManager
class ThemeChatVC: RCConversationViewController,RCMessageCellDelegate {
    
    var isSearch:Bool?//是否是搜索
    var searchModel:ChatContentModel?//搜索内容
    var gModel: GroupModel?
    
    var isMsgCopy:Bool?
    var isSearchBack:Bool?
    var atArray:Array<GroupUserModel>?
    var themeInfoView:ThemeInfoView?
    
    var endBtn:UIButton?
    
    var isChooseView = false//多选开关
    var chooseList = Array<String>.init()//选中的messageId
    var chooseType = "RCTextMessageCell,RCImageMessageCell"//多选内容分类
    
    var lasttime: Any?  //获取的最后一条历史消息的时间
    var length: Int? = 10 //需要获取的历史消息条数,默认10条
    var isLoadingMore:Bool? //是否正在获取更多历史消息,防止下拉获取历史消息接口重复调用
    var lastMessageUid: String?
    var isZhuantui:Bool?//是否是转推选择消息页面
    var finishSelect:(_ chooseList:Array<String>)->() = {//转推选择的消息回调
        msgIdArr in
    }
    var scrollToBottom:Bool?//获取完历史消息是否应该滚动到底部
    var callAudioVc : CallAudioMultiCallViewController? //语音通话页面
    var callVideoVc : CallVideoMultiCallViewController? //视频通话页面
    
    
    var pointButton:UIButton?
    var projectId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackItem()
        IQKeyboardManager.shared().isEnabled = false
        isLoadingMore = false
        scrollToBottom = false
        atArray = Array()
        RCIM.shared().enableMessageMentioned = true
        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
//        RCIM.shared().registerMessageType(ThemeMessageContent.self)
//        RCIM.shared().registerMessageType(HistoryMessageContent.self)
        
        //注册自定义消息
        self.registerCustomerMessageContent()
        
        self.enableUnreadMessageIcon = true
        self.displayUserNameInCell = true
        self.chatSessionInputBarControl.inputTextView.disableActionMenu = true
        self.conversationMessageCollectionView.register(MyVoiceCell.self, forCellWithReuseIdentifier: "voice")
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 2)
        
        
       self.add()
        
        
        
        self.register(ThemeMessageCell.self, forMessageClass: ThemeMessageContent.self)
        self.register(HistoryMessageCell.self, forMessageClass: HistoryMessageContent.self)
        
        self.chatSessionInputBarControl.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
       
        let predicate = NSPredicate.init(format: "groupid == %@", argumentArray: [self.targetId])
        
        gModel = GroupModel.objects(with: predicate).firstObject() as! GroupModel?
        
        
        
        if self.conversationDataRepository.count > 0 {
            let lastMessageModel : RCMessageModel = self.conversationDataRepository.firstObject as! RCMessageModel
            lasttime = lastMessageModel.sentTime - 1
            length = 10 - self.conversationDataRepository.count
        }else{
            lasttime = Date().timeIntervalSince1970 * 1000.0 - 1
        }
        if length! > 0 {
            scrollToBottom = true
            self.getHistoryMsg()
        }
         self.getThemeInfo()
//        if gModel?.is_consult == 1 && (gModel?.owner_id == sharePublicDataSingle.publicData.userid){
//            DLog("groupModel?.consult_info?.consult_status :\(gModel?.consult_info?.consult_status)")
//            if gModel?.consult_info?.consult_status == "5" {
//                addEndBtn()
//            }
//        }
        
        self.creatPointButton()
    }
    
    func add(){
        
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage.init(named: "talkYuYinBeiwang"), title: "语音备忘", at: 5, tag: 211)
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage.init(named: "talkFenxiBaoGao"), title: "分析报告", at: 6, tag: 212)
        
        self.register(ProjectReportMessageContentCell.self, forMessageClass: ProjectReportMessageContent.self)
        self.register(ProjectVoiceMessageContentCell.self, forMessageClass: ProjectVoiceMessageContent.self)
        self.conversationMessageCollectionView.register(ProjectReportMessageContentCell.self, forCellWithReuseIdentifier: "ProjectReportMessageContent")
        self.conversationMessageCollectionView.register(ProjectVoiceMessageContentCell.self, forCellWithReuseIdentifier: "ProjectVoiceMessageContent")
        
    }
    
    
    
    
    
    func getThemeInfo(){
        
        let predicate = NSPredicate(format:"groupid == %@  AND is_delete == '0'",self.targetId)
        let themeResult = ThemeInfoModel.objects(with: predicate)
        if  themeResult.count > 0 {
            let themeInfoModel:ThemeInfoModel = themeResult.firstObject() as! ThemeInfoModel
            let anyArray = BaseRequest.makeJsonWithString(jsonStr: themeInfoModel.imageArray)
            var dic:Dictionary<String,Any> = Dictionary.init()
            dic.updateValue(themeInfoModel.group_name, forKey: "group_name")
            dic.updateValue(anyArray, forKey: "titleFileList")
            self.addThemeInfoView(dic: dic)
            let params = ["sub_groupid":self.targetId as Any,"app_token":sharePublicDataSingle.token]
            GroupRequest.getGroupSubjectInfo(params: params, hadToast: false, fail: { [weak self](fail)  in
            }) { [weak self](success) in
            }
        }
        else{
            
            let params = ["sub_groupid":self.targetId as Any,"app_token":sharePublicDataSingle.token]
            GroupRequest.getGroupSubjectInfo(params: params, hadToast: false, fail: { [weak self](fail)  in
                //            self?.getThemeInfo()
            }) { [weak self](success) in
                
                self?.addThemeInfoView(dic: success)
            }
            
            
        }
        
        
    }
    func getHistoryMsg(){
        isLoadingMore = true
        GroupRequest.getGroupSubjectHistorymsg(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":self.targetId,"lasttime": lasttime!,"length":length!], hadToast: false, fail: { (error) in
            self.isLoadingMore = false
        }, success: { [weak self](dic) in
            self?.isLoadingMore = false
            print("历史消息记录:",dic)
            if let lastTime = dic["lastTime"] as? NSNumber {
                let lastTimeString = lastTime.stringValue
                self?.lasttime = (Float64)(lastTimeString)! - 1
            }
            if let lastTime = dic["lastTime"] as? String {
                self?.lasttime = (Float64)(lastTime)! - 1
            }
            
            self?.length = dic["count"] as! Int? == 0 ? -1 : dic["count"] as! Int?
            let list : Array<Dictionary<String, Any>> = dic["list"] as! Array<Dictionary<String, Any>>
            for i in 0..<list.count {
                let messageModel = RCMessageModel.init()
                
                let dict = list[i]
                let contentData : Data? = (dict["content"] as? String)?.data(using: String.Encoding.utf8)
                //                let contentdic = try?JSONSerialization.jsonObject(with: contentData!, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                //                            }1499397019384
                var messageContent = RCMessageContent.init()
                if dict["classname"] as! String? == "RC:GrpNtf" {
                    messageContent = RCGroupNotificationMessage.init()
                }
                if dict["classname"] as! String? == "RC:TxtMsg" {
                    messageContent = RCTextMessage.init()
                }
                if dict["classname"] as! String? == "RC:ImgMsg" {
                    messageContent = RCImageMessage.init()
                }
                if dict["classname"] as! String? == "RC:VcMsg" {
                    messageContent = RCVoiceMessage.init()
                    messageModel.receivedStatus = .ReceivedStatus_LISTENED
                    
                }
                if dict["classname"] as! String? == "RC:FileMsg" {
                    messageContent = RCFileMessage.init()
                }
                if dict["classname"] as! String? == "HistoryMessageContent" {
                    messageContent = HistoryMessageContent.init()
                }
                if dict["classname"] as! String? == "ProjectVoiceMessageContent" {
                    messageContent = ProjectVoiceMessageContent.init()
                }
                if dict["classname"] as! String? == "ProjectReportMessageContent" {
                    messageContent = ProjectReportMessageContent.init()
                }
                
                if contentData != nil {
                    messageContent.decode(with: contentData!)
                }
                
                messageModel.isDisplayMessageTime = true
                messageModel.isDisplayNickname = true
                messageModel.conversationType = .ConversationType_GROUP
                messageModel.targetId = self?.targetId
                messageModel.receivedStatus = .ReceivedStatus_READ
                messageModel.senderUserId = dict["from_im_userid"] as! String?
                messageModel.content = messageContent
                messageModel.messageDirection = .MessageDirection_RECEIVE
                messageModel.objectName = dict["classname"] as! String?
                messageModel.messageUId = dict["msg_uid"] as! String?
                if dict["direction"] as! String? == "send" {
                    messageModel.messageDirection = .MessageDirection_SEND
                }else{
                    messageModel.messageDirection = .MessageDirection_RECEIVE
                }
                
                
                
                messageModel.sentTime = ((dict["datetime"] as! NSString?)?.longLongValue)!
                
                let mNum = NSNumber.init(value: messageModel.sentTime)
                
                messageModel.messageId = mNum.intValue-i
                
                if (self?.conversationDataRepository.value(forKeyPath: "messageUId") as! NSArray).contains(dict["msg_uid"]!){
                    return
                }
                self?.conversationDataRepository.insert(messageModel, at: 0)
                
            }
            self?.conversationMessageCollectionView.reloadData()
            if self?.scrollToBottom == true{
                self?.scrollToBottom(animated: false)
                self?.scrollToBottom = false
            }
        })
        
    }
    func addThemeInfoView(dic:Dictionary<String, Any>) {
        
        DLog(dic)
        if self.title == nil{
            self.title = dic["group_name"] as! String?
        }
        
        themeInfoView = ThemeInfoView.init(frame: CGRect(x: 0, y: NAV_HEIGHT, width: kScreenW, height:40))
        themeInfoView?.themeName = dic["group_name"] as! String
        
        themeInfoView?.imageArray = dic["titleFileList"] as! Array<Dictionary<String, String>>
        themeInfoView?.configUI()
        themeInfoView?.openUrl = {url in
            let webView = UIWebView.init(frame: self.view.frame)
            let wbc = BaseViewController.init()
            wbc.configBackItem()
            //                wbc.title = (model.content as! HistoryMessageContent).title
            wbc.view = webView
            var newUrl = url
            if url.range(of: "//") == nil{
                newUrl = "http://"+url
            }
            webView.loadRequest(URLRequest.init(url: URL.init(string: newUrl)!))
            self.navigationController?.pushViewController(wbc, animated: true)
        }
        themeInfoView?.openBtnClick = {
            
            if self.chatSessionInputBarControl.inputTextView.isFirstResponder {
                self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
            }
            self.chatSessionInputBarControl.resetToDefaultStatus()
        }
        self.view.addSubview(themeInfoView!);
        if gModel?.is_consult == 1 && (gModel?.owner_id == sharePublicDataSingle.publicData.userid){
            DLog("groupModel?.consult_info?.consult_status :\(gModel?.consult_info?.consult_status)")
            if gModel?.consult_info?.consult_status == "5" {
                addEndBtn()
            }
        }
//        if self.endBtn != nil {
//            self.view.bringSubview(toFront: self.endBtn!)
//        }
    }
    
    func addEndBtn() {
//        endBtn = UIButton(frame: CGRect(x: kScreenW - 89 - 10, y: 95, width: 89, height: 30))
        
        
        self.themeInfoView?.themeLable = UILabel.init(frame: CGRect(x: space, y: 5, width: kScreenW-2*space - 90 , height: 30))
        endBtn = UIButton(frame: CGRect(x: kScreenW - 89 - 10, y: 5, width: 89, height: 30))
        endBtn?.setImage(UIImage(named: "endBtn"), for: .normal)
        endBtn?.addTarget(self, action: #selector(clickEndBtn(btn:)), for: .touchUpInside)
        self.themeInfoView?.addSubview(endBtn!)
    }
    @objc func clickEndBtn(btn:UIButton){
        CoachViewModel.clearCoachKey()
        weak var weakSelf = self
        self.addAlertView(title: "", message: "结束辅导后，导师将不再进行辅导，您确认要结束辅导吗？", actionTitles: ["确定","取消"], okAction: { (action) in
            weakSelf?.progressShow()
            GroupRequest.finishOnlineConsult(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":weakSelf?.gModel?.groupid], hadToast: true, fail: { (error) in
                weakSelf?.progressDismiss()
            }, success: { (dic) in
                DLog(dic)
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                if time == nil{
                    time = "0"
                }
                
                //结束辅导后对导师进行评分
                let view = EvaluateTeacherView.init(consultId: (self.gModel?.consult_info?.consult_id)!, teacherId: (self.gModel?.consult_info?.teacher_sso_userid)!, frame: self.conversationMessageCollectionView.frame)
                self.conversationMessageCollectionView.addSubview(view)
//                APPDelegate.window?.addSubview(view)
//                return
                
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { (fail) in
                    weakSelf?.progressDismiss()
                }, success: {(dic) in
                    DLog(dic)
                    weakSelf?.endBtn?.removeFromSuperview()
                    weakSelf?.themeInfoView?.themeLable = UILabel.init(frame: CGRect(x: space, y: 5, width: kScreenW-2*space, height: 30))
                    weakSelf?.progressDismiss()
                }
                )
                
            })
            
            
        }, cancleAction: { (action) in
            
        })
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if  let chatBar:RCChatSessionInputBarControl = object as? RCChatSessionInputBarControl{
            DLog(chatBar.frame)
            if chatBar.frame.origin.y < kScreenH - chatBar.frame.size.height {
                if self.themeInfoView?.isOpen == true{
                    self.themeInfoView?.btnClick()
                }
            }
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if(action == #selector(paste(_:)) )
        {
            if isMsgCopy == true {
                isMsgCopy = false
                return false
            }
            return true
        }
        else{
            return super.canPerformAction(action, withSender: sender)
        }
        
        
    }
    
    /// 判断是否显示tab上的红点提醒
    func isClearNewPoint(){
        
        guard gModel != nil else {
            return
        }
        
        let groupIdArr : Array<String> = GroupModel.objects(with: NSPredicate.init(format: "parentid == %@", (self.gModel?.parentid)!)).value(forKeyPath: "groupid") as! Array<String>
        var subGroupMesTotalCount : Int32? = 0
        for targetId in groupIdArr {
            subGroupMesTotalCount = subGroupMesTotalCount! + RCIMClient.shared().getUnreadCount(.ConversationType_GROUP, targetId: targetId)
        }
        
        if subGroupMesTotalCount == 0 {
            self.clearTabRedPoint()
        }
        else{
            self.showTabRedPoint()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.chatSessionInputBarControl.inputTextView.becomeFirstResponder()
        if isSearchBack == true {
            isSearchBack = false
        }
        else{
            
            let predicate = NSPredicate.init(format: "groupid == %@", argumentArray: [self.targetId])
            
            gModel = GroupModel.objects(with: predicate).firstObject() as! GroupModel?
            if gModel != nil {
                
                self.title = gModel?.group_name
                
            }
            
            //清除未读数据
            let mResult = MessageCenterModel.objects(with: NSPredicate(format: "targetId == %@", self.targetId))
            DataBaseOperation.removeDataWithArray(rlmObjects: mResult)
            
            let notice = Notification.init(name: NSNotification.Name(rawValue: "reLoadTotalUnreadCount"), object: nil, userInfo: nil)
            NotificationCenter.default.post(notice)
            if (self.navigationController?.navigationBar.subviews.contains(coverNavBar))! {
                coverNavBar.removeFromSuperview()
            }
            if isSearch != true {
                
                makeNavigationRightBtn()
            }
        }
        
        
        self.callPhoneNoti()
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        shareAVManager.stopPlay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.cancleMoreAction(UIButton.init())
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
        self.isClearNewPoint()
        
        if isSearch == true {
            self.scrollToIndexWithMessageId(model: searchModel!)
        }
        refreshUserInfoOrGroupInfo()
        
        if self.projectId == "" {
            self.pointButton?.isHidden = true
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if self.conversationDataRepository.count > 0 {
            if self.lastMessageUid == nil {
                for messageModel in self.conversationDataRepository {
                    if (messageModel as! RCMessageModel).content is RCGroupNotificationMessage{
                        if let notiMessage = ((messageModel as! RCMessageModel).content as! RCGroupNotificationMessage).message{
                            if notiMessage  == String.init(format: "%@加入了话题。",sharePublicDataSingle.publicData.realname){
                                self.lastMessageUid = (messageModel as! RCMessageModel).messageUId
                                break
                            }
                        }
                    }
                }
            }else{
                if self.isLoadingMore! || length! < 0 || scrollView.contentOffset.y > 0{
                    return
                }
                self.getHistoryMsg()
                
                //                if (self.conversationDataRepository.firstObject as! RCMessageModel).content is RCGroupNotificationMessage{
                //                    if ((self.conversationDataRepository.firstObject as! RCMessageModel).content as! RCGroupNotificationMessage).message == String.init(format: "%@加入了话题。",sharePublicDataSingle.publicData.realname){
                //                                           }
                //                }else{
                //
                //                }
            }
        }
    }
    
    override func willDisplayMessageCell(_ cell: RCMessageBaseCell!, at indexPath: IndexPath!) {
        DLog("deinit: \(cell.classForCoder) + \(cell.model.objectName)")
        if cell.model.objectName == "RC:GrpNtf"  {
            let notModel:RCGroupNotificationMessage? = cell.model.content as? RCGroupNotificationMessage
            //            if notModel?.operation == GroupNotificationMessage_GroupOperationAdd || notModel?.operation == GroupNotificationMessage_GroupOperationKicked  {
            
            let mycell = cell as! RCTipMessageCell
            let label = UILabel.init()
            label.font = mycell.tipMessageLabel.font
            guard (notModel?.message.contains(sharePublicDataSingle.publicData.realname))! else {
                
                mycell.tipMessageLabel.text = notModel?.message
                let height = Int((mycell.tipMessageLabel.text?.getTextHeight(font: mycell.tipMessageLabel.font, width: tipView_Width))!) + 6
                label.text = notModel?.message
                label.sizeToFit()
                mycell.tipMessageLabel.frame.size = CGSize.init(width: label.frame.size.width + 20 < tipView_Width ? label.frame.size.width + 20 : tipView_Width, height: CGFloat(height))
                mycell.tipMessageLabel.center.x = SCREEN_WIDTH * 0.5
                return
            }
            
            mycell.tipMessageLabel.text = notModel?.message.replacingOccurrences(of: sharePublicDataSingle.publicData.realname, with: "你")
            let height = Int((mycell.tipMessageLabel.text?.getTextHeight(font: mycell.tipMessageLabel.font, width: tipView_Width))!) + 6
            label.text = notModel?.message.replacingOccurrences(of: sharePublicDataSingle.publicData.realname, with: "你")
            label.sizeToFit()
            mycell.tipMessageLabel.frame.size = CGSize.init(width: label.frame.size.width + 20 < tipView_Width ? label.frame.size.width + 20 : tipView_Width, height: CGFloat(height))
            mycell.tipMessageLabel.center.x = SCREEN_WIDTH * 0.5
            
            
            //            }
            //            else{
            //                super.willDisplayMessageCell(cell, at: indexPath)
            //                DLog(cell)
            //                cell.delegate = self
            //            }
            
        }
        else{
            super.willDisplayMessageCell(cell, at: indexPath)
            
            cell.clearCell()
            
            if self.isChooseView {
                let className = "\(cell.classForCoder)"
                if self.chooseType.range(of: className) != nil {
                    
                    let  btn = UIButton.init(type: .custom)
                    self.chooseShow(cell: cell, isShow: true, listArray: self.chooseList as NSArray, btn: btn)
                    btn.addTarget(self, action: #selector(cellBtnClick(btn:)), for: .touchUpInside)
                }
                else{
                    self.chooseShow(cell: cell, isShow: false, listArray: self.chooseList as NSArray, btn: UIButton())
                }
            }
            if cell.isKind(of: ThemeMessageCell.self) {
                (cell as! ThemeMessageCell).didJoin = {
                    (themeId:String) in
                    //                    DLog(themeId)
                    let talk = ThemeChatVC(conversationType: RCConversationType.ConversationType_GROUP, targetId: themeId)
                    self.navigationController?.pushViewController(talk!, animated: true)
                }
            }
            cell.delegate = self
        }
    }
    
    
    @objc func cellBtnClick(btn:UIButton){
        
        let view  =  btn.superview
        let imageView:UIImageView = view?.viewWithTag(1234) as! UIImageView
        if (self.chooseList.contains("\(btn.tag)")) {
            self.chooseList.remove(at: (self.chooseList.index(of: "\(btn.tag)")!))
            imageView.image = UIImage.init(named: "logic_normal")
            
        }else{
            self.chooseList.append("\(btn.tag)")
            imageView.image = UIImage.init(named: "logic_select")
        }
        
    }
    
    
    
    override func willAppendAndDisplay(_ message: RCMessage!) -> RCMessage! {
        let newme = super.willAppendAndDisplay(message)
        
        DLog(message)
        return newme
    }
    
    
    
    
    
    //MARK: -----------RCMessageCellDelegate  cell点击事件------------------------//
    override func didLongTouchMessageCell(_ model: RCMessageModel!, in view: UIView!) {
        if self.isChooseView {
            
        }else{
            super.didLongTouchMessageCell(model, in: view)
        }
    }
    var selectRCMessageModel:RCMessageModel?
    
    override func didTapMessageCell(_ model: RCMessageModel!) {
        super.didTapMessageCell(model)
        
        if model.content.isKind(of: ThemeMessageContent.self) {
            let predicate = NSPredicate(format:"userid == %@ AND groupid == %@  AND is_delete == '0'", sharePublicDataSingle.publicData.userid,(model.content as! ThemeMessageContent).themeId)
            let results = GroupUserModel.objects(with: predicate)
            if results.count == 0 {
                GroupRequest.getGroupSubjectInfo(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":(model.content as! ThemeMessageContent).themeId], hadToast: true, fail: { (dic) in
                    
                }) { (dic) in
                    let results2 = GroupUserModel.objects(with: predicate)
                    if results2.count == 0 {
                        GroupRequest.joinGroupSubject(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":(model.content as! ThemeMessageContent).themeId], hadToast: true, fail: { (error) in
                            
                        }, success: { (dic) in
                            let talk = ThemeChatVC(conversationType: RCConversationType.ConversationType_GROUP, targetId: (model.content as! ThemeMessageContent).themeId)
                            self.navigationController?.pushViewController(talk!, animated: true)
                        })
                    }else{
                        let talk = ThemeChatVC(conversationType: RCConversationType.ConversationType_GROUP, targetId: (model.content as! ThemeMessageContent).themeId)
                        self.navigationController?.pushViewController(talk!, animated: true)
                    }
                }
            }else{
                let talk = ThemeChatVC(conversationType: RCConversationType.ConversationType_GROUP, targetId: (model.content as! ThemeMessageContent).themeId)
                self.navigationController?.pushViewController(talk!, animated: true)
            }
        }
        if model.content.isKind(of: HistoryMessageContent.self) {
            let webView = UIWebView.init(frame: self.view.frame)
            let wbc = BaseViewController.init()
            wbc.configBackItem()
            wbc.title = (model.content as! HistoryMessageContent).title
            wbc.view = webView
            webView.loadRequest(URLRequest.init(url: URL.init(string: (model.content as! HistoryMessageContent).url)!))
            self.navigationController?.pushViewController(wbc, animated: true)
            
            //            self.didTapUrl(inMessageCell: (model.content as! HistoryMessageContent).url, model: model)
        }
    }
    
    override func getLongTouchMessageCellMenuList(_ model: RCMessageModel!) -> [UIMenuItem]! {
        var menuList = super.getLongTouchMessageCellMenuList(model)
        self.selectRCMessageModel = model
        isMsgCopy = true
        if self.selectRCMessageModel?.objectName == "RC:ImgMsg" {
            let callBackBtn = UIMenuItem.init(title: "复制", action: #selector(callCopyBtnAction(_:)))
            menuList?.append(callBackBtn)
        }
        
        if model.senderUserId == sharePublicDataSingle.publicData.im_userid{
            
            let send:Double = Double((self.selectRCMessageModel?.sentTime)!)
            
            let interval:TimeInterval = Date().timeIntervalSince1970 * 1000
            if interval - send <= 120*1000  {
                
                
                let callBackBtn = UIMenuItem.init(title: "撤回", action: #selector(callBackBtnAction(_:)))
                menuList?.append(callBackBtn)
                
                
            }
            
            
            
        }
        
        if self.selectRCMessageModel?.objectName == "RC:ImgMsg" || self.selectRCMessageModel?.objectName == "RC:TxtMsg" || self.selectRCMessageModel?.objectName == "RC:VcMsg"{
            
            let callBackBtn = UIMenuItem.init(title: "转发", action: #selector(repeatAction(_:)))
            menuList?.append(callBackBtn)
            
        }
        
        
        
        if self.selectRCMessageModel?.objectName == "RC:ImgMsg" || self.selectRCMessageModel?.objectName == "RC:TxtMsg"{
            let moreBtn = UIMenuItem.init(title: "更多…", action: #selector(moreAction(_:)))
            menuList?.append(moreBtn)
        }
        
        
        
        
        
        return menuList
    }
    
    
    
    
    
    @objc func callCopyBtnAction(_ btn:Any) {
        
        //        for i in 0..< self.conversationMessageCollectionView.visibleCells.count {
        //
        //        }
        for i in 0..<self.conversationMessageCollectionView.visibleCells.count {
            let cell = self.conversationMessageCollectionView.visibleCells[i]
            guard cell is RCMessageCell else {
                continue
            }
            
            let myCell:RCMessageCell = cell as! RCMessageCell
            
            if myCell.model.messageId == self.selectRCMessageModel?.messageId {
                let fullImageUrl = (myCell.model.content as! RCImageMessage).imageUrl
                //                DLog(fullImageUrl)
                let myImageCell:RCImageMessageCell = myCell as! RCImageMessageCell
                let pasteboard:UIPasteboard = UIPasteboard.general
                pasteboard.image = myImageCell.pictureView.image
                
                if fullImageUrl?.range(of: "http://") != nil{
                    DispatchQueue.global().async {
                        do{
                            let fullImage = try UIImage.init(data: Data.init(contentsOf: URL.init(string: fullImageUrl!)!))
                            DispatchQueue.main.async {
                                pasteboard.image = fullImage
                            }
                        }catch{
                            DLog(error)
                        }
                    }
                }else{
                    //                    do{
                    //                    DLog(fullImageUrl as! String)
                    //                    DLog(Bundle.main.resourcePath)
                    //                    DLog(NSData.init(contentsOf: URL(fileURLWithPath: fullImageUrl as! String)))
                    //                    try DLog(NSData.init(contentsOfFile: fullImageUrl!, options: NSData.ReadingOptions.init(rawValue: 0)))
                    //                    }
                    //                    catch{
                    //                        DLog(error)
                    //                    }
                    //
                    pasteboard.image = UIImage.init(contentsOfFile: fullImageUrl!)
                }
            }
        }
    }
    
    
    
    
    
    override func paste(_ btn:(Any)?){
        
        let pasteboard:UIPasteboard = UIPasteboard.general
        if pasteboard.image != nil {
            
            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
            
            let paste:PasteView = Bundle.main.loadNibNamed("PasteView", owner: self, options: nil)?.last as! PasteView
            paste.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
            paste.imageView.image = pasteboard.image
            UIApplication.shared.keyWindow?.addSubview(paste)
            
            paste.sendBtnClick {[weak self] in
                let message:RCImageMessage = RCImageMessage.init(image: pasteboard.image)
                self?.sendMessage(message, pushContent:PublicDataSingle.makePushContent(message, groupId: (self?.targetId)!))
            }
        }
        else{
            super.paste(btn)
        }
        
    }
    
    
    
    
    
    @objc func callBackBtnAction(_ btn:Any) {
        //callback
        
        self.recallMessage((self.selectRCMessageModel?.messageId)!)
        UserRequest.withdraw_message(params: ["app_token":sharePublicDataSingle.token,"msg_uid":self.selectRCMessageModel?.messageUId,"groupid":self.targetId], hadToast: true, fail: { (error) in
            
        }) { (dic) in
            
        }
    }
    @objc func repeatAction(_ btn:Any) {
        
        
        //callback
        //        self.recallMessage((self.selectRCMessageModel?.messageId)!)
        let aaa = SelectMyGroup()
        aaa.targetId = self.targetId  //当前所在群组的groupid
        aaa.message = self.selectRCMessageModel?.content
        aaa.iszhuanfa = true
        aaa.finishSelect = {
            sGroupList,otherText in
            
            for sGroupOne in sGroupList {
                let gModel = sGroupOne as! GroupModel
                if gModel.groupid == self.gModel?.parentid {//转发到本群
                    for i in 0..<(self.navigationController?.childViewControllers.count)!{
                        if self.navigationController?.childViewControllers[i] is TMTabbarController{
                            
                            let Tab:TMTabbarController = self.navigationController?.childViewControllers[i] as! TMTabbarController
                            let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                            smak.isRunApi = false//设置为false,返回到闲聊会话会滚动到底部显示最新消息
                            break
                        }
                    }
                    
                }
                RCIM.shared().sendMessage(.ConversationType_GROUP, targetId: gModel.groupid, content: self.selectRCMessageModel?.content, pushContent: PublicDataSingle.makePushContent(self.selectRCMessageModel?.content, groupId: gModel.groupid), pushData: PublicDataSingle.makePushContent(self.selectRCMessageModel?.content, groupId: gModel.groupid), success: { (Int) in
                    
                    if otherText != "" {
                        DispatchQueue.main.async {
                            RCIM.shared().sendMessage(.ConversationType_GROUP, targetId: gModel.groupid, content: RCTextMessage.init(content: otherText), pushContent: PublicDataSingle.makePushContent(RCTextMessage.init(content: otherText), groupId: gModel.groupid), pushData: PublicDataSingle.makePushContent(RCTextMessage.init(content: otherText), groupId: gModel.groupid), success: { (Int) in
                                
                            }, error: { (RCErrorCode, Int) in
                                
                            })
                        }
                    }
                }, error: { (RCErrorCode, Int) in
                    
                })
                
                
            }
            self.navigationController?.view.makeToast("转发成功", duration: 1.0, position: self.navigationController?.view.center)
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
        
        self.navigationController?.pushViewController(aaa, animated: true)
        
    }
    
    
    
    
    func makeNavigationRightBtn() {
        if isZhuantui == true {
            let rightBtn = UIButton.init(type: .system)
            rightBtn.setTitle("确定", for: .normal)
            rightBtn.sizeToFit()
            let rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
            rightBtn.addTarget(self, action: #selector(retweetSureBtnDidClick), for: .touchUpInside)
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
            
            isChooseView = true
            //收回键盘
            if self.chatSessionInputBarControl.inputTextView.isFirstResponder {
                self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
            }
            self.conversationMessageCollectionView.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT)
            self.chatSessionInputBarControl.isHidden = true
            return
        }
        let rightBtn = UIButton.init(type: .system)
        rightBtn.frame =  CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
        
        let rightBtn2 = UIButton.init(type: .system)
        rightBtn2.frame =  CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
        
        rightBtn.setImage(UIImage.init(named: "theme_transmit_big"), for: .normal)
        rightBtn.addTarget(self, action: #selector(retweetBtnDidClick), for: .touchUpInside)
        
        rightBtn2.setImage(UIImage.init(named: "search_white"), for: .normal)
        rightBtn2.addTarget(self, action: #selector(searchBtnDidClick), for: .touchUpInside)
        
        rightBtn.sizeToFit()
        rightBtn2.sizeToFit()
        
        
        
        let rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        let rightBarButtonItem2 = UIBarButtonItem.init(customView: rightBtn2)
        let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",self.targetId)).firstObject() as! GroupModel?
        if groupModel?.is_delete == "1" {//已经解散了
            self.navigationItem.rightBarButtonItem = rightBarButtonItem2
        }else{
            let array = [rightBarButtonItem,rightBarButtonItem2]
            self.navigationItem.rightBarButtonItems = array
        }
    }
    @objc func retweetBtnDidClick(button: UIButton) {
        let vc = ThemeRetweetVC()
        vc.thisThemeId = self.targetId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchBtnDidClick(button: UIButton) {
        let v = ChatContentSearchVC()
        v.targetId = self.targetId
        
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    @objc func retweetSureBtnDidClick(button: UIButton){//选择完转推消息后确认按钮点击事件
        var idlist = Array<String>.init()
        
        for  idStr in self.chooseList {
            for oneMessage in self.conversationDataRepository {
                let oneM = oneMessage as! RCMessageModel
                if idStr == "\(oneM.messageId)"{
                    idlist.append(oneM.messageUId)
                    break
                }
            }
        }
        
        self.finishSelect(idlist)
    }
    
    override func rcConversationCollectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        let model:RCMessageModel = self.conversationDataRepository[indexPath.row] as! RCMessageModel
        if model.objectName == "ProjectVoiceMessageContent" {
            if model.isDisplayMessageTime == true{
                return CGSize.init(width: MAIN_SCREEN_WIDTH, height: 140)
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model:RCMessageModel = self.conversationDataRepository[indexPath.row] as! RCMessageModel
        if model.objectName == "RC:VcMsg"
        {
            //                return super.collectionView(collectionView, cellForItemAt: indexPath)
            let cell:MyVoiceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "voice", for: indexPath) as! MyVoiceCell
            cell.setDataModel(model)
            cell.myDelegate = self as! MyVoiceViewCellDelegate
            cell.delegate = self as! RCMessageCellDelegate
            //多选时语音不可点击
            self.willDisplayMessageCell(cell, at: indexPath)
            return  cell as UICollectionViewCell
            
            
        }
        else if model.objectName == "ProjectVoiceMessageContent"
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
            self.willDisplayMessageCell(cell, at: indexPath)
            return cell
            
        }else if model.objectName == "ProjectReportMessageContent"
        {
            let cell:ProjectReportMessageContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectReportMessageContent", for: indexPath) as! ProjectReportMessageContentCell
            cell.setDataModel(model)
            self.willDisplayMessageCell(cell, at: indexPath)
            return cell
        }
        else
        {
            //                DLog(model.objectName)
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
    
    @objc func moreAction(_ btn:Any) {
        
        //        isChooseView = true
        //        self.conversationMessageCollectionView.reloadData()
        self.doMoreAction(btn) { (list) in
            
        }
    }
    
    //更多按钮点击事件
    func doMoreAction(_ btn:Any,finishB:@escaping (Array<String>)->()) {
        //收回键盘
        if self.chatSessionInputBarControl.inputTextView.isFirstResponder {
            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
        }
        self.chatSessionInputBarControl.resetToDefaultStatus()
        self.navigationController?.navigationBar.addSubview(coverNavBar)
        isChooseView = true
        self.conversationMessageCollectionView.reloadData()
        self.moreBottomView.creatBtnsWithImageNames(ImageNamesArr: ["more_transmit","more_delete"])
        self.moreBottomView.btnClickBlock = ({ [weak self](btn) in
            if let strongSelf = self{
                switch btn.tag {
                case 10:
                    if strongSelf.chooseList.count == 0 {
                        strongSelf.view.makeToast("请选择转发的内容", duration: 1.0, position: strongSelf.view.center)
                        return
                    }
                    
                    let alertV = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    alertV.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (cAlert) in
                    }))
                    alertV.addAction(UIAlertAction(title: "逐条转发", style: .default, handler: { (cAlert) in
                        
                        var idlist = Array<RCMessageModel>.init()
                        for  idStr in strongSelf.chooseList {
                            for oneMessage in strongSelf.conversationDataRepository {
                                let oneM = oneMessage as! RCMessageModel
                                if idStr == "\(oneM.messageId)"{
                                    idlist.append(oneM)
                                    break
                                }
                            }
                        }
                        idlist.sort(by: { (model1, model2) -> Bool in
                            return model1.sentTime < model2.sentTime
                        })
                        let selectVC = SelectMyGroup()
                        selectVC.targetId = strongSelf.gModel?.groupid  //当前所在群组的groupid
                        selectVC.iszhuanfa = true
                        selectVC.finishSelect = {
                            sGroupList,otherText in
                            for sGroupOne in sGroupList {
                                let gModel = sGroupOne as! GroupModel
                                self?.sendListMessage(from: 0, idlist: idlist, ggModel: gModel, endMessage: otherText!)
                                
                                //                                for oneM in idlist {
                                //                                    if gModel.groupid == self?.gModel?.parentid {//转发到本群
                                //                                        let Tab:TMTabbarController = self!.navigationController?.childViewControllers[1] as! TMTabbarController
                                //                                        let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                                //                                        smak.sendMessage(oneM.content, pushContent: nil)
                                //                                        if otherText != "" {
                                //                                            smak.sendMessage(RCTextMessage.init(content: otherText), pushContent: otherText)
                                //                                        }
                                //                                    }else{
                                //                                        RCIMClient.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel.groupid, content: oneM.content, pushContent: "转发", pushData: "转发", success: { (Int) in
                                //                                        }, error: { (RCErrorCode, Int) in
                                //                                        })
                                //                                        if otherText != "" {
                                //                                            RCIMClient.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel.groupid, content: RCTextMessage.init(content: otherText), pushContent: otherText, pushData: otherText, success: { (Int) in
                                //                                            }, error: { (RCErrorCode, Int) in
                                //                                            })
                                //                                        }
                                //                                    }
                                //
                                //                                }
                                
                            }
                            strongSelf.navigationController?.view.makeToast("转发成功", duration: 1.0, position: strongSelf.navigationController?.view.center)
                            
                            strongSelf.navigationController?.popViewController(animated: true)
                            strongSelf.cancleMoreAction(btn)
                        }
                        strongSelf.navigationController?.pushViewController(selectVC, animated: true)
                        
                    }))
                    alertV.addAction(UIAlertAction(title: "合并转发", style: .default, handler: { (cAlert) in
                        var idlist = ""
                        for  idStr in strongSelf.chooseList {
                            for oneMessage in strongSelf.conversationDataRepository {
                                let oneM = oneMessage as! RCMessageModel
                                if idStr == "\(oneM.messageId)"{
                                    idlist.append(oneM.messageUId+",")
                                    break
                                }
                            }
                        }
                        let selectVC = SelectMyGroup()
                        selectVC.targetId = strongSelf.gModel?.groupid  //当前所在群组的groupid
                        selectVC.iszhuanfa = true
                        selectVC.finishSelect = {
                            sGroupList,otherText in
                            strongSelf.progressShow()
                            GroupRequest.forwardGroupSubject(params: ["app_token":sharePublicDataSingle.token,"groupid":strongSelf.gModel?.groupid,"msg_uid_str":idlist,"is_all":false], hadToast: true, fail: { [weak self](errorDic) in
                                if let strongSelf = self{
                                    strongSelf.progressDismiss()
                                }
                                DLog(errorDic)
                                }, success: { [weak self](succDic) in
                                    if let strongSelf = self{
                                        strongSelf.progressDismiss()
                                        let nMessage = HistoryMessageContent.init()
                                        nMessage.title = succDic["title"] as! String
                                        nMessage.content = succDic["content"] as! String
                                        nMessage.url = succDic["forwardUrl"] as! String
                                        
                                        for sGroupOne in sGroupList {
                                            let gModel = sGroupOne as! GroupModel
                                            if gModel.groupid == self?.gModel?.parentid {//转发到本群
                                                for i in 0..<(strongSelf.navigationController?.childViewControllers.count)!{
                                                    if strongSelf.navigationController?.childViewControllers[i] is TMTabbarController{
                                                        
                                                        let Tab:TMTabbarController = strongSelf.navigationController?.childViewControllers[i] as! TMTabbarController
                                                        let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                                                        smak.isRunApi = false
                                                        break
                                                    }
                                                }

                                                
                                            }
                                            RCIM.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel.groupid, content: nMessage, pushContent: PublicDataSingle.makePushContent(nMessage, groupId: gModel.groupid), pushData: PublicDataSingle.makePushContent(nMessage, groupId: gModel.groupid), success: { (Int) in
                                                if otherText != "" {
                                                    DispatchQueue.main.async {
                                                        RCIM.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel.groupid, content: RCTextMessage.init(content: otherText), pushContent: PublicDataSingle.makePushContent(RCTextMessage.init(content: otherText), groupId: gModel.groupid), pushData: PublicDataSingle.makePushContent(RCTextMessage.init(content: otherText), groupId: gModel.groupid), success: { (Int) in
                                                        }, error: { (RCErrorCode, Int) in
                                                        })
                                                    }
                                                }
                                            }, error: { (RCErrorCode, Int) in
                                            })
                                            
                                        }
                                        
                                        strongSelf.navigationController?.view.makeToast("转发成功", duration: 1.0, position: strongSelf.navigationController?.view.center)
                                        
                                        strongSelf.navigationController?.popViewController(animated: true)
                                        
                                        
                                    }
                                    
                            })
                            
                            
                            strongSelf.cancleMoreAction(btn)
                            
                        }
                        strongSelf.navigationController?.pushViewController(selectVC, animated: true)
                    }))
                    
                    strongSelf.present(alertV, animated: true, completion: nil)
                    
                    DLog("转发")
                case 11:
                    if strongSelf.chooseList.count == 0 {
                        strongSelf.view.makeToast("请选择删除的内容", duration: 1.0, position: strongSelf.view.center)
                        return
                    }
                    
                    for idStr in strongSelf.chooseList {
                        for oneMessage in strongSelf.conversationDataRepository {
                            let oneM = oneMessage as! RCMessageModel
                            if idStr == "\(oneM.messageId)"{
                                strongSelf.deleteMessage(oneM)
                                break
                            }
                        }
                    }
                    
                    //todo没有找到更好的方法，暂时这么处理
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                        strongSelf.cancleMoreAction(btn)
                    })
                    
                    DLog("删除")
                default:
                    break
                }
            }
        })
        self.view.addSubview(self.moreBottomView)
        self.chatSessionInputBarControl.isHidden = true
    }
    
    func doSelectAction(_ btn:Any,finishB:@escaping (Array<String>)->()) {
        isChooseView = true
        //收回键盘
        if self.chatSessionInputBarControl.inputTextView.isFirstResponder {
            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
        }
        //        self.conversationMessageCollectionView.reloadData()
        self.moreBottomView.creatBtnsWithTitleNames(TitleNamesArr: ["取消","确定"])
        self.moreBottomView.btnClickBlock = ({ (btn) in
            
            var idlist = Array<String>.init()
            
            for  idStr in self.chooseList {
                for oneMessage in self.conversationDataRepository {
                    let oneM = oneMessage as! RCMessageModel
                    if idStr == "\(oneM.messageId)"{
                        idlist.append(oneM.messageUId)
                        break
                    }
                }
            }
            
            switch btn.tag {
            case 10:
                DLog("转发")
            //                finishB(idlist)
            case 11:
                DLog("删除")
                finishB(idlist)
            default:
                break
            }
            
        })
        self.conversationMessageCollectionView.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT)
        //        self.view.addSubview(self.moreBottomView)
        self.chatSessionInputBarControl.isHidden = true
    }
    
    func sendListMessage(from:Int ,idlist:Array<RCMessageModel> , ggModel:GroupModel ,endMessage:String) {
        
        if idlist.count == from{
            if endMessage != "" {
                DispatchQueue.main.async {
                    if ggModel.groupid == self.gModel?.parentid {//转发到本群
                        if self.navigationController != nil{
                            for i in 0..<(self.navigationController?.childViewControllers.count)!{
                                if self.navigationController?.childViewControllers[i] is TMTabbarController{
                                    
                                    let Tab:TMTabbarController = self.navigationController?.childViewControllers[i] as! TMTabbarController
                                    let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                                    smak.isRunApi = false
                                    break
                                }
                            }
                           
                        }
                    }
                    RCIM.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: ggModel.groupid, content: RCTextMessage.init(content: endMessage), pushContent: PublicDataSingle.makePushContent(RCTextMessage.init(content: endMessage), groupId: ggModel.groupid), pushData: PublicDataSingle.makePushContent(RCTextMessage.init(content: endMessage), groupId: ggModel.groupid), success: { (Int) in
                    }, error: { (RCErrorCode, Int) in
                    })
                }
            }
            return
        }
        
        let oneM = idlist[from]
        DispatchQueue.main.async {
            if ggModel.groupid == self.gModel?.parentid {//转发到本群
                if self.navigationController != nil{
                    for i in 0..<(self.navigationController?.childViewControllers.count)!{
                        if self.navigationController?.childViewControllers[i] is TMTabbarController{
                            
                            let Tab:TMTabbarController = self.navigationController?.childViewControllers[i] as! TMTabbarController
                            let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                            smak.isRunApi = false
                            break
                        }
                    }
                   
                    
                }
                
            }
            RCIM.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: ggModel.groupid, content: oneM.content, pushContent: "[转发]"+PublicDataSingle.makePushContent(oneM.content, groupId: ggModel.groupid), pushData: "[转发]"+PublicDataSingle.makePushContent(oneM.content, groupId: ggModel.groupid), success: { (Int) in
                Thread.sleep(forTimeInterval: 0.1)
                self.sendListMessage(from: from+1, idlist: idlist, ggModel: ggModel, endMessage: endMessage )
            }, error: { (RCErrorCode, Int) in
                Thread.sleep(forTimeInterval: 0.1)
                self.sendListMessage(from: from+1, idlist: idlist, ggModel: ggModel, endMessage: endMessage )
            })
        }
        
    }
    
    //取消更多点击事件
    @objc func cancleMoreAction(_ btn:Any) {
        coverNavBar.removeFromSuperview()
        isChooseView = false
        self.chooseList.removeAll()
        self.conversationMessageCollectionView.reloadData()
        self.moreBottomView.removeFromSuperview()
        self.chatSessionInputBarControl.isHidden = false
        
    }
    
    
    
    
    
    func avfinish(){
        
        
        //        let mArray = notification.object as! Array<Any>
        //        let m:RCMessageModel = mArray[0] as! RCMessageModel
        
        if shareAVManager.isAuto != true {
            return
        }
        
        if shareAVManager.model?.messageDirection == .MessageDirection_SEND {
            //自己发的消息不用做自动播放处理
            return
        }
        
        
        let m:RCMessageModel = shareAVManager.model!
        
        guard m.targetId == self.targetId else {
            //必须保证 当前播放的语音消息 是属于当前聊天场景（后续可能会添加 话题等，由于系统设计tabbarcontroller 会出现同时有多个聊天场景共存的现象）  否则没有必要去做接下来的处理
            return
        }
        
        
        //需要将播放完成语音消息  接收状态改变
        let i = self.conversationDataRepository.index(of: m)
        m.receivedStatus = .ReceivedStatus_LISTENED
        
        //在滑动的时候 可能会出现越界 因此要加一个判断
        if self.conversationDataRepository.count>=i
        {
            self.conversationDataRepository.replaceObject(at: i, with: m)
        }
        
        //        如果刚播完的语音在播放前不是未读  就没有必要做自动播放
        
        
        
        //拿到当前屏幕上显示的cell  并做类型过滤
        var array = Array<Any>()
        
        if self.conversationMessageCollectionView.visibleCells.count > 0 {
            for i in 0..<self.conversationMessageCollectionView.visibleCells.count {
                let cell = self.conversationMessageCollectionView.visibleCells[i]
                
                guard cell is MyVoiceCell else {
                    continue
                }
                
                let cuCell:MyVoiceCell = cell as! MyVoiceCell
                if cuCell.model.messageDirection == .MessageDirection_RECEIVE && cuCell.model.receivedStatus != .ReceivedStatus_LISTENED {
                    array.append(cell)
                }
                
            }
            
        }
        
        
        
        if array.count > 0
        {
            
            
            //必须做排序  必须做！！！ 必须做！！！ 必须做！！！
            //拿到的屏幕显示的数据  并不会按照cell显示的顺序存放到数组
            array = array.sorted(by: { (cell1, cell2) -> Bool in
                let cell11:RCMessageCell = cell1 as! RCMessageCell
                let cell22:RCMessageCell = cell2 as! RCMessageCell
                return cell22.model.messageId > cell11.model.messageId
            })
            
            
            
            //我们是要做语音消息的处理  所以保证接下来处理的cell类型为语音类型
            for i in 0..<array.count {
                let cell  = array[i]
                
                /// 先在显示到屏幕的cell中去做处理 只要找到符合条件的就播放 并跳出循环
                let myCell:MyVoiceCell = cell as! MyVoiceCell
                if myCell.model.receivedStatus != RCReceivedStatus.ReceivedStatus_LISTENED {
                    
                    if myCell.model.messageId > (shareAVManager.model?.messageId)! {
                        myCell.play()
                        return
                    }
                }
                
            }
        }else{
            
            self.conversationMessageCollectionView.reloadData()
            
        }
        
        
        // 当把当前屏幕显示的所有未播放的播放完   要到数据源里去找未播放的语音
        for i in 0..<self.conversationDataRepository.count {
            let model:RCMessageModel = self.conversationDataRepository[i] as! RCMessageModel
            
            guard model.messageDirection == .MessageDirection_RECEIVE else {
                continue
            }
            
            
            if model.objectName == "RC:VcMsg" && model.receivedStatus != RCReceivedStatus.ReceivedStatus_LISTENED {
                
                if model.messageId > (shareAVManager.model?.messageId)! {
                    
                    shareAVManager.playAudioWithModel(progress: 0, mModel: model, compete: {[weak self] (finish) in
                        if finish == true{
                            self?.avfinish()
                        }
                        
                        
                        }, action: {
                            
                    })
                    
                    
                    return
                }
                else{
                    continue
                }
                
                
                
            }
            
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    /// 点击头像 响应事件
    ///
    /// - Parameter userId: <#userId description#>
    override func didTapCellPortrait(_ userId: String!) {
        
        if !userId.contains("system") {
            let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"im_userid == %@ AND groupid == %@", userId,self.targetId)).firstObject() as! GroupUserModel?
            PublicPush().pushToUserInfo(imId: (groupUserModel?.userid)!, userId: "", vc: self)
        }
        
        DLog("点击了用户头像--用户id--"+userId)
        
        let str = "{\"action\":\"goto\",\"data\":{\"data\":"+userId.substring(to: (userId.range(of: "-")?.lowerBound)!)+",\"subAction\":\"personDetail\"}}"
        //        let notice = NSNotification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
        let notice = Notification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
        NotificationCenter.default.post(notice)
        
    }
    
    
    //MARK: - ----------------------更多底部按钮----------------------
    lazy var moreBottomView: MoreSelectBottomView = {
        var moreBottomView = MoreSelectBottomView.init(frame: CGRect.init(x: 0, y: kScreenH - 50, width: kScreenW, height: 50))
        return moreBottomView
    }()
    
    //MARK: - ----------------------更多选择时遮盖导航栏----------------------
    lazy var coverNavBar: UINavigationBar = {
        var coverNavBar = UINavigationBar.init(frame: (self.navigationController?.navigationBar.bounds)!)
        let cancleBtn = UIButton.init()
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(UIColor.white, for: .normal)
        cancleBtn.sizeToFit()
        cancleBtn.addTarget(self, action: #selector(cancleMoreAction(_:)), for: .touchUpInside)
        coverNavBar.addSubview(cancleBtn)
        let titleLabel = UILabel.init()
        titleLabel.text = self.gModel?.group_name
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        coverNavBar.addSubview(titleLabel)
        cancleBtn.mas_makeConstraints({ (make) in
            make!.left.equalTo()(20)
            make!.centerY.equalTo()(coverNavBar)
        })
        titleLabel.mas_makeConstraints({ (make) in
            make!.width.equalTo()(SCREEN_WIDTH - 2 * (cancleBtn.frame.size.width + 30))
            make!.center.equalTo()(coverNavBar)
        })
        return coverNavBar
    }()
    
    
    
    //MARK: - ---------------------刷新用户信息 做头像  名称的刷新----------------------
    func  refreshUserInfoOrGroupInfo(){
        
        
        if self.conversationType == .ConversationType_GROUP{
            let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0'", argumentArray: [self.targetId])
            let groupUser =  GroupUserModel.objects(with: predicate)
            for i in 0..<groupUser.count {
                let gModel:GroupUserModel = groupUser.object(at: i) as! GroupUserModel
                let userModelTemp : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", gModel.userid)).firstObject() as! UserModelTcp?

                let userModel = RCUserInfo.init()
                userModel.userId = gModel.im_userid
                userModel.name = userModelTemp?.realname

                if userModelTemp?.avater  == nil || userModelTemp?.avater == "" {
                    userModel.portraitUri = defaultHeaderImageURL
                }
                else
                {

                    userModel.portraitUri = userModelTemp?.avater

                }

                RCIM.shared().refreshUserInfoCache(userModel, withUserId: userModel.userId)
            }
            
            
        }
        
    }
    
    /// 给发消息加推送
    ///
    /// - Parameters:
    ///   - messageContent: 消息内容
    ///   - pushContent: 消息推送内容
    override func sendMessage(_ messageContent: RCMessageContent!, pushContent: String!) {
        super.sendMessage(messageContent, pushContent: PublicDataSingle.makePushContent(messageContent, groupId: self.targetId))
    }
    
    //MARK: - ---------------------消息将要发送----------------------
    override func willSendMessage(_ messageContent: RCMessageContent!) -> RCMessageContent! {
        
        if messageContent.isMember(of: RCTextMessage.self){
            
            // atArray 中存放的是要@的对象
            if (self.atArray?.count != 0){
                
                let array:NSArray = NSArray.init(array: self.atArray!)
                messageContent.mentionedInfo = RCMentionedInfo.init(mentionedType:.mentioned_Users, userIdList: array.value(forKeyPath: "im_userid") as! [Any]!, mentionedContent:nil)
                self.atArray?.removeAll()
                return messageContent
            }
            else {
                //@全体
                let textMsg:RCTextMessage = messageContent as! RCTextMessage
                if textMsg.content.contains("@全体")  {
                    messageContent.mentionedInfo = RCMentionedInfo.init(mentionedType:.mentioned_All, userIdList: nil, mentionedContent:nil)
                    return messageContent
                }
                
                return super.willSendMessage(messageContent)
                
            }
            
            
        }
        return super.willSendMessage(messageContent)
    }
    
    
    //MARK: - ---------------------每次输入框输入的内容发生变化的回调----------------------
    override func inputTextView(_ inputTextView: UITextView!, shouldChangeTextIn range: NSRange, replacementText text: String!) {
        
        guard text != nil else {
            
            super.inputTextView(inputTextView, shouldChangeTextIn: range, replacementText: text)
            return
        }
        if text == "@"{
            
            let vc =   GroupChooseMemberVC()
            vc.groupId = targetId
            vc.backWithUserName(username: {[weak self] (user) in
                //                let imId = user.userid.appending("-0")
                self?.atArray?.append(user)
                inputTextView.text.append(user.realname)
                inputTextView.text.append(" ")
            })
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            
            //每次当有删除的时候 如果输入框中不包括数组中的数据  说明该数据就是被删除了
            if self.atArray?.count == 0 || text != ""{
                return
            }
            var inputText = inputTextView.text as NSString
            let deleteText:NSString = inputText.substring(with: NSRange.init(location: inputTextView.selectedRange.location-1, length: 1)) as NSString
            if deleteText.isEqual(to: " ") {
                
                
                inputText = inputText.substring(to: inputTextView.selectedRange.location-1) as NSString
                
                var userTempStr = String()
                var indexTemp:Int = 0
                for i in (0..<inputText.length-1).reversed(){
                    let str = inputText.substring(with:NSRange(location: i,length: 1))
                    if str == "@" {
                        
                        let start = inputTextView.text.index(inputTextView.text.startIndex, offsetBy: i)
                        let end = inputTextView.text.index(inputTextView.text.startIndex, offsetBy: inputTextView.selectedRange.location)
                        let range = Range.init(uncheckedBounds: (start,end))
                        
                        userTempStr = inputTextView.text.substring(with: range)
                        
                        indexTemp = i
                        break
                    }
                }
                
                guard !userTempStr.isEmpty else {
                    return
                }
                for i in 0..<self.atArray!.count {
                    
                    let model:GroupUserModel = (self.atArray?[i])!
                    let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", model.userid)).firstObject() as! UserModelTcp?

                    let username = String.init(format: "@%@ ", userModel?.realname != nil ? (userModel?.realname)! : "")

                    if username  == userTempStr {
                        self.atArray?.remove(at: i)
                        let startIndex = inputTextView.text.index(inputTextView.text.startIndex, offsetBy: indexTemp)
                        let endIndex = inputTextView.text.index(inputTextView.text.startIndex, offsetBy: inputTextView.selectedRange.location)

                        let t = Range(uncheckedBounds:(startIndex,endIndex))

                        inputTextView.text = inputTextView.text.replacingCharacters(in: t ,with: " ")

                        break
                    }
                }
            }
            else{
                
                for i in 0..<self.atArray!.count {
                    
                    let model:GroupUserModel = (self.atArray?[i])!
                    let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", model.userid)).firstObject() as! UserModelTcp?

                    let username = String.init(format: "@%@ ", userModel?.realname != nil ? (userModel?.realname)! : "")

                    if !inputTextView.text.contains(username) {
                        self.atArray?.remove(at: i)
                        break;
                    }
                    
                }
                
            }
            
            
        }
    }
    
    ///输入板点击加号后出来的按钮点击响应
    ///
    /// - Parameters:
    ///   - pluginBoardView: <#pluginBoardView description#>
    ///   - tag: <#tag description#>
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        if tag == 1101 || tag == 1102{ //语音/视频通话
            
            self.chatSessionInputBarControl.inputTextView.resignFirstResponder()
            let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0'", argumentArray: [self.targetId])
            let groupUsers =  GroupUserModel.objects(with: predicate)
            
            var vc : SelectMemberViewController?
            if tag == 1101{
                vc = SelectMemberViewController.init(conversationType: self.conversationType, targetId: self.targetId, mediaType: RCCallMediaType.audio, exist: [sharePublicDataSingle.publicData.im_userid], success: { [weak self](addUserIdList) in
                    
                    self?.callAudioVc = CallAudioMultiCallViewController.init(outgoingCall: (self?.conversationType)!, targetId: self?.targetId, mediaType: RCCallMediaType.audio, userIdList: addUserIdList)
                    self?.present((self?.callAudioVc)!, animated: true, completion: nil)
                })
            }
            if tag == 1102{
                vc = SelectMemberViewController.init(conversationType: self.conversationType, targetId: self.targetId, mediaType: RCCallMediaType.video, exist: [sharePublicDataSingle.publicData.im_userid], success: { [weak self](addUserIdList) in
                    
                    self?.callVideoVc = CallVideoMultiCallViewController.init(outgoingCall: (self?.conversationType)!, targetId: self?.targetId, mediaType: RCCallMediaType.video, userIdList: addUserIdList)
                    self?.present((self?.callVideoVc)!, animated: true, completion: nil)
                })
            }
            vc?.listingUserIdList = groupUsers.value(forKeyPath: "im_userid") as! [Any]
            self.present(vc!, animated: true, completion: nil)
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
        
        let vc  =  RecorderPlayerListViewController()
        vc.projectId = gModel?.project_id
        vc.click = {[weak self](dic) in
            DLog(dic)
            let voice = ProjectVoiceMessageContent.init()
            voice.projectId = (self?.gModel?.project_id)!
            voice.projectName = String.noNilStr(str: dic["parallelism_name"])
            voice.duration = String.noNilStr(str: dic["duration"])
            voice.url = String.noNilStr(str: dic["file"])
            voice.extra = ""
            self?.sendMessage(voice, pushContent: "")
        }
        self.navigationController?.pushViewController(vc, animated: true)
        return
        
        
        
        
    }
    
    
    // MARK: - 发送赢单
    func sendReportMessage(){
        
        self.getReportInfo(pid: (self.gModel?.project_id)!) {[weak self] (model) in
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
        
        
    }
    
    // MARK: - 发送图文消息
    func sendRichMessage(){
        let rich = RCRichContentMessage.init(title: "图文消息", digest: "哈哈", imageURL: "", url: "www.baidu.com", extra: "")
        self.sendMessage(rich, pushContent: "")
    }
    
    
    
    
    
    
    //MARK: - ---------------------自定义 @某个对象的时候   必须重写融云的该方法 融云的知识库里的说明----------------------
    override func showChooseUserViewController(_ selectedBlock: ((RCUserInfo?) -> Void)!, cancel cancelBlock: (() -> Void)!) {
        
    }
    
    
    
    
    //语音消息开始录音
    override func onBeginRecordEvent() {
        //应该把正在播放的语音关闭
        shareAVManager.stopPlay()
        self.scrollToBottom(animated: true)
        super.onBeginRecordEvent()
        
    }
    
    
    
    func scrollToIndexWithMessageId(model:ChatContentModel){
        
        isSearchBack = true
        //读取我们查到界面的前一条及后面所有条数（暂定1000条，超过就显示不全了）
        let newDataArr = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_GROUP, targetId: self.targetId, sentTime: model.time!, beforeCount: 1, afterCount: 1000)
        //移除原有截面数据，然后把查到的数据插入到当前界面数据列表中
        self.conversationDataRepository.removeAllObjects()
        for nemodel in newDataArr! {
            self.conversationDataRepository.insert(RCMessageModel.init(message: nemodel as! RCMessage), at: 0)
        }
        //刷新界面数据显示
        self.conversationMessageCollectionView.reloadData()
        //定位到最顶端（显示我们查到的数据）
        self.conversationMessageCollectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        
    }
    
    
    
    //处理播放的时候电话来了   TODO 需要整理
    func callPhoneNoti(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(callPhone(notification: )), name: NSNotification.Name(rawValue: "AVAudioSessionInterruptionNotification"), object:nil)
        
    }
    
    @objc func callPhone(notification:Notification){
        
        
        let type:NSNumber = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as! NSNumber
        
        
        if type == 1 {
            
            shareAVManager.finishBlock?(false)
            shareAVManager.saveProgress(time: 1)
            shareAVManager.player?.stop()
            
            shareAVManager.timerStop()
        }
    }
    
    
    
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
}



//MARK: - ---------------------语音cell的代理----------------------
extension ThemeChatVC:MyVoiceViewCellDelegate{
    
    
    func addAlertView(title:String, message:String, actionTitles:Array<String>,okAction: ((UIAlertAction) -> Void)?, cancleAction: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for (index,actionTitle) in actionTitles.enumerated() {
            if index == 0 {
                alertController.addAction(UIAlertAction.init(title: actionTitle, style: .default, handler: { (action) in
                    okAction!(action)
                }))
            }
            if index > 0 && index == actionTitles.count - 1 {
                alertController.addAction(UIAlertAction.init(title: actionTitle, style: .cancel, handler: { (action) in
                    cancleAction!(action)
                }))
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clickPlayAbortive(model: RCMessageModel) {
        
        
        
        guard model.targetId == self.targetId else {
            //必须保证 当前播放的语音消息 是属于当前聊天场景（后续可能会添加 话题等，由于系统设计tabbarcontroller 会出现同时有多个聊天场景共存的现象）  否则没有必要去做接下来的处理
            return
        }
        
        
        //需要将播放完成语音消息  接收状态改变
        let i = self.conversationDataRepository.index(of: model)
        model.receivedStatus = .ReceivedStatus_LISTENED
        
        //在滑动的时候 可能会出现越界 因此要加一个判断
        if self.conversationDataRepository.count>=i
        {
            self.conversationDataRepository.replaceObject(at: i, with: model)
        }
        
    }
    
    
    func clickPlay(cell:MyVoiceCell,model:RCMessageModel,progress:Double){
        
        if  shareAVManager.isPlaying() {
            
            if model.messageId == shareAVManager.model?.messageId {
                shareAVManager.oncePlay()
                
            }else{
                shareAVManager.stopPlay()
            }
            
            
        }
        
        
        shareAVManager.playAudioWithModel(progress:progress,mModel:model, compete: {[weak cell,weak self] (finish) in
            
            if let myCell = cell{
                if finish == true {
                    
                    
                    myCell.cellStatus(status: .finish)
                    self?.avfinish()
                }
                else{
                    myCell.cellStatus(status: .pause)
                }
            }
            
            
        }) {[weak cell]  in
            
            if (cell != nil)
            {
                DispatchQueue.main.async {
                    cell?.timeChange()
                }
                
                
            }
            else{
                
            }
        }
        
    }
    
    
    
    
    func creatPointButton() {
        self.pointButton = UIButton.init(type: .custom)
        //self.pointButton?.setTitle("按钮", for: .normal)
        self.pointButton?.frame = CGRect(x: kScreenW-70, y: kScreenH-150, width: 60, height: 60)
        self.pointButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //self.pointButton?.backgroundColor = UIColor.orange
        self.pointButton?.layer.cornerRadius = 30
        self.pointButton?.layer.masksToBounds = true
        self.pointButton?.setImage(UIImage.init(imageLiteralResourceName: "QFxufuaniu"), for: .normal)
        self.pointButton?.addTarget(self, action: #selector(gotoProjectVC), for: .touchUpInside)
        self.view.addSubview(self.pointButton!)
        
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(changePostion(pan:)))
        self.pointButton?.addGestureRecognizer(pan)
    }
    @objc func gotoProjectVC(){
        PublicPush().pushToProjectVC(id: self.projectId)
    }
    
    @objc func changePostion(pan:UIPanGestureRecognizer) {
        let point:CGPoint = pan.translation(in: self.pointButton!)
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let originalFrame = self.pointButton?.frame
        var newFrame = originalFrame
        
        if ((originalFrame?.origin.x)! >= CGFloat(0) && (originalFrame?.origin.x)!+(originalFrame?.size.width)! <= width) {
            
            newFrame?.origin.x = (originalFrame?.origin.x)!+point.x
            
            
        }
        if ((originalFrame?.origin.y)! >= CGFloat(0) && (originalFrame?.origin.y)!+(originalFrame?.size.height)! <= height) {
            
            newFrame?.origin.y = point.y + (originalFrame?.origin.y)!
            
        }
        
        self.pointButton?.frame = newFrame!
        
        pan.setTranslation(CGPoint.zero, in: self.pointButton!)
        
        if (pan.state == UIGestureRecognizerState.began) {
            
            self.pointButton?.isEnabled = false
            
        }else if (pan.state == UIGestureRecognizerState.changed){
            
        } else {
            
            let frame = self.pointButton?.frame
            var nFrame = frame
            //是否越界
            
            var isOver = false
            
            if ((frame?.origin.x)! < CGFloat(0)) {
                
                nFrame?.origin.x = 0;
                
                isOver = true
                
            } else if ((frame?.origin.x)!+(frame?.size.width)! > width) {
                
                nFrame?.origin.x = width - (frame?.size.width)!
                
                isOver = true
                
            }
            if ((frame?.origin.y)! < CGFloat(64)) {
                
                nFrame?.origin.y = 64;
                
                isOver = true
                
            } else if ((frame?.origin.y)!+(frame?.size.height)! > height) {
                
                nFrame?.origin.y = height - (frame?.size.height)!
                
                isOver = true
                
            }
            if (isOver) {
                self.pointButton?.frame = nFrame!
            }
            
            self.pointButton?.isEnabled = true
            
        }
    }
}


