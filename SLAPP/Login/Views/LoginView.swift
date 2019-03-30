//
//  LoginView.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import Masonry

class LoginView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   
    
    let phoneNum = UITextField()
    let passWord = UITextField()
    let loginBtn = UIButton(type: UIButtonType.custom)
    
    let buyBtn = UIButton(type: UIButtonType.custom)
   let forgetPassword = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let headImageView = UIImageView.init(frame: CGRect(x: 0, y: -64, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_WIDTH/7216*5412))
        headImageView.image = UIImage.init(named: "shutterstock")
        self.addSubview(headImageView)
        
        let backBlackView = UIView.init(frame: headImageView.frame)
        backBlackView.backgroundColor = .black
        backBlackView.alpha = 0.7
        self.addSubview(backBlackView)
        
        let yunImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/1242*426/1.5, height: MAIN_SCREEN_WIDTH/1242*426/304*224/1.5))
        yunImage.image = UIImage.init(named: "cloud")
        yunImage.center = headImageView.center
        self.addSubview(yunImage)
        
        let sl_cloud = UIImageView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/1242*700, height: MAIN_SCREEN_WIDTH/1242*700/717*141))
        sl_cloud.image = UIImage.init(named: "sl_cloud")
        sl_cloud.center = headImageView.center
        sl_cloud.centerY = sl_cloud.centerY + 80
        sl_cloud.centerX = sl_cloud.centerX - 5
        self.addSubview(sl_cloud)
        
        let phoneBackView = UIView()//电话号码背景
        phoneBackView.backgroundColor = .white
        self.addSubview(phoneBackView)
        weak var weakSelf = self
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        phoneBackView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(headImageView.mas_bottom)?.valueOffset()(30 as NSValue)
            make?.height.mas_equalTo()(60)
        }
        phoneBackView.layer.cornerRadius = 1.0
        phoneBackView.layer.shadowColor = UIColor.darkGray.cgColor;
        phoneBackView.layer.shadowOffset = CGSize.init(width: 2, height: 2);
        phoneBackView.layer.shadowOpacity = 0.5;
        phoneBackView.layer.shadowRadius = 2;
        
        let phoneImage = UIImageView()
        phoneImage.image = UIImage.init(named: "login_username")
        phoneBackView.addSubview(phoneImage)
        phoneImage.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
            make?.top.mas_equalTo()(phoneBackView)?.valueOffset()(20 as NSValue)
            make?.left.mas_equalTo()(phoneBackView)?.valueOffset()(5 as NSValue)
        }
        let phoneNumLab = UILabel.init()
        phoneNumLab.text = "账号:"
        //        phoneNum.text = "company@company.com"
        phoneBackView.addSubview(phoneNumLab)
        phoneNumLab.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(phoneImage)
            make?.left.mas_equalTo()(phoneImage.mas_right)?.valueOffset()(5 as NSValue)
            make?.width.equalTo()(60)
            make?.height.mas_equalTo()(phoneImage)
        }
        phoneNum.keyboardType = .numbersAndPunctuation
        phoneNum.placeholder = "手机号/邮箱"
//        phoneNum.text = "company@company.com"
        phoneBackView.addSubview(phoneNum)
        phoneNum.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()
            make?.left.mas_equalTo()(phoneNumLab.mas_right)
            make?.right.mas_equalTo()(phoneBackView)?.valueOffset()(-5 as NSValue)
            make?.centerY.mas_equalTo()(phoneBackView)
            make?.height.mas_equalTo()(30)
        }
        
//        phoneNum.backgroundColor = UIColor.black
//        phoneNumLab.backgroundColor = UIColor.gray
//        phoneBackView.backgroundColor = UIColor.red
        
        let passBackView = UIView()//电话号码背景
        passBackView.backgroundColor = .white
        self.addSubview(passBackView)
        passBackView.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(phoneBackView.mas_bottom)?.valueOffset()(20 as NSValue)
            make?.height.mas_equalTo()(60)
        }
        passBackView.layer.cornerRadius = 1.0
        passBackView.layer.shadowColor = UIColor.darkGray.cgColor;
        passBackView.layer.shadowOffset = CGSize.init(width: 2, height: 2);
        passBackView.layer.shadowOpacity = 0.5;
        passBackView.layer.shadowRadius = 2;
        
        let passImage = UIImageView()
        passImage.image = UIImage.init(named: "login_password")
        passBackView.addSubview(passImage)
        passImage.mas_makeConstraints { (make) in
            make?.size.mas_equalTo()(CGSize(width: 20, height: 20))
            make?.top.mas_equalTo()(passBackView)?.valueOffset()(20 as NSValue)
            make?.left.mas_equalTo()(passBackView)?.valueOffset()(5 as NSValue)
        }
        let passNumLab = UILabel.init()
        passNumLab.text = "密码:"
        //        phoneNum.text = "company@company.com"
        passBackView.addSubview(passNumLab)
        passNumLab.mas_makeConstraints { (make) in
            make?.top.mas_equalTo()(passImage)
            make?.left.mas_equalTo()(passImage.mas_right)?.valueOffset()(5 as NSValue)
            make?.width.equalTo()(60)
            make?.height.mas_equalTo()(passImage)
        }
        
        passWord.placeholder = "密码"
//        passWord.text = "111111"
        passWord.isSecureTextEntry = true
        passBackView.addSubview(passWord)
        passWord.mas_makeConstraints { (make) in
//            make?.top.mas_equalTo()(passImage)
            make?.left.mas_equalTo()(passNumLab.mas_right)
            make?.right.mas_equalTo()(passBackView)?.valueOffset()(-5 as NSValue)
            make?.centerY.mas_equalTo()(passBackView)
            make?.height.mas_equalTo()(30)
        }
        
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.backgroundColor = kNavBarBGColor
        loginBtn.layer.cornerRadius = 1
        self.addSubview(loginBtn)
        loginBtn.mas_makeConstraints { (make) in
            make?.left.mas_equalTo()(weakSelf)?.valueOffset()(LEFT_PADDING as NSValue)
            make?.right.mas_equalTo()(weakSelf)?.valueOffset()(-LEFT_PADDING as NSValue)
            make?.top.mas_equalTo()(passBackView.mas_bottom)?.valueOffset()(20 as NSValue)
            make?.height.mas_equalTo()(60)
        }
        loginBtn.layer.shadowColor = UIColor.darkGray.cgColor;
        loginBtn.layer.shadowOffset = CGSize.init(width: 2, height: 2);
        loginBtn.layer.shadowOpacity = 0.5;
        loginBtn.layer.shadowRadius = 2;
        
        forgetPassword.setTitleColor(UIColor.darkGray, for: .normal)
        self.addSubview(forgetPassword)
        forgetPassword.setTitle("忘记密码", for: .normal)
        forgetPassword.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        forgetPassword.snp.makeConstraints {[weak loginBtn] (make) in
            make.top.equalTo((loginBtn?.snp.bottom)!).offset(20)
            make.right.equalTo((loginBtn?.snp.right)!)
            make.width.equalTo(60)
        }
        
        buyBtn.setTitleColor(UIColor.darkGray, for: .normal)
        self.addSubview(buyBtn)
        buyBtn.setTitle("免费开通", for: .normal)
        buyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        buyBtn.snp.makeConstraints {[weak loginBtn] (make) in
            make.top.equalTo((loginBtn?.snp.bottom)!).offset(20)
            make.left.equalTo((loginBtn?.snp.left)!)
            make.width.equalTo(60)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
