//
//  ThemeRetweetVC.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/6/23.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class ThemeRetweetVC: BaseViewController {

    var thisGroupId = ""
    var thisThemeId:String = ""{
        didSet{
            self.getGroupId(themeId: thisThemeId)
        }
    }
    let nMessage = ThemeMessageContent()
    
    var titleFileList = Array<Dictionary<String, Any>>.init()
    
    func getGroupId(themeId:String) {
//        self.progressShow()
        GroupRequest.getGroupSubjectInfo(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":themeId], hadToast: true, fail: { [weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismissWith(str: "获取话题信息失败")
            }
            
            }, success: { [weak self](dic) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    strongSelf.thisGroupId = dic["parentid"] as! String
                    strongSelf.nMessage.content = dic["group_name"] as! String
                    strongSelf.nMessage.extra = ""
                    strongSelf.nMessage.imageURL = ""
                    strongSelf.nMessage.thumbnailUrl = ""
                    strongSelf.nMessage.url = ""
                    strongSelf.nMessage.groupId = dic["parentid"] as! String
                    strongSelf.nMessage.themeId = dic["groupid"] as! String
                    self?.titleFileList = dic["titleFileList"] as! Array<Dictionary<String, Any>>
                }
        })
    }
    
    var localGroupContainAll :Bool = true //默认选择本群
    var otherGroupCount : Int = 0
    var localGroupContainNone :Bool = false //本群不包含内容
    var localGroupContainSome :Bool = false //本群包含部分内容
    var otherGroupContainNone :Bool = false //其他群不包含内容
    var otherGroupContain :Bool = false
    var otherGroupContainAll :Bool = false //其他群包含所有内容
    var otherGroupContainSome :Bool = false //其他群包含部分内容
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "转推"
        self.setRightBtnWithArray(items: ["确定"])
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rightBtnClick(button: UIButton) {
        
        if !localGroupContainAll && !otherGroupContainNone && !otherGroupContainAll && !otherGroupContainSome {
            self.view.makeToast("请选择转推类型", duration: 1.0, position: self.view.center)
            return
        }
        if self.thisGroupId == ""{
            self.progressShow()
            GroupRequest.getGroupSubjectInfo(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":self.thisThemeId], hadToast: true, fail: { [weak self](error) in
                if let strongSelf = self {
                    strongSelf.progressDismissWith(str: "获取话题信息失败")
                }
                }, success: { [weak self](dic) in
                    if let strongSelf = self {
                        if strongSelf.otherGroupCount > 0{
                            strongSelf.progressDismiss()
                        }
                        strongSelf.thisGroupId = dic["parentid"] as! String
                        strongSelf.nMessage.content = dic["group_name"] as! String
                        strongSelf.nMessage.extra = ""
                        strongSelf.nMessage.imageURL = ""
                        strongSelf.nMessage.thumbnailUrl = ""
                        strongSelf.nMessage.url = ""
                        strongSelf.nMessage.groupId = dic["parentid"] as! String
                        strongSelf.nMessage.themeId = dic["groupid"] as! String
                        self?.titleFileList = dic["titleFileList"] as! Array<Dictionary<String, Any>>
                        strongSelf.rightBtnClick(button: button)
                    }
            })
            return
        }
        if localGroupContainAll { //本群包含所有内容
            var tempMesArr : Array<Any>? = []
            let sendTime : Int64? = Int64(Date().timeIntervalSince1970) * 1000
            let hisMesArr = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_GROUP, targetId: self.thisThemeId, sentTime: sendTime!, beforeCount: 100, afterCount: 0)
            if (hisMesArr?.count)! > 0 {
                for i in 0..<(hisMesArr?.count)! {
                    //                    RCMessageModel.init(message: nemodel as! RCMessage)
                    if (tempMesArr?.count)! == 2 {
                        break
                    }
                    if (hisMesArr?[i] as! RCMessage).objectName == RCTextMessageTypeIdentifier {
                        tempMesArr?.append(hisMesArr?[i])
                    }else{
                    
                    }
                }
            }
            for i in 0..<(tempMesArr?.count)! {
                let groupUserModel = GroupUserModel.objects(with: NSPredicate.init(format:"im_userid == %@", (tempMesArr?[i] as! RCMessage).senderUserId)).firstObject() as? GroupUserModel
                let userModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", groupUserModel?.userid != nil ? (groupUserModel?.userid)! : "")).firstObject() as! UserModelTcp?

                if i == 0 {
                    nMessage.extra = (userModel?.realname.appendingFormat(":%@", ((tempMesArr?[i] as! RCMessage).content as! RCTextMessage).conversationDigest()))!
                }else{
                    nMessage.extra = nMessage.extra.appendingFormat("\n%@:%@", userModel?.realname != nil ? (userModel?.realname)! : "",((tempMesArr?[i] as! RCMessage).content as! RCTextMessage).conversationDigest())
                }
            }
            for i in 0..<(self.navigationController?.childViewControllers.count)!{
                if self.navigationController?.childViewControllers[i] is TMTabbarController{
                    
                    let Tab:TMTabbarController = self.navigationController?.childViewControllers[i] as! TMTabbarController
                    let smak:SmallTalkVC = Tab.viewControllers?.first as! SmallTalkVC
                    smak.isRunApi = false
                    smak.sendMessage(nMessage, pushContent: PublicDataSingle.makePushContent(nMessage, groupId: smak.targetId))
                    self.navigationController?.view.makeToast("转推成功", duration: 1.0, position: self.navigationController?.view.center)
                    self.navigationController?.popViewController(animated: true)
                    break
                }
            }
           

        }
        if otherGroupCount > 0{ //其他群
            switch true {
            case otherGroupContainNone:
                let aaa = SelectMyGroup()
                aaa.targetId = self.thisGroupId  //当前所在群组的groupid
                aaa.message = self.nMessage
                aaa.iszhuanfa = false
                aaa.finishSelect = {
                    sGroupList,otherText in
                    let failArr : Array<GroupModel> = []
//                    self.progressShow()
                    self.navigationController?.view.makeToastActivity(self.navigationController?.view.center)

                    self.creatTheme(from:0,sGroupList: sGroupList as? Array<GroupModel>,failArr:failArr, otherText: otherText, bbb: nil)

                   
                }
                self.navigationController?.pushViewController(aaa, animated: true)
                break
            case otherGroupContainAll:
                let aaa = SelectMyGroup()
                aaa.targetId = self.thisGroupId  //当前所在群组的groupid
                aaa.message = self.nMessage
                aaa.iszhuanfa = false
                aaa.finishSelect = {
                    sGroupList,otherText in
                    DispatchQueue.main.async {
                        
//                        self.progressShow()
                         self.navigationController?.view.makeToastActivity(self.navigationController?.view.center)
                        GroupRequest.forwardGroupSubject(params: ["app_token":sharePublicDataSingle.token,"groupid":self.thisThemeId,"msg_uid_str":"","is_all":true], hadToast: true, fail: { [weak self](errorDic) in
                            if let strongSelf = self{
                                strongSelf.progressDismiss()
                                strongSelf.navigationController?.view.hideToastActivity()
                                DLog(errorDic)
                            }
                            }, success: { [weak self](succDic) in
                                if let strongSelf = self{
                                    let bbb = HistoryMessageContent.init()
                                    bbb.title = succDic["title"] as! String
                                    bbb.content = succDic["content"] as! String
                                    bbb.url = succDic["forwardUrl"] as! String
                                    DispatchQueue.main.async {
                                    
                                    let failArr : Array<GroupModel> = []
                                    strongSelf.creatTheme(from:0,sGroupList: sGroupList as? Array<GroupModel>,failArr:failArr, otherText: otherText, bbb: bbb)
                                    }
                                }
                                
                        })
                    }
//                     self.creatTheme(sGroupList: sGroupList as? Array<GroupModel>, otherText: otherText, bbb: nil)
                }
                self.navigationController?.pushViewController(aaa, animated: true)
                break
            case otherGroupContainSome:
                
                let talk = ThemeChatVC(conversationType: RCConversationType.ConversationType_GROUP, targetId: self.thisThemeId)
                talk?.isZhuantui = true
                self.navigationController?.pushViewController(talk!, animated: true)
                talk?.finishSelect = { (chooseList) in
                    
                    let aaa = SelectMyGroup()
                    aaa.targetId = self.thisGroupId  //当前所在群组的groupid
                    aaa.message = self.nMessage
                    aaa.iszhuanfa = false
                    aaa.finishSelect = {
                        sGroupList,otherText in
                        
                        var msg_uid_str: String? = ""
                        if chooseList.count > 0 {
                            msg_uid_str = (chooseList as NSArray).componentsJoined(by: ",")
                        }
//                        self.progressShow()
                        self.navigationController?.view.makeToastActivity(self.navigationController?.view.center)

                        GroupRequest.forwardGroupSubject(params: ["app_token":sharePublicDataSingle.token,"groupid":self.thisThemeId,"msg_uid_str":msg_uid_str!,"is_all":false], hadToast: true, fail: { [weak self](errorDic) in
                            if let strongSelf = self{
                                strongSelf.progressDismiss()
                                strongSelf.navigationController?.view.hideToastActivity()

                                DLog(errorDic)
                            }

                        }, success: { [weak self](succDic) in
                            if let strongSelf = self{
                                
                                let bbb = HistoryMessageContent.init()
                                bbb.title = succDic["title"] as! String
                                bbb.content = succDic["content"] as! String
                                bbb.url = succDic["forwardUrl"] as! String
                                let failArr : Array<GroupModel> = []
                                strongSelf.creatTheme(from:0,sGroupList: sGroupList as? Array<GroupModel>,failArr:failArr, otherText: otherText, bbb: bbb)
                                
                            }
                        })
                    }
                    self.navigationController?.pushViewController(aaa, animated: true)
                    
                }
                
                break
            default:
                break
            }

        }
    }
    func creatTheme(from:Int,sGroupList: Array<GroupModel>?,failArr: Array<GroupModel>,otherText:String?,bbb:HistoryMessageContent?){
        var failArrTemp = failArr
        if sGroupList?.count == from{
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            var time:String? = UserDefaults.standard.object(forKey: username) as! String?
            DLog(failArr)
            if time == nil{
                time = "0"
            }
            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    strongSelf.navigationController?.view.makeToast("转推失败", duration: 1.0, position: strongSelf.navigationController?.view.center)
                }
                }, success: {[weak self] (dic) in
                    if let strongSelf = self {
                        DispatchQueue.main.async {
                            strongSelf.progressDismiss()
                            strongSelf.navigationController?.view.hideToastActivity()

                            if (failArr.count) > 0{
                                let alert = UIAlertController(title: "温馨提示", message: "群组:".appending(((failArr as! NSArray).value(forKeyPath: "group_name") as! NSArray).componentsJoined(by: "\n")).appending("此话题已存在，您可直接参与讨论。"), preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "我知道了", style: .default, handler: { action in
                                    var reweetVc : ThemeRetweetVC? = nil
                                    for vc in (strongSelf.navigationController?.childViewControllers)!{
                                        if vc is ThemeRetweetVC {
                                            reweetVc = vc as? ThemeRetweetVC
                                        }
                                    }
                                    strongSelf.navigationController?.popToViewController(reweetVc!, animated: false)
                                    reweetVc?.navigationController?.popViewController(animated: true)
                                    
                                })
                                alert.addAction(okAction)
                                strongSelf.present(alert, animated: true, completion: nil)
                            }else{
                                strongSelf.navigationController?.view.makeToast("转推成功", duration: 1.0, position: strongSelf.navigationController?.view.center)
                                var reweetVc : ThemeRetweetVC? = nil
                                for vc in (strongSelf.navigationController?.childViewControllers)!{
                                    if vc is ThemeRetweetVC {
                                        reweetVc = vc as? ThemeRetweetVC
                                    }
                                }
                                strongSelf.navigationController?.popToViewController(reweetVc!, animated: false)
                                reweetVc?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            )

            return
        }
        
        let gModel = sGroupList?[from]
        
        DispatchQueue.main.async {
            var params : Dictionary<String, Any> = [:]
            params = ["app_token":sharePublicDataSingle.token,"groupid":gModel?.groupid,"title":self.nMessage.content,"file_json":SignTool.makeJsonStrWith(object: self.titleFileList)]
            GroupRequest.createGroupSubject(params: params, hadToast: false, fail: { [weak self] (fail) in
                if let strongSelf = self {
                    failArrTemp.append(gModel!)
                    strongSelf.creatTheme(from:from+1,sGroupList: sGroupList,failArr:failArrTemp, otherText: otherText, bbb: bbb != nil ? bbb! : nil)
                    
                }
            }) { [weak self](success) in
                print("创建话题成功",success)
                if let strongSelf = self {
                    let themeid : String? = String.changeToString(inValue: success["subGroupId"])
                    let newMess = strongSelf.nMessage
                    newMess.groupId = (gModel?.groupid)!
                    newMess.themeId = String.changeToString(inValue: success["subGroupId"])
                    strongSelf.sendMessageToOtherGroup(themeid: themeid!, gModel: gModel, otherText: otherText != "" ? otherText! : "", newMess: newMess, bbb:bbb != nil ? bbb! : nil)
                    
                    strongSelf.creatTheme(from:from+1,sGroupList: sGroupList,failArr:failArrTemp, otherText: otherText, bbb: bbb != nil ? bbb! : nil)
                    
                }
                
            }
        
        }

    }

    func creatTheme(sGroupList: Array<GroupModel>?,otherText:String?,bbb:HistoryMessageContent?){
        var num : Int? = 0
        var failArr : Array<GroupModel>? = []
//        self.progressShow()
        for sGroupOne in sGroupList! {
            let gModel = sGroupOne 
            var params : Dictionary<String, Any> = [:]
            params = ["app_token":sharePublicDataSingle.token,"groupid":gModel.groupid,"title":self.nMessage.content,"file_json":SignTool.makeJsonStrWith(object: self.titleFileList)]
            GroupRequest.createGroupSubject(params: params, hadToast: false, fail: { [weak self] (fail) in
                if let strongSelf = self {
                    num = num! + 1
                    failArr?.append(gModel)
                    if num == (sGroupList?.count)!{
                        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                        var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                        DLog(failArr!)
                        if time == nil{
                            time = "0"
                        }
                        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                            if let strongSelf = self {
                                strongSelf.progressDismiss()
                                strongSelf.navigationController?.view.makeToast("转推失败", duration: 1.0, position: strongSelf.navigationController?.view.center)
                            }
                            }, success: {[weak self] (dic) in
                                if let strongSelf = self {
                                    DispatchQueue.main.async {
                                        strongSelf.progressDismiss()
                                        if (failArr?.count)! > 0{
                                            let alert = UIAlertController(title: "温馨提示", message: "群组:".appending(((failArr as! NSArray).value(forKeyPath: "group_name") as! NSArray).componentsJoined(by: "\n")).appending("此话题已存在，您可直接参与讨论。"), preferredStyle: .alert)
                                            let okAction = UIAlertAction(title: "我知道了", style: .default, handler: { action in
                                                var reweetVc : ThemeRetweetVC? = nil
                                                for vc in (strongSelf.navigationController?.childViewControllers)!{
                                                    if vc is ThemeRetweetVC {
                                                        reweetVc = vc as? ThemeRetweetVC
                                                    }
                                                }
                                                strongSelf.navigationController?.popToViewController(reweetVc!, animated: false)
                                                reweetVc?.navigationController?.popViewController(animated: true)
                                                
                                            })
                                            alert.addAction(okAction)
                                            strongSelf.present(alert, animated: true, completion: nil)
                                        }else{
                                        strongSelf.navigationController?.view.makeToast("转推成功", duration: 1.0, position: strongSelf.navigationController?.view.center)
                                            var reweetVc : ThemeRetweetVC? = nil
                                            for vc in (strongSelf.navigationController?.childViewControllers)!{
                                                if vc is ThemeRetweetVC {
                                                    reweetVc = vc as? ThemeRetweetVC
                                                }
                                            }
                                            strongSelf.navigationController?.popToViewController(reweetVc!, animated: false)
                                            reweetVc?.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        )

                    }

                }
            }) { [weak self](success) in
                print("创建话题成功",success)
                num = num! + 1
                if let strongSelf = self {
                    let themeid : String? = String.changeToString(inValue: success["subGroupId"])
                    let newMess = strongSelf.nMessage
                    newMess.groupId = gModel.groupid
                    newMess.themeId = String.changeToString(inValue: success["subGroupId"])
                    strongSelf.sendMessageToOtherGroup(themeid: themeid!, gModel: gModel, otherText: otherText != "" ? otherText! : "", newMess: newMess, bbb:bbb != nil ? bbb! : nil)
                    
                    if num == (sGroupList?.count)!{
                    
                        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                        var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                        
                        if time == nil{
                            time = "0"
                        }
                        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                            if let strongSelf = self {
                                DispatchQueue.main.async {
                                    strongSelf.progressDismiss()
                                    strongSelf.navigationController?.view.makeToast("转推失败", duration: 1.0, position: strongSelf.navigationController?.view.center)
                                }

                            }
                            }, success: {[weak self] (dic) in
                                if let strongSelf = self {
                                   
                                    DispatchQueue.main.async {
                                        strongSelf.progressDismiss()
                                        strongSelf.navigationController?.view.makeToast("转推成功", duration: 1.0, position: strongSelf.navigationController?.view.center)
                                        var reweetVc : ThemeRetweetVC? = nil
                                        for vc in (strongSelf.navigationController?.childViewControllers)!{
                                            if vc is ThemeRetweetVC {
                                                reweetVc = vc as? ThemeRetweetVC
                                            }
                                        }
                                        strongSelf.navigationController?.popToViewController(reweetVc!, animated: false)
                                        reweetVc?.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        )

                    }
                }
                
            }

        }
        

    }
    func sendMessageToOtherGroup(themeid: String?,gModel: GroupModel?,otherText:String?,newMess:ThemeMessageContent?,bbb:HistoryMessageContent?) {
//        let themeid : String? = String.changeToString(inValue: success["subGroupId"])
//        let newMess = strongSelf.nMessage
//        newMess.groupId = gModel.groupid
//        newMess.themeId = String.changeToString(inValue: success["subGroupId"])
        
        RCIMClient.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel?.groupid, content: newMess, pushContent: PublicDataSingle.makePushContent(newMess, groupId: gModel!.groupid), pushData: PublicDataSingle.makePushContent(newMess, groupId: (gModel?.groupid)!), success: { (Int) in
            
            if otherText != "" {
                DispatchQueue.main.async {
                    
                    RCIMClient.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: gModel?.groupid, content: RCTextMessage.init(content: otherText), pushContent: otherText, pushData: otherText, success: { (Int) in
                        
                    }, error: { (RCErrorCode, Int) in
                    })
                }
            }
        }, error: { (RCErrorCode, Int) in
        })
        if bbb != nil {
            RCIMClient.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: themeid, content: bbb, pushContent: PublicDataSingle.makePushContent(bbb, groupId: themeid!), pushData: PublicDataSingle.makePushContent(bbb, groupId: themeid!), success: { (Int) in
            }, error: { (RCErrorCode, Int) in
            })
        }
    }
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT))
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = UIView.init()
        return tableView
    }()
    
    
}
//MARK: - ---------------------TableDelegate AND DataSource----------------------
extension ThemeRetweetVC:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else{
            return otherGroupCount
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView : ThemeRetweetView? = ThemeRetweetView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        sectionView?.delegate = self
        if section == 0 {
            sectionView?.iconButton.isSelected = self.localGroupContainAll
            sectionView?.iconButton.tag = 10
            sectionView?.iconButton.setTitle("本群", for: .normal)
        }else{
            sectionView?.iconButton.isSelected = (self.otherGroupCount > 0)
            sectionView?.iconButton.tag = 11
            sectionView?.iconButton.setTitle("其他群", for: .normal)
        }
        return sectionView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 88))
            view.backgroundColor = UIColor.white
            let sectionView1 : ThemeRetweetView? = ThemeRetweetView.init(frame: CGRect.init(x: 60, y: 0, width: SCREEN_WIDTH - 60, height: 44))
            sectionView1?.delegate = self
            sectionView1?.iconButton.isSelected = self.otherGroupContainAll
            sectionView1?.iconButton.tag = 1110
            sectionView1?.iconButton.setTitle("全部内容", for: .normal)
            view.addSubview(sectionView1!)
            let sectionView2 : ThemeRetweetView? = ThemeRetweetView.init(frame: CGRect.init(x: 60, y: 44, width: SCREEN_WIDTH - 60, height: 44))
            sectionView2?.delegate = self
            sectionView2?.iconButton.isSelected = self.otherGroupContainSome
            sectionView2?.iconButton.tag = 1111
            sectionView2?.iconButton.setTitle("部分内容", for: .normal)
            view.addSubview(sectionView2!)
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            if self.otherGroupContain {
                return 88
            }else{
                return 0
            }
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell? = UITableViewCell.init(style: .default, reuseIdentifier: "ThemeRetweetCell")
        cell?.selectionStyle = .none
        let sectionView : ThemeRetweetView? = ThemeRetweetView.init(frame: CGRect.init(x: 30, y: 0, width: SCREEN_WIDTH - 30, height: 44))
        sectionView?.delegate = self
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                sectionView?.iconButton.isSelected = self.localGroupContainNone
                sectionView?.iconButton.tag = 100
                sectionView?.iconButton.setTitle("不包括讨论内容", for: .normal)
            }else{
                sectionView?.iconButton.isSelected = self.localGroupContainSome
                sectionView?.iconButton.tag = 101
                sectionView?.iconButton.setTitle("包括部分讨论内容", for: .normal)
            }
        }else{
            if indexPath.row == 0 {
                sectionView?.iconButton.isSelected = self.otherGroupContainNone
                sectionView?.iconButton.tag = 110
                sectionView?.iconButton.setTitle("不包括讨论内容", for: .normal)
            }else{
                sectionView?.iconButton.isSelected = self.otherGroupContain
                sectionView?.iconButton.tag = 111
                sectionView?.iconButton.setTitle("包括讨论内容", for: .normal)
            }
        }

        cell?.addSubview(sectionView!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension ThemeRetweetVC : ThemeRetweetViewDelegate{
    func selectButtonDidClick(btn: UIButton) {
        if btn.isSelected {
            return
        }
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.localGroupContainNone = false
            self.localGroupContainSome = false
            self.otherGroupContainNone = false
            self.otherGroupContain = false
            self.otherGroupContainAll = false
            self.otherGroupContainSome = false
            if btn.tag == 10 {
                self.localGroupContainAll = true
                self.otherGroupCount = 0
            }
            if btn.tag == 11 {
                self.localGroupContainAll = false
                self.otherGroupCount = 2
                self.otherGroupContainNone = true
            }
            if btn.tag == 100 {
                self.localGroupContainNone = true
            }
            if btn.tag == 101 {
                self.localGroupContainSome = true
            }
            if btn.tag == 110 {
                self.otherGroupContainNone = true
            }
            if btn.tag == 111 {
                self.otherGroupContain = true
                self.otherGroupContainAll = true
            }
            if btn.tag == 1110 {
                self.otherGroupContain = true
                self.otherGroupContainAll = true
            }
            if btn.tag == 1111 {
                self.otherGroupContain = true
                self.otherGroupContainSome = true
            }

        }else{
            self.localGroupContainAll = false
            self.otherGroupCount = 0
        }
        tableView.reloadData()
    }

}
