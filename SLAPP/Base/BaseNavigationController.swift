//
//  BaseNavigationController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/12.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {
    
    let topView = UIView()
    let backButton = UIButton()
    let rightButton = UIButton()
    let rightButton2 = UIButton()
    let navView = UIView()
    let titleLab = UILabel()
    
    var pushClick:()->() = { () in
        
    }
    
    var popClick:()->() = { () in
        
    }
    
    let backView = UIView(frame: CGRect(x: 0, y: -30, width: MAIN_SCREEN_WIDTH, height: 80))
    
    func makeNavigationView(vc:UIViewController) {
        
        let backButton = UIButton.init(frame: CGRect(x:0, y: 0.0, width: kNavBackWidth*3, height: kNavBackHeight*2))
        
        backButton.backgroundColor  = UIColor.red
        
//        backButton.imageEdgeInsets = UIEdgeInsetsMake(0,-40,0,0);
        backButton.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: backButton)
//        vc.navigationItem.leftBarButtonItem = leftItem;
//        self.navigationBar.addSubview(backButton);
//        self.navigationItem.setHidesBackButton(true, animated: false)
//        vc.navigationItem.backBarButtonItem = leftItem
        
        
        
        
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//
//            forBarMetrics:UIBarMetricsDefault];
        
        
    }
    
    func customizeInterface() {
        let navBarAppearance = UINavigationBar.appearance()
        var backgroundImage = UIImage()
        var textAttributes = Dictionary<NSAttributedStringKey,Any>()

        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1){
            backgroundImage = UIImage.imageFromColor(color:kGrayColor_Slapp)
            textAttributes = [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),
                NSAttributedStringKey.foregroundColor: kColor_NavBarTitle
            ]
        }else{
            //#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
            backgroundImage = UIImage.imageFromColor(color: kNavBarBGColor_Black)
            textAttributes =  [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
                NSAttributedStringKey.foregroundColor: kColor_NavBarTitle,
                //        NSAttributedStringKey(rawValue: UITextAttributeTextShadowColor): UIColor.clear,
                //        NSAttributedStringKey(rawValue: UITextAttributeTextShadowOffset): NSValue.init(uiOffset: UIOffset.zero)
            ]
            
            //            #endif
        }
        navBarAppearance.tintColor = UIColor.white
        navBarAppearance.setBackgroundImage(backgroundImage, for: .default)
        navBarAppearance.titleTextAttributes = textAttributes
        //        navBarAppearance.isTranslucent = true
        
        //        backView.backgroundColor = kGrayColor_Slapp
        //        navBarAppearance.addSubview(backView)
        //        navBarAppearance.sendSubview(toBack: backView)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.customizeInterface()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    //    override init(rootViewController: UIViewController) {
    //        super.init(rootViewController: rootViewController)
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationBar.shadowImage = UIImage.init()
//        //获取系统自带滑动手势的target对象
//        let target = self.interactivePopGestureRecognizer?.delegate
//        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//        let pan = UIPanGestureRecognizer.init(target: target, action: Selector("handleNavigationTransition:"))
//        // 设置手势代理，拦截手势触发
//        pan.delegate = self
//        // 给导航控制器的view添加全屏滑动手势
//        self.view.addGestureRecognizer(pan)
        // 禁止使用系统自带的滑动手势
        self.interactivePopGestureRecognizer?.isEnabled = false;
    }
    
    // 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
        // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
        if (self.childViewControllers.count == 1) {
            // 表示用户在根控制器界面，就不需要触发滑动手势，
            //        self.tabBarController.tabBar.hidden = NO;
            return false;
        }else{
            let tPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
            if (tPoint.x >= 0) {
                let x = fabs(tPoint.x)
                if (x<0) {
                    return false
                }
                return true;
            }else{
                return false;
            }
        }
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
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 禁止使用系统自带的滑动手势
        self.interactivePopGestureRecognizer?.isEnabled = false;
        if (self.viewControllers.count > 0)
        {
            viewController.hidesBottomBarWhenPushed = true;
            self.makeNavigationView(vc: viewController)
        }
        if viewController is BaseViewController || viewController is TMTabbarController || viewController is RCConversationListViewController || viewController is RCConversationViewController{
            self.navigationBar.isTranslucent = true
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp2
        }else{
            self.navigationBar.isTranslucent = false
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp
        }
        self.pushClick()
        super.pushViewController(viewController, animated: animated)
        
        
        
        
        let backButton = UIButton.init(type: .custom);
        backButton.frame = CGRect(x:0, y: 0.0, width: kNavBackWidth*3, height: kNavBackHeight*2)
        //        backButton.imageEdgeInsets = UIEdgeInsetsMake(0,-40,0,0);
        backButton.setImage(UIImage.init(named: "icon-arrow-left"), for: .normal)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: backButton)
        
        
        viewController.navigationItem.backBarButtonItem = leftItem;
    }
    
    
    fileprivate func goBackAlert(_ tc: ThemeChatVC, _ end: @escaping ()->()) {
        //                    addEndBtn()
        let predicate = NSPredicate.init(format: "groupid == %@", argumentArray: [tc.targetId])
        let result = GroupModel.objects(with: predicate)
        if result.count > 0 {
           
                tc.addAlertView(title: "请注意", message: "您是想结束辅导，还是暂时离开？", actionTitles: ["结束辅导","暂时离开"], okAction: { (action) in
                    tc.addAlertView(title: "", message: "结束辅导后，导师将不再进行辅导，您确认要结束辅导吗？", actionTitles: ["确定","取消"], okAction: { (action) in
                        tc.progressShow()
                        GroupRequest.finishOnlineConsult(params: ["app_token":sharePublicDataSingle.token,"sub_groupid":tc.gModel?.groupid], hadToast: true, fail: { (error) in
                            tc.progressDismiss()
                        }, success: { (dic) in
                            DLog(dic)
                            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
                            var time:String? = UserDefaults.standard.object(forKey: username) as! String?
                            if time == nil{
                                time = "0"
                            }
                            //结束辅导后对导师进行评分
                            let view = EvaluateTeacherView.init(consultId: (tc.gModel?.consult_info?.consult_id)!, teacherId: (tc.gModel?.consult_info?.teacher_sso_userid)!, frame: UIScreen.main.bounds)
                            tc.view.addSubview(view)
                            view.willgoback = {end()}
                            
                            UserRequest.initData(params: ["app_token":sharePublicDataSingle.token,"updatetime":time!], hadToast: true, fail: { (fail) in
                                //                        tc.progressDismiss()
                            }, success: {(dic) in
                                DLog(dic)
                                tc.endBtn?.removeFromSuperview()
                                //                        tc.progressDismiss()
                            })
                        })
                    }, cancleAction: { (action) in
                        self.goBackAlert(tc, end)
                    })
                }, cancleAction: { (action) in
                    end()
                })
                
                
                
            }
        
    
        
        
        
        
        
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        self.popClick()
        if self.topViewController is ThemeChatVC {
            let tc = self.topViewController as! ThemeChatVC
            if tc.gModel?.is_consult == 1 && (tc.gModel?.owner_id == sharePublicDataSingle.publicData.userid){
                DLog("groupModel?.consult_info?.consult_status :\(tc.gModel?.consult_info?.consult_status)")
                if tc.gModel?.consult_info?.consult_status == "5" {
                    goBackAlert(tc, {
                        return super.popViewController(animated: animated)
                    })
                    return nil
                }
            }
        }
        if self.childViewControllers[self.childViewControllers.count - 2] is BaseViewController || self.childViewControllers[self.childViewControllers.count - 2] is TMTabbarController || self.childViewControllers[self.childViewControllers.count - 2] is RCConversationListViewController || self.childViewControllers[self.childViewControllers.count - 2] is RCConversationViewController{
            self.navigationBar.isTranslucent = true
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp2
        }else{
            self.navigationBar.isTranslucent = false
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp
        }
        return super.popViewController(animated: animated)
    }
    @objc func pop() {
        
        self.popViewController(animated: true)
        if self.topViewController is BaseViewController || self.topViewController is TMTabbarController || self.topViewController is RCConversationListViewController || self.topViewController is RCConversationViewController{
            self.navigationBar.isTranslucent = true
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp2
        }else{
            self.navigationBar.isTranslucent = false
            let statusBar = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = kGrayColor_Slapp
        }
        
    }
    
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        self.popClick()
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        self.popClick()
        return super.popToRootViewController(animated: animated)
    }
}

