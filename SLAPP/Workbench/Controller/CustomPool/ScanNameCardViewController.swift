//
//  ScanNameCardViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/30.
//  Copyright © 2018年 柴进. All rights reserved.
//  扫名片

import UIKit
import SwiftyJSON

class ScanNameCardViewController: BaseVC {
    
    enum GenderTypeEnum : Int {
        
        case man = 0
        case female = 1
        case unKnown = 9
        
        init(type: Int) {
            switch type {
            case 0: self = .man
            case 1: self = .female
            default: self = .unKnown
            }
        }
        
        var value : Int {
            return self.rawValue
        }
        
        func description() -> String {
            switch self {
            case .man:
                return "男"
            case .female:
                return "女"
            case .unKnown:
                return ""
            }
        }
    }
    
    fileprivate enum MoreNameEnum : String {
        
        case name = "姓名"
        case title = "职位"
        case dep = "部门"
        case gender = "性别"
        case brithday = "生日"
        case phone = "手机"
        case wechat = "微信"
        case qq = "QQ"
        case email = "邮件"
        case address = "地址"
        case postcode = "邮编"
        case remarks = "备注"
        
        var value : String {
            return self.rawValue
        }
    }
    
    fileprivate enum CellHeightEnum : CGFloat {
        
        case normal = 48
        case phone = 120
        case zero = 0
        
        var value : CGFloat {
            return self.rawValue
        }
    }
    
    fileprivate enum ActionSheetTypeEnum : Int {
        
        case belong = 10
        case gender = 100
        case more = 1000
        
        var value : Int {
            return self.rawValue
        }
    }
    
    var isScan = true
    
    var isPublicSea = true
    
    var fileURLString: String?
    
    var selectedImage : UIImage?
    
    var poolIdString : String?
    
    var tradeModel : TradeModel?
    
    var picker : DatePickerView?
    
    private var belongPoolArray : [JSON] = []
    
    private var moreNameArray : [String] = []
    
    var constraintArray : [NSLayoutConstraint] = []
    
    let shareView = CustomerShareCell(style: .default, reuseIdentifier: "cell")
    
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var customNameLabel: UITextField!                    // 客户名
    
    @IBOutlet weak var customTradeLabel: UITextField!                   // 客户行业
    
    @IBOutlet weak var customPhoneTextField: UITextField!               // 客户电话
    
    @IBOutlet weak var customBelongPoolTextField: UITextField!          // 客户所属公海池
    
    // MARK: - 可选视图约束
    @IBOutlet weak var nameHeightConstraint: NSLayoutConstraint!        // 姓名
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!       // 职位
    @IBOutlet weak var depHeightConstraint: NSLayoutConstraint!         // 部门
    @IBOutlet weak var genderHeightConstraint: NSLayoutConstraint!      // 性别
    @IBOutlet weak var birthdayHeightConstraint: NSLayoutConstraint!    // 生日
    @IBOutlet weak var phoneHeightConstraint: NSLayoutConstraint!       // 电话
    @IBOutlet weak var wechatHeightConstraint: NSLayoutConstraint!      // 微信
    @IBOutlet weak var qqHeightConstraint: NSLayoutConstraint!          // QQ
    @IBOutlet weak var emailHeightConstraint: NSLayoutConstraint!       // 邮件
    @IBOutlet weak var addressHeightConstraint: NSLayoutConstraint!     // 地址
    @IBOutlet weak var postcodeHeightConstraint: NSLayoutConstraint!    // 邮编
    @IBOutlet weak var remarksHeightConstraint: NSLayoutConstraint!     // 备注
    @IBOutlet weak var moreHeightConstraint: NSLayoutConstraint!        // 添加更多
    
    @IBOutlet weak var permissionsSettingsConstraint: NSLayoutConstraint! // 权限设置

    @IBOutlet weak var permissionsSettingsBgView: UIView!
    
    // MARK: - 可选视图输入框
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var depTextField: UITextField!
    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var birthdayLabel: UITextField!
    @IBOutlet weak var phoneBgView: HYAddPhoneV!
    @IBOutlet weak var wechatTextField: UITextField!
    @IBOutlet weak var qqTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var remarksTextField: UITextField!
    
    @IBOutlet weak var reselectPhotoBgView: UIView!
    
    @IBOutlet weak var moreButton: UIButton!
    
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
        case 4: // 选择性别
            self.selectGenderFunc()
        case 5: // 选择生日
            self.selectBithdayFunc()
        case 9: // 更多
            self.selectMoreFunc()
        case 10: // 重拍
            self.reselectPhotoFunc()
        default:
            break
        }
    }
    
    func selectGenderFunc() {
        
        let actionSheet = LCActionSheet(title: "选择性别", buttonTitles: [GenderTypeEnum.description(.man)(), GenderTypeEnum.description(.female)()], redButtonIndex: -1, delegate: self)
        actionSheet?.tag = ActionSheetTypeEnum.gender.value
        actionSheet?.show()
    }
    
    func selectMoreFunc() {
        
        let actionSheet = LCActionSheet(title: "添加更多信息", buttonTitles: self.moreNameArray, redButtonIndex: -1, delegate: self)
        actionSheet?.tag = ActionSheetTypeEnum.more.value
        actionSheet?.show()
    }
    
    func reselectPhotoFunc() {
        
        let imagePickerVc = UIImagePickerController()
//        imagePickerVc.allowsEditing = true
        imagePickerVc.delegate = self
        
        switch self.isScan {
        case true: // 拍照
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.camera
        case false: // 相册
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imagePickerVc, animated: true, completion: nil)
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
    
    func selectBithdayFunc() {
        
        self.picker = DatePickerView()
        
        self.picker?.pickerResult = { [weak self] (date) in
            self?.birthdayLabel.text = Date.timeIntervalToDateDetailyymmddStr(date: date)
            self?.picker = nil
        }
        
        self.view.addSubview(self.picker!)
        
        picker!.snp.makeConstraints {[weak self] (make) in
            make.top.equalTo((self?.view.snp.bottom) ?? 0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(200)
        }
        
        UIView.animate(withDuration: 2, animations: {
            self.picker?.snp.updateConstraints({ (make) in
                make.top.equalTo((self.view.snp.bottom)).offset(-200)
            })
        })
    }
    
    func selectCustomBelongPoolFunc() {
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: "pp.client.get_client_gonghai", params: ["token":userModel.token ?? ""], hadToast: true, fail: { (dict) in
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
            }
        }
    }
    
    @objc func saveBtnClickFunc() {
        
        guard !self.customNameLabel.text!.trimSpace().isEmpty else {
            PublicMethod.toastWithText(toastText: "请选择客户名")
            return
        }
        
        guard !self.customTradeLabel.text!.trimSpace().isEmpty else {
            PublicMethod.toastWithText(toastText: "请选择行业")
            return
        }
        
        var params : [String:String] = [:]
        
        params["token"] = UserModel.getUserModel().token ?? ""
        params["client_name"] = self.customNameLabel.text // 客户名字
        params["trade_id"] = self.tradeModel?.index_id ?? self.tradeModel?.parent_id
        params["trade_name"] = self.customTradeLabel.text // 行业name
        params["contact_name"] = self.nameTextField.text // 联系人名字
        params["position_name"] = self.titleTextField.text // 联系人职务
        params["dep"] = self.depTextField.text // 联系人部门
        params["sex"] = self.genderLabel.text // 联系人性别
        params["birthday"] = self.birthdayLabel.text // 联系人生日
        params["weixin"] = self.wechatTextField.text // 联系人微信
        params["qq"] = self.qqTextField.text // 联系人qq
        params["email"] = self.emailTextField.text // 联系人邮箱
        params["particulars"] = self.remarksTextField.text // 联系人备注
        params["addr"] = self.addressTextField.text // 客户地址
        params["file_url"] = self.fileURLString ?? "" // 图片地址
        
        let phones = self.phoneBgView.fetchPhones()
        params["phone"] = phones == "0" ? "" : phones // 联系人电话
        
//        let selectTuple = shareView.resultParams()
//        params["authorization_corp"] = selectTuple.all
//        params["authorization_deps"] = selectTuple.dep
//        params["authorization_member"] = selectTuple.mem
        
        print("*** params = \(params)")
        
        LoginRequest.getPost(methodName: isPublicSea ? CUSTOM_POOL_CREATE_CONTACT_ADD : CUSTOM_POOL_CREATE_CONTACT_ADD_PRIVATE, params: params, hadToast: true, fail: { (dict) in
            
            let jsons = JSON(dict)
            
            if let status = jsons["status"].int, status == 2 {
                
                let modelArray = NSMutableArray()
                
                jsons["data"].arrayValue.forEach({ (json) in
                    
                    let model = SLRepeatInfoModel()
                    
                    model.numberID = json["id"].string // 联系人id
                    model.name = json["name"].string // 联系人姓名
                    model.email = json["email"].string // 联系人邮箱
                    model.qq = json["qq"].string // 联系人QQ
                    model.wechat = json["wechat"].string // 联系人微信
                    model.birthday = json["birthday"].string // 联系人生日
                    model.sex = json["sex"].string // 联系人性别
                    model.more = json["more"].string // 联系人备注
                    model.client_id = json["client_id"].string // 客户id
                    model.client_name = json["client_name"].string // 客户名称
                    model.jurisdiction = json["jurisdiction"].string // 是否可合并
                    
                    let phoneString = json["phone_arr"].arrayValue.map { $0.stringValue }.joined(separator: ",")
                    model.phone = phoneString // 联系人电话
                    
                    modelArray.add(model)
                })
                
                let model = SLRepeatInfoModel()
                
                model.numberID = "" // 联系人id
                model.name = self.nameTextField.text // 联系人姓名
                model.email = self.emailTextField.text // 联系人邮箱
                model.qq = self.qqTextField.text // 联系人QQ
                model.wechat = self.wechatTextField.text // 联系人微信
                model.birthday = self.birthdayLabel.text // 联系人生日
                model.sex = self.genderLabel.text // 联系人性别
                model.more = self.remarksTextField.text // 联系人备注
                model.client_name = self.customNameLabel.text // 客户名称
                model.client_id = "" // 客户id
                model.jurisdiction = "" // 是否可合并
                
                let phones = self.phoneBgView.fetchPhones()
                model.phone = phones == "0" ? "" : phones // 联系人电话
                
                let vc = SLRepeatInfoVC()
                let navi = UINavigationController(rootViewController: vc) // SLRepeatInfoVC需要
                vc.commitModel = model
                vc.dataArr = modelArray
                
                self.present(navi, animated: true, completion: nil)
            } else {
                PublicMethod.dismissWithSuccess(str: jsons["msg"].stringValue)
            }
        }) { [weak self] (dict) in
            PublicMethod.dismissWithSuccess(str: "保存成功")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func initPermissionsSettingsFunc() {

        shareView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 170)
        shareView.frameHeightChanged = { [weak shareView, weak permissionsSettingsConstraint] (height) in
            shareView?.height = height
            permissionsSettingsConstraint?.constant = height
        }
        
        self.permissionsSettingsBgView.addSubview(self.shareView)
    }
    
    func initPhoneBgViewFunc() {
        self.phoneBgView.action = { [weak phoneHeightConstraint] (height) in
            phoneHeightConstraint?.constant = CGFloat(height * 50) + CellHeightEnum.phone.value
        }
    }
    
    func addSaveBarButtonItemFunc() {
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchBtn.setTitle("保存", for: .normal)
        searchBtn.addTarget(self, action: #selector(saveBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBtn)
    }
    
    func initConstraintFunc() {
        
        self.nameHeightConstraint.constant = CellHeightEnum.zero.value
        self.titleHeightConstraint.constant = CellHeightEnum.zero.value
        self.depHeightConstraint.constant = CellHeightEnum.zero.value
        self.genderHeightConstraint.constant = CellHeightEnum.zero.value
        self.birthdayHeightConstraint.constant = CellHeightEnum.zero.value
        self.phoneHeightConstraint.constant = CellHeightEnum.zero.value
        self.wechatHeightConstraint.constant = CellHeightEnum.zero.value
        self.qqHeightConstraint.constant = CellHeightEnum.zero.value
        self.emailHeightConstraint.constant = CellHeightEnum.zero.value
        self.addressHeightConstraint.constant = CellHeightEnum.zero.value
        self.postcodeHeightConstraint.constant = CellHeightEnum.zero.value
        self.remarksHeightConstraint.constant = CellHeightEnum.zero.value
        
        self.moreNameArray = [MoreNameEnum.name.value, MoreNameEnum.title.value, MoreNameEnum.dep.value, MoreNameEnum.gender.value, MoreNameEnum.brithday.value, MoreNameEnum.phone.value, MoreNameEnum.wechat.value, MoreNameEnum.qq.value, MoreNameEnum.email.value, MoreNameEnum.address.value, MoreNameEnum.postcode.value, MoreNameEnum.remarks.value]
        self.constraintArray = [self.nameHeightConstraint, self.titleHeightConstraint, self.depHeightConstraint, self.genderHeightConstraint, self.birthdayHeightConstraint, self.phoneHeightConstraint, self.wechatHeightConstraint, self.qqHeightConstraint, self.emailHeightConstraint, self.addressHeightConstraint, self.postcodeHeightConstraint, self.remarksHeightConstraint]
    }
    
    func loadData() {
        
        guard let image = self.selectedImage else {
            print("selected img is nil")
            return
        }
        
        // 下面赋值copy的之前的扫描代码，dic转JSON对象后会出现乱码，扫描结果返回的也可能是乱码
        PublicMethod.showProgress()
        LoginRequest.sendVCardImage(image: image, hadToast: true, fail: {[weak self] (dic) in
            PublicMethod.dismissWithErrorStr(str: "识别失败")
            
            self?.reselectPhotoBgView.isHidden = false
            DLog("识别失败")
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog("名片识别")
            DLog(dic)
            
            self?.sendScanImageFunc(image: image)
            
            //姓名
            if dic["formatted_name"] != nil {
                let nameArray:Array<Dictionary<String,Any>> = dic["formatted_name"] as! Array<Dictionary<String,Any>>
                let subDict = nameArray.first!
                self?.nameTextField.text = String.noNilStr(str: subDict["item"])
                
                self?.nameHeightConstraint.constant = CellHeightEnum.normal.value
                
                self?.moreNameArray.remove(MoreNameEnum.name.value)
                self?.constraintArray.remove((self?.nameHeightConstraint)!)
            }
            
            // 地址与邮编
            if dic["address"] != nil {
                var addressString = ""
                let addressArray:Array<Dictionary<String,Any>> = dic["address"] as! Array<Dictionary<String,Any>>
                for subDict in addressArray {
                    let addressDict:Dictionary<String,Any> = subDict["item"] as! Dictionary<String,Any>
                    addressString.append(String.noNilStr(str: addressDict["locality"]))
                    addressString.append(String.noNilStr(str: addressDict["street"]))
                    addressString.append(",")
                    
                    if addressDict["postal_code"] != nil {
                        self?.postcodeTextField.text = String.noNilStr(str: addressDict["postal_code"])
                        self?.postcodeHeightConstraint.constant = CellHeightEnum.normal.value
                        self?.moreNameArray.remove(MoreNameEnum.postcode.value)
                        self?.constraintArray.remove((self?.postcodeHeightConstraint)!)
                    }
                    
                }
                self?.addressTextField.text = addressString
                self?.addressHeightConstraint.constant = CellHeightEnum.normal.value
                self?.moreNameArray.remove(MoreNameEnum.address.value)
                self?.constraintArray.remove((self?.addressHeightConstraint)!)
            }
            
            // 手机号与传真
            if dic["telephone"] != nil {
                var array : [String] = []
                let mobileArray:Array<Dictionary<String,Any>> = dic["telephone"] as! Array<Dictionary<String,Any>>
                for subDict in mobileArray {
                    let mobileDict:Dictionary<String,Any> = subDict["item"] as! Dictionary<String,Any>
                    
                    let typeArray:Array<String> = mobileDict["type"] as! Array<String>
                    var isFac = false
                    for type in typeArray {
                        if type == "facsimile" {
                            isFac = true
                        }
                    }
                    if !isFac {
                        array.append(String.noNilStr(str: mobileDict["number"]))
                    }
                }
                
                // 配置电话 mobileString
                print("*** array \(array)")
                self?.phoneBgView.configPhones(array)
            }
            
            // 邮箱
            if dic["email"] != nil {
                let emailArray:Array<Dictionary<String,Any>> = dic["email"] as! Array<Dictionary<String,Any>>
                let subDict = emailArray.first!
                self?.emailTextField.text = String.noNilStr(str: subDict["item"])
                
                self?.emailHeightConstraint.constant = CellHeightEnum.normal.value
                
                self?.moreNameArray.remove(MoreNameEnum.email.value)
                self?.constraintArray.remove((self?.emailHeightConstraint)!)
            }
            
            // 职位
            if dic["title"] != nil {
                let posArray:Array<Dictionary<String,Any>> = dic["title"] as! Array<Dictionary<String,Any>>
                let subDict = posArray.first!
                self?.titleTextField.text = String.noNilStr(str: subDict["item"])
                
                self?.titleHeightConstraint.constant = CellHeightEnum.normal.value
                
                self?.moreNameArray.remove(MoreNameEnum.title.value)
                self?.constraintArray.remove((self?.titleHeightConstraint)!)
            }
            
            // 微信
            if dic["sns"] != nil {
                let snsArray:Array<Dictionary<String,Any>> = dic["sns"] as! Array<Dictionary<String,Any>>
                let subDict = snsArray.first!
                self?.wechatTextField.text = String.noNilStr(str: subDict["item"])
                
                self?.wechatHeightConstraint.constant = CellHeightEnum.normal.value
                
                self?.moreNameArray.remove(MoreNameEnum.wechat.value)
                self?.constraintArray.remove((self?.wechatHeightConstraint)!)
            }
            
            // QQ
            if dic["im"] != nil {
                let imArray:Array<Dictionary<String,Any>> = dic["im"] as! Array<Dictionary<String,Any>>
                let subDict = imArray.first!
                self?.qqTextField.text = String.noNilStr(str: subDict["item"])
                
                self?.qqHeightConstraint.constant = CellHeightEnum.normal.value
                
                self?.moreNameArray.remove(MoreNameEnum.qq.value)
                self?.constraintArray.remove((self?.qqHeightConstraint)!)
            }
        }
    }
    
    func initData() {
        
        self.initConstraintFunc()
        
        self.loadData()
    }
    
    func initView() {
        
        self.title = "扫名片"
        
        self.initPhoneBgViewFunc()
        
        self.addSaveBarButtonItemFunc()
        
//        self.initPermissionsSettingsFunc()
        
        self.reselectPhotoBgView.isHidden = true
        
        self.headImageView.image = self.selectedImage
    }
}

// MARK: - 代理相关
extension ScanNameCardViewController : LCActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func sendScanImageFunc(image:UIImage) {
        
        LoginRequest.sendScanImage(image: image, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            
            print("*** file url = \(dic)")
            
            self?.fileURLString = JSON(dic).dictionaryValue["preview_url"]?.string
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if image.size.width > SCREEN_WIDTH {
            image = image.imageScaled(to: CGSize(width: SCREEN_WIDTH, height: image.size.height * SCREEN_WIDTH / image.size.width))
        }
        
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.selectedImage = image
        
        self.headImageView.image = image
        
        self.loadData() // 再去根据图片识别相关信息
    }
    
    func moreActionSheetFunc(buttonIndex:Int) {
        
        guard buttonIndex < self.constraintArray.count else {
            return
        }
        
        let constraint = self.constraintArray[buttonIndex]
        
        constraint.constant = CellHeightEnum.normal.value
        if moreNameArray[buttonIndex] == MoreNameEnum.phone.value {
            constraint.constant = CellHeightEnum.phone.value
            self.phoneBgView.configView()
        }
        
        self.moreNameArray.remove(at: buttonIndex)
        self.constraintArray.remove(at: buttonIndex)
        
        if self.moreNameArray.isEmpty {
            self.moreHeightConstraint.constant = 0
            self.moreButton.isHidden = true
        }
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        switch actionSheet.tag {
        case ActionSheetTypeEnum.belong.value:
            let json = self.belongPoolArray[buttonIndex]
            self.customBelongPoolTextField.text = json["name"].stringValue
            self.poolIdString = json["id"].stringValue
        case ActionSheetTypeEnum.gender.value:
            self.genderLabel.text = GenderTypeEnum(type: buttonIndex).description()
        case ActionSheetTypeEnum.more.value:
            self.moreActionSheetFunc(buttonIndex: buttonIndex)
        default:
            break
        }
    }
}
