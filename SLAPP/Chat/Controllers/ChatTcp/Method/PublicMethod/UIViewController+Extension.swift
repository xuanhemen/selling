//
//  UIViewController+Extension.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/15.
//  Copyright © 2017年 柴进. All rights reserved.
//

import Foundation
import SVProgressHUD
extension UIViewController {

    func configIOS10(){
        let a:NSString = UIDevice.current.systemVersion as NSString
        if a.floatValue < 11.0 {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
     /// 设置导航栏右侧按钮
     ///
     /// - Parameter items: 导航栏右侧按钮按从右往左的顺序,文字按钮直接传string类型,图片按钮需要传入UIImage类型
     func setRightBtnWithArray<T>(items:[T]){
    
        var itemArr = [UIBarButtonItem]()
        for i in 0..<items.count {
            
            let btn = UIButton.init()
            btn.tag = 1000 + i
            let item = items[i]
            if item is String {
                btn.titleLabel?.font = FONT_15
                btn.setTitle(item as? String, for: .normal)
            }
            if item is UIImage {
                btn.setImage(item as? UIImage, for: .normal)
            }
            btn.sizeToFit()
            btn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
            let barButtonItem = UIBarButtonItem.init(customView: btn)
            itemArr.append(barButtonItem)
        }
        self.navigationItem.rightBarButtonItems = itemArr
    }

    /// 导航栏右侧按钮点击事件,在需要监听方法的控制器中重写这个方法
    ///
    /// - Parameter button: 通过按钮的tag值判断点击的是哪一个,tag值从1000开始
    @objc func rightBtnClick(button:UIButton) {
        
    }
    
    
    
    /// 对导航颜色做修改
    func configNav(){
    
        let bar = UINavigationBar.appearance()
        bar.barTintColor = UIColor.black
        bar.tintColor = UIColor.white
        
        var attrs = [NSAttributedStringKey : AnyObject]()
        
        attrs[NSAttributedStringKey.font] = UIFont.systemFont(ofSize: 17)
        attrs[NSAttributedStringKey.foregroundColor] = UIColor.white
        bar.titleTextAttributes = attrs
   
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
    
    }
    
    
    
    
    /// 显示加载状态
    func progressShow(){
       self.configSVP()
       SVProgressHUD.show()
    }
    /// 显示加载状态
    func progressShowWith(str:String){
        self.configSVP()
        SVProgressHUD.show(withStatus: str)
    }
    /// 取消
    func progressDismiss(){
       SVProgressHUD.dismiss()
    }
    
    /// 取消
    func progressDismissWith(str:String){
        SVProgressHUD.showError(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 0.5)
    }

    /// 配置SVP
    func configSVP(){
//        SVProgressHUD.setDefaultStyle(.custom)
//        SVProgressHUD.setDefaultMaskType(.gradient)
//        SVProgressHUD.setBackgroundColor(UIColor.darkGray)
//        SVProgressHUD.setForegroundColor(UIColor.white)
    }
    
    
    
    /// 应酬tab
    ///
    /// - Parameter isHidden: <#isHidden description#>
    func isHiddeTab(isHidden:Bool){
        
        if self.tabBarController == nil {
            return;
        }
        
        if (self.tabBarController?.isKind(of: TMTabbarController.self))! {
            
            let tab:TMTabbarController = self.tabBarController as! TMTabbarController
            tab.isHiddenTab(isHidden: isHidden)
        }
        
    }

    
    /// 清除tab红点提示
    func clearTabRedPoint(){
    
        
        
        var tab:TMTabbarController?
        
        for vc in (self.navigationController?.childViewControllers)! {
            
            if vc.isKind(of: TMTabbarController.self) {
                tab = vc as! TMTabbarController
            }
        }
        
        guard tab != nil else {
            return
        }
        
            tab?.clearRedPoint()
        
        
    }
    
    
    /// 显示tab红点提示(在主题聊天界面调用)
    func showTabRedPoint(){
        
        
        
        var tab:TMTabbarController?
        
        for vc in (self.navigationController?.childViewControllers)! {
            
            if vc.isKind(of: TMTabbarController.self) {
                tab = vc as! TMTabbarController
            }
        }
        
        guard tab != nil else {
            return
        }
        
       tab?.showRedPoint(type: 1)
        
        
    }

    
    
    
    
    /// 显示红点提醒
    ///
    /// - Parameter type: <#type description#>
    func showRedRemind(type:Int){
        if self.tabBarController == nil {
            return;
        }
        
        
        if (self.tabBarController?.isKind(of: TMTabbarController.self))! {
          
            let tab:TMTabbarController = self.tabBarController as! TMTabbarController
            tab.showRedPoint(type: 1)
        }
    }
    
    
    
    
    func configBackItem(){
    
        let backBtn :UIButton = UIButton.init(type: .custom)
        backBtn.frame = CGRect.init(x: 0, y: 0, width: kNavBackWidth, height: kNavBackHeight)
        //        backBtn.setTitle("返回", for: .normal)
//        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-40,0,0);
        backBtn.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
        backBtn.sizeToFit()
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        let barItem :UIBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.navigationItem.leftBarButtonItem = barItem

    
    }
    
    
    @objc func backBtnClick()
    {
        if self is TMTabbarController {
            ((self as! TMTabbarController).viewControllers?.first as! SmallTalkVC).clearInputText()
        }
        self.navigationController?.popViewController(animated: true)
//        if self.childViewControllers.count>1 {
//            self.popViewController(animated: true)
//        }
//        else
//        {
//            let nav = self.tabBarController?.navigationController
//            nav?.popViewController(animated: true)
//            
//        }
        
        
    }

    
}
