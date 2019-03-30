//
//  AppDelegate.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/7.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import UserNotifications
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCCallReceiveDelegate ,UNUserNotificationCenterDelegate{

    var window: UIWindow?

    var buildVC:SLNewBuildScheduleVC?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //服务器环境配置
        self.config()
        // Override point for customization after application launch.
        //推送注册
        self.toRegisterPushNotoInfo(launchOptions: launchOptions)
       
//        友盟统计相关
        self.configUM()
        
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        application.statusBarStyle = .lightContent
        let vc = UIViewController.init()
        let img = UIImageView.init(frame: UIScreen.main.bounds)
        img.image = self.getLuimage()
        vc.view.addSubview(img)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
//        RCIM.shared().initWithAppKey("qf3d5gbjqpxeh")//测试
//        RCIM.shared().initWithAppKey("sfci50a7sqloi")//正式
        RCIM.shared().initWithAppKey(ryKey)
        RCIMDelegate.shared.isBack = false//融云收消息监听，勿删！！！
        //设置全局通话呼入的监听器RCCallReceiveDelegate
        RCCallClient.shared().setDelegate(self)
        //设置融云log级别
        RCIMClient.shared().logLevel = RCLogLevel.log_Level_Error
        //demo
//        RCIM.shared().initWithAppKey("n19jmcy59f1q9")
        
        if UserDefaultRead(key: kPassword) == nil ? false : ((UserDefaultRead(key: kPassword) as! String) != "") && ((UserModel.getUserModel().companies) != nil) {
            
            sharePublicDataSingle.token = UserModel.getUserModel().token! as NSString;
            sharePublicDataSingle.publicData.userid = UserModel.getUserModel().tcp_userid!
            sharePublicDataSingle.publicData.avater = UserModel.getUserModel().avater!
            sharePublicDataSingle.publicData.corpid = UserModel.getUserModel().corpid!
            sharePublicDataSingle.publicData.realname = UserModel.getUserModel().realname!
            sharePublicDataSingle.publicData.im_token = UserModel.getUserModel().im_token!
            sharePublicDataSingle.publicData.im_userid = UserModel.getUserModel().im_userid!
            print("系统"+sharePublicDataSingle.publicData.im_userid)
            sharePublicDataSingle.startGetMessageNot()
            
            DLog(UserModel.getUserModel().im_userid)
            
            DataOperation.initDataBase()
            
            

            let tab = TabBarController.init(nibName: nil, bundle: nil)
            self.window?.rootViewController = tab
        }else{
            let lgV = LoginViewController.init(nibName: nil, bundle: nil)
                let baseNav = BaseNavigationController.init(rootViewController: lgV)
            window?.rootViewController = baseNav
        }
        
     
        
        window?.makeKeyAndVisible()
       
//        版本升级提醒
        setupSiren()
        
        return true
    }
    
    

    
    /// 友盟统计相关设置
    func configUM(){
        //友盟统计
        UMConfigure.initWithAppkey(umAnalyticsKey, channel: umChannel)
        MobClick.setScenarioType(.E_UM_NORMAL)
        
        //错误日志统计
        MobClick.setCrashReportEnabled(true)
        
        //分享
        UMSocialManager.default().umSocialAppkey = umAnalyticsKey
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wxfb198075d96fd300", appSecret: "eb9c78b25b9d21cb32b111e09708322c", redirectURL: "http://file.xslp.cn/upgrade/downloadApp.html")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "101527321", appSecret: nil, redirectURL: "http://file.xslp.cn/upgrade/downloadApp.html")
    }
    
   
    /// 版本升级提醒
    func setupSiren() {
        let siren = Siren.shared
        siren.debugEnabled = false

//        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        
        siren.forceLanguageLocalization = .chineseSimplified
        siren.majorUpdateAlertType = .option
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
        
        Siren.shared.checkVersion(checkType: .immediately)
    }

    
    
    //MARK: - ---------------------收到通话的代理RCCallReceiveDelegate----------------------
    func didReceiveCall(_ callSession: RCCallSession!) {
        let predicate = NSPredicate.init(format: "groupid == %@ AND is_delete == '0'", callSession.targetId)
        let groupUser =  GroupUserModel.objects(with: predicate)
        for i in 0..<groupUser.count {
            let gModel:GroupUserModel = groupUser.object(at: i) as! GroupUserModel
            let userModelTemp : UserModelTcp? = UserModelTcp.objects(with: NSPredicate.init(format: "userid == %@", gModel.userid)).firstObject() as! UserModelTcp?
            
            let userModel = RCUserInfo.init()
            userModel.userId = gModel.im_userid
            userModel.name = userModelTemp?.realname
            
            if userModelTemp?.avater == nil { //头像为空时设置默认头像
                userModel.portraitUri = defaultHeaderImageURL
            }
            else
            {
                userModel.portraitUri = userModelTemp?.avater
            }
            
            RCIM.shared().refreshUserInfoCache(userModel, withUserId: userModel.userId)
        }
        if callSession.mediaType == RCCallMediaType.audio {
            let callAudioVc = CallAudioMultiCallViewController.init(incomingCall: callSession)
            RCCall.shared().present(callAudioVc)
        }
        if callSession.mediaType == RCCallMediaType.video {
            let callVideoVc = CallVideoMultiCallViewController.init(incomingCall: callSession)
            RCCall.shared().present(callVideoVc)
        }
    }
    func didReceiveCallRemoteNotification(_ callId: String!, inviterUserId: String!, mediaType: RCCallMediaType, userIdList: [Any]!, userDict: [AnyHashable : Any]!) {
        
    }
    
    func didCancelCallRemoteNotification(_ callId: String!, inviterUserId: String!, mediaType: RCCallMediaType, userIdList: [Any]!) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        RCIMDelegate.shared.isBack = true
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = Int(RCIMClient.shared().getTotalUnreadCount())
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        RCIMDelegate.shared.isBack = false
        Siren.shared.checkVersion(checkType: .daily)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Siren.shared.checkVersion(checkType: .daily)
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func getLuimage() -> UIImage {
        let viewSize = UIScreen.main.bounds.size
        let viewOrientation = "Portrait"
        var launchImage = ""
        let images = Bundle.main.infoDictionary!["UILaunchImages"]  as! Array<Dictionary<String,Any>>
        for dict in images {
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"] as! String)
            if (imageSize.equalTo(viewSize) && viewOrientation == dict["UILaunchImageOrientation"] as! String) {
                launchImage = dict["UILaunchImageName"] as! String
            }
        }
        return UIImage.init(named: launchImage)!
        
    }
    
    func fetchVersion() {
        let params = Dictionary<String,Any>()
        LoginRequest.getPost(methodName: QFRequest_FetchVersion, params: params.addToken(), hadToast: true, fail: { (dic) in
        }) { [weak self](dic) in
            DLog("获取版本更新")
            DLog(dic)
            
        }
    }

    // MARK: - *********** 推送相关 **************
    
    //注册推送通知
    func toRegisterPushNotoInfo(launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    DLog("注册通知iOS request notification success")
                   
                }else{
                    DLog("注册通知iOS 10 request notification fail")

                }
            }
            notifiCenter.getNotificationSettings { (settings) in
                
            }
        } else { //iOS8,iOS9注册通知
            
            let setting = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
            
      UIApplication.shared.registerUserNotificationSettings(setting)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    
    //iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    
    private func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void){
        let userInfo = notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler([.sound,.alert])
        
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    private func userNotificationCenter(center: UNUserNotificationCenter, didReceiveNotificationResponse response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void){
        let userInfo = response.notification.request.content.userInfo
        print("userInfo10:\(userInfo)")
        completionHandler()
    }
    //本地通知后台（需要点击）
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let info = response.notification.request.content.userInfo
        self.toDealwith(info: info as! [String : String])
        print("本地通知后台")
    }
    //本地通知前台
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let info = notification.request.content.userInfo
        print(info["id"] ?? "")
        self.toDealwith(info: info as! [String : String])
    }
    //处理本地通知
    func toDealwith(info: [String:String]) {
        let contentStr = info["content"] ?? ""
        let alertController = UIAlertController(title: "日程提醒",message: contentStr, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "知道啦", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "查看详情", style: .default, handler: {
            action in
            self.buildVC = SLNewBuildScheduleVC()
            let nvc = UINavigationController.init(rootViewController: self.buildVC!)
            let barItem = UIBarButtonItem.init(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.dismissView))
            self.buildVC?.navigationItem.leftBarButtonItem = barItem
            self.buildVC?.buildStyle = SLBuildStyle.look
            self.buildVC?.numberID = info["id"] ?? ""
            UIApplication.shared.keyWindow?.rootViewController?.present(nvc, animated: true, completion: {
                
            })
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: {
            
        })
    }
    @objc func dismissView() {
        self.buildVC?.dismiss(animated: true, completion: nil)
    }
    private func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("收到新消息Active\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }else{
            // 代表从后台接受消息后进入app
        }
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = String.init(format: "%@", deviceToken as CVarArg)
        let token:String = tokenString.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "") as String
        sharePublicDataSingle.publicData.pushToken = token
        RCIMClient.shared().setDeviceToken(token)
    }
    
    
    
    
}


//extension AppDelegate: SirenDelegate
//{
//    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
//        print(#function, alertType)
//    }
//
//    func sirenUserDidCancel() {
//        print(#function)
//    }
//
//    func sirenUserDidSkipVersion() {
//        print(#function)
//    }
//
//    func sirenUserDidLaunchAppStore() {
//        print(#function)
//    }
//
//    func sirenDidFailVersionCheck(error: Error) {
//        print(#function, error)
//    }
//
//    func sirenLatestVersionInstalled() {
//        print(#function, "Latest version of app is installed")
//    }
//
//    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
//        print(#function, "\(lookupModel)")
//    }
//
//    // This delegate method is only hit when alertType is initialized to .none
//    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
//        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
//    }
//}


