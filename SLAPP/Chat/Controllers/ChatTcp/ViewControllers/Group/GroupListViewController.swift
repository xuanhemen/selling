//
//  GroupListViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/2/28.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
import MJRefresh
class GroupListViewController: RCConversationListViewController {
    
    var newTargetId : String? //新加入的群组Id,不为空时直接进入会话页面
    var fakeView = FakeTabView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.configNav()
        view.backgroundColor = UIColor.white
        self.title = "消息中心"
        
//        self.setRightBtnWithArray(items: [UIImage.init(named: "nav_add")])
        
        self.isShowNetworkIndicatorView = false
//        let rightBtn2 = UIButton.init(type: .custom)
//        rightBtn2.frame =  CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
//        rightBtn2.setImage(UIImage.init(named: "ewm`bgtop"), for: .normal)
//        rightBtn2.sizeToFit()
//        rightBtn2.addTarget(self, action: #selector(scanClick(btn:)), for: .touchUpInside)
//        let rightBarButtonItem2 = UIBarButtonItem.init(customView: rightBtn2)
//        self.navigationItem.rightBarButtonItems?.append(rightBarButtonItem2)
        self.setDisplayConversationTypes([RCConversationType.ConversationType_GROUP.rawValue])
        //        self.setCollectionConversationType([RCConversationType.ConversationType_GROUP.rawValue])
        self.showConnectingStatusOnNavigatorBar = true
        //                self.refreshConversationTableViewIfNeeded()
        self.conversationListTableView.tableFooterView = UIView.init()
        self.conversationListTableView.tag = 10086 //方便获取conversationListTableView
        self.conversationListTableView.frame = CGRect(x: self.conversationListTableView.frame.origin.x, y: NAV_HEIGHT, width: self.conversationListTableView.frame.width, height: kScreenH - NAV_HEIGHT)
        if #available(iOS 11, *) {
            self.conversationListTableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.conversationListTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(headerRefresh))
        self.emptyConversationView = UIView.init()
        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
        let getRemote:Bool? = UserDefaults.standard.object(forKey: getRemoteKey + username) as! Bool?
        if getRemote != nil && getRemote! == true{ //首次进入时同步会话
            self.progressShow()
            self.getRemoteMessage(success: {
                self.progressDismiss()
            }, error: {
                self.progressDismiss()
            })
        }
        //        self.view.addSubview(RepeatMessageView(type: "test", model: GroupModel() , message:""))
        
        RCIM.shared().connectionStatusDelegate = self as! RCIMConnectionStatusDelegate
        
//        RCIM.shared().registerMessageType(ThemeMessageContent.self)
//        RCIM.shared().registerMessageType(HistoryMessageContent.self)
////        self.addFakeTab()
        //注册自定义消息
        self.registerCustomerMessageContent()
        
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            
            self.fakeView.showBage(type: .group, bage: Int(RCIMClient.shared().getTotalUnreadCount()))
        }
    }
    
    func getRemoteMessage(success: (() -> ())!, error: (() -> ())!) {
        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
        let getRemote:Bool? = UserDefaults.standard.object(forKey: getRemoteKey + username) as! Bool?
        //切换账号时需要重新同步会话列表
        if getRemote != nil && getRemote! == true {
            let groupModels = GroupModel.objects(with: NSPredicate.init(format: "is_delete == '0' AND is_remove == '0'"))
//            if groupModels.count == 0 {
//                success()
//                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
//                UserDefaults.standard.set(false, forKey: getRemoteKey + username)
//                return
//            }
            var realArr : Array<GroupModel> = []
            for i in 0..<groupModels.count {
                let groupModel : GroupModel = groupModels[i] as! GroupModel
                let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@ AND is_delete == '0'", sharePublicDataSingle.publicData.userid,groupModel.groupid)).firstObject() as! GroupUserModel?
                if groupUserModel != nil {
                    realArr.append(groupModel)
                }
            }
            if realArr.count == 0 {
                success()
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                UserDefaults.standard.set(false, forKey: getRemoteKey + username)
                return
            }

            self.getRemoteHistoryMessages(from: 0, grouplist: realArr,successCount:0)
        }

    }
    
    func getRemoteHistoryMessages(from:Int ,grouplist:Array<GroupModel>, successCount:Int) {
        
        if from == grouplist.count { //全部获取一遍并且有成功的(不能保证全部成功)
            self.progressDismiss()
            self.conversationListTableView.mj_header.endRefreshing()
            if  successCount > 0 {//有成功的(不能保证全部成功)
                
                let arr = RCIMClient.shared().getConversationList([RCConversationType.ConversationType_GROUP.rawValue]) as NSArray
                
                for conversation in arr {
                    self.conversationListDataSource.add(RCConversationModel.init(conversation: (conversation as! RCConversation), extend: nil))
                }
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                UserDefaults.standard.set(false, forKey: getRemoteKey + username)
                
                
                self.refreshConversationTableViewIfNeeded()
            }
            return
        }
        let groupModel : GroupModel = grouplist[from]
        DispatchQueue.main.async {
            RCIMClient.shared().getRemoteHistoryMessages(.ConversationType_GROUP, targetId: groupModel.groupid, recordTime: 0, count: 5, success: { [weak self](array) in
                
                if let strongSelf = self {
                    strongSelf.getRemoteHistoryMessages(from: from + 1, grouplist: grouplist,successCount:successCount + 1)
                }
                }, error: { [weak self](errorCode) in
                    if let strongSelf = self {
                        
                        strongSelf.getRemoteHistoryMessages(from: from + 1, grouplist: grouplist,successCount:successCount)
                    }
            })
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func rightBtnClick(button: UIButton) {
        
        UIApplication.shared.keyWindow?.addSubview(comboboxView!)
        
    }
    @objc func emptyBtnClick(button: UIButton) {
        self.progressShow()
        GroupRequest.joinPublicGroup(params: ["app_token":sharePublicDataSingle.token], hadToast: true, fail: { [weak self](error) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
            }
            
        }, success: { (dic) in
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            let time = UserDefaults.standard.object(forKey: username) as! String
            
            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self](error) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                }

            }, success: {[weak self] (dic) in
                
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    strongSelf.refreshConversationTableViewIfNeeded()

                }
                }
            )

        })
    }
    @objc func scanClick(btn:Any) {
        let str = "{\"action\":\"goto\",\"data\":{\"data\":\"\",\"subAction\":\"scan\"}}"
        //        let notice = NSNotification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
        let notice = Notification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
        NotificationCenter.default.post(notice)
    }
    
    @objc func headerRefresh(){
        
        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
        var time:String? = (UserDefaults.standard.object(forKey: username) as! String?)
        
        if (time == nil ){
            time = "0"
        }
        
        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self] (error) in
            if let strongSelf = self {
                strongSelf.conversationListTableView.mj_header.endRefreshing()
            }
            
            }, success: {[weak self] (dic) in
                
                if let strongSelf = self {
                    let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                    let getRemote:Bool? = UserDefaults.standard.object(forKey: getRemoteKey + username) as! Bool?
                    if getRemote != nil && getRemote! == true {
                        strongSelf.getRemoteMessage(success: {
                            strongSelf.conversationListTableView.mj_header.endRefreshing()
                        }, error: {
                            strongSelf.conversationListTableView.mj_header.endRefreshing()

                        })
                    }else{
                        strongSelf.conversationListTableView.mj_header.endRefreshing()
                        strongSelf.refreshConversationTableViewIfNeeded()
                    }
                }
            }
        )
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        if conversationModelType == RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION {
            
//            let talk = SmallTalkVC(conversationType: (model?.conversationType)!, targetId: model?.targetId)
//            self.navigationController?.pushViewController(talk!, animated: true)
            let trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(model.targetId)!)).firstObject() as? GroupModel
            let tabBarVc : TMTabbarController = TMTabbarController()
            tabBarVc.groupModel = model
            tabBarVc.projectId = String.noNilStr(str: trueGroupModel!.project_id)
            self.navigationController?.pushViewController(tabBarVc, animated: true)
            
        }
    }
    
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        super.willReloadTableData(dataSource)
        var tempDelGroupModels = Array<RCConversationModel>()//应该移除的融云会话模型(永久移除)
        var tempDelSubGroupModels = Array<RCConversationModel>()//应该移除的话题会话模型(非永久移除)
        for i in 0..<dataSource.count {
            let model : RCConversationModel = dataSource[i] as! RCConversationModel
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",model.targetId)).firstObject() as! GroupModel?
            if groupModel == nil{
                tempDelGroupModels.append(model)
                continue
            }
            if groupModel?.type == "1" {
                tempDelSubGroupModels.append(model)
                continue
            }
            model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
            model.conversationTitle = groupModel?.group_name
            model.extend = groupModel?.icon_url
            model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
            model.cellBackgroundColor = UIColor.white
            
        }
        for model in tempDelGroupModels {//移除数据库中不包含的会话
            dataSource.remove(model)
            RCIMClient.shared().clearMessages(model.conversationType, targetId: model.targetId)
            RCIMClient.shared().remove(model.conversationType, targetId: model.targetId)
        }
        for model in tempDelSubGroupModels {//移除话题会话数据
            dataSource.remove(model)
        }

        if (newTargetId != nil) {
            for i in 0..<dataSource.count {
                let model : RCConversationModel = dataSource[i] as! RCConversationModel
                if newTargetId == model.targetId {
                    newTargetId = nil
                    DispatchQueue.main.async {
                        let trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(model.targetId)!)).firstObject() as? GroupModel
                        let tabBarVc : TMTabbarController = TMTabbarController()
                        tabBarVc.groupModel = model
                        tabBarVc.projectId = String.noNilStr(str: trueGroupModel!.project_id)
                        self.navigationController?.pushViewController(tabBarVc, animated: true)
//                        let talk = SmallTalkVC(conversationType: model.conversationType, targetId: model.targetId)
//                        self.navigationController?.pushViewController(talk!, animated: true)
                        
                    }
                }
                
            }
            
        }
        self.conversationListDataSource = dataSource
        DispatchQueue.main.async {
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            let getRemote:Bool? = UserDefaults.standard.object(forKey: getRemoteKey + username) as! Bool?
            if dataSource.count == 0 && getRemote != nil && getRemote! == false{
                if sharePublicDataSingle.publicData.corpid == "0" {
                    self.conversationListTableView.addSubview(self.emptyBtn)
                }else{
                   
                    self.conversationListTableView.addSubview(self.emptyImg)
                }
            }else{
                self.emptyBtn.removeFromSuperview()
                self.emptyImg.removeFromSuperview()
            }
        }

        //        self.footLabel.text = "\(dataSource.count)个群聊"
        return dataSource
    }
    lazy var emptyBtn : UIButton = {
        var  emptyBtn = UIButton.init()
        emptyBtn.setImage(UIImage.init(named: "emptyImg22"), for: .normal)
        emptyBtn.adjustsImageWhenHighlighted = false
        emptyBtn.sizeToFit()
        emptyBtn.addTarget(self, action: #selector(self.emptyBtnClick), for: .touchUpInside)
        emptyBtn.center = self.conversationListTableView.center
        return emptyBtn
    
    }()
    lazy var emptyImg : UIImageView = {
        var emptyImg = UIImageView.init(image: UIImage.init(named: "emptyImg11"))
        emptyImg.center = self.conversationListTableView.center
        return emptyImg
        
    }()
    override func rcConversationListTableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 64
    }
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        let cell = GroupListCell.cell(withTableView: tableView)
        cell.setDataModel(self.conversationListDataSource![indexPath.row] as! RCConversationModel)
        if MessageCenterModel.objects(with: NSPredicate(format: "parentId == %@", cell.model.targetId)).count != 0 {
            cell.badgeLb.isHidden = false
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let conversationModel : RCConversationModel = self.conversationListDataSource![indexPath.row] as! RCConversationModel
        let delAction = UITableViewRowAction.init(style: .destructive, title: "删除") { (action, indexPath) in
            RCIMClient.shared().remove(conversationModel.conversationType, targetId: conversationModel.targetId)
            RCIMClient.shared().clearMessages(conversationModel.conversationType, targetId: conversationModel.targetId)
            let realm:RLMRealm = RLMRealm.default()
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",conversationModel.targetId)).firstObject() as! GroupModel?
            realm.beginWriteTransaction()
            groupModel?.setValue("1", forKey: "is_remove")
            try? realm.commitWriteTransaction()

            self.refreshConversationTableViewIfNeeded()
        }
        var topAction : UITableViewRowAction?
        if conversationModel.isTop{
            topAction = UITableViewRowAction.init(style: .destructive, title: "取消置顶") { (action, indexPath) in
                RCIMClient.shared().setConversationToTop(conversationModel.conversationType, targetId: conversationModel.targetId, isTop: false)
                self.refreshConversationTableViewIfNeeded()
            }
            
        }else{
            topAction = UITableViewRowAction.init(style: .destructive, title: "置顶") { (action, indexPath) in
                RCIMClient.shared().setConversationToTop(conversationModel.conversationType, targetId: conversationModel.targetId, isTop: true)
                self.refreshConversationTableViewIfNeeded()
            }
        }
        topAction?.backgroundColor = UIColor.hexString(hexString: "c7c7c7")
        return [delAction,topAction!]
    }
    override func didReceiveMessageNotification(_ notification: Notification!) {
        DispatchQueue.main.async {
            
            self.fakeView.showBage(type: .group, bage: Int(RCIMClient.shared().getTotalUnreadCount()))
        }

        let message : RCMessage = notification.object as! RCMessage
        DLog("groupid == " + message.targetId)
        let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",message.targetId)).firstObject() as! GroupModel?
        if groupModel?.is_remove == "1" {
            let realm:RLMRealm = RLMRealm.default()
            realm.beginWriteTransaction()
            groupModel?.setValue("0", forKey: "is_remove")
            try? realm.commitWriteTransaction()
        }
        if message.objectName == RCGroupNotificationMessageIdentifier {//群组通知类消息
            
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            let time = UserDefaults.standard.object(forKey: username) as! String
            
            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self](error) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                }

            }, success: {[weak self] (dic) in
                
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    //                    let me = message.content as! RCGroupNotificationMessage
                    //                    if !(me.operatorUserId == sharePublicDataSingle.publicData.im_userid) {
                    //                        strongSelf.refreshConversationTableViewIfNeeded()
                    //                    }
                    let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",message.targetId)).firstObject() as! GroupModel?
                    if groupModel != nil {
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,(groupModel?.groupid)!)).firstObject() as! GroupUserModel?
                        if groupModel?.is_delete == "1" || groupUserModel?.is_delete == "1"{
                            RCIMClient.shared().setConversationToTop(.ConversationType_GROUP, targetId: message.targetId, isTop: false)
                        }
                    }

                    if strongSelf.navigationController?.topViewController is GroupListViewController{
                        strongSelf.refreshConversationTableViewIfNeeded()
                        
                    }
                    if strongSelf.navigationController?.topViewController is SmallTalkVC{
                        let vc : SmallTalkVC = strongSelf.navigationController?.topViewController as! SmallTalkVC

                        vc.refreshUserInfoOrGroupInfo()
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,message.targetId)).firstObject() as! GroupUserModel?
                        if groupUserModel?.is_delete == "1"{
                            vc.makeNavigationRightBtn(canClick: false)
                            
                        }else{
                            vc.makeNavigationRightBtn(canClick: true)
                            
                        }
                        
                    }
                    if strongSelf.navigationController?.topViewController is GroupSettingViewController {
                        let vc : GroupSettingViewController = strongSelf.navigationController?.topViewController as! GroupSettingViewController
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,message.targetId)).firstObject() as! GroupUserModel?
                        if groupUserModel?.is_delete == "1"{
                            vc.navigationController?.popToRootViewController(animated: true)
                        }else{
                            vc.reloadHeaderData()
                        }
                    }
                    if strongSelf.navigationController?.topViewController is GroupQRCodeViewController {
                        let vc : GroupSettingViewController = strongSelf.navigationController?.childViewControllers[(strongSelf.navigationController?.childViewControllers.count)! - 2] as! GroupSettingViewController
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,message.targetId)).firstObject() as! GroupUserModel?
                        if groupUserModel?.is_delete == "1"{
                            vc.navigationController?.popToRootViewController(animated: true)
                        }else{
                            vc.reloadHeaderData()
                        }
                    }
                }
                }
            )
        }else{
            if self.navigationController?.topViewController is GroupListViewController{
                let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",message.targetId)).firstObject() as! GroupModel?
                if groupModel != nil { //数据库中没有更新下来的会话暂时不需要显示
                    self.refreshConversationTableViewIfNeeded()
                }
                
            }
        }
    }
    
    lazy var footView: UIView = {
        var footView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        var separateLine : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.5))
        separateLine.backgroundColor = separateLine_Color
        footView.addSubview(separateLine)
        footView.addSubview(self.footLabel)
        return footView
    }()
    
    lazy var footLabel: UILabel = {
        var footLabel : UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        footLabel.font = FONT_14
        footLabel.textColor = UIColor.darkGray
        footLabel.textAlignment = .center
        return footLabel
    }()
    
    lazy var comboboxView: ComboboxView? = {
        var comboboxView = ComboboxView.init(titles: ["创建群组","查找群组"], imageNames: [["group_add","search"],["group_add","search"]], bgImgName: "combobox", frame: CGRect.init(x: MAIN_SCREEN_WIDTH - 100 - 10, y: NAV_HEIGHT, width: 100, height: (oneRow_height * 2 + TOP_PADDING + 1)))
        comboboxView.delegate = self
        return comboboxView
    }()
    
    
    
    
    /// 假tab
    func addFakeTab(){
        
        self.fakeView = FakeTabView.init(frame: CGRect(x: 0, y: kScreenH-kFakeTab_HEIGHT, width: kScreenW, height: kFakeTab_HEIGHT))
        self.fakeView.congigUI(menuList: nil)
        
        self.view.addSubview(self.fakeView)
        
        //显示红点
        //        fakeView.showBage(type: .mine, bage: 4)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeMyRedCount"), object: nil, queue: nil) { (notif) in
            self.fakeView.showBage(type: .mine, bage: Int(notif.userInfo?["myRedCount"] as! String)!)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeGroupRedCount"), object: nil, queue: nil) { (notif) in
            
            DispatchQueue.main.async(execute: {
                self.fakeView.showBage(type: .group, bage: Int(RCIMClient.shared().getTotalUnreadCount()))
            })
        }
        //按钮点击响应
        fakeView.fakeType {[weak self] (type) in
            
            var str = "{\"action\":\"goto\",\"data\":{\"data\":\"\",\"subAction\":\""
            
            switch type {
            case .friend:
                str += "friends"
                break
            case .group:
                str += "group"
                break
            case .finding:
                str += "find"
                break
            case .course:
                str += "classes"
                break
            case .mine:
                str += "center"
                break
            default:
                break
            }
            
            str += "\"}}"
            if type != .group{
                let notice = Notification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
                NotificationCenter.default.post(notice)
            }
        }
        
        
    }
}

extension GroupListViewController : ComboboxViewDelegate {
    
    func comboboxViewOneRowClick(button: UIButton) {
        switch button.tag {
        case 10:
            let addMemeberVc = GroupMemberVC()
            addMemeberVc.isCreatGroup = true
            
            self.navigationController?.pushViewController(addMemeberVc, animated: true)
        case 11:
            let search = GroupSearchVC()
            self.navigationController?.pushViewController(search, animated: true)
            
            break
            
        default:
            break
        }
    }
}

extension GroupListViewController:RCIMConnectionStatusDelegate{
    
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        
//        if RCIMClient.shared().getCurrentNetworkStatus() == RCNetworkStatus.notReachable  {
//            self.isShowNetworkIndicatorView = true
//        }
//        else{
//            self.isShowNetworkIndicatorView = false
//        }
        
        if status == .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
            
            

            
            let str = "{\"action\":\"goto\",\"data\":{\"data\":\"\",\"subAction\":\"kick\"}}"
            //        let notice = NSNotification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
            let notice = Notification.init(name: NSNotification.Name(rawValue: "touchOnePerson"), object: nil, userInfo: ["str" : str])
            NotificationCenter.default.post(notice)
            
            
                        let alert = UIAlertController(title: "温馨提示", message:"您的账号已经在别的设备登录,您在当前设备被迫下线！", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: { action in
            
                        })
                        alert.addAction(okAction)
            
           
                self.present(alert, animated: true, completion: nil)
            
            
            
            
            
            //            SVProgressHUD.showError(withStatus: "账号在别的设备登录，本设备被迫下线")
            //            SVProgressHUD.dismiss(withDelay: 1)
        }else if status == .ConnectionStatus_Unconnected{
            
//            self.navigationController?.view.makeToast("当前与服务器未连接", duration: 3.0, position: .center)
            
        }else if status == .ConnectionStatus_Connected{
//            self.navigationController?.view.makeToast("已经连接服务器", duration: 3.0, position: .center)
        }
    }
    
}

