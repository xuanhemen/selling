//
//  PrivateListViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2018/2/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import MJRefresh
import ReactiveCocoa
import ReactiveSwift

class PrivateListViewController: RCConversationListViewController,UISearchBarDelegate,RCDSearchViewDelegate {
    
    var searchNavigationController:BaseNavigationController?
    
    let  header = HYPrivateListHeaderView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 65*5))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateIMData()
    }
    
    
    
    func updateIMData(){
        PublicDataSingle.initData(fail: { (dic) in
            
        }) {[weak self] (dic) in
            
            DLog("请求了增量-------------------------------------------------------------------------------------------")
            self?.conversationListTableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         self.emptyConversationView = UIView()
        // Do any additional setup after loading the view.
        self.configNav()
        view.backgroundColor = UIColor.white
        self.title = "消息中心"
        
        self.isShowNetworkIndicatorView = true
    self.setDisplayConversationTypes([RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_PRIVATE.rawValue,RCConversationType.ConversationType_SYSTEM.rawValue])
        self.showConnectingStatusOnNavigatorBar = true
        
        let arr = RCIMClient.shared().getConversationList([RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_PRIVATE.rawValue,RCConversationType.ConversationType_SYSTEM.rawValue]) as NSArray
//        DLog(arr)
//        RCIM.shared().registerMessageType(ThemeMessageContent.self)
//        RCIM.shared().registerMessageType(HistoryMessageContent.self)
        //注册自定义消息
        self.registerCustomerMessageContent()
        
//        self.setRightBtnWithArray(items: [UIImage.init(named: "search_white")])
        

//        self.conversationListTableView.tableHeaderView = search
        
       
        
    self.configHeader()
    }
    
    
    func configHeader(){
        
        header.search.delegate = self
        header.cellClickWithTargetId = { (idStr,nameStr) in
            
            if idStr == "system2" {
                let rcc = SingleChatVC.init(conversationType: RCConversationType.ConversationType_SYSTEM, targetId: idStr)
                
                rcc?.title = nameStr
                
                self.navigationController?.pushViewController(rcc!, animated: true)
            }
            else{
                
                let vc = HYVisitNotificationsVC()
                vc.nameStr = nameStr
                vc.id = idStr
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        self.conversationListTableView.tableHeaderView = header;
    }
    
    
    func configHeaderData(){
        
//
//        const val CONSULT_SYSTEM_ID = "system2"
//        const val SYSTEM_COMMENT_ID="systemCommentMessage"
//        const val SYSTEM_PRAISE_ID="systemPraiseMessage"
//        const val SYSTEM_AT_ID="systemAtMessage
        
        
        
        
        header.refresh()
        
    }
    
    
    
    override func rightBtnClick(button: UIButton) {
//        self.present(UIViewController(), animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
//    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
//        let arr = super.willReloadTableData(dataSource)
//        let data = RCIMClient.shared().getConversationList([RCConversationType.ConversationType_GROUP.rawValue,RCConversationType.ConversationType_PRIVATE.rawValue,RCConversationType.ConversationType_SYSTEM.rawValue])
//        DLog(arr)
//        DLog(data)
//        return arr
//    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return super.tableView(tableView, cellForRowAt: indexPath)
        let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        
        
        
        
        let cell = GroupListCell.cell(withTableView: tableView)
        if model.conversationType == RCConversationType.ConversationType_GROUP {
            let groupModel : GroupModel? = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",model.targetId)).firstObject() as! GroupModel?
            if groupModel != nil{
                model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                print("QF -- name : ",groupModel?.group_name as Any)
                model.conversationTitle = groupModel?.group_name
                model.extend = groupModel?.icon_url
                model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
                model.cellBackgroundColor = UIColor.white
            }
            
            cell.setDataModel(self.conversationListDataSource![indexPath.row] as! RCConversationModel)
            if MessageCenterModel.objects(with: NSPredicate(format: "parentId == %@", cell.model.targetId)).count != 0 {
                cell.badgeLb.isHidden = false
            }
            return cell
        }else if model.conversationType == RCConversationType.ConversationType_PRIVATE{
            let usermodel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", model.targetId.components(separatedBy: "-")[0])).firstObject() as! UserModelTcp?
            if usermodel != nil{
                model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
                print("QF -- realname : ",usermodel?.realname as Any)
                model.conversationTitle = usermodel?.realname
                model.extend = usermodel?.avater
                model.topCellBackgroundColor = UIColor.hexString(hexString: "DCDCDC")
                model.cellBackgroundColor = UIColor.white
                cell.setDataModel(self.conversationListDataSource![indexPath.row] as! RCConversationModel)
                if String.changeToString(inValue: model.extend) == ""{
                    cell.headerImageView.image = UIImage.init(named: "message_system")
                    cell.headerImageView.layer.borderColor = UIColor.clear.cgColor
                    cell.headerImageView.layer.borderWidth = 0
                }
            }else{
                cell.headerImageView.image = UIImage.init(named: "message_system")
                cell.headerImageView.layer.borderColor = UIColor.clear.cgColor
                cell.headerImageView.layer.borderWidth = 0
            }
            return cell
        }else if model.conversationType == RCConversationType.ConversationType_SYSTEM{
//            model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
//            cell.headerImageView.image = UIImage.init(named: "message_book")
//            cell.nameLabel.text = "在线辅导"
            let oldcell = super.tableView(tableView, cellForRowAt: indexPath) as! RCConversationCell
            oldcell.conversationTitle.text = "在线辅导"
            model.conversationTitle = "在线辅导"
            oldcell.headerImageViewBackgroundView.removeFromSuperview()
            
            var headerImageView = StitchingImageView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            headerImageView.layer.cornerRadius = 4.0
            headerImageView.clipsToBounds = true
            headerImageView.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
            headerImageView.layer.borderWidth = 0.5
            let backView = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 60))
            backView.backgroundColor = .white
            oldcell.contentView.addSubview(backView)
            backView.addSubview(headerImageView)
            
            headerImageView.mas_makeConstraints { (make) in
                make!.top.left().equalTo()(LEFT_PADDING)
                make!.size.equalTo()(CGSize(width: 44, height: 44))
            }
            oldcell.bubbleTipView.bubbleTipPositionAdjustment = CGPoint(x: -5, y: 15)
            backView.addSubview(oldcell.bubbleTipView)
            
            headerImageView.image = UIImage.init(named: "message_book")
            return oldcell
        }else{
            model.conversationModelType = RCConversationModelType.CONVERSATION_MODEL_TYPE_CUSTOMIZATION
            DLog("userid ==" + String(model.conversationType.rawValue))
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func didDeleteConversationCell(_ model: RCConversationModel!) {
        super.didDeleteConversationCell(model)
        let deleteArrayName = UserModel.getUserModel().id! + UserModel.getUserModel().corpid! + "deleteArray"
        var deleteArray = Array<String>()
        if UserDefaultRead(key: deleteArrayName) != nil{
            deleteArray = UserDefaultRead(key: deleteArrayName) as! Array<String>
        }
        if !deleteArray.contains(String(model.conversationType.rawValue) + model.targetId) {
            deleteArray.append(String(model.conversationType.rawValue) + model.targetId)
        }
        UserDefaultWrite(id: deleteArray, key: deleteArrayName)
        self.refreshConversationTableViewIfNeeded()
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        DLog(model)
        if model.conversationType == RCConversationType.ConversationType_GROUP {
            let trueGroupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",(model.targetId)!)).firstObject() as? GroupModel
            let tabBarVc : TMTabbarController = TMTabbarController()
            
            if trueGroupModel == nil {
                
                
                let time = "0"
                let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                UserDefaults.standard.set(time, forKey: username)
                self.updateIMData()
                return
                
                
//                let rcc = RCConversationViewController.init(conversationType: model.conversationType, targetId: model.targetId)
//                rcc?.title = model.conversationTitle
//                self.navigationController?.pushViewController(rcc!, animated: true)
//                return
            }
            
            tabBarVc.projectId = String.noNilStr(str: (trueGroupModel?.project_id)!)
            
            if trueGroupModel?.parentid == "" || trueGroupModel?.parentid == "0"{
                let rcc = RCIMClient.shared().getConversation(RCConversationType.ConversationType_GROUP, targetId: trueGroupModel?.groupid)
                tabBarVc.groupModel = RCConversationModel.init(conversation: rcc, extend: nil)
                if tabBarVc.groupModel?.targetId == nil ||  (tabBarVc.groupModel?.targetId.isEmpty)!{
                    PublicMethod.toastWithText(toastText: "信息不全无法完成操作")
                    return
                }
                self.navigationController?.pushViewController(tabBarVc, animated: true)
            }else{
                let rcc = RCIMClient.shared().getConversation(RCConversationType.ConversationType_GROUP, targetId: trueGroupModel?.parentid)
                tabBarVc.groupModel = RCConversationModel.init(conversation: rcc, extend: nil)
                if tabBarVc.groupModel?.targetId == nil ||  (tabBarVc.groupModel?.targetId.isEmpty)!{
                    tabBarVc.groupModel?.targetId = trueGroupModel?.parentid
                }
//                self.navigationController?.pushViewController(tabBarVc, animated: false)
//                tabBarVc.btnClick(tabBarVc.bgImageView.viewWithTag(1001) as! TMTabbarButton)
                let tc = ThemeChatVC.init(conversationType: RCConversationType.ConversationType_GROUP, targetId: trueGroupModel?.groupid)
                tc?.title = model.conversationTitle
                tc?.projectId = String.noNilStr(str: (trueGroupModel?.project_id)!)
                self.navigationController?.pushViewController(tc!, animated: true)
            }
        }else{
            
            let userModel1 = RCUserInfo.init()
            userModel1.userId = UserModel.getUserModel().im_userid
            userModel1.name = UserModel.getUserModel().realname
            if UserModel.getUserModel().avater == nil {
                userModel1.portraitUri = tcp_host+"static/images/userpic.jpg"
            }else{
                userModel1.portraitUri = UserModel.getUserModel().avater?.appending(imageSuffix)
            }
            RCIM.shared().refreshUserInfoCache(userModel1, withUserId: userModel1.userId)
            
            let userModel = RCUserInfo.init()
            userModel.userId = String.noNilStr(str: model.targetId)
            userModel.name = String.noNilStr(str: model.conversationTitle)
            
            let headImageModel : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", model.targetId.components(separatedBy: "-")[0])).firstObject() as! UserModelTcp?
            
            if String.noNilStr(str: headImageModel?.avater).isEmpty{
                
            }else{
                userModel.portraitUri = String.noNilStr(str: headImageModel?.avater)
            }
            
            RCIM.shared().refreshUserInfoCache(userModel, withUserId: userModel.userId)
            
            let rcc = SingleChatVC.init(conversationType: model.conversationType, targetId: model.targetId)
            rcc?.title = model.conversationTitle
            rcc?.reactive.signal(for: #selector(viewDidLoad)).observe({ (event) in
                //            RCIM.shared().registerMessageType(ThemeMessageContent.self)
                //            RCIM.shared().registerMessageType(HistoryMessageContent.self)
            })
            self.navigationController?.pushViewController(rcc!, animated: true)
        }
            
            
//        let rcc = RCConversationViewController.init(conversationType: model.conversationType, targetId: model.targetId)
//        rcc?.title = model.conversationTitle
//        rcc?.reactive.signal(for: #selector(viewDidLoad)).observe({ (event) in
////            RCIM.shared().registerMessageType(ThemeMessageContent.self)
////            RCIM.shared().registerMessageType(HistoryMessageContent.self)
//        })
//        self.navigationController?.pushViewController(rcc!, animated: true)
//        }
    }
    
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
         self.conversationListDataSource = super.willReloadTableData(dataSource)
        let deleteArrayName = UserModel.getUserModel().id! + UserModel.getUserModel().corpid! + "deleteArray"
        if UserDefaultRead(key: deleteArrayName) != nil {
            let deleteArray = UserDefaultRead(key: deleteArrayName) as! Array<String>
            var tempDelGroupModels = Array<RCConversationModel>()
            for i in 0..<dataSource.count {
                let model : RCConversationModel = dataSource[i] as! RCConversationModel
                if deleteArray.contains(String(model.conversationType.rawValue) + model.targetId){
                    tempDelGroupModels.append(model)
                }
            }
            for model in tempDelGroupModels {//移除话题会话数据
                self.conversationListDataSource.remove(model)
            }
        }
      
        let array = self.conversationListDataSource.filter { (cModel) -> Bool in
//            把系统消息相关的过滤掉
            return (cModel as! RCConversationModel).conversationType != RCConversationType.ConversationType_SYSTEM
        }
        self.conversationListDataSource.removeAllObjects()
        self.conversationListDataSource.addObjects(from: array)
        
        self.configHeaderData()
        return self.conversationListDataSource
    }
    override func rcConversationListTableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat {
        return 64
    }
    override func rcConversationListTableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath!) -> RCConversationBaseCell! {
        let model = self.conversationListDataSource[indexPath.row] as! RCConversationModel
        DLog(model.conversationTitle)
        DLog(model.conversationType)
        DLog("asdasdasdasd")
            let cell = GroupListCell.cell(withTableView: tableView)
            cell.setDataModel(self.conversationListDataSource![indexPath.row] as! RCConversationModel)
            if MessageCenterModel.objects(with: NSPredicate(format: "parentId == %@", cell.model.targetId)).count != 0 {
                cell.badgeLb.isHidden = false
            }
        
        if model.unreadMessageCount == 0 && (model.conversationType == RCConversationType.ConversationType_SYSTEM || model.conversationType == RCConversationType.ConversationType_PRIVATE || model.conversationType == RCConversationType.ConversationType_GROUP){
            cell.badgeLb.isHidden = false
        }
        return cell
    }
   
  // MARK: - search 相关
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let search = RCDSearchViewController.init()
        self.searchNavigationController = BaseNavigationController.init(rootViewController: search)
        search.delegate = self
        self.navigationController?.view.addSubview((self.searchNavigationController?.view)!)
    }
    
    func onSearchCancelClick() {
        self.searchNavigationController?.view.removeFromSuperview()
        self.searchNavigationController?.removeFromParentViewController()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.refreshConversationTableViewIfNeeded()
    }
    
    
    
    
    
    
}
