//
//  QFVcardVC.swift
//  SLAPP
//
//  Created by qwp on 2018/6/7.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import HandyJSON


class QFVcardVC: UIViewController {

    
    @objc var retakePicture:()->() = {
        
    }
    @objc var save:()->() = {
        
    }
    let shareView = CustomerShareCell.init(style: .default, reuseIdentifier: "cell");
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var postionTextField: UITextField!
    @IBOutlet weak var qqTextField: UITextField!
    @IBOutlet weak var wechatTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var chuanzhenTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @objc var image:UIImage?
    
    @IBOutlet weak var shareBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "编辑名片"
        
        let leftBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.setTitle("重新拍摄", for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftBtn.addTarget(self, action: #selector(retakeBtnClick(_:)), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem
        
        
        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightBtn.setTitleColor(.white, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightBtn.setTitle("保存", for: .normal)
        rightBtn.addTarget(self, action: #selector(saveBtnClick(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        shareView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: 170)
        shareView.frameHeightChanged = {[weak shareView,weak shareBackView](h) in
            shareView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: h)
            self.viewHeight.constant = 920+h
        }
        shareBackView.addSubview(shareView)
        
        
        PublicMethod.showProgress()
        LoginRequest.sendVCardImage(image: self.image!, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
            DLog("识别失败")
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
            DLog("名片识别")
            DLog(dic)
            //姓名
            if dic["formatted_name"] != nil {
                let nameArray:Array<Dictionary<String,Any>> = dic["formatted_name"] as! Array<Dictionary<String,Any>>
                let subDict = nameArray.first!
                self?.nameTextField.text = String.noNilStr(str: subDict["item"])
            }
            
            //地址与邮编
            if dic["address"] != nil {
                var addressString = ""
                let addressArray:Array<Dictionary<String,Any>> = dic["address"] as! Array<Dictionary<String,Any>>
                for subDict in addressArray {
                    let addressDict:Dictionary<String,Any> = subDict["item"] as! Dictionary<String,Any>
                    addressString.append(String.noNilStr(str: addressDict["locality"]))
                    addressString.append(String.noNilStr(str: addressDict["street"]))
                    addressString.append(",")
                    
                    if addressDict["postal_code"] != nil {
                        self?.numTextField.text = String.noNilStr(str: addressDict["postal_code"])
                    }
                    
                }
                self?.addressTextField.text = addressString
            }
            
            //手机号与传真
            if dic["telephone"] != nil {
                var mobileString = ""
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
                    if isFac {
                        self?.chuanzhenTextField.text = String.noNilStr(str: mobileDict["number"])
                    }else{
                        mobileString.append(String.noNilStr(str: mobileDict["number"]))
                        mobileString.append(",")
                    }
                }
                self?.mobileTextField.text = mobileString
            }
            
            //邮箱
            if dic["email"] != nil {
                let emailArray:Array<Dictionary<String,Any>> = dic["email"] as! Array<Dictionary<String,Any>>
                let subDict = emailArray.first!
                self?.emailTextField.text = String.noNilStr(str: subDict["item"])
            }
            
            //职位
            if dic["title"] != nil {
                let posArray:Array<Dictionary<String,Any>> = dic["title"] as! Array<Dictionary<String,Any>>
                let subDict = posArray.first!
                self?.postionTextField.text = String.noNilStr(str: subDict["item"])
            }
            //微信
            if dic["sns"] != nil {
                let snsArray:Array<Dictionary<String,Any>> = dic["sns"] as! Array<Dictionary<String,Any>>
                let subDict = snsArray.first!
                self?.wechatTextField.text = String.noNilStr(str: subDict["item"])
            }
            //QQ
            if dic["im"] != nil {
                let imArray:Array<Dictionary<String,Any>> = dic["im"] as! Array<Dictionary<String,Any>>
                let subDict = imArray.first!
                self?.qqTextField.text = String.noNilStr(str: subDict["item"])
            }
            //公司
            if dic["organization"] != nil {
                var companyString = ""
                let companyArray:Array<Dictionary<String,Any>> = dic["organization"] as! Array<Dictionary<String,Any>>
                for subDict in companyArray {
                    let companyDict:Dictionary<String,Any> = subDict["item"] as! Dictionary<String,Any>
                    if companyDict["name"] != nil {
                        companyString.append(String.noNilStr(str: companyDict["name"]))
                        companyString.append(";")
                    }
                }
                self?.companyTextField.text = companyString
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imageView.image = self.image!
        
    }

    @objc func retakeBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.retakePicture()
    }
    
    @objc func saveBtnClick(_ sender: Any) {
        if self.nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0{
            self.view.makeToast("姓名不能为空", duration: 1.0, position: self.view.center)
            return
        }
        let result = shareView.resultParams()
        
        let params = ["contact_name":self.nameTextField.text!,
                      "contact_phone":self.mobileTextField.text!,
                      "contact_client_id":"0",
                      "contact_client_name":"",
                      "contact_position":self.postionTextField.text!,
                      "contact_email":self.emailTextField.text!,
                      "contact_qq":self.qqTextField.text!,
                      "contact_wechat":self.wechatTextField.text!,
                      "contact_addr":self.addressTextField.text!,
                      "contact_postcode":self.numTextField.text!,
                      "contact_fax":self.chuanzhenTextField.text!,
                      "contact_dep":self.departmentTextField.text!,
                      "contact_sex":"",
                      "contact_comment":"",
                      "token":UserModel.getUserModel().token!,
                      "trade_name":"",
                      "trade_id":"",
                      "authorization_member":result.2,
                      "authorization_corp":result.0,
                      "authorization_deps":result.1]
        
        let methodName = CONTACT_ADD
        self.umAnalyticsWithName(name: um_contactAddSave)
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: methodName, params: params, hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismissWithSuccess(str: "保存成功")
            self?.save()
            self?.navigationController?.popViewController(animated: true)
        }

    }
    
}
