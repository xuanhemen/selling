//
//  FindPasswordVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class FindPasswordVC: UIViewController {

    let phone = LoginTextView.init(frame: CGRect.init(x: 20, y: 40, width: MAIN_SCREEN_WIDTH-40, height: 50), andImage: "login_username", placeText: "请输入手机号", andIsHasVerifyBtn: true)
    
    let verify = LoginTextView.init(frame: CGRect.init(x: 20, y: 100, width: MAIN_SCREEN_WIDTH-40, height: 50), andImage: "login_password", placeText: "请输入验证码", andIsHasVerifyBtn: false)
    
    let pw = LoginTextView.init(frame: CGRect.init(x: 20, y: 160, width: MAIN_SCREEN_WIDTH-40, height: 50), andImage: "login_password", placeText: "请输入新密码", andIsHasVerifyBtn: false)
    
    
    let pwAgain = LoginTextView.init(frame: CGRect.init(x: 20, y: 220, width: MAIN_SCREEN_WIDTH-40, height: 50), andImage: "login_password", placeText: "请再次输入新密码", andIsHasVerifyBtn: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "找回密码"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.view.addSubview(phone!)
        phone?.sendVerify = { [weak self] in
            self?.toSendVerify()
        }
        self.view.addSubview(verify!)
        self.view.addSubview(pw!)
        pw?.textField.isSecureTextEntry = true
        self.view.addSubview(pwAgain!)
        pwAgain?.textField.isSecureTextEntry = true
        
        let exitBtn:UIButton = UIButton.init(type: .custom)
        self.view.addSubview(exitBtn)
        exitBtn.backgroundColor = kGreenColor
        exitBtn.layer.cornerRadius = 6
        exitBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(280)
            make.height.equalTo(50)
        }
        exitBtn.setTitle("确认", for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func exitBtnClick(){
        
        if !String.isMobile(str: (phone?.textField.text)!) {
            PublicMethod.toastWithText(toastText: "请输入正确的手机号")
            return
        }
        
        if (verify?.textField.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "请输入验证码")
            return
        }
        
        if (pw?.textField.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "请输入密码")
            return
        }
        
        if (pwAgain?.textField.text?.isEmpty)! {
            PublicMethod.toastWithText(toastText: "请再次输入密码")
            return
        }
        
        if pw?.textField.text != pwAgain?.textField.text {
            PublicMethod.toastWithText(toastText: "两次输入的密码不一致，请您再次确认")
            return
        }
        
        
        
        self.toSendPW()
        
    }
   
    
    
    
    func toSendVerify(){
        
        if !String.isMobile(str: (phone?.textField.text)!) {
            PublicMethod.toastWithText(toastText: "请输入正确的手机号")
            phone?.stop()
            return
        }
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: VERIFY_PHONE, params: ["username":phone?.textField.text], hadToast: true, fail: { (dic)  in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            DLog(dic)
            PublicMethod.toastWithText(toastText: "验证码发送成功，请注意查收")
            self?.phone?.startTimer()
        }
    }

    
    func toSendPW(){
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: FIND_PW, params: ["username":phone?.textField.text,"code":verify?.textField.text,"passport":LoginRequest.md5StringFromString(str: (pw?.textField.text)!)], hadToast: true, fail: { (dic)  in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            PublicMethod.toastWithText(toastText: "重置成功")
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
