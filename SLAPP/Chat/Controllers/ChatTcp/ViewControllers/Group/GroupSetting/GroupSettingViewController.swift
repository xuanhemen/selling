//
//  GroupSettingViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/9.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import Realm
class GroupSettingViewController: BaseViewController {

    fileprivate var dataSourceArr = Array<Array<Dictionary<String, Any>>>()
    fileprivate var usersDataSourceArr  = Array<GroupUserModel>()
    var header : GroupSettingTableViewHeader!
    var headerView : UIView!
    var groupModel:GroupModel?
    var groupUserModel:GroupUserModel? //当前登录用户的groupUserModel
    var ownUserModel:GroupUserModel? //群主的groupUserModel
    var is_owner : Bool? //是否是群组
    var targetId:String?{
        
        didSet {
            groupModel = GroupModel.objects(with: NSPredicate.init(format: "groupid == %@",targetId!)).firstObject() as! GroupModel?
            groupUserModel = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,(groupModel?.groupid)!)).firstObject() as! GroupUserModel?

            is_owner = (groupModel?.owner_id)! == sharePublicDataSingle.publicData.userid as String
            self.configData()
            self.configUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "群组信息"
        self.configNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configData()
        self.tableView.reloadData()
    }
    func configData() {
        usersDataSourceArr.removeAll()
        ownUserModel = GroupUserModel.objects(with: NSPredicate.init(format: "groupid == %@ AND userid == %@ AND is_delete == '0'",(groupModel?.groupid)!,(groupModel?.owner_id)!)).firstObject() as! GroupUserModel?
        if ownUserModel != nil {
            usersDataSourceArr.append(ownUserModel!)
        }
        let groupUserModels = GroupUserModel.objects(with: NSPredicate.init(format: "groupid == %@ AND userid != %@ AND is_delete == '0'",(groupModel?.groupid)!, (groupModel?.owner_id)!)).sortedResults(usingKeyPath: "inputtime", ascending: true)
        for i in 0..<groupUserModels.count {
            let groupUserModel : GroupUserModel = groupUserModels[i] as! GroupUserModel
            usersDataSourceArr.append(groupUserModel)
        }
        let conversation  = RCIMClient.shared().getConversation(.ConversationType_GROUP, targetId: targetId)

        if is_owner! {
            //12
            dataSourceArr = [
                [["群组名称":groupModel?.group_name],],
                [["置顶聊天":conversation?.isTop.hashValue],["查找聊天内容":""]]
            ]
        }else{
            dataSourceArr = [
                [["群组名称":groupModel?.group_name]],
                [["置顶聊天":conversation?.isTop.hashValue],["查找聊天内容":""]]
            ]
        }

    }
    
    func configUI() {
        if usersDataSourceArr.count > 0 {
            
            header = GroupSettingTableViewHeader.init()
            header.myDelegate = self
            header.users = usersDataSourceArr
            header.isAllowedDeleteMember = is_owner
            header.isAllowedInviteMember = groupModel?.is_delete == "0" && groupUserModel?.is_delete == "0"
            headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: header.collectionViewLayout.collectionViewContentSize.height))
            headerView.addSubview(header)
            header.mas_makeConstraints { (make) in
                make!.top.left().bottom().right().equalTo()(headerView)
            }
            self.tableView.tableHeaderView = headerView
        }
        
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 70))
        footerView.backgroundColor = UIColor.clear
        let delAndExitBtn = UIButton.init(frame: CGRect.init(x: 20, y: 20, width: SCREEN_WIDTH - 20 * 2, height: 40))
        delAndExitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        delAndExitBtn.backgroundColor = UIColor.hexString(hexString: "2183DE")
        delAndExitBtn.layer.cornerRadius = 5.0
        delAndExitBtn.clipsToBounds = true
        if is_owner! {
            
            delAndExitBtn.setTitle("解散群组", for: .normal)
        }else{
            delAndExitBtn.setTitle("删除并退出", for: .normal)
        }
        delAndExitBtn.titleLabel?.textColor = UIColor.white
        delAndExitBtn.titleLabel?.font = FONT_16
        footerView.addSubview(delAndExitBtn)
        
        self.tableView.tableFooterView = footerView
        
        self.view.addSubview(self.tableView)
        
    }
    
    func reloadHeaderData() {

        self.configData()
        if usersDataSourceArr.count == 0 {
            self.tableView.tableHeaderView = nil
            return
        }
        self.header.users = usersDataSourceArr
        self.header.isAllowedInviteMember = groupModel?.is_delete == "0" && groupUserModel?.is_delete == "0"
        self.header.reloadData()
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height:
            self.header.collectionViewLayout.collectionViewContentSize.height)
        self.tableView.tableHeaderView = self.headerView
        self.tableView.reloadData()

    }
    @objc func exitBtnClick() {
        if is_owner! {
            self.addAlertView(title: "您确定要解散该群组吗?", message: "", actionTitles: ["确定","取消"], okAction: { (action) in
                self.progressShow()
                GroupRequest.dismiss(params: ["app_token":sharePublicDataSingle.token,"groupid":self.groupModel?.groupid], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                }, success: {  [weak self](dic) in
                    if let strongSelf = self{
                        strongSelf.progressDismiss()
                        let realm:RLMRealm = RLMRealm.default()
                        realm.beginWriteTransaction()
                        strongSelf.groupModel?.setValue("1", forKey: "is_delete")
                        try? realm.commitWriteTransaction()
//                        RCIMClient.shared().clearMessages((strongSelf.conversationModel?.conversationType)!, targetId: strongSelf.conversationModel?.targetId)
//                        RCIMClient.shared().remove((strongSelf.conversationModel?.conversationType)!, targetId: strongSelf.conversationModel?.targetId)
                        strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                })
                
            }, cancleAction: { (action) in
                
            })
            
        }else{
            self.addAlertView(title: "您确定要退出该群组吗?", message: "", actionTitles: ["确定","取消"], okAction: { (action) in
                self.progressShow()
                GroupRequest.quit(params: ["app_token":sharePublicDataSingle.token,"groupid":self.groupModel?.groupid], hadToast: true, fail: { [weak self](error) in
                    if let strongSelf = self {
                        strongSelf.progressDismiss()
                    }
                }, success: { [weak self](dic) in
                    if let strongSelf = self{
                        strongSelf.progressDismiss()
                        let groupUserModel : GroupUserModel? = GroupUserModel.objects(with: NSPredicate(format:"userid == %@ AND groupid == %@", sharePublicDataSingle.publicData.userid,(strongSelf.groupModel?.groupid)!)).firstObject() as! GroupUserModel?
                        let realm:RLMRealm = RLMRealm.default()
                        realm.beginWriteTransaction()
                        groupUserModel?.setValue("1", forKey: "is_delete")
                        try? realm.commitWriteTransaction()
                        RCIMClient.shared().clearMessages(.ConversationType_GROUP, targetId: strongSelf.targetId)
                        RCIMClient.shared().remove(.ConversationType_GROUP, targetId: strongSelf.targetId)
                        strongSelf.navigationController?.popToRootViewController(animated: true)
                    }
                })
                
            }, cancleAction: { (action) in
                
            })
            
        }
    }
    //MARK: --------------------------- Getter and Setter --------------------------

    lazy var tableView: UITableView = {
        var tableView : UITableView = UITableView.init(frame: CGRect(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT))
        tableView.backgroundColor = UIColor.groupTableViewBackground
        tableView.dataSource  = self
        tableView.delegate    = self
        return tableView
    }()
}
//MARK: - UITableViewDataSource, UITableViewDelegate
extension GroupSettingViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArr[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && indexPath.row != 3 || indexPath.section == 1 && indexPath.row != 0 {
            let cell = GroupSettingWithArrowCell.cell(withTableView: tableView)
            if indexPath.section == 0 && indexPath.row == 2 {
                cell.selectionStyle = .none
            }else{
                cell.selectionStyle = .default
            }
            if indexPath.section == 0 && indexPath.row == 1 {
                cell.detailLabel.isHidden = false
                cell.detailImage.isHidden = true
            }else{
                cell.detailLabel.isHidden = false
                cell.detailImage.isHidden = true
            }
            if indexPath.section == 0 {
                cell.rightArrow.isHidden = true
            }else{
                cell.rightArrow.isHidden = false
            }
            
            cell.model = dataSourceArr[indexPath.section][indexPath.row]
            return cell
        }else{
            let cell = GroupSettingWithSwitchCell.cell(withTableView: tableView)
            cell.delegate = self
            cell.model = dataSourceArr[indexPath.section][indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 && indexPath.row == 3 {
//            let detailStr = (dataSourceArr[indexPath.section][indexPath.row] ).first?.value as! String?
//            if detailStr == "未设置" {
//                return 44
//            }else{
//                let height = ((detailStr?.getTextHeight(font: FONT_14, width: SCREEN_WIDTH - LEFT_PADDING_GS * 2 - 15))! + 0.4) > 60 ? 50.5 : ((detailStr?.getTextHeight(font: FONT_14, width: SCREEN_WIDTH - LEFT_PADDING_GS * 2 - 15))! + 0.4)
//                return 44 + height + 5
//            }
//        }else{
            return 44
//        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if is_owner! {
                    let groupNameEditVC = GroupNameEditViewController()
                    groupNameEditVC.groupModel = groupModel
                    self.navigationController?.pushViewController(groupNameEditVC, animated: true)
                }else{
                    self.addAlertView(title: "提示", message: "只有群主"+(ownUserModel != nil ? (ownUserModel?.realname)! : "")+"才能修改群组名称", actionTitles: ["确定"], okAction: { (okAlertAction) in
                        
                    }, cancleAction: { (cancleAlertAction) in
                        
                    })
                }
            case 1:
//                let groupQRCodeVC = GroupQRCodeViewController()
//                groupQRCodeVC.groupModel = groupModel
//                self.navigationController?.pushViewController(groupQRCodeVC, animated: true)
                break
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1:
                
                let chatContent = ChatContentSearchVC()
                chatContent.targetId = self.groupModel?.groupid
                self.navigationController?.pushViewController(chatContent, animated: true)
                
                
            default:
                break
            }
        default:
            break
        }
    }
}
//MARK: - GroupSettingTableViewHeaderDelegate
extension GroupSettingViewController : GroupSettingTableViewHeaderDelegate {

    func userItemDidClick(userId: String) {
        PublicPush().pushToUserInfo(imId: userId, userId: "", vc: self)
        DLog("点击了用户--userid == " + userId)
    }
    func addBtnDidClick() {
        let addMemeberVc = GroupMemberVC()
        // 数组 header.users 包含群组成员model
//        addMemeberVc.mem
        addMemeberVc.isAddMember = true
        addMemeberVc.groudId = groupModel?.groupid
        addMemeberVc.memberArray = header.users
        addMemeberVc.resultWithArray { [weak self]  (resultArray) in
            if let strongHSelf = self{
                strongHSelf.reloadHeaderData()
            }

        }
        
        self.present(addMemeberVc, animated: true, completion: nil)

    }
    func delBtnDidClick() {
        let addMemeberVc = GroupMemberVC()
        addMemeberVc.isAddMember = false
        addMemeberVc.groudId = groupModel?.groupid
        addMemeberVc.memberArray = header.users
        addMemeberVc.resultWithArray { [weak self]  (resultArray) in
            if let strongHSelf = self{

                strongHSelf.reloadHeaderData()
            }
            
        }

        self.present(addMemeberVc, animated: true, completion: nil)
    }
}

extension GroupSettingViewController : GroupSettingWithSwitchCellDelegate {
    
    func onClickSwitchButton(swich: UIButton, title: String) {
        switch title {
        case "群组开放性":
            self.progressShow()
            GroupRequest.setOpen(params: ["app_token":sharePublicDataSingle.token,"groupid":groupModel?.groupid,"is_open":swich.isSelected ? "0" : "1"], hadToast: true, fail: { [weak self](error) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                }
            }) { [weak self](dic) in
                if let strongSelf = self {
                    strongSelf.progressDismiss()
                    swich.isSelected = !swich.isSelected
                    let realm:RLMRealm = RLMRealm.default()
                    realm.beginWriteTransaction()
                    strongSelf.groupModel?.setValue(swich.isSelected ? "1" : "0", forKey: "is_open")
                    try? realm.commitWriteTransaction()

                }
            }
        case "置顶聊天":
            let setTopSuccess = RCIMClient.shared().setConversationToTop(.ConversationType_GROUP, targetId: targetId, isTop: !swich.isSelected)

            if setTopSuccess {
                swich.isSelected = !swich.isSelected
            }
        default:
            break
        }

    }
}
