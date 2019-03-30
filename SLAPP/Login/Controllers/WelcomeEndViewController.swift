//
//  WelcomeEndViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/2/13.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class WelcomeEndViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.title = "欢迎"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        self.navigationController?.isNavigationBarHidden = true
        
        let backimag = UIImageView.init(frame: CGRect(x: -50, y: 0, width: MAIN_SCREEN_HEIGHT_PX*7216/5412, height: MAIN_SCREEN_HEIGHT_PX))
        backimag.image = UIImage.init(named: "shutterstock")
        self.view.addSubview(backimag)
        let backBlackView = UIView.init(frame: backimag.frame)
        backBlackView.backgroundColor = .black
        backBlackView.alpha = 0.7
        self.view.addSubview(backBlackView)
        let yunImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH/1242*426, height: MAIN_SCREEN_WIDTH/1242*426/422*385))
        yunImage.image = UIImage.init(named: "cloudRight")
        yunImage.center = CGPoint(x: MAIN_SCREEN_WIDTH/2, y: 150)
        self.view.addSubview(yunImage)
        
        let w1Lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 60))
        w1Lab.text = "恭喜您，已完成初始配置，\n您可以使用赢单罗盘了！"
        w1Lab.font = UIFont.systemFont(ofSize: 20)
        w1Lab.textAlignment = .center
        w1Lab.numberOfLines = 0
        w1Lab.textColor = .white
        w1Lab.center = CGPoint(x: self.view.centerX, y: self.view.centerY)
        self.view.addSubview(w1Lab)
        let w2Lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: 40))
        w2Lab.text = "温馨提示：您可以前往我的——企业管理配置其他内容。"
        w2Lab.font = kFont_Big
        w2Lab.textAlignment = .left
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
        exitBtn.setTitle("开始使用", for: .normal)
        exitBtn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
        
    }
    
    @objc func exitBtnClick() {
        let tab = TabBarController.init(nibName: nil, bundle: nil)
        APPDelegate.window?.rootViewController = tab
    }
    
    @objc func finishClick() {
        let tab = TabBarController.init(nibName: nil, bundle: nil)
        APPDelegate.window?.rootViewController = tab
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
