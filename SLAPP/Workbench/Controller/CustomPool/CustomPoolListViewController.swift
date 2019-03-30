//
//  CustomPoolListViewController.swift
//  SLAPP
//
//  Created by fank on 2018/11/27.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户池列表

import UIKit
import SwiftyJSON

enum AuthEnum : String {
    
    case normal = "0"
    case power = "1"
    
    var value : String {
        return self.rawValue
    }
}

enum ActionSheetTypeEnum : Int {
    
    case create = 1000
    case operate = 100
    
    var value : Int {
        return self.rawValue
    }
}

enum OperateCustomTypeEnum : Int {
    
    case get = 0
    case alloc = 1
    case delete = 2
    case recover = 5
    case unKnown = -1
    
    init(type: Int) {
        switch type {
        case 0: self = .get
        case 1: self = .alloc
        case 2: self = .delete
        case 5: self = .recover
        default: self = .unKnown
        }
    }
    
    var value : Int {
        return self.rawValue
    }
    
    func description() -> String {
        switch self {
        case .get:
            return "领取"
        case .alloc:
            return "分配"
        case .delete:
            return "删除"
        case .recover:
            return "恢复"
        case .unKnown:
            return ""
        }
    }
}

enum CreateCustomTypeEnum : Int {
    
    case manualCreate = 0
    case scanCard = 1
    case selPhoto = 2
    case unKnown = -1
    
    init(type: Int) {
        switch type {
        case 0: self = .manualCreate
        case 1: self = .scanCard
        case 2: self = .selPhoto
        default: self = .unKnown
        }
    }
    
    var value : Int {
        return self.rawValue
    }
    
    func description() -> String {
        switch self {
        case .manualCreate:
            return "手动创建"
        case .scanCard:
            return "扫名片"
        case .selPhoto:
            return "选择相册中的名片"
        case .unKnown:
            return ""
        }
    }
}

class CustomPoolListViewController: BaseVC {
    
    var dataArray : [CustomPoolModel] = []
    
    var selectArray : [CustomPoolModel] = []
    
    var authTuple : (isRoot: Bool, isManager: Bool) = (false, false)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        
        print("*** token = \(UserModel.getUserModel().toString())")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initData()
    }
    
    // MARK: - 事件相关
    @IBAction func recycleBtnClickFunc(_ sender: UIButton) {
        
        guard self.authTuple.isRoot else {
            PublicMethod.toastWithText(toastText: "您不是系统管理员，没有查看回收站权限")
            return
        }
        
        if let vc = R.storyboard.customPool.customPoolRecycleListViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func operateBtnClickFunc(_ sender: UIButton) {
        
        var buttonTitles : [String] = [OperateCustomTypeEnum.description(.get)()]
        
        if self.authTuple.isManager {
            buttonTitles.append(OperateCustomTypeEnum.description(.alloc)())
        }
        
        if self.authTuple.isRoot {
            buttonTitles.append(OperateCustomTypeEnum.description(.delete)())
        }
        
        let actionSheet = LCActionSheet(title: "操作选项", buttonTitles: buttonTitles, redButtonIndex: -1, delegate: self)
        actionSheet?.tag = ActionSheetTypeEnum.operate.value
        actionSheet?.show()
    }
    
    @objc func searchBtnClickFunc() {
        if let vc = R.storyboard.customPool.customPoolSearchViewController() {
            vc.authTuple = self.authTuple
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addBtnClickFunc() {
        let actionSheet = LCActionSheet(title: "创建客户", buttonTitles: [CreateCustomTypeEnum.description(.manualCreate)(), CreateCustomTypeEnum.description(.scanCard)(), CreateCustomTypeEnum.description(.selPhoto)()], redButtonIndex: -1, delegate: self)
        actionSheet?.tag = ActionSheetTypeEnum.create.value
        actionSheet?.show()
    }
    
    func addRightBarButtonItemsFunc() {
        
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addBtn.setImage(R.image.nav_add_new(), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnClickFunc), for: .touchUpInside)
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchBtn.setImage(R.image.search(), for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClickFunc), for: .touchUpInside)
        
        var rightBarButtonItems : [UIBarButtonItem] = []
        
        if self.authTuple.isRoot {
            rightBarButtonItems = [UIBarButtonItem(customView: addBtn), UIBarButtonItem(customView: searchBtn)]
        } else {
            rightBarButtonItems = [UIBarButtonItem(customView: searchBtn)]
        }
        
        self.navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    func initData(completion: (() -> Swift.Void)? = nil) {
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST, params: ["token":userModel.token ?? ""], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
            
            if let completion = completion {
                completion()
            }
        }) { [weak self] (dict) in
            
            self?.selectArray.removeAll()
            self?.dataArray.removeAll()
            
            self?.showDismiss()
            
            print("*** jsons = \(JSON(dict))")
            
            if let jsons = JSON(dict)["list"].array {
                
                self?.dataArray.removeAll()
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(CustomPoolModel.customPoolModel(json: json))
                })
                
                self?.tableView.reloadData()
            }
            
            if let isRoot = JSON(dict)["is_root"].string {
                self?.authTuple.isRoot = isRoot == AuthEnum.power.value ? true : false
            }
            
            if let isManager = JSON(dict)["ismanager"].string {
                self?.authTuple.isManager = isManager == AuthEnum.power.value ? true : false
            }
            
            self?.addRightBarButtonItemsFunc()
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func initView() {
        
        self.title = "全部公海客户"
    }

}

// MARK: - 代理相关
extension CustomPoolListViewController : CustomPoolCellDelegate, LCActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if image.size.width > SCREEN_WIDTH {
            image = image.imageScaled(to: CGSize(width: SCREEN_WIDTH, height: image.size.height * SCREEN_WIDTH / image.size.width))
        }
        
        if picker.sourceType == UIImagePickerControllerSourceType.camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        self.dismiss(animated: true, completion: nil)
        
        if let vc = R.storyboard.customPool.scanNameCardViewController() {
            if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary {
                vc.isScan = false
            }
            vc.selectedImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func chooseImageFunc(isScan:Bool = true) {
        
        let imagePickerVc = UIImagePickerController()
//        imagePickerVc.allowsEditing = true
        imagePickerVc.delegate = self
        
        switch isScan {
        case true: // 拍照
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.camera
        case false: // 相册
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imagePickerVc, animated: true, completion: nil)
    }
    
    func selPhotoFunc() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.restricted || status == PHAuthorizationStatus.denied {
            
            let alertController = UIAlertController(title: nil, message: "请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的照片。", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (defaultAlert) in
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.chooseImageFunc(isScan: false)
        }
    }
    
    func scanCardFunc() {
        
        let mediaType = AVMediaType.video
        let authStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        if authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.denied {
            
            let alertController = UIAlertController(title: nil, message: "请在iPhone的“设置-隐私”选项中，允许赢单罗盘访问你的相机。", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { (defaultAlert) in
            }))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.chooseImageFunc()
        }
    }
    
    func pushToCreateCustomVCFunc() {
        if let vc = R.storyboard.customPool.createCustomViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteFunc() {
        
        let clientIdString = self.selectArray.map { $0.idString ?? "" }.joined(separator: ",")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_DELETE, params: ["token":userModel.token ?? "", "client_id_str":clientIdString], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            self?.initData { PublicMethod.dismissWithSuccess(str: "操作成功") }
        }
    }
    
    func getAndAllocFunc(isGet:Bool = true, idString: String = "") {
        
        let status = isGet ? "0" : "1"
       
        
        let clientIdString = self.selectArray.map { $0.idString ?? "" }.joined(separator: ",")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: CUSTOM_POOL_LIST_ALLOC_GET, params: ["token":userModel.token ?? "", "status":status, "client_id_str":clientIdString, "member_id":idString], hadToast: true, fail: { (dict) in
        }) { [weak self] (dict) in
            self?.initData { PublicMethod.dismissWithSuccess(str: "操作成功") }
        }
    }
    
    func pushToSelectMemberVCFunc(tag:Int = 1) {
        
        let vc = HYColleaguesVC()
        vc.isSingle = true
        vc.singleSelectClosure = { (id) in
            self.getAndAllocFunc(isGet: false, idString: id)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func operateDetailFunc(operateEnum:OperateCustomTypeEnum) {
        
        guard self.selectArray.count > 0 else {
            guard operateEnum.value == OperateCustomTypeEnum.unKnown.value else {
                PublicMethod.toastWithText(toastText: "请选择客户")
                return
            }
            return
        }
        
        if self.authTuple.isRoot {
            if self.authTuple.isManager {
                switch operateEnum {
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
                switch operateEnum {
                case .get:
                    self.getAndAllocFunc()
                case .alloc:
                    self.deleteFunc()
                default:
                    break
                }
            }
        } else {
            if self.authTuple.isManager {
                switch operateEnum {
                case .get:
                    self.getAndAllocFunc()
                case .alloc:
                    self.pushToSelectMemberVCFunc()
                default:
                    break
                }
            } else {
                switch operateEnum {
                case .get:
                    self.deleteFunc()
                default:
                    break
                }
            }
        }
    }
    
    func createDetailFunc(createEnum:CreateCustomTypeEnum) {
        switch createEnum {
        case .manualCreate:
            self.pushToCreateCustomVCFunc()
        case .scanCard:
            self.scanCardFunc()
        case .selPhoto:
            self.selPhotoFunc()
        default:
            break
        }
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        print("*** actionSheet.tag = \(actionSheet.tag)")
        switch actionSheet.tag {
        case ActionSheetTypeEnum.create.value:
            print("这你")
            self.createDetailFunc(createEnum: CreateCustomTypeEnum(type: buttonIndex))
        case ActionSheetTypeEnum.operate.value:
            print("我")
            if OperateCustomTypeEnum(type: buttonIndex) == .get{
                self.authTuple = (true,true)
            }
            self.operateDetailFunc(operateEnum: OperateCustomTypeEnum(type: buttonIndex))
        default:
            break
        }
    }
    
    func customPoolCellBtnClickFunc(indexPath: IndexPath, isSelected: Bool) {
        
        if isSelected {
            self.selectArray.append(self.dataArray[indexPath.row])
        } else {
            self.selectArray.remove(self.dataArray[indexPath.row])
        }
        
        self.dataArray[indexPath.row].isSelected = isSelected
    }
}

// MARK: - tableview相关
extension CustomPoolListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPoolCell") as! CustomPoolCell
        
        cell.customPoolModel = self.dataArray[indexPath.row]
        
        cell.indexPath = indexPath
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.authTuple.isRoot, let vc = R.storyboard.customPool.customDetailViewController() {
            vc.customIdString = self.dataArray[indexPath.row].idString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
