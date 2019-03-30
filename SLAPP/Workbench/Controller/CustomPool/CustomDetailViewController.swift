//
//  CustomDetailViewController.swift
//  SLAPP
//
//  Created by fank on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户详情

import UIKit
import SwiftyJSON

class CustomDetailViewController: BaseVC {
    
    fileprivate enum CellHeightEnum : CGFloat {
        
        case normal = 48
        case remarks = 68
        case zero = 0
        
        var value : CGFloat {
            return self.rawValue
        }
    }
    
    enum PrivateSeaMoreTypeEnum : Int {
        
        case change = 0
        case back = 1
        case unKnown = -1
        
        init(type: Int) {
            switch type {
            case 0: self = .change
            case 1: self = .back
            default: self = .unKnown
            }
        }
        
        var value : Int {
            return self.rawValue
        }
        
        func description() -> String {
            switch self {
            case .change:
                return "更换负责人"
            case .back:
                return "退回公海"
            case .unKnown:
                return ""
            }
        }
    }
    
    var jsons : JSON?
    
    @objc var isPublicSea = true
    
    @objc var customIdString : String?
    
    var customNameString : String?
    
    var clientMap : [String:String] = [:]
    
    var contactInfo : [String:Any] = [:]
    
    var sendBackArray : [MemberModel] = []
    
    var authTuple : (isAllot: Bool, isSendBack: Bool, isGet: Bool, isDel: Bool, isRecover: Bool) = (false, false, false, false, false)
    var buttons = [String]()
    
    // MARK: - 可选视图约束
    @IBOutlet weak var urlHeightConstraint: NSLayoutConstraint!         // 网址
    @IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!       // 邮箱
    @IBOutlet weak var phoneHeightConstraint: NSLayoutConstraint!       // 电话
    @IBOutlet weak var faxHeightConstraint: NSLayoutConstraint!         // 传真
    @IBOutlet weak var countHeightConstraint: NSLayoutConstraint!       // 员工数
    @IBOutlet weak var postcodeHeightConstraint: NSLayoutConstraint!    // 邮编
    @IBOutlet weak var capitalHeightConstraint: NSLayoutConstraint!     // 资本
    @IBOutlet weak var remarksHeightConstraint: NSLayoutConstraint!     // 备注
    
    // MARK: - 顶部信息
    @IBOutlet weak var topNameLabel: UILabel!                           // 客户名
    @IBOutlet weak var topResponsibleLabel: UILabel!                    // 负责
    @IBOutlet weak var topFollowUpLabel: UILabel!                       // 跟进
    @IBOutlet weak var topBelongLabel: UILabel!                         // 所属
    @IBOutlet weak var topRelationLabel: UILabel!                       // 关联项目
    @IBOutlet weak var topProjectTotalLabel: UILabel!                   // 项目总额
    @IBOutlet weak var topBackTotalLabel: UILabel!                      // 回款总额
    @IBOutlet weak var topParticipantsLabel: UILabel!                   // 参与人
    @IBOutlet weak var topContactsLabel: UILabel!                       // 联系人
    
    // MARK: - 基础信息
    @IBOutlet weak var baseNameLabel: UITextField!                      // 客户
    @IBOutlet weak var baseTradeLabel: UITextField!                     // 行业
    @IBOutlet weak var baseURLLabel: UITextField!                       // 网址
    @IBOutlet weak var baseEmailLabel: UITextField!                     // 邮箱
    @IBOutlet weak var basePhoneLabel: UITextField!                     // 电话
    @IBOutlet weak var baseFaxLabel: UITextField!                       // 传真
    @IBOutlet weak var baseCountLabel: UITextField!                     // 员工数
    @IBOutlet weak var basePostcodeLabel: UITextField!                  // 邮编
    @IBOutlet weak var baseCapitalLabel: UITextField!                   // 资本
    @IBOutlet weak var baseRemarksLabel: UILabel!                       // 备注
    
    @IBOutlet weak var areaLabel: UITextField!                          // 区域
    @IBOutlet weak var addressLabel: UITextField!                       // 地址
    
    // MARK: - 系统信息
    @IBOutlet weak var sysFollowUpLabel: UITextField!                   // 最新跟进
    @IBOutlet weak var sysRecycleLabel: UITextField!                    // 回收时限
    @IBOutlet weak var sysResponsibleLabel: UITextField!                // 负责
    @IBOutlet weak var sysDepartmentLabel: UITextField!                 // 部门
    @IBOutlet weak var sysCreateLabel: UITextField!                     // 创建人
    @IBOutlet weak var sysModifyLabel: UITextField!                     // 修改人
    @IBOutlet weak var sysAllocationLabel: UITextField!                 // 分配人
    @IBOutlet weak var sysCreateTimeLabel: UITextField!                 // 创建时间
    @IBOutlet weak var sysModifyTimeLabel: UITextField!                 // 修改时间
    @IBOutlet weak var sysAllocTimeLabel: UITextField!                  // 分配时间
    @IBOutlet weak var sysSellTimesLabel: UITextField!                  // 转手次数
    @IBOutlet weak var sysBackReasonLabel: UITextField!                 // 退回理由

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
        self.initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    @IBAction func btnClickFunc(_ sender: UIButton) {
        
        switch sender.tag {
        case 1: // 参与人
            self.pushToParticipantsVCFunc()
        case 2: // 联系人
            self.pushToContactsVCFunc()
        case 3: // 项目
            self.pushToProjectsVCFunc()
        case 4: // 跟进
            self.pushToFollowUpVCFunc()
        case 5: // 拜访
            self.pushToVisitVCFunc()
        case 6: // 更多
            self.alertMoreActionSheetFunc()
        default:
            break
        }
    }
    
    // MARK: - 页面跳转
    // MARK: 跳转参与人列表页
    func pushToParticipantsVCFunc() {
        if let vc = R.storyboard.customPool.customDetailPersonsViewController() {
            vc.isContacts = false
            vc.isPublicSea = self.isPublicSea
            vc.customIdString = self.customIdString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: 跳转联系人列表页
    func pushToContactsVCFunc() {
        if let vc = R.storyboard.customPool.customDetailPersonsViewController() {
            vc.isPublicSea = self.isPublicSea
            vc.contactInfo = self.contactInfo
            vc.customIdString = self.customIdString
            vc.customNameString = self.customNameString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: 跳转项目页
    func pushToProjectsVCFunc() {
        
        self.clientMap["modifiTag"] = "1"
        
        let vc = HYClientProjectsVC()
        vc.clientId = self.customIdString
        vc.model = HYClientModel(dictionary: self.clientMap)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 跳转跟进页
    func pushToFollowUpVCFunc() {
        let vc = CustomerFollowUpVC()
        vc.customerId = self.customIdString
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: 跳转拜访页
    func pushToVisitVCFunc() {
      let vc =  HYClientAndContactsVisitListVC()
        vc.clientId = self.customIdString ?? ""
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func alertMoreActionSheetFunc() {
        
        var actionSheet : LCActionSheet?
        
        if isPublicSea {
            
            var buttonTitles : [String] = []
            
            if self.authTuple.isRecover {
                buttonTitles.append(OperateCustomTypeEnum.description(.recover)())
            } else {
                if self.authTuple.isGet {
                    buttonTitles.append(OperateCustomTypeEnum.description(.get)())
                }
                
                if self.authTuple.isAllot {
                    buttonTitles.append(OperateCustomTypeEnum.description(.alloc)())
                }
                
                if self.authTuple.isDel {
                    buttonTitles.append(OperateCustomTypeEnum.description(.delete)())
                }
            }
            
            actionSheet = LCActionSheet(title: "更多操作", buttonTitles: buttonTitles, redButtonIndex: -1, delegate: self)
            buttons = buttonTitles
            actionSheet?.tag = ActionSheetTypeEnum.operate.value
            actionSheet?.show()
        } else {
            
            var buttonTitles : [String] = []
            
            if self.authTuple.isAllot {
                buttonTitles.append(PrivateSeaMoreTypeEnum.description(.change)())
            }
            
            if self.authTuple.isSendBack {
                buttonTitles.append(PrivateSeaMoreTypeEnum.description(.back)())
            }
            
            if buttonTitles.count == 0 {
                self.toast(withText: "暂无更多操作")
                return
            }
            
            actionSheet = LCActionSheet(title: "更多操作", buttonTitles: buttonTitles, redButtonIndex: -1, delegate: self)
            actionSheet?.tag = ActionSheetTypeEnum.create.value
            actionSheet?.show()
        }
    }
    
    @objc func editBtnClickFunc() {
        if let vc = R.storyboard.customPool.createCustomViewController() {
            vc.jsons = self.jsons
            vc.isFromPublicSea = self.isPublicSea
            vc.customIdString = self.customIdString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addEditBarButtonItemFunc() {
        
        let editBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        editBtn.setTitle("编辑", for: .normal)
        editBtn.addTarget(self, action: #selector(editBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
    }
    
    func loadData() {
        
        guard self.customIdString != nil else {
            PublicMethod.toastWithText(toastText: "客户id不存在")
            return
        }
        
        let userModel = UserModel.getUserModel()
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: CUSTOM_POOL_CUSTOM_DETAIL, params: ["token":userModel.token ?? "", "id":self.customIdString!], hadToast: true, fail: { (dict) in
            PublicMethod.dismissWithError()
        }) { [weak self] (dict) in
            
            PublicMethod.dismiss()
            
            let jsons = JSON(dict)
            print("*** jsons = \(jsons)")
            
            self?.jsons = jsons
            
            // MARK: - TOP
            if let head = jsons["head"].dictionary {
                
                // 负责
                if let value = head["user_name"]?.string {
                    self?.topResponsibleLabel.text = "负责：\(value)"
                }
                
                // 跟进
                if let value = head["fo_addtime_str"]?.string {
                    self?.topFollowUpLabel.text = "跟进：\(value)"
                }
                
                // 所属
                if let value = head["gonghai_name"]?.string {
                    self?.topBelongLabel.text = "所属：\(value)"
                }
                
                // 关联项目
                if let value = head["project_count"]?.int {
                    self?.topRelationLabel.text = "关联项目：\(value)个"
                }
                
                // 项目总额
                if let value = head["amount"]?.string {
                    self?.topProjectTotalLabel.text = "项目总额：\(value)万"
                }
                
                // 回款总额
                if let value = head["returned_money"]?.string {
                    self?.topBackTotalLabel.text = "回款总额：\(value)万"
                }
                
                // 参与人
                if let value = head["participant_count"]?.string {
                    self?.topParticipantsLabel.text = "我方参与人：\(value)个"
                }
                
                // 联系人
                if let value = head["contact_count"]?.string {
                    self?.topContactsLabel.text = "客户联系人：\(value)个"
                }
            }
            
            // MARK: - BASE
            if let basic = jsons["basic"].dictionary {
                
                // 客户名
                if let value = basic["client_name"]?.string {
                    self?.topNameLabel.text = value
                    self?.baseNameLabel.text = value
                    self?.customNameString = value
                    
                    self?.contactInfo["client_name"] = value
                    self?.contactInfo["client_id"] = self?.customIdString
                    
                    self?.clientMap["name"] = value
                    self?.clientMap["Id"] = self?.customIdString
                }
                
                // 行业
                if let value = basic["trade_name"]?.string {
                    self?.baseTradeLabel.text = value
                    self?.clientMap["trade_name"] = value
                }
                
                if let value = basic["trade_id_two"]?.string {
                    if value.isEmpty {
                        if let value = basic["trade_id_one"]?.string {
                            self?.clientMap["trade_id"] = value
                        }
                    } else {
                        self?.clientMap["trade_id"] = value
                    }
                }
                
                // 网址
                if let value = basic["url"]?.string, value != "" {
                    self?.baseURLLabel.text = value
                    self?.urlHeightConstraint.constant = CellHeightEnum.normal.value
                }
                
                // 邮箱
                if let value = basic["email"]?.string, value != "" {
                    self?.baseEmailLabel.text = value
//                    self?.contactInfo["email"] = value
                    self?.emailHeightConstraint.constant = CellHeightEnum.normal.value
                }
                
                // 电话
                if let value = basic["phone"]?.string, value != "" {
                    self?.basePhoneLabel.text = value
//                    self?.contactInfo["phone_arr"] = [value]
                    self?.phoneHeightConstraint.constant = CellHeightEnum.normal.value
                }
                
                // 传真
                if let value = basic["fax"]?.string, value != "" {
                    self?.baseFaxLabel.text = value
                    self?.faxHeightConstraint.constant = CellHeightEnum.normal.value
                }
                
                // 员工数
                if let value = basic["staff_number"]?.string, value != "" {
                    self?.baseCountLabel.text = value + "人"
                    self?.countHeightConstraint.constant = CellHeightEnum.normal.value
                }

                // 邮编
                if let value = basic["postcode"]?.string, value != "" {
                    self?.basePostcodeLabel.text = value
                    self?.postcodeHeightConstraint.constant = CellHeightEnum.normal.value
                }

                // 资本
                if let value = basic["registered_capital"]?.string, value != "" {
                    self?.baseCapitalLabel.text = value + "万"
                    self?.capitalHeightConstraint.constant = CellHeightEnum.normal.value
                }
                
                // 备注
                if let value = basic["note"]?.string, value != "" {
                    
                    self?.baseRemarksLabel.text = value
//                    self?.contactInfo["more"] = value
                    
                    let size = value.sizeWithText(text: value, font: SystemFont14, maxSize: CGSize(width: SCREEN_WIDTH - 85 - 10, height: CGFloat.greatestFiniteMagnitude))
                    
                    if size.height > 20 {
                        self?.remarksHeightConstraint.constant = CellHeightEnum.remarks.value
                    } else {
                        self?.remarksHeightConstraint.constant = CellHeightEnum.normal.value
                    }
                }
            }
            
            // MARK: - SITE
            if let site = jsons["site"].dictionary {
                
                if let value = site["dir"]?.string {
                    self?.areaLabel.text = value
                }
                
                if let value = site["place"]?.string {
                    self?.addressLabel.text = value
//                    self?.contactInfo["addr"] = value
                }
            }
            
            // MARK: - INFO
            if let system = jsons["system"].dictionary {
                
                // 最新跟进
                if let value = system["newest_followup_time_str"]?.string {
                    self?.sysFollowUpLabel.text = value
                }
                
                // 回收时限
                if let value = system["shixian"]?.string {
                    self?.sysRecycleLabel.text = value
                }
                
                // 负责
                if let value = system["user_realname"]?.string {
                    self?.sysResponsibleLabel.text = value
                }
                
                // 部门
                if let value = system["dep_name"]?.string {
                    self?.sysDepartmentLabel.text = value
                }
                
                // 创建人
                if let value = system["create_name"]?.string {
                    self?.sysCreateLabel.text = value
                }
                
                // 修改人
                if let value = system["save_name"]?.string {
                    self?.sysModifyLabel.text = value
                }
                
                // 分配人
                if let value = system["fenpei_name"]?.string {
                    self?.sysAllocationLabel.text = value
                }
                
                // 创建时间
                if let value = system["addtime_str"]?.string {
                    self?.sysCreateTimeLabel.text = value
                }
                
                // 修改时间
                if let value = system["edittime_str"]?.string {
                    self?.sysModifyTimeLabel.text = value
                }
                
                // 分配时间
                if let value = system["fenpei_time_str"]?.string {
                    self?.sysAllocTimeLabel.text = value
                }
                
                // 转手次数
                if let value = system["send_back_count"]?.string {
                    self?.sysSellTimesLabel.text = value
                }
                
                // 退回理由
                if let value = system["reason"]?.string {
                    self?.sysBackReasonLabel.text = value
                }
            }
            
            // MARK: - JURISDICTION
            if let jurisdiction = jsons["jurisdiction"].dictionary {
                
                // 编辑
                if let value = jurisdiction["save_client"]?.int, value == 1 {
                    self?.addEditBarButtonItemFunc()
                }
                
                // 更换负责人
                if let value = jurisdiction["allot"]?.int, value == 1 {
                    self?.authTuple.isAllot = true
                }
                
                // 退回公海
                if let value = jurisdiction["send_back"]?.int, value == 1 {
                    self?.authTuple.isSendBack = true
                }
                
                // 领取
                if let value = jurisdiction["get"]?.int, value == 1 {
                    self?.authTuple.isGet = true
                }
                
                // 删除
                if let value = jurisdiction["del"]?.int, value == 1 {
                    self?.authTuple.isDel = true
                }
                
                // 删除
                if let value = jurisdiction["recover"]?.int, value == 1 {
                    self?.authTuple.isRecover = true
                }
            }
        }
    }
    
    func initData() {
        
        self.urlHeightConstraint.constant = CellHeightEnum.zero.value
        self.emailHeightConstraint.constant = CellHeightEnum.zero.value
        self.phoneHeightConstraint.constant = CellHeightEnum.zero.value
        self.faxHeightConstraint.constant = CellHeightEnum.zero.value
        self.countHeightConstraint.constant = CellHeightEnum.zero.value
        self.postcodeHeightConstraint.constant = CellHeightEnum.zero.value
        self.capitalHeightConstraint.constant = CellHeightEnum.zero.value
        self.remarksHeightConstraint.constant = CellHeightEnum.zero.value
    }
    
    func initView() {
        
        self.title = "客户详情"
    }

}

// MARK: - 代理相关
extension CustomDetailViewController : LCActionSheetDelegate {
    
    func alertChangeResponsibleFunc() {
        
        let alertController = UIAlertController(title: nil, message: "该客户下的项目有多个负责人，无法退回到公海，如要不再负责该客户，请直接更换负责人", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.darkGray
        
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "更换", style: .default, handler: { (_) in
            self.pushToSelectMemberVCFunc(tag: 2)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendBackRequestFunc(text:String) {
        
        self.showProgress(withStr: "正在加载中...")
        
        LoginRequest.getPost(methodName: CUSTOM_POOL_CUSTOM_DETAIL_SEND_BACK, params: ["token":UserModel.getUserModel().token ?? "", "client_id":self.customIdString ?? "", "reason":text], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            print("*** = \(dict)")
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func sendBeforeBackRequestFunc() {
        
//        self.showProgress(withStr: "正在加载中...")
        
        LoginRequest.getPost(methodName: CUSTOM_POOL_CUSTOM_DETAIL_BEFORE_SEND_BACK, params: ["token":UserModel.getUserModel().token ?? "", "client_id":self.customIdString ?? ""], hadToast: true, fail: { (dict) in
//            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
//            self?.showDismiss()
            
            print("*** = \(dict)")
            
            if let jsons = JSON(dict)["list"].array {
                
                if jsons.count > 0 {
                    
                    self?.sendBackArray.removeAll()
                    
                    jsons.forEach({ (json) in
                        self?.sendBackArray.append(MemberModel.memberModel(json: json))
                    })
                    
                    self?.alertChangeResponsibleFunc()
                } else {
                    self?.alertBackReasonFunc()
                }
            }
        }
    }
    
    func alertBackReasonFunc() {
        
        // MARK: 弹出之前就去请求接口查看是否有多个负责人，如果是，在点确定按钮时再弹出提示框
        
        let alertController = UIAlertController(title: nil, message: "退回理由", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.darkGray
        
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入退回理由"
        }
        
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { [weak alertController] (_) in
            print("*** value is \(alertController!.textFields!.first!.text!)")
            
            if let text = alertController?.textFields?.first?.text, !text.trimSpace().isEmpty {
                self.sendBackRequestFunc(text: text)
            } else {
                self.present(alertController!, animated: true, completion: {
                    PublicMethod.toastWithText(toastText: "请输入退回理由")
                })
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func privateSeaMoreFunc(type:PrivateSeaMoreTypeEnum) {
        
        if self.authTuple.isAllot {
            if self.authTuple.isSendBack {
                switch type {
                case .change:
                    self.pushToSelectMemberVCFunc(tag: 3)
                case .back:
                    self.sendBeforeBackRequestFunc()
                default:
                    break
                }
            } else {
                switch type {
                case .change:
                    self.pushToSelectMemberVCFunc(tag: 3)
                default:
                    break
                }
            }
        } else {
            switch type {
            case .change:
                self.sendBeforeBackRequestFunc()
            default:
                break
            }
        }
    }
    
    func deleteFunc() {
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_DELETE, params: ["token":userModel.token ?? "", "client_id_str":self.customIdString!], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            PublicMethod.dismissWithSuccessCompletion(str: "操作成功", completion: {
                self?.navigationController?.popViewController(animated: false)
            })
        }
    }
    
    func getAndAllocFunc(tag:Int = 0, idString: String = "") {
        
        print("*** client_id_str = \(self.customIdString!), status = \(tag)")
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_ALLOC_GET, params: ["token":UserModel.getUserModel().token ?? "", "status":tag.description, "client_id_str":self.customIdString!, "member_id":idString], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            print((dict))
            PublicMethod.dismissWithSuccessCompletion(str: "操作成功", completion: {
                self?.navigationController?.popViewController(animated: false)
            })
        }
    }
    
    func pushToSelectMemberVCFunc(tag:Int = 1) {
        
        let vc = HYColleaguesVC()
        vc.isSingle = true
        vc.singleSelectClosure = { (id) in
            self.getAndAllocFunc(tag: tag, idString: id)
        }
        
        if !self.sendBackArray.isEmpty { vc.dataArray = self.sendBackArray }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resumeBtnClickFunc() {
        
        guard self.customIdString != nil else {
            return
        }
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_RECYCLE_RESUME, params: ["token":userModel.token ?? "", "client_id_str":self.customIdString!], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func publicSeaMoreFunc(type:OperateCustomTypeEnum) {
        
        guard self.customIdString != nil else {
            PublicMethod.toastWithText(toastText: "客户id不存在")
            return
        }
        
        if self.authTuple.isRecover {
            self.resumeBtnClickFunc()
        } else {
            if self.authTuple.isAllot {
                switch type {
                case .get:
                    self.getAndAllocFunc()
                case .alloc:
                    self.pushToSelectMemberVCFunc()
                case .delete:
                    self.deleteFunc()
                default:
                    break
                }
            } else {
                switch type {
                case .get:
                    self.getAndAllocFunc()
                case .alloc:
                    self.deleteFunc()
                default:
                    break
                }
            }
        }
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        
        print(actionSheet.tag,buttonIndex)
        if actionSheet.tag==100 {
             if buttonIndex==buttons.count{return}
        }
       
       
        switch actionSheet.tag {
        case ActionSheetTypeEnum.operate.value:
            self.publicSeaMoreFunc(type: OperateCustomTypeEnum(type: buttonIndex))
        case ActionSheetTypeEnum.create.value:
            self.privateSeaMoreFunc(type: PrivateSeaMoreTypeEnum(type: buttonIndex))
        default:
            break
        }
    }
}
