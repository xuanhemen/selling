//
//  TabBarController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/21.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController,RCIMConnectionStatusDelegate {
    var carryView:HYCarryDownView?
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        
        if status == .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT {
            
            let alert = UIAlertController.init(title: "", message: "您的账号在别的设备登录，本设备被迫下线", preferredStyle: .alert, okAndCancel:("上线","知道了"), btnActions: {[weak self] (action, str) in
                
                if str == "ok" {
                    let login = LoginViewController()
                    login.connectRongYun(success: {
                        
                    }) { (str) in
                    }
                }else{
                    
                    
                    RCIM.shared().logout()
                    return
                    let nav = UINavigationController.init(rootViewController: LoginViewController())
                    self?.present(nav, animated: true, completion: nil)
                    
                }
                
            })
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if status == .ConnectionStatus_Connected {
            DLog("融云连接成功 5555555555")
            if !sharePublicDataSingle.publicData.pushToken.isEmpty {
            RCIMClient.shared().setDeviceToken(sharePublicDataSingle.publicData.pushToken)
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = Int(RCIMClient.shared().getTotalUnreadCount())
                }
            }
        }
        
        if status == .ConnectionStatus_UNKNOWN {
             DLog("融云连接出错了5555555555")
        }
    }
    
    
    
   
    
    
    var customTabbar = TabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.creatTabbar()
       
        tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = kGreenColor
        self.creatChildViewControllers()
        
       RCIM.shared().connectionStatusDelegate = self
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "changeGroupRedCount"), object: nil, queue: nil) { (notif) in
            DispatchQueue.main.async(execute: {
                if self.tabBar.items != nil && (self.tabBar.items?.count as! Int) > 4{
                    (self.tabBar.items![0] as! UITabBarItem).showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
                }
            })
        }
       sharePublicDataSingle.publicTabbar = self
    }

    
    @objc func showCarrayDown(str:String){
        let cView : HYCarryDownView = HYCarryDownView()
        self.view.addSubview(cView)
        cView.des.text = str
        cView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0);
            make.height.equalTo(40);
            make.bottom.equalTo(-TAB_HEIGHT)
        }
        cView.carryDownClick = { [weak self] in
            let vc:UINavigationController =  (self?.viewControllers![(self?.selectedIndex)!])! as! UINavigationController;
            
            vc.pushViewController(HYCarryDownVC(), animated: true)
        }
        self.carryView = cView
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        for child in self.tabBar.subviews {
////            if child is UITabBarItem{
//                child.removeFromSuperview()
////            }
//        }
        if self.tabBar.items != nil && (self.tabBar.items?.count as! Int) > 4{
            (self.tabBar.items![0] as! UITabBarItem).showBadge(with: .number, value: Int(RCIMClient.shared().getTotalUnreadCount()), animationType: .none)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    /**
     * 初始化自定义的tabbar
     */
    func creatTabbar() {
        tabBar.backgroundImage = UIImage.init(named: "backWhite")
        tabBar.shadowImage = UIImage()
        customTabbar = TabBarView.init(frame: tabBar.bounds)
        //customTabbar.deleg
        customTabbar.tabBarDidSelectBtnFrom = {(tabBar,from,to) in
            self.selectedIndex = to
        }
        
        tabBar.addSubview(customTabbar)
        
    }
    
    func creatChildViewControllers() {
      
        let viewC1 = HYHomeVC.init()
        self.creatChildViewController(childVC: viewC1, title: "首页", imageName: "homeNomal", selectedImageName: "homeSelect")

        let viewC2 = QFProjectViewController()
        self.creatChildViewController(childVC: viewC2, title: "项目", imageName: "projectNomal", selectedImageName: "projectSelect")
        
        let viewC3 = WorkbenchVC.init()
        self.creatChildViewController(childVC: viewC3, title: "工作台", imageName: "workbenchNomal", selectedImageName: "workbenchSelect")
        
        
        let viewC4 = DashboardVC()
        self.creatChildViewController(childVC: viewC4, title: "仪表盘", imageName: "dashboardNomal", selectedImageName: "dashboardSelect")
        
        
        let viewC5 = MineViewController()
        self.creatChildViewController(childVC: viewC5, title: "我的", imageName: "mineNomal", selectedImageName: "mineSelect")
        
        
       DLog(UserModel.getUserModel().im_token)
        
        RCIM.shared().connect(withToken: UserModel.getUserModel().im_token, success: { (userId) in
            //            success()
            DLog("登陆成功。当前登录的用户ID：\(userId)")
        }, error: { (status) in
            //            error("登陆的错误码为:\(status)")
            DLog("登陆的错误码为:\(status)")
        }) {
            //            error("token错误")
            DLog("token错误")
        }
        //本地后台通知
        
        RCIM.shared().disableMessageAlertSound = true
        
        let login = LoginViewController()
        login.connectRongYun(success: {

        }) { (str) in
                    }
    }
    
    func selectedWithIndex(index:NSInteger) {
        
        self.selectedIndex = index
//        customTabbar.selectedWithIndex(selectIndex: index)
    }
    func setbage(badge:String,index:NSInteger) {
//        customTabbar.setBage(badge: badge, index: index)
    }
    
    /**
     *  初始化
     *
     *  @param childVC           要被加入的视图控制器
     *  @param title             标题
     *  @param imageName         正常显示图片
     *  @param selectedImageName 选中显示图片
     */
    func creatChildViewController(childVC:UIViewController,title:String,imageName:String,selectedImageName:String) {
        childVC.tabBarItem.title = title
        childVC.tabBarItem.image = UIImage.init(named: imageName)
        let selectedImage = UIImage.init(named: selectedImageName)
        childVC.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        let nav = BaseNavigationController.init(rootViewController: childVC)
        self.addChildViewController(nav)
        
        nav.pushClick = { [weak self] in
            
            if self?.carryView != nil {
                self?.carryView?.isHidden = true
            }
            
        }
        
        nav.popClick = { [weak self] in
            
            var isNotfirst:Bool = false
            for nav in (self?.viewControllers)! {
                if (nav.childViewControllers.count > 2){
                    isNotfirst = true
                    break
                }
            }
            
            if isNotfirst == false {
                if self?.carryView != nil {
                    self?.carryView?.isHidden = false
                }
            }
            
        }
        
        
    }

}
