//
//  PublicMethod.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/11.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

import Realm
import SVProgressHUD
import Toast


class PublicMethod: NSObject {

    class func analysisFailMessage(code:String,message:String) {
        SVProgressHUD.dismiss()
        
    }
    class func appRootViewController() -> UIViewController
    {
        
        let appRootVC = UIApplication.shared.keyWindow?.rootViewController
        var topVC = appRootVC
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController;
        }
        return topVC!;
    }
    class func appCurrentViewController() -> UIViewController
    {
        let vc = self.appRootViewController()
        if (vc is UITabBarController) {
            let nav = (vc as! UITabBarController).selectedViewController as? UINavigationController
            while ((nav?.topViewController?.presentedViewController) != nil) {
                return (nav!.topViewController?.presentedViewController)!;
            }
            return nav!.topViewController!;
        }else{
            return vc;
        }
    }
    class func appChildViewController() -> UIViewController
    {
        let appRootVC = UIApplication.shared.keyWindow?.rootViewController
        var topVC = appRootVC;
        while (topVC?.childViewControllers.count != 0) {
            if (topVC is UITabBarController) {
                topVC = (topVC as! UITabBarController).selectedViewController
            }else if (topVC is UINavigationController){
                topVC = (topVC as! UINavigationController).topViewController
            }else{
                DLog("出错了！！")
                break;
            }
        }
        return topVC!;
    }
    
    /// 非空判断
    ///
    /// - Returns: 是否为空 ture为非空
//    class func isNotEmpty(obj:Any) -> Bool {
//        if !(obj == nil) {
//            if !(obj is NSNull){
//                if !((obj as AnyObject).responds(to: Selector("length")) && ((obj as AnyObject).perform(Selector("length")) as! Int == 0)){
//                    if !((obj as AnyObject).responds(to: Selector("count")) && ((obj as AnyObject).perform(Selector("count")) as! Int == 0)){
//                        return true
//                    }
//                }
//            }
//        }
//        return false
////        return !(obj == nil || obj is NSNull || ((obj as AnyObject).responds(to: Selector("length")) && ((obj as AnyObject).perform(Selector("length")) as! Int == 0)) || ((obj as AnyObject).responds(to: Selector("count")) && ((obj as AnyObject).perform(Selector("count")) as! Int == 0)))
//    }
    
    /**
     *  toast 提醒
     *
     *  @param toastText 需要提醒的文字
     *  @param druation  要展示的时间长度
     */
    class func toastWithText(toastText:String,druation:Float) {
        let point = APPDelegate.window?.center
        let value = NSValue.init(cgPoint: point!)
        let style = CSToastStyle.init(defaultStyle: ())
        APPDelegate.window?.makeToast(toastText, duration: TimeInterval(druation), position: value, style: style)
    }
    
    /**
     *  toast 提醒 （默认展示时间为 2s）
     *
     *  @param toastText 需要提醒的文字
     */
    class func toastWithText(toastText:String)
    {
        self.toastWithText(toastText: toastText, druation: 2)
    }
    
    
    /// 初始化网络状态控件
    class func configSVP()
    {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setBackgroundColor(UIColor.white)
//        SVProgressHUD.setForegroundColor(kNavBarBGColor)
    }
    
    /**
     *  显示网络加载状态（不带文字）
     */
    class func showProgress()
    {
        self.configSVP()
        SVProgressHUD.show()
    }
    
    /**
     *  显示网络加载状态 （带提醒文字）
     *
     *  @param statusStr 要提醒的文字
     */
    class func showProgressWithStr(statusStr:String)
    {
        self.configSVP()
        SVProgressHUD.show(withStatus: statusStr)
    }
    
    /**
     *  取消显示网络加载状态
     */
    class func dismiss()
    {
        SVProgressHUD.dismiss()
    }
    
    /**
     *  加载失败  取消网络加载状态
     */
    class func dismissWithError()
    {
        SVProgressHUD.showError(withStatus: "加载失败")
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    /**
     *  加载失败  取消网络加载状态(自定义提醒文字)
     */
    class func dismissWithErrorStr(str:String?)
    {
        SVProgressHUD.showError(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    /**
     *  加载成功  取消网络加载状态
     */
    class func dismissWithSuccess(str:String)
    {
        SVProgressHUD.showSuccess(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 0.2)
    }
    
    class func dismissWithSuccessCompletion(str:String, completion:@escaping () -> Void)
    {
        SVProgressHUD.showSuccess(withStatus: str)
        SVProgressHUD.dismiss(withDelay: 0.2) {
            completion()
        }
    }
    
    // MARK: - 是否是管理员  企业管理者和部门都算
   class func isManager()->(Bool){
        let model = UserModel.getUserModel()
        if model.ismanager == "1" || model.is_root == "1" {
            return true
        }
        return false
    }
    
    func addddddd(){
        
        
    }

}
