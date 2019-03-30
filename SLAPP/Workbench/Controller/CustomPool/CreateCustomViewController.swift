//
//  CreateCustomViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//  创建客户

import UIKit
import SwiftyJSON
import Kingfisher

class CreateCustomViewController: BaseVC {
    
    fileprivate enum CellHeightEnum : CGFloat {
        
        case normal = 48
        case zero = 0
        
        var value : CGFloat {
            return self.rawValue
        }
    }
    
    fileprivate enum ActionSheetTypeEnum : Int {
        
        case belong = 100
        case more = 1000
        
        var value : Int {
            return self.rawValue
        }
    }
    
    enum MoreNameEnum : String {
        
        case count = "人员数"
        case fax = "传真"
        case email = "邮箱"
        case url = "网址"
        case postcode = "邮政编码"
        case capital = "注册资本"
        case remarks = "备注"
        
        var value : String {
            return self.rawValue
        }
    }
    
    var jsons : JSON?
    
    var areaView : AreaView?
    
    var poolIdString : String?
    
    var tradeModel : TradeModel?
    
    var customIdString : String?
    
    @objc var isFromPublicSea  = true
    
    var moreNameArray : [String] = []
    
    var belongPoolArray : [JSON] = []
    
    var constraintArray : [NSLayoutConstraint] = []
    
    var areaTuple : (areaIndex: Int, selectId: String) = (0, "")
    
    let shareView = CustomerShareCell(style: .default, reuseIdentifier: "cell")
    
    var areaIdTuple : (province: String, city: String, area: String) = ("", "", "")
    
    var provinceArray : NSMutableArray = []
    
    var cityArray : NSMutableArray = []
    
    var districtArray : NSMutableArray = []
    
    @IBOutlet weak var customNameLabel: UITextField!                    // 客户名
    
    @IBOutlet weak var customTradeLabel: UITextField!                   // 客户行业
    
    @IBOutlet weak var customPhoneTextField: UITextField!               // 客户电话
    
    @IBOutlet weak var customBelongPoolTextField: UITextField!          // 客户所属公海池
    
    // MARK: - 可选视图约束相关
    @IBOutlet weak var countHeightConstraint: NSLayoutConstraint!       // 员工数
    @IBOutlet weak var faxHeightConstraint: NSLayoutConstraint!         // 传真
    @IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!       // 邮箱
    @IBOutlet weak var urlHeightConstraint: NSLayoutConstraint!         // 网址
    @IBOutlet weak var postcodeHeightConstraint: NSLayoutConstraint!    // 邮编
    @IBOutlet weak var capitalHeightConstraint: NSLayoutConstraint!     // 资本
    @IBOutlet weak var remarksHeightConstraint: NSLayoutConstraint!     // 备注
    @IBOutlet weak var moreHeightConstraint: NSLayoutConstraint!        // 添加更多
    
    @IBOutlet weak var permissionsSettingsConstraint: NSLayoutConstraint! // 权限设置
    
    @IBOutlet weak var permissionsSettingsLabel: UILabel!
    @IBOutlet weak var permissionsSettingsBgView: UIView!
    
    // MARK: - 可选视图输入框相关
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var faxTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    
    @IBOutlet weak var moreButton: UIButton!
    
    
    
    var tapValue = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()

        self.initData()
    }
    
    @IBAction func btnClickFunc(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        switch sender.tag {
        case 1: // 客户
            self.selectCustomNameFunc()
        case 2: // 行业
            self.selectCustomTradeFunc()
        case 3: // 所属公海池
            self.selectCustomBelongPoolFunc()
        case 4: // 选择省市区
            self.selectAreaFunc()
        case 9: // 更多
            self.selectMoreFunc()
        default:
            break
        }
    }
    
    func selectCustomNameFunc() {
        
        let vc = HYSelectCompanyVC()
        vc.selectBlock = { [weak self] (companyName) -> Void in
            self?.customNameLabel.text = companyName
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectCustomTradeFunc() {
        
        let vc = ChooseTradeVC()
        vc.result = { [weak self] (tradeModel) -> Void in
            self?.tradeModel = tradeModel
            self?.customTradeLabel.text = "\(tradeModel.parent_name)-\(tradeModel.name)"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectCustomBelongPoolFunc() {
        
        guard self.tapValue == 0 else{
            return
        }
        
        self.tapValue = 1
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_CREATE_BELONG, params: ["token":userModel.token ?? ""], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            
            if let jsons = JSON(dict)["data"].array {
                
                self?.belongPoolArray.removeAll()
                
                var nameArray : [String] = []
                
                jsons.forEach({ (json) in
                    self?.belongPoolArray.append(json)
                    nameArray.append(json["name"].stringValue)
                })
                
                if nameArray.count > 0 {
                    
                    let actionSheet = LCActionSheet(title: "选择所属公海池", buttonTitles: nameArray, redButtonIndex: -1, delegate: self)
                    actionSheet?.tag = ActionSheetTypeEnum.belong.value
                    actionSheet?.show()
                }
                self?.tapValue = 0
            }
        }
    }
    
    func selectAreaFunc() {
        
        if self.areaView == nil {
            self.areaView = AreaView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
            self.areaView?.isHidden = true
            self.areaView?.address_delegate = self
            UIApplication.shared.keyWindow?.addSubview(areaView!)
        }
        
        switch self.areaTuple.areaIndex {
        case 0:
            self.areaView?.show()
            self.areaView?.provinceArray = self.provinceArray
        case 1:
            
            let array : NSMutableArray = []
            self.cityArray.forEach { (model) in
                if let model = model as? AddressAreaModel {
                    if model.parent == self.areaTuple.selectId {
                        array.add(model)
                    }
                }
            }

            self.areaView?.cityArray = array
        case 2:
            
            let array : NSMutableArray = []
            self.districtArray.forEach { (model) in
                if let model = model as? AddressAreaModel {
                    if model.parent == self.areaTuple.selectId {
                        array.add(model)
                    }
                }
            }
            
            self.areaView?.regionsArray = array
        default:
            self.areaTuple.areaIndex = 0
        }
    }
    
    func selectMoreFunc() {
        
        let actionSheet = LCActionSheet(title: "添加更多信息", buttonTitles: self.moreNameArray, redButtonIndex: -1, delegate: self)
        actionSheet?.tag = ActionSheetTypeEnum.more.value
        actionSheet?.show()
    }
    
    @objc func saveBtnClickFunc() {
        
        let andDruation : Float = 0.5
        
        if let text = self.customNameLabel.text {
            if text.trimSpace().isEmpty {
                self.toast(withText: "客户名称不能为空", andDruation: andDruation)
                return
            }
        }
        
        if let text = self.customTradeLabel.text {
            if text.trimSpace().isEmpty {
                self.toast(withText: "请选择客户行业", andDruation: andDruation)
                return
            }
        }
        
        if let text = self.customBelongPoolTextField.text {
            if text.trimSpace().isEmpty {
                self.toast(withText: "请选择客户所属公海池", andDruation: andDruation)
                return
            }
        }
        
        if self.title == "编辑客户" {
            self.saveRequestFunc()
            return
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "仅保存", style: .default, handler: { (defaultAlert) in
            self.saveRequestFunc()
        }))
        
        alertController.addAction(UIAlertAction(title: "保存并新建联系人", style: .default, handler: { (defaultAlert) in
            self.saveRequestFunc(isJustSave: false)
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveRequestFunc(isJustSave:Bool = true) {
        
        let userModel = UserModel.getUserModel()
        
        var params : [String: String] = [:]
        
        params["client_name"] = self.customNameLabel.text?.trimSpace()  // 客户名称
        params["trade_id"] = self.tradeModel?.index_id                  // 行业id
        params["trade_name"] = self.tradeModel?.name                    // 行业名称
        params["phone"] = self.customPhoneTextField.text?.trimSpace()   // 客户联系方式
        params["staff_number"] = self.countTextField.text?.trimSpace()  // 人员数
        params["fax"] = self.faxTextField.text?.trimSpace()             // 传真
        params["email"] = self.emailTextField.text?.trimSpace()         // 邮箱
        params["url"] = self.urlTextField.text?.trimSpace()             // 网址
        params["registered_capital"] = self.capitalTextField.text?.trimSpace() // 注册资金
        params["postcode"] = self.postcodeTextField.text?.trimSpace()   // 邮编
        params["site"] = self.addressTextField.text?.trimSpace()        // 地址
        params["client_details"] = self.remarksTextField.text?.trimSpace() // 备注
        params["province"] = self.areaIdTuple.province                  // 省份
        params["city"] = self.areaIdTuple.city                          // 城市
        params["area"] = self.areaIdTuple.area                          // 区域
        params["gonghai_id"] = self.poolIdString                        // 公海id
        params["gonghai_name"] = self.customBelongPoolTextField.text?.trimSpace() // 公海名
        params["token"] = userModel.token ?? ""                         // token
        
        if !isFromPublicSea {
            
            let selectTuple = shareView.resultParams()
            print("*** selectTuple = \(selectTuple)")
            params["authorization_corp"] = selectTuple.all              // 是否是全公司都有
            params["authorization_deps"] = selectTuple.dep              // 权限部门以逗号隔开
            params["authorization_member"] = selectTuple.mem            // 权限人员以逗号隔开
        }
        
        if self.jsons != nil {
            params["client_id"] = self.customIdString                   // 公海id
        }
        
        var url = ""
        if isFromPublicSea {
            if self.jsons != nil { // 修改
                url = CUSTOM_POOL_CREATE_UPDATE
            } else { // 添加
                url = CUSTOM_POOL_CREATE_CUSTOM
            }
        } else {
            if self.jsons != nil { // 修改
                url = CUSTOM_POOL_CREATE_PRIVATE_UPDATE
            } else { // 添加
                url = CUSTOM_POOL_CREATE_PRIVATE_CUSTOM
            }
        }
        
        print("*** params = \(params), url = \(url)")
        
        LoginRequest.getPost(methodName: url, params: params, hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            
            if isJustSave {
                self?.navigationController?.popViewController(animated: true)
            } else {
                
                var contactInfo : [String:Any] = [:]
                
                contactInfo["client_id"] = self?.customIdString ?? JSON(dict)["id"].string
                contactInfo["client_name"] = self?.customNameLabel.text?.trimSpace()
//                contactInfo["email"] = self?.emailTextField.text?.trimSpace()
//                contactInfo["addr"] = self?.addressTextField.text?.trimSpace()
//                contactInfo["more"] = self?.remarksTextField.text?.trimSpace()
//                contactInfo["phone_arr"] = [self?.customPhoneTextField.text?.trimSpace()]
                
                print("*** contactInfo = \(contactInfo)")
                
                let vc = HYAddContactVC()
                vc.indentifier = "保存并新建"
                vc.contactInfo = contactInfo
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func addSaveBarButtonItemFunc() {
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchBtn.setTitle("保存", for: .normal)
        searchBtn.addTarget(self, action: #selector(saveBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
    }
    
    func initAreaDataFunc() {
        
        if let url = R.file.addressJson(), let data = try? Data(contentsOf: url) {
            
            if let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                
                let addressJson = JSON(jsonData)
                
                addressJson["province"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.provinceArray.add(model)
                    }
                }
                
                addressJson["city"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.cityArray.add(model)
                    }
                }
                
                addressJson["district"].arrayValue.forEach { (json) in
                    if let model = AddressAreaModel(json.dictionaryObject) {
                        self.districtArray.add(model)
                    }
                }
            }
        }
    }
    
    func initPermissionsSettingsFunc() {
        
        if self.isFromPublicSea {
            self.permissionsSettingsLabel.isHidden = true
            self.permissionsSettingsConstraint.constant = 0
        } else {
            shareView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 170)
            shareView.frameHeightChanged = { [weak shareView, weak permissionsSettingsConstraint] (height) in
                shareView?.height = height
                permissionsSettingsConstraint?.constant = height
            }
            
            self.permissionsSettingsBgView.addSubview(self.shareView)
        }
    }
    
    func initEditDataFunc() {
        
        if let jsons = self.jsons {
            
            // MARK: - BASE
            if let basic = jsons["basic"].dictionary {
                
                // 客户名
                if let value = basic["client_name"]?.string {
                    self.customNameLabel.text = value
                }
                
                // 行业
                if let value = basic["trade_name"]?.string, let id = basic["trade_id_two"]?.string {
                    
                    self.customTradeLabel.text = value
                    
                    self.tradeModel = TradeModel()
                    self.tradeModel?.index_id = id
                    self.tradeModel?.name = value
                }
                
                // 电话
                if let value = basic["phone"]?.string, value != "" {
                    self.customPhoneTextField.text = value
                }
                
                // 所属
                if let value = basic["gonghai_name"]?.string, let id = basic["gonghai"]?.string {
                    self.customBelongPoolTextField.text = value
                    self.poolIdString = id
                }
                
                // 员工数
                if let value = basic["staff_number"]?.string, value != "" {
                    self.countTextField.text = value
                    self.countHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.count.value)
                    self.constraintArray.remove(self.countHeightConstraint)
                }
                
                // 传真
                if let value = basic["fax"]?.string, value != "" {
                    self.faxTextField.text = value
                    self.faxHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.fax.value)
                    self.constraintArray.remove(self.faxHeightConstraint)
                }
                
                // 邮件
                if let value = basic["email"]?.string, value != "" {
                    self.emailTextField.text = value
                    self.emailHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.email.value)
                    self.constraintArray.remove(self.emailHeightConstraint)
                }
                
                // 网址
                if let value = basic["url"]?.string, value != "" {
                    self.urlTextField.text = value
                    self.urlHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.url.value)
                    self.constraintArray.remove(self.urlHeightConstraint)
                }
                
                // 邮编
                if let value = basic["postcode"]?.string, value != "" {
                    self.postcodeTextField.text = value
                    self.postcodeHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.postcode.value)
                    self.constraintArray.remove(self.postcodeHeightConstraint)
                }
                
                // 资本
                if let value = basic["registered_capital"]?.string, value != "" {
                    self.capitalTextField.text = value
                    self.capitalHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.capital.value)
                    self.constraintArray.remove(self.capitalHeightConstraint)
                }
                
                // 备注
                if let value = basic["note"]?.string, value != "" {
                    self.remarksTextField.text = value
                    self.remarksHeightConstraint.constant = CellHeightEnum.normal.value
                    self.moreNameArray.remove(MoreNameEnum.remarks.value)
                    self.constraintArray.remove(self.remarksHeightConstraint)
                }
            }
            
            // MARK: - SITE
            if let site = jsons["site"].dictionary {
                
                if let value = site["dir"]?.string {
                    self.areaTextField.text = value
                }
                
                if let value = site["place"]?.string, let province = site["province_id"]?.string, let city = site["city_id"]?.string, let area = site["area_id"]?.string {
                    self.addressTextField.text = value
                    self.areaIdTuple = (province, city, area)
                }
            }
            
            if jsons["authorization_corp"].string == "0" && jsons["authorization_deps"].string == "" && jsons["authorization_member"].int == 1 {
                self.shareView.nameLable.configTag(tag: 0)
            } else if jsons["authorization_corp"].string == "1" {
                self.shareView.nameLable.configTag(tag: 1)
            } else {
                
                var dataArray : [[String:[BaseModel]]] = []
                
                var dArray : [DepModel] = []
                
                var mArray : [DepMemberModel] = []
                
                for dic in jsons["client_dep"].arrayValue {
                    let model = DepModel()
                    model.id = dic["id"].stringValue
                    model.name = dic["name"].stringValue
                    dArray.append(model)
                }
                
                for dic in jsons["client_member"].arrayValue {
                    let model = DepMemberModel()
                    model.id = dic["id"].stringValue
                    model.head = dic["head"].stringValue
                    model.realname = dic["realname"].stringValue
                    mArray.append(model)
                }
                
                dataArray.append(["dep":dArray])
                dataArray.append(["mem":mArray])
                
                self.shareView.dataArray = dataArray
                self.shareView.nameLable.configTag(tag: 2)
            }
        }
    }
    
    func initData() {
        
        self.countHeightConstraint.constant = 0
        self.faxHeightConstraint.constant = 0
        self.emailHeightConstraint.constant = 0
        self.urlHeightConstraint.constant = 0
        self.postcodeHeightConstraint.constant = 0
        self.capitalHeightConstraint.constant = 0
        self.remarksHeightConstraint.constant = 0
        
        self.moreNameArray = [MoreNameEnum.count.value, MoreNameEnum.fax.value, MoreNameEnum.email.value, MoreNameEnum.url.value, MoreNameEnum.postcode.value, MoreNameEnum.capital.value, MoreNameEnum.remarks.value]
        self.constraintArray = [self.countHeightConstraint, self.faxHeightConstraint, self.emailHeightConstraint, self.urlHeightConstraint, self.postcodeHeightConstraint, self.capitalHeightConstraint, self.remarksHeightConstraint]
        
        self.initAreaDataFunc()
        
        self.initEditDataFunc()
    }
    
    func initView() {
        
        if self.jsons == nil {
            self.title = "创建客户"
        } else {
            self.title = "编辑客户"
        }
        
        self.addSaveBarButtonItemFunc()
        
        self.initPermissionsSettingsFunc()
    }

}

// MARK: - 代理相关
extension CreateCustomViewController : LCActionSheetDelegate, AreaSelectDelegate {
    
    func select(_ index: Int, selectID areaID: String!) {
        
        self.areaTuple = (index, areaID)
        self.selectAreaFunc()
        
        switch index {
        case 1:
            self.areaIdTuple.province = areaID
        case 2:
            self.areaIdTuple.city = areaID
        case 3:
            self.areaIdTuple.area = areaID
        default:
            break
        }
    }
    
    func getSelectAddressInfor(_ addressInfor: String!) {
        
        self.areaTuple.areaIndex = 0
        
        if self.areaIdTuple.area != "" {
            self.areaTextField.text = addressInfor
        }
    }
    
    func moreActionSheetFunc(buttonIndex:Int) {
        
        guard buttonIndex < self.constraintArray.count else {
            return
        }
        
        let constraint = self.constraintArray[buttonIndex]
        constraint.constant = CellHeightEnum.normal.value
        self.moreNameArray.remove(at: buttonIndex)
        self.constraintArray.remove(at: buttonIndex)
        
        if self.moreNameArray.isEmpty {
            self.moreHeightConstraint.constant = 0
            self.moreButton.isHidden = true
        }
    }
    
    func belongActionSheetFunc(buttonIndex:Int) {
        if buttonIndex < self.belongPoolArray.count {
            let json = self.belongPoolArray[buttonIndex]
            self.customBelongPoolTextField.text = json["name"].stringValue
            self.poolIdString = json["id"].stringValue
        }
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        switch actionSheet.tag {
        case ActionSheetTypeEnum.belong.value:
            self.belongActionSheetFunc(buttonIndex: buttonIndex)
        case ActionSheetTypeEnum.more.value:
            self.moreActionSheetFunc(buttonIndex: buttonIndex)
        default:
            break
        }
    }
}
