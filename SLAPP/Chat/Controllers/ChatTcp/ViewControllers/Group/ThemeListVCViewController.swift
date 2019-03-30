//
//  ThemeListVCViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/8.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
import MJRefresh
let cardView_height : CGFloat = 40.0
enum ThemeType {
    case unJoin
    case joined
}
class ThemeListVCViewController: RCConversationListViewController {
    
    fileprivate var themeType: ThemeType! = .joined
    var unJoinDataSource : NSMutableArray = [] //存有未参与的话题id
    var tabBarVc : TMTabbarController!
    var emptyBtn : UIButton! //空页面按钮
    var is_groupOwner : Bool?
    var is_search : Bool? //点击搜索按钮
    var getUnjoinDataFirst : Bool? //第一次加载未参与的
    var searchText_joined : String? = ""
    var searchText_unJoin : String? = ""
    var searchCoverView : UIView! //搜索时覆盖页面
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        is_search = false
        getUnjoinDataFirst = true
        
        tabBarVc = self.tabBarController as! TMTabbarController
        self.configNav()
        view.backgroundColor = UIColor.white
        let groupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(self.tabBarVc.groupModel?.targetId)!)).firstObject() as! GroupModel?
        
        is_groupOwner = (groupModel?.owner_id)! == sharePublicDataSingle.publicData.userid as String
        cardView.backgroundColor = kGrayColor_Slapp
        cardView.titleNormalColor = kCardNoSelectColor
        cardView.bottomLineNormalColor = kGreenColor
        cardView.titleSelectColor = .white
        cardView.creatBtns(withTitles: ["已参与","未参与"])
        cardView.btnClickBlock = ({ (btn) in
            if (self.searchCoverView != nil) {
                self.searchCoverView.removeFromSuperview()
            }
            switch btn {
            case 10:
                self.themeType = .joined
                if self.is_search! {
                    if (self.searchText_joined?.characters.count)! > 0 {
                        self.searchView.text = self.searchText_joined
                    }else{
                        self.searchView.text = ""
                        self.searchView.resignFirstResponder()
                    }
                }
                
            case 11:
                self.themeType = .unJoin
                if self.is_search! {
                    if (self.searchText_unJoin?.characters.count)! > 0{
                        self.searchView.text = self.searchText_unJoin
                    }else{
                        self.searchView.text = ""
                        self.searchView.resignFirstResponder()
                    }
                }
                if self.getUnjoinDataFirst! {
                    self.searchUnjoinData(keyword: self.searchView.text!, reloadSuccess: {
                        
                    }, reloadError: {
                        
                    })
                }
            default:
                break
            }
            if self.is_search! {
                if (self.searchView.text?.characters.count)! > 0 {
                    self.searchView.showsCancelButton = true
                }else{
                    self.searchView.showsCancelButton = false
                }
            }
            self.refreshConversationTableViewIfNeeded()
            return false
        })
        self.view .addSubview(cardView)
        self.setDisplayConversationTypes([RCConversationType.ConversationType_GROUP.rawValue])
        self.showConnectingStatusOnNavigatorBar = true
        self.isShowNetworkIndicatorView = false
        self.conversationListTableView.tableFooterView = UIView.init()
        self.conversationListTableView.tag = 10086 //方便获取conversationListTableView
        self.conversationListTableView.frame = CGRect(x: 0, y: NAV_HEIGHT + cardView_height, width: self.view.frame.width, height: kScreenH - NAV_HEIGHT - cardView_height - 49)
        self.conversationListTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction:#selector(headerRefresh))
        self.conversationListTableView.separatorStyle = .none
        if #available(iOS 11, *) {
            self.conversationListTableView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        emptyBtn = UIButton.init()
        emptyBtn.addTarget(self, action: #selector(emptyBtnClick), for: .touchUpInside)
        emptyBtn.titleLabel?.font = FONT_14
        emptyBtn.setTitleColor(UIColor.lightGray, for: .normal)
        emptyBtn.titleLabel?.textAlignment = .center
        emptyBtn.titleLabel?.numberOfLines = 0
        
        self.emptyConversationView = emptyBtn
        
        //        self.reloadData(reloadSuccess: { [weak self] () in
        //            if let strongSelf = self{
        //                if strongSelf.joinedDataSource.count == 0 { //初始化应该显示的页面
        //                    if strongSelf.unJoinDataSource.count > 0 {
        //                        strongSelf.cardView.btnClick(btn: (strongSelf.cardView.viewWithTag(11) as? UIButton)!)
        //                    }
        //                }
        //
        //            }
        //        }, reloadError: {
        //
        //        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.makeNavigationRightBtn()
    }
    
    func makeNavigationRightBtn() {
        let rightBtn = UIButton.init(type: .system)
        rightBtn.frame =  CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
        
        let rightBtn2 = UIButton.init(type: .system)
        rightBtn2.frame =  CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
        
        rightBtn.setImage(UIImage.init(named: "nav_add"), for: .normal)
        rightBtn.addTarget(self, action: #selector(addBtnDidClick), for: .touchUpInside)
        
        rightBtn2.setImage(UIImage.init(named: "search_white"), for: .normal)
        rightBtn2.addTarget(self, action: #selector(searchBtnDidClick), for: .touchUpInside)
        
        rightBtn.sizeToFit()
        rightBtn2.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        let rightBarButtonItem2 = UIBarButtonItem.init(customView: rightBtn2)
        let array = [rightBarButtonItem,rightBarButtonItem2]
        self.tabBarController?.navigationItem.rightBarButtonItems = array
    }
    //MARK: ------------ selector ------------
    //新建话题
    @objc func addBtnDidClick(button: UIButton) {
        self.creatOrEditSubject(subGroupid: "")
    }
    @objc func searchBtnDidClick(button: UIButton) {
        self.is_search = !self.is_search!
        if self.is_search! {
            self.view.addSubview(searchView)
            self.searchView.frame = CGRect(x: 0, y: NAV_HEIGHT + cardView_height, width: self.view.frame.width, height: searchView_height)
            self.conversationListTableView.frame = CGRect(x: 0, y: NAV_HEIGHT + cardView_height + searchView_height, width: self.view.frame.width, height: kScreenH - NAV_HEIGHT  - cardView_height - searchView_height - 49)
        }else{
            if (self.searchCoverView != nil) {
                self.searchCoverView.removeFromSuperview()
            }
            searchView.removeFromSuperview()
            searchView.showsCancelButton = false
            searchView.text = ""
            if (self.searchText_joined?.characters.count)! > 0{
                self.searchText_joined = ""
                self.refreshConversationTableViewIfNeeded()
            }
            if (self.searchText_unJoin?.characters.count)! > 0{
                self.searchText_unJoin = ""
                searchUnjoinData(keyword: searchView.text!, reloadSuccess: {
                    self.refreshConversationTableViewIfNeeded()
                }, reloadError: {
                    
                })
            }

//            self.searchView.frame = CGRect(x: 0, y: NAV_HEIGHT, width: self.view.frame.width, height: cardView_height)
            self.conversationListTableView.frame = CGRect(x: 0, y: NAV_HEIGHT + cardView_height, width: self.view.frame.width, height: kScreenH - NAV_HEIGHT  - cardView_height - 49)
        }
    }
    @objc func emptyBtnClick(button: UIButton) {
        self.creatOrEditSubject(subGroupid: "")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchUnjoinData(keyword : String, reloadSuccess: (() -> ())!, reloadError: (() -> ())!) {
        
        var params = Dictionary<String, Any>()
        params["app_token"] = sharePublicDataSingle.token
        params["groupid"] = self.tabBarVc.groupModel?.targetId
        if keyword.characters.count > 0 {
            params["keyword"] = keyword
        }
        params["is_join"] = 0 //未加入
        self.progressShow()
        GroupRequest.getSubjectList(params: params, hadToast: true, fail: { (fail) in
            self.progressDismiss()
            reloadError()
        }, success: { [weak self](success) in
            reloadSuccess()
            if let strongSelf = self {
                strongSelf.getUnjoinDataFirst = false
                strongSelf.progressDismiss()
                strongSelf.unJoinDataSource.removeAllObjects()
                if success["list"] != nil{
                    let arr = (success["list"] as! NSArray).value(forKeyPath: "groupid")
                    strongSelf.unJoinDataSource.addObjects(from: arr as! [Any])
                }
                strongSelf.refreshConversationTableViewIfNeeded()
            }
        })
        
    }
    
    @objc func headerRefresh(){
        if themeType == .joined {
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            var time:String? = (UserDefaults.standard.object(forKey: username) as! String?)
            
            if (time == nil ){
                time = "0"
            }
            self.progressShow()
            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { [weak self] (error) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    strongSelf.conversationListTableView.mj_header.endRefreshing()
                }
                
                }, success: {[weak self] (dic) in
                    
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                        strongSelf.conversationListTableView.mj_header.endRefreshing()
                        strongSelf.refreshConversationTableViewIfNeeded()
                    }
                }
            )
        }
        if themeType == .unJoin {
            
            searchUnjoinData(keyword: searchView.text!, reloadSuccess: { [weak self] () in
                if let strongSelf = self {
                    strongSelf.conversationListTableView.mj_header.endRefreshing()
                }
                }, reloadError: { [weak self] () in
                    if let strongSelf = self {
                        strongSelf.conversationListTableView.mj_header.endRefreshing()
                    }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        if searchView.isFirstResponder {
            searchView.resignFirstResponder()
        }
        //打开会话界面
        self.conversationListTableView.deselectRow(at: indexPath, animated: false)
        if conversationModelType == RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION {
            
            if self.themeType == .joined {
                let talk = ThemeChatVC(conversationType: (model?.conversationType)!, targetId: model?.targetId)
                self.tabBarController?.navigationController?.pushViewController(talk!, animated: true)
            }else{
                self.joinGroupSubject(model: model, joinSuccess: {
                    
                    DispatchQueue.main.async {
                        let talk = ThemeChatVC(conversationType: .ConversationType_GROUP, targetId: model?.targetId)
                        self.tabBarController?.navigationController?.pushViewController(talk!, animated: true)
                    }
                    
                }, joinFail: {
                    
                })
            }
            
        }
    }
    
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        super.willReloadTableData(dataSource)
        if self.themeType == .joined {
            
            var tempDelGroupModels = Array<RCConversationModel>()//应该移除的群组融云会话模型(非永久移除)
            var tempDelSubGroupModels = Array<RCConversationModel>()//应该移除的话题会话模型(永久移除)
            for i in 0..<dataSource.count {
                let model : RCConversationModel = dataSource[i] as! RCConversationModel
                let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",model.targetId)).firstObject() as! GroupModel?
                
                //                let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@ AND is_delete == '0'", sharePublicDataSingle.publicData.userid,model.targetId)).firstObject() as! GroupUserModel?
                // || self.unJoinDataSource.contains(model.targetId)
                if groupModel == nil{
                    tempDelSubGroupModels.append(model)
                    continue
                }
                //                if is_search! {
                //                    if (self.searchView.text?.characters.count)! > 0 {
                //                        if !(groupModel?.group_name.contains(self.searchView.text!))! {
                //                            tempDelGroupModels.append(model)
                //                            continue
                //                        }
                //                    }
                //                }
                //|| groupUserModel == nil 不考虑当前是不是在话题内(因为已经解散的还需保存会话)
                if groupModel?.type == "0" || groupModel?.parentid != self.tabBarVc.groupModel?.targetId {
                    
                    tempDelGroupModels.append(model)
                    continue
                }
                //                if groupModel?.type == "0" || groupModel?.parentid != self.tabBarVc.groupModel?.targetId || (self.joinedDataSource.count > 0 && !self.joinedDataSource.contains(model.targetId)){
                //                    tempDelGroupModels.append(model)
                //                    continue
                //                }
                
                model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                model.conversationTitle = groupModel?.group_name
                model.extend = groupModel?.icon_url
//                model.sentTime = Int64((groupModel?.inputtime)!)!
                model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
                model.cellBackgroundColor = UIColor.white
                
            }
            for model in tempDelGroupModels {//移除数据库中不包含的会话
                dataSource.remove(model)
            }
            for model in tempDelSubGroupModels {//移除数据库中不包含的会话
                dataSource.remove(model)
                RCIMClient.shared().clearMessages(model.conversationType, targetId: model.targetId)
                RCIMClient.shared().remove(model.conversationType, targetId: model.targetId)
            }
            
        }
        if self.themeType == .unJoin {
            dataSource.removeAllObjects()
            //            unJoinDataSource.sort(using: NSSortDescriptor.init(key: "inputtime", ascending: false))
            
            unJoinDataSource.sort(
                comparator: {
                    (s1:Any!,s2:Any!)->ComparisonResult in
                    let groupModel1 : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",s1 as! String)).firstObject() as! GroupModel?
                    let groupModel2 : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",s2 as! String)).firstObject() as! GroupModel?
                    
                    if (groupModel1?.inputtime)! < (groupModel2?.inputtime)!{
                        return .orderedDescending
                    }else{
                        return .orderedAscending
                    }
                    
            })    //按创建时间降序排序
            for i in 0..<unJoinDataSource.count {
                let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",unJoinDataSource[i] as! String)).firstObject() as! GroupModel?
                let model : RCConversationModel = RCConversationModel.init()
                model.targetId = groupModel?.groupid
                model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                model.conversationTitle = groupModel?.group_name
                model.extend = groupModel?.icon_url
                model.sentTime = Int64((groupModel?.inputtime)!)!
                model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
                model.cellBackgroundColor = UIColor.white
                dataSource.add(model)
            }
        }
        DispatchQueue.main.async {
            self.emptyBtn.setTitle("您暂无话题\n赶紧创建一个话题吧~", for: .normal)
            self.emptyBtn.sizeToFit()
            self.emptyBtn.center = self.conversationListTableView.center
        }
        
        self.conversationListDataSource = dataSource
        if self.is_search! {
            if (self.searchView.text?.characters.count)! > 0 {
                
                self.conversationListDataSource.filter(using: NSPredicate.init(format:"conversationTitle contains %@",self.searchView.text!))
            }
            DispatchQueue.main.async {
                self.showRemind()
            }
        }else{
            DispatchQueue.main.async {
                self.conversationListTableView.tableFooterView = UIView.init()
                self.emptyConversationView = self.emptyBtn
            }
        }
        return dataSource
    }
    override func rcConversationListTableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.row < self.conversationListDataSource.count {
            if themeType == .joined {
                return 64 + 50
            }
            if themeType == .unJoin {
                return 64 + 10
            }
            return 64 + 50
        }
        return 0
    }
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        
        if indexPath.row < self.conversationListDataSource.count {
            var cell : ThemeListBaseCell?
            let model : RCConversationModel = self.conversationListDataSource![indexPath.row] as! RCConversationModel
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@ AND type == '1'",model.targetId)).firstObject() as! GroupModel?
          
            let is_themeOwner = (groupModel?.owner_id != nil ?(groupModel?.owner_id)! : "") == sharePublicDataSingle.publicData.userid as String
            
            if themeType == .joined {
                cell = ThemeJoinedListCell.cell(withTableView: tableView)
            }
            if themeType == .unJoin {
                cell = ThemeListBaseCell.cell(withTableView: tableView)
            }
            
            cell?.btnClickBlock = ({ (btn) in
                switch btn.titleLabel?.text! {
                case "置顶"?:
                    RCIMClient.shared().setConversationToTop(model.conversationType, targetId: model.targetId, isTop: true)
                    self.refreshConversationTableViewIfNeeded()
                case "取消置顶"?:
                    RCIMClient.shared().setConversationToTop(model.conversationType, targetId: model.targetId, isTop: false)
                    self.refreshConversationTableViewIfNeeded()
                case "转推"?:
                    if groupModel?.is_delete == "1" {//已经解散的话题
                        self.view.makeToast("该话题已被解散,无法转推", duration: 1.0, position: self.view.center)
                        break
                    }
                    let vc = ThemeRetweetVC()
                    vc.thisThemeId = model.targetId
                    self.tabBarVc.navigationController?.pushViewController(vc, animated: true)
                case "编辑"?:
                    if groupModel?.is_delete == "1" {//已经解散的话题
                        self.view.makeToast("该话题已被解散,无法编辑", duration: 1.0, position: self.view.center)
                        break
                    }
                    self.creatOrEditSubject(subGroupid: model.targetId)
                case "解散"?:
                    if groupModel?.is_delete == "1" {//已经解散的话题
                        self.addAlertView(title: "温馨提示", message: "该话题已被解散,您确定要删除该会话?", actionTitles: ["确定","取消"], okAction: { (action) in
                            RCIMClient.shared().clearMessages(.ConversationType_GROUP, targetId: model.targetId)
                            RCIMClient.shared().remove(.ConversationType_GROUP, targetId: model.targetId)
                            self.refreshConversationTableViewIfNeeded()
                            
                        }, cancleAction: { (action) in
                            
                        })
                        
                        break
                    }
                    
                    self.quitGroupSubject(title: "解散", message: "解散该话题讨论后，其他人也将无法查看话题内容",sub_groupid: model.targetId)
                case "退出"?:
                    DLog("退出")
                    self.quitGroupSubject(title: "退出", message:"退出话题后，将无法收到该话题群的消息",sub_groupid: model.targetId)
                    
                case "结束辅导"?:

                    self.quitGroupSubject(title: "结束辅导", message:"结束辅导后，导师将不再进行辅导，您确认要结束辅导吗？",sub_groupid: model.targetId)
                default:
                    break
                }
                //                self.conversationListDataSource.removeAllObjects()
                //                self.refreshConversationTableViewIfNeeded()
            })
            cell?.setDataModel(self.conversationListDataSource![indexPath.row] as! RCConversationModel)
            var bottomTitleList = [[(model.isTop ? "取消置顶" : "置顶"),"theme_setTop"],["转推","theme_transmit"],["退出","theme_quit"]]
            if is_groupOwner! && !is_themeOwner{
                bottomTitleList = [[(model.isTop ? "取消置顶" : "置顶"),"theme_setTop"],["转推","theme_transmit"],["解散","theme_dismiss"],["退出","theme_quit"]]
            }else if is_themeOwner{
                bottomTitleList = [[(model.isTop ? "取消置顶" : "置顶"),"theme_setTop"],["转推","theme_transmit"],["编辑","theme_edit"],["解散","theme_dismiss"]]
            }else{
                bottomTitleList = [[(model.isTop ? "取消置顶" : "置顶"),"theme_setTop"],["转推","theme_transmit"],["退出","theme_quit"]]
            }
            
            if groupModel?.is_consult == 1 {
                DLog("groupModel?.consult_info?.consult_status :\(groupModel?.consult_info?.consult_status)")
                if groupModel?.consult_info?.consult_status == "5" && (groupModel?.owner_id == sharePublicDataSingle.publicData.userid){
                    bottomTitleList.append(["结束辅导",""])
                }else if groupModel?.consult_info?.consult_status == "6"{
                    bottomTitleList.append(["已结束",""])
                }else if groupModel?.consult_info?.consult_status == "4"{
                    bottomTitleList.append(["取消",""])
                }
            }
            cell?.bottomTitleImgs = bottomTitleList
            return cell
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    override func didReceiveMessageNotification(_ notification: Notification!) {
        let message : RCMessage = notification.object as! RCMessage
        DLog("groupid == " + message.targetId)
        if message.objectName == RCGroupNotificationMessageIdentifier {//群组通知类消息
            
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            let time = UserDefaults.standard.object(forKey: username) as! String
            
            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time], hadToast: true, fail: { (error) in
                //                DLog(error)
            }, success: {[weak self] (dic) in
                
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    
                    let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",message.targetId)).firstObject() as! GroupModel?
                    if groupModel != nil {
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,(groupModel?.groupid)!)).firstObject() as! GroupUserModel?
                        if groupModel?.is_delete == "1" || groupUserModel?.is_delete == "1"{
                            RCIMClient.shared().setConversationToTop(.ConversationType_GROUP, targetId: message.targetId, isTop: false)
                        }
                    }
                    
                    strongSelf.refreshConversationTableViewIfNeeded()
                    
                }
                }
            )
        }else{
            //            if self.navigationController?.topViewController is GroupListViewController{
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",message.targetId)).firstObject() as! GroupModel?
            if groupModel != nil { //数据库中没有更新下来的会话暂时不需要显示
                self.refreshConversationTableViewIfNeeded()
            }
            
            //            }
        }
        
    }
    //创建或编辑话题
    func creatOrEditSubject(subGroupid:String?) {
        let vc = ThemeCreatVC()
        if (subGroupid?.characters.count)! > 0{
            vc.subGroupid = subGroupid
        }
        vc.groupid = self.tabBarVc.groupModel?.targetId
        vc.creatThemeSuccessBlock = ({ (themeid) in
            RCIMClient.shared().getRemoteHistoryMessages(.ConversationType_GROUP, targetId: themeid!, recordTime: 0, count: 20, success: { [weak self](array) in
                DispatchQueue.main.async {
                    let talk = ThemeChatVC(conversationType: .ConversationType_GROUP, targetId: themeid)
                    self?.tabBarController?.navigationController?.pushViewController(talk!, animated: true)
                }
                }, error: { (errorCode) in
                    
            })
            
            self.refreshConversationTableViewIfNeeded()
        })
        self.tabBarVc.navigationController?.pushViewController(vc, animated: true)
    }
    func joinGroupSubject(model: RCConversationModel,joinSuccess: (() -> ())!, joinFail: (() -> ())!) {
        self.progressShow()
        GroupRequest.joinGroupSubject(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":model.targetId!], hadToast: true, fail: { [weak self] (fail) in
            if let strongSelf = self {
                strongSelf.progressDismiss()
                joinFail()
            }
            
            }, success: { (dic) in
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                
                if time == nil{
                    time = "0"
                }
                UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                    }, success: {[weak self] (dic) in
                        if let strongSelf = self {
                            strongSelf.progressDismiss()
                            strongSelf.unJoinDataSource.remove(model.targetId)
                            let a = strongSelf.cardView.btnClickBlock(10)
                            strongSelf.refreshConversationTableViewIfNeeded()
                            joinSuccess()
                            
                        }
                    }
                )
                
        })
    }
    //解散或退出话题
    func quitGroupSubject(title: String?, message: String?, sub_groupid: String?) {
        self.addAlertView(title: "", message: message!, actionTitles: ["确定","取消"], okAction: { (action) in
            self.progressShow()
            switch title! {
            case "解散":
                GroupRequest.dismissGroupSubject(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":sub_groupid!], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self{
                        strongSelf.progressDismiss()
                    }
                    }, success: { [weak self](dic) in
                        if let strongSelf = self{
                            strongSelf.progressDismiss()
                            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",sub_groupid!)).firstObject() as! GroupModel?
                            
                            let realm:RLMRealm = RLMRealm.default()
                            realm.beginWriteTransaction()
                            groupModel?.setValue("1", forKey: "is_delete")
                            try? realm.commitWriteTransaction()
                            
                            //                        RCIMClient.shared().clearMessages(.ConversationType_GROUP, targetId: sub_groupid)
                            //                        RCIMClient.shared().remove(.ConversationType_GROUP, targetId: sub_groupid)
                            strongSelf.refreshConversationTableViewIfNeeded()
                        }
                })
            case "退出":
                GroupRequest.quitGroupSubject(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":sub_groupid!], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self{
                        strongSelf.progressDismiss()
                    }
                    }, success: { (dic) in
                        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                        var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                        
                        if time == nil{
                            time = "0"
                        }
                        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                            if let strongSelf = self {
                                strongSelf.progressDismiss()
                            }
                            }, success: { [weak self] (dic) in
                                if let strongSelf = self{
                                    strongSelf.progressDismiss()
                                    RCIMClient.shared().clearMessages(.ConversationType_GROUP, targetId: sub_groupid)
                                    RCIMClient.shared().remove(.ConversationType_GROUP, targetId: sub_groupid)
                                    let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",sub_groupid!)).firstObject() as! GroupModel?
                                    if groupModel?.is_delete == "1" {//已经解散了不要添加到未参与列表里
                                    }else{
                                        if !strongSelf.unJoinDataSource.contains(sub_groupid!) {
                                            strongSelf.unJoinDataSource.insert(sub_groupid!, at: 0)
                                        }
                                    }
                                    
                                    strongSelf.refreshConversationTableViewIfNeeded()
                                }
                            }
                        )
                        
                })
                
            case "结束辅导" :
                GroupRequest.finishOnlineConsult(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":sub_groupid!], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self{
                        strongSelf.progressDismiss()
                    }
                    }, success: { (dic) in
                        DLog(dic)
                        let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                        var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                        
                        if time == nil{
                            time = "0"
                        }
                        //结束辅导后对导师进行评分
                        let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@ AND type == '1'",sub_groupid!)).firstObject() as! GroupModel?
                        let view = EvaluateTeacherView.init(consultId: (groupModel?.consult_info?.consult_id)!, teacherId: (groupModel?.consult_info?.teacher_sso_userid)!, frame: UIScreen.main.bounds)
                        self.view.addSubview(view)
                        UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { [weak self] (fail) in
                            if let strongSelf = self {
                                strongSelf.progressDismiss()
                            }
                            }, success: { [weak self] (dic) in
                                DLog(dic)
                                self?.conversationListTableView.reloadData()
                            }
                        )
                        
                })
                
            default:
                break
            }
            
            
        }, cancleAction: { (action) in
            
        })
        
    }
    /// 提醒个数
    func showRemind(){
        
        let fView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 50))
        
        let line = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        fView.addSubview(line)
        
        let numberLable = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kScreenW, height: 30))
        numberLable.textAlignment = NSTextAlignment.center
        numberLable.font = UIFont.systemFont(ofSize: 14)
        
        numberLable.text = "没有查找到相关的话题"
        fView.addSubview(numberLable)
        
        if self.conversationListDataSource.count == 0 && (self.searchView.text?.characters.count)! > 0{
            conversationListTableView.tableFooterView = fView
            self.emptyConversationView = UIView.init()
        }else{
            conversationListTableView.tableFooterView = UIView.init()
            self.emptyConversationView = self.emptyBtn
        }
        
    }
    
    //MARK: - Getter and Setter
    lazy var cardView : CardView  = {
        let cardView = CardView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: self.view.frame.size.width, height: cardView_height))
        return cardView
    }()
    
    lazy var searchView: UISearchBar = {
        let searchView = UISearchBar.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT + cardView_height, width: kScreenW, height: 50))
        searchView.setBackgroundImage(UIImage.init(named: "backGray")!, for: .any, barMetrics: .default)
        searchView.delegate = self
        searchView.placeholder = "搜索"
        return searchView
    }()
}

extension ThemeListVCViewController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchView.showsCancelButton = true
        if (self.searchCoverView != nil) {
            self.searchCoverView.removeFromSuperview()
        }
        self.searchCoverView = UIView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT + cardView_height + searchView_height, width: kScreenW, height: kScreenH - (NAV_HEIGHT + cardView_height + searchView_height)))
        self.searchCoverView.backgroundColor = UIColor.white
        let numberLable = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: kScreenW, height: 30))
        numberLable.textAlignment = NSTextAlignment.center
        numberLable.font = UIFont.systemFont(ofSize: 14)
        numberLable.text = "搜索相关内容"
        self.searchCoverView.addSubview(numberLable)
        self.view.addSubview(self.searchCoverView)
        self.view.bringSubview(toFront: self.searchCoverView)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if (self.searchCoverView != nil) {
            self.searchCoverView.removeFromSuperview()
        }
        searchView.showsCancelButton = false
        searchView.text = ""
        if themeType == .joined {
            self.searchText_joined = searchView.text
            self.refreshConversationTableViewIfNeeded()
        }
        if themeType == .unJoin {
            self.searchText_unJoin = searchView.text
            searchUnjoinData(keyword: searchView.text!, reloadSuccess: {
                self.refreshConversationTableViewIfNeeded()
            }, reloadError: {
                
            })
            
        }
        searchBar.resignFirstResponder()
        conversationListTableView.tableFooterView = UIView.init()
        self.emptyConversationView = self.emptyBtn
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (self.searchCoverView != nil) {
            self.searchCoverView.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if themeType == .joined {
            self.searchText_joined = searchView.text
            //            self.conversationListDataSource.filter(using: NSPredicate.init(format:"conversationTitle contains %@",searchView.text!))
            //            self.conversationListTableView.reloadData()
            self.refreshConversationTableViewIfNeeded()
        }
        if themeType == .unJoin {
            self.searchText_unJoin = searchView.text
            searchUnjoinData(keyword: searchView.text!, reloadSuccess: {
                
            }, reloadError: { 
                
            })
        }
        
    }
    
}

extension ThemeListVCViewController{
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
}
