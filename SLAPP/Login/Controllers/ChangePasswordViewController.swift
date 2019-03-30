//
//  ChangePasswordViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    var saveFinish = {}
    var savePass:((String)->())? = nil

    let phoneNum = UITextField()
    let passWord = UITextField()
    let loginBtn = UIButton(type: UIButtonType.custom)
    
    let oldBackView = UIView()//电话号码背景
    let oldWord = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "修改密码"
        // Do any additional setup after loading the view.
//        let back = YGGravityImageView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT))
//        back.image = UIImage.init(named: "login_bg6")
//        back.startAnimate()
//        self.view.addSubview(back)
        
        
        
        let phoneBackView = UIView()//电话号码背景
        phoneBackView.backgroundColor = .white
        self.view.addSubview(phoneBackView)
        weak var weakSelf = self.view
        
        oldBackView.backgroundColor = .white
        self.view.addSubview(oldBackView)
        oldBackView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.bottom.mas_equalTo()(phoneBackView.mas_top)?.valueOffset()(-30 as NSValue)
            make?.height.mas_equalTo()(40)
        }
        oldBackView.layer.cornerRadius = 5.0
        
        let oldImage = UIImageView()
        oldImage.image = UIImage.init(named: "login_password")
        oldBackView.addSubview(oldImage)
        oldImage.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 30, height: 30))
            make?.top.mas_equalTo()(oldBackView)?.valueOffset()(5 as NSValue)
            make?.left.mas_equalTo()(oldBackView)?.valueOffset()(5 as NSValue)
        }
        
        oldWord.placeholder = "请输入旧密码"
        //        passWord.text = "111111"
        oldWord.isSecureTextEntry = true
        oldBackView.addSubview(oldWord)
        oldWord.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(oldImage)
            make?.left.mas_equalTo()(oldImage.mas_right)?.valueOffset()(5 as NSValue)
            make?.right.mas_equalTo()(oldBackView)?.valueOffset()(-5 as NSValue)
            make?.height.mas_equalTo()(oldImage)
        }
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        phoneBackView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(weakSelf)?.valueOffset()(NAV_HEIGHT+100 as NSValue)
            make?.height.mas_equalTo()(40)
        }
        phoneBackView.layer.cornerRadius = 5.0
        
        let phoneImage = UIImageView()
        phoneImage.image = UIImage.init(named: "login_password")
        phoneBackView.addSubview(phoneImage)
        phoneImage.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 30, height: 30))
            make?.top.mas_equalTo()(phoneBackView)?.valueOffset()(5 as NSValue)
            make?.left.mas_equalTo()(phoneBackView)?.valueOffset()(5 as NSValue)
        }
        
        phoneNum.placeholder = "请输入新密码"
        //        phoneNum.text = "company@company.com"
        phoneBackView.addSubview(phoneNum)
        phoneNum.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(phoneImage)
            make?.left.mas_equalTo()(phoneImage.mas_right)?.valueOffset()(5 as NSValue)
            make?.right.mas_equalTo()(phoneBackView)?.valueOffset()(-5 as NSValue)
            make?.height.mas_equalTo()(phoneImage)
        }
        
        let passBackView = UIView()//电话号码背景
        passBackView.backgroundColor = .white
        self.view.addSubview(passBackView)
        passBackView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(phoneBackView.mas_bottom)?.valueOffset()(30 as NSValue)
            make?.height.mas_equalTo()(40)
        }
        passBackView.layer.cornerRadius = 5.0
        
        let passImage = UIImageView()
        passImage.image = UIImage.init(named: "login_password")
        passBackView.addSubview(passImage)
        passImage.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 30, height: 30))
            make?.top.mas_equalTo()(passBackView)?.valueOffset()(5 as NSValue)
            make?.left.mas_equalTo()(passBackView)?.valueOffset()(5 as NSValue)
        }
        
        passWord.placeholder = "请再次输入新密码"
        //        passWord.text = "111111"
//        passWord.isSecureTextEntry = true
        passBackView.addSubview(passWord)
        passWord.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(passImage)
            make?.left.mas_equalTo()(passImage.mas_right)?.valueOffset()(5 as NSValue)
            make?.right.mas_equalTo()(passBackView)?.valueOffset()(-5 as NSValue)
            make?.height.mas_equalTo()(passImage)
        }
        
        loginBtn.setTitle("保存", for: .normal)
        loginBtn.backgroundColor = kNavBarBGColor
        loginBtn.layer.cornerRadius = 10
        self.view.addSubview(loginBtn)
        loginBtn.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(passBackView.mas_bottom)?.valueOffset()(30 as NSValue)
            make?.height.mas_equalTo()(40)
        }
        
        loginBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func exitBtnClick() {
//        if !oldBackView.isHidden{
//            if oldWord.text != (UserDefaultRead(key: kPassword) as? String) {
//                PublicMethod.toastWithText(toastText: "旧密码错误，请核对!")
//                return
//            }
//        }
        if phoneNum.text != passWord.text{
            PublicMethod.toastWithText(toastText: "您输入的2次密码不一致，请核对!")
            return
        }
        PublicMethod.showProgressWithStr(statusStr: "修改密码中...")
        if savePass == nil {
            let oldPassText = oldBackView.isHidden ? UserDefaultRead(key: kPassword) as! String : oldWord.text!
            LoginRequest.getPost(methodName: MEMBER_SAVE_PWD, params: ["old_passport":BaseRequest.md5StringFromString(str: oldPassText),"new_passport":BaseRequest.md5StringFromString(str: phoneNum.text!),kToken:UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
                PublicMethod.dismissWithError()
            }) { (dic) in
                PublicMethod.dismissWithSuccess(str: "成功")
                let user = UserModel.getUserModel()
                user.is_pass = "1"
                user.saveUserModel()
                UserDefaultWrite(id: self.passWord.text, key: kPassword)
                self.saveFinish()
//                self.navigationController?.popViewController(animated: true)
            }
        }else{
            savePass!(phoneNum.text!)
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
