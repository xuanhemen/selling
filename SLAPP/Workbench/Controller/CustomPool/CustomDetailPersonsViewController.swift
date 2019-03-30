//
//  CustomDetailPersonsViewController.swift
//  SLAPP
//
//  Created by fank on 2018/12/4.
//  Copyright © 2018年 柴进. All rights reserved.
//  客户详情 - 参与人、联系人列表

import UIKit
import SwiftyJSON

class CustomDetailPersonsViewController: BaseVC {
    
    var isContacts = true
    
    var isPublicSea = true // 默认是公海
    
    var customIdString : String?
    
    var customNameString : String?
    
    var contactInfo : [String:Any] = [:]
    
    var searchArray : [CustomDetailModel] = []
    
    var dataArray : [CustomDetailModel] = []
    
    @IBOutlet weak var noDataNoticeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initData()
    }
    
    @IBAction func searchTextFieldEditingChanged(_ sender: UITextField) {
        
        if !sender.text!.isEmpty && sender.text!.trimSpace().count == 0 {
            sender.text = ""
            return
        }
        
        self.searchArray.removeAll()
        
        if sender.text! == "" {
             self.searchArray = self.dataArray
        } else {
            self.dataArray.forEach { [weak self] (model) in
                if (self?.isContacts)! {
                    let topString = "\(String(describing: model.nameString)) | \(String(describing: model.titleString))"
                    if topString.lowercased().contains(sender.text!) || (model.companyString ?? "").contains(sender.text!) {
                        self?.searchArray.append(model)
                    }
                } else {
                    let bottomString = "\(model.titleString ?? "")  \(model.phoneString ?? "")".contains(sender.text!)
                    if (model.nameString ?? "").contains(sender.text!) || bottomString {
                        self?.searchArray.append(model)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func deleteBtnClickFunc() {
        
        self.view.endEditing(true)
        
        if let vc = R.storyboard.customPool.customPoolDeleteContactsViewController() {
            vc.dataArray = self.dataArray
            vc.customIdString = self.customIdString
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func addBtnClickFunc() {
        
        self.view.endEditing(true)
        
        let actionSheet = LCActionSheet(title: "手动创建", buttonTitles: [CreateCustomTypeEnum.description(.manualCreate)(), CreateCustomTypeEnum.description(.scanCard)(), CreateCustomTypeEnum.description(.selPhoto)()], redButtonIndex: -1, delegate: self)
        actionSheet?.show()
    }
    
    func addRightBarButtonItemsFunc() {
        
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        searchBtn.setImage(R.image.customer_edit(), for: .normal)
        searchBtn.addTarget(self, action: #selector(deleteBtnClickFunc), for: .touchUpInside)
        
        let addBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        addBtn.setImage(R.image.nav_add_new(), for: .normal)
        addBtn.addTarget(self, action: #selector(addBtnClickFunc), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: addBtn), UIBarButtonItem(customView: searchBtn)]
    }
    
    func initData() {
        
        guard self.customIdString != nil else {
            PublicMethod.toastWithText(toastText: "客户id不存在")
            return
        }
        
        let idString = isContacts ? "client_id" : "id"
        
        self.showProgress(withStr: "正在加载中...")
        
        let userModel = UserModel.getUserModel()
        LoginRequest.getPost(methodName: isContacts ? CUSTOM_POOL_CUSTOM_DETAIL_CONTACT : CUSTOM_POOL_CUSTOM_DETAIL_PARTICIPANT, params: ["token":userModel.token ?? "", idString: self.customIdString!], hadToast: true, fail: { [weak self] (dict) in
            self?.showDismissWithError()
        }) { [weak self] (dict) in
            
            self?.showDismiss()
            
            if let jsons = JSON(dict)["list"].array {
                print("*** jsons = \(jsons)")
                self?.dataArray.removeAll()
                self?.searchArray.removeAll()
                
                jsons.forEach({ (json) in
                    self?.dataArray.append(CustomDetailModel.customDetailModel(json: json))
                })
                
                self?.searchArray = (self?.dataArray)!
                
                if (self?.searchArray.count)! > 0 {
                    self?.noDataNoticeLabel.isHidden = true
                } else {
                    self?.noDataNoticeLabel.isHidden = false
                    self?.noDataNoticeLabel.text = (self?.isContacts)! ? "暂无客户联系人" : "暂无我方参与人"
                }
                
                self?.tableView.reloadData()
            }
        }
    }
    
    func initView() {
        
        self.title = "客户联系人"
        
        if !self.isContacts {
            self.title = "我方参与人"
        } else { // 如果是联系人，且是私海
            if !self.isPublicSea {
                self.addRightBarButtonItemsFunc()
            }
        }
    }
}

// MARK: - 代理相关
extension CustomDetailPersonsViewController : LCActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            vc.isPublicSea = self.isPublicSea
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func chooseImageFunc(isScan:Bool = true) {
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.delegate = self
        
        switch isScan {
        case true: // 拍照
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.camera
        case false: // 相册
            imagePickerVc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(imagePickerVc, animated: true, completion: nil)
    }
    
    func pushToAddContactVCFunc() {
        
        let ok = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
        ok[0] = true
        
        let vc = HYAddContactVC()
        vc.isFromCustom = ok
        vc.contactInfo = self.contactInfo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func actionSheet(_ actionSheet: LCActionSheet!, didClickedButtonAt buttonIndex: Int) {
        
        switch buttonIndex {
        case CreateCustomTypeEnum.manualCreate.value:
            self.pushToAddContactVCFunc()
        case CreateCustomTypeEnum.scanCard.value:
            self.chooseImageFunc()
        case CreateCustomTypeEnum.selPhoto.value:
            self.chooseImageFunc(isScan: false)
        default:
            break
        }
    }
}

// MARK: - tableview相关
extension CustomDetailPersonsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isContacts {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailContactsCell") as! CustomDetailContactsCell
            
            cell.customDetailModel = self.searchArray[indexPath.row]
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomDetailParticipantsCell") as! CustomDetailParticipantsCell
            
            cell.customDetailModel = self.searchArray[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isContacts {
            let vc = HYContactDetailVC()
            vc.client_id = self.customIdString
            vc.contact_id = self.searchArray[indexPath.row].idString
            print(vc.client_id,vc.contact_id)
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            PublicPush.addressPushToUserInfoForDetailVC(userId: self.searchArray[indexPath.row].idString!, vc: self)
        }
    }
}
