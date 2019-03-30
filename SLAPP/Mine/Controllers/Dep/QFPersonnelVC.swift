//
//  QFPersonnelVC.swift
//  SLAPP
//
//  Created by qwp on 2018/6/12.
//  Copyright © 2018 柴进. All rights reserved.
//

import UIKit
import SwiftyJSON

class QFPersonnelVC: UIViewController {

    @IBOutlet weak var switchBackView: UIView!
    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var bigButton: UIButton!
    @IBOutlet weak var userHeaderImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var depNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var switchView: UISwitch!
    
    @IBOutlet weak var moveX: NSLayoutConstraint!
    var userId:String = ""
    var userDict:Dictionary = Dictionary<String, Any>()
    var allUserArray:Array = Array<Dictionary<String,Any>>()
    var baseDict:Dictionary = Dictionary<String, Any>()
    @objc var is_root = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人中心"
        self.userHeaderImageView.layer.cornerRadius = 55
        self.userHeaderImageView.clipsToBounds = true
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: QFdep_Personnel_info, params: ["userid":self.userId,"token":UserModel.getUserModel().token as Any], hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) {[weak self] (dic) in
            DLog(dic)
            PublicMethod.dismiss()
            self?.baseDict = dic
            self?.nameLabel.text = JSON(dic["realname"] as Any).stringValue
            self?.depNameLabel.text = JSON(dic["dep_name"] as Any).stringValue
            self?.phoneLabel.text = JSON(dic["mobile"] as Any).stringValue
            self?.emailLabel.text = JSON(dic["email"] as Any).stringValue
            self?.roleLabel.text = JSON(dic["position_name"] as Any).stringValue
            if JSON(dic["ismanager"] as Any).stringValue == "1" {
                self?.switchView.isOn = true
            }else{
                self?.switchView.isOn = false
            }
            if JSON(dic["is_login"] as Any).stringValue == "1" {
                self?.moveX.constant = SCREEN_WIDTH/2
            }else{
                self?.moveX.constant = 0
            }
            let headString = JSON(dic["head"] as Any).stringValue + imageSuffix
            self?.userHeaderImageView.sd_setImage(with: URL(string: headString), placeholderImage: nil)
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.is_root {
            self.switchBackView.isHidden = true
            self.bigButton.isHidden = true
            self.smallButton.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let params = ["dep_id":JSON(baseDict["dep_id"] as Any).stringValue,"domains":"CC","username":JSON(baseDict["mobile"] as Any).stringValue,"realname":JSON(baseDict["realname"] as Any).stringValue] as [String : Any];
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: USER_REGISTER, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismissWithSuccess(str: "发送成功")
        }
    }
    
    @IBAction func moveDepartment(_ sender: Any) {
        var alertString  = "转移时是否携带项目？"
        var cancelString = "不带项目"
        var sureString = "带项目"
        var isNoUser = false
        if self.allUserArray.count>1 {
            
        }else{
            alertString = "部门没有可接收项目人员，转移时会携带您的项目"
            cancelString = "取消"
            sureString = "确定"
            isNoUser = true
        }
        let alert = UIAlertController.init(title: "提醒", message: alertString, preferredStyle: .alert, btns: [kCancel:cancelString,"sure":sureString], btnActions: {[weak self] (ac, str) in
            
            if str != kCancel {
                let qfChooseVC = QFChooseDepartmentVC()
                qfChooseVC.isHaveProject = true
                qfChooseVC.userArray = [self?.userDict] as! Array<[String : Any]>
                self?.navigationController?.pushViewController(qfChooseVC, animated: true)
            }
            if str != "sure" {
                if isNoUser == false {
                    let vc = QFMoveProjectVC()
                    vc.userArray = (self?.allUserArray)!
                    vc.chooseArray = [self?.userDict] as! Array<[String : Any]>
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func switchValueChange(_ sender: Any) {
        
        let params = ["userid":JSON(baseDict["userid"] as Any).stringValue] as [String : Any];
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: QFdep_Personnel_isManager, params: params.addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            if JSON(dic["manager"] as Any).stringValue == "1" {
                self?.switchView.isOn = true
            }else{
                self?.switchView.isOn = false
            }
        }
    }
    

}
