//
//  WelcomeViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/6.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "欢迎"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        
        
        let backimag = UIImageView.init(frame: CGRect(x: -50, y: 0, width: MAIN_SCREEN_HEIGHT_PX*7216/5412, height: MAIN_SCREEN_HEIGHT_PX))
        backimag.image = UIImage.init(named: "shutterstock")
        self.view.addSubview(backimag)
        let backBlackView = UIView.init(frame: backimag.frame)
        backBlackView.backgroundColor = .black
        backBlackView.alpha = 0.7
        self.view.addSubview(backBlackView)
        let yunImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/1242*426, height: MAIN_SCREEN_WIDTH/1242*426/422*385))
        yunImage.image = UIImage.init(named: "cloud")
        yunImage.center = CGPoint(x: MAIN_SCREEN_WIDTH/2, y: 150)
        self.view.addSubview(yunImage)
        
        let w1Lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 40))
        w1Lab.text = "欢迎使用赢单罗盘"
        w1Lab.font = UIFont.systemFont(ofSize: 20)
        w1Lab.textAlignment = .center
        w1Lab.textColor = .white
        w1Lab.center = CGPoint(x: self.view.centerX, y: self.view.centerY)
        self.view.addSubview(w1Lab)
        let w2Lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 40))
        w2Lab.text = "为使您的赢单罗盘尽快投入使用，\n下面请" + (UserModel.getUserModel().is_pass == "0" ? "修改密码并进行初始配置。"  : "进行初始配置。")
//        w2Lab.text = "为使您的销售罗盘·云教练尽快投入使用，\n下面请" + (UserModel.getUserModel().guide == "0" ? (UserModel.getUserModel().is_pass == "0" ? "修改密码并邀请同事加入。" : "邀请同事加入") : "修改密码。")
        w2Lab.font = kFont_Big
        w2Lab.textAlignment = .center
        w2Lab.numberOfLines = 0
        w2Lab.textColor = .white
        w2Lab.center = CGPoint(x: self.view.centerX, y: self.view.centerY/2*3)
        self.view.addSubview(w2Lab)
        
        let exitBtn:UIButton = UIButton.init(type: .custom)
        self.view.addSubview(exitBtn)
        exitBtn.backgroundColor = kGreenColor
        exitBtn.layer.cornerRadius = 6
        exitBtn.frame = CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/2, height: 40)
        exitBtn.center = CGPoint(x: self.view.centerX, y: self.view.centerY/4*7)
        exitBtn.setTitle("开始配置", for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        
    }
    
    @objc func exitBtnClick() {
        if UserModel.getUserModel().is_pass == "0"{
            let changep = ChangePasswordViewController()
            changep.oldBackView.isHidden = true
            changep.saveFinish = {
                let dep = DepartmentVC()
                dep.isInitConfig = true
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.pushViewController(dep, animated: true)
            }
            self.navigationController?.pushViewController(changep, animated: true)
        }else{
            let dep = DepartmentVC()
            dep.isInitConfig = true
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(dep, animated: true)
        }
    }
    
    @objc func finishClick() {
        
        let vc = ProductInformationVC()
        vc.parentid = "0"
        vc.isInit = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
