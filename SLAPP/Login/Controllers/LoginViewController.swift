//
//  LoginViewController.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/15.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    let loginV = LoginView.init(frame: CGRect(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT))

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let status  = (UIApplication.shared.value(forKey: "statusBarWindow") as! NSObject).value(forKey: "statusBar") as! UIView
        status.backgroundColor = UIColor.clear
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "登录"
        
//        let back = YGGravityImageView.init(frame: CGRect.init(x: 0, y: 0, width: MAIN_SCREEN_WIDTH, height: MAIN_SCREEN_HEIGHT))
//        back.image = UIImage.init(named: "login_bg6")
//        back.startAnimate()
//        self.view.addSubview(back)
        loginV.phoneNum.text = UserDefaultRead(key: kUserName) as? String
        loginV.passWord.text = UserDefaultRead(key: kPassword) as? String
        loginV.forgetPassword.addTarget(self, action: #selector(forgetClick), for: .touchUpInside)
        loginV.buyBtn.addTarget(self, action: #selector(buyButtonClick), for: .touchUpInside)
        self.view.addSubview(loginV)
        loginV.loginBtn.reactive.controlEvents(UIControlEvents.touchUpInside).observe { (event) in
            
            PublicMethod.showProgressWithStr(statusStr: "正在登录")
            LoginRequest.login(params: ["username":self.loginV.phoneNum.text!.removeHiddenCode(),"password":BaseRequest.md5StringFromString(str: self.loginV.passWord.text!) ?? "","_domain":"CC"], hadToast: false, fail: { [weak self] (dic) in
                PublicMethod.dismiss()
                print(dic)
                if String.changeToString(inValue: dic["status"] ?? "2") == "666" {
                    let alert = UIAlertController(title: "提示", message: String.noNilStr(str: dic["msg"]), preferredStyle: .alert)
                    let array:Array<Dictionary<String,Any>> = dic["data"] as! Array<Dictionary<String, Any>>
                    for subDict in array{
                        let action = UIAlertAction.init(title: String.noNilStr(str: subDict["name"]), style: .default, handler: { (sender) in
                            let urlString = String.noNilStr(str: subDict["url"])
                            UIApplication.shared.open(URL.init(string: urlString)!, options: [:], completionHandler: { (success) in
                            })
                        })
                        alert.addAction(action)
                    }
                    let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: { (sender) in
                    })
                    alert.addAction(cancelAction)
                    self?.present(alert, animated: true, completion: nil)
                }else{
                    SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic["msg"] ?? "网络出现错误"))
                }
                
            }, success: { (dic) in
                UserDefaultWrite(id: dic["userid"] as? String, key: kUserid)
                UserDefaultWrite(id: self.loginV.phoneNum.text, key: kUserName)
                UserDefaultWrite(id: self.loginV.passWord.text, key: kPassword)
                
                let userModel = UserModel.getUserModel()
                userModel.id = dic["userid"] as? String
                
                let companies = dic["companies"] as! Array<Dictionary<String,Any>>
                if companies.count == 1{
                    userModel.companies = ["id":String(describing: companies[0]["id"] as! NSNumber),"name":companies[0]["name"] as! String]
                    LoginRequest.login2(params: ["userid":dic["userid"],"corpid":companies[0]["id"]], hadToast: true, fail: { (dic) in
                        DLog(dic)
                    }, success: { [weak self](dic) in
                        DLog(dic)
                        userModel.guide = dic["guide"] is String ? dic["guide"] as! String : String(describing: dic["guide"] as! NSNumber)
                        userModel.is_pass = dic["is_pass"] is String ? dic["is_pass"] as! String : String(describing: dic["is_pass"] as! NSNumber)
                        userModel.token = dic["token"] as? String
                        userModel.is_root = dic["is_root"] is String ? dic["is_root"] as! String : String(describing: dic["is_root"] as! NSNumber)
                        userModel.ismanager = dic["ismanager"] is String ? dic["ismanager"] as! String : String(describing: dic["ismanager"] as! NSNumber)
                        userModel.corpid = String(describing: companies[0]["id"] as! NSNumber)
                        userModel.saveUserModel()
                        sharePublicDataSingle.publicData.corpid = String(describing: companies[0]["id"] as! NSNumber)
                        sharePublicDataSingle.token = dic["token"] as! NSString

                        
                        self?.connectRongYun(success: {
                            PublicMethod.dismiss()
                            DispatchQueue.main.async {
                                if userModel.is_pass == "0" || userModel.guide == "0"{
                                    APPDelegate.window?.rootViewController = BaseNavigationController.init(rootViewController: WelcomeViewController())
                                }else{
                                let tab = TabBarController.init(nibName: nil, bundle: nil)
                                APPDelegate.window?.rootViewController = tab
                                }
                            }
                        }, error: { (str) in
                            PublicMethod.dismissWithErrorStr(str: "登录失败")
                        })
                    })
                }else{
                    PublicMethod.dismiss()
                    self.chooseCorpWithCrop(cropDic: companies)
                }
            
            })
        }        // Do any additional setup after loading the view.
    }
    /**
     *  获取登录成功信息    第三方登录也是（检查是绑定过就返回）
     *
     *  @param result <#result description#>
     */
//    func haveLoginSucessInfo(result:Dictionary<String,Any>) {
//        UserDefaultWrite(id: loginV.phoneNum.text, key: kUserName)
//        UserDefaultWrite(id: loginV.passWord.text, key: kPassword)
//        UserDefaultWrite(id: result["userid"], key: kUserid)
//
//        var model = UserModel.getUserModel()
//        if model == nil {
//            model = UserModel.init(coder: NSCoder.init())
//        }
//    }
    
    func chooseCorpWithCrop(cropDic:Array<Dictionary<String,Any>>) {
        let svc = ChooseCompanyView.init(frame: CGRect.zero)
        svc.companyDic = cropDic
        self.view.addSubview(svc)
//        let svc = ChooseCompanyTableViewController.init(nibName: nil, bundle: nil)
//        svc.companyDic = cropDic
        svc.chooseOne = {cDic in
            let userModel = UserModel.getUserModel()
            userModel.id = UserDefaultRead(key: kUserid) as? String
            userModel.companies = ["id":String(describing: cDic["id"] as! NSNumber),"name":cDic["name"] as! String]
            PublicMethod.showProgress()
            LoginRequest.login2(params: ["userid":userModel.id,"corpid":cDic["id"]], hadToast: true, fail: { (dic) in
                PublicMethod.toastWithText(toastText: "网络出现错误,请再次选择")
                
            }, success: { [weak self](dic) in
                DLog(dic)
                userModel.guide = dic["guide"] is String ? dic["guide"] as! String : String(describing: dic["guide"] as! NSNumber)
                userModel.is_pass = dic["is_pass"] is String ? dic["is_pass"] as! String : String(describing: dic["is_pass"] as! NSNumber)
                userModel.token = dic["token"] as? String
                userModel.is_root = dic["is_root"] is String ? dic["is_root"] as! String : String(describing: dic["is_root"] as! NSNumber)
                userModel.corpid = String(describing: cDic["id"] as! NSNumber)
                userModel.ismanager = dic["ismanager"] is String ? dic["ismanager"] as! String : String(describing: dic["ismanager"] as! NSNumber)
                userModel.saveUserModel()
                sharePublicDataSingle.publicData.corpid = String(describing: cDic["id"])
                sharePublicDataSingle.token = dic["token"] as! NSString
//                self.navigationController?.popViewController(animated: true)
                
                
                self?.connectRongYun(success: {
                    PublicMethod.dismiss()
                    DispatchQueue.main.async {
                        if userModel.is_pass == "0" || userModel.guide == "0"{
                            APPDelegate.window?.rootViewController = BaseNavigationController.init(rootViewController: WelcomeViewController())
                        }else{
                            let tab = TabBarController.init(nibName: nil, bundle: nil)
                            APPDelegate.window?.rootViewController = tab
                        }
                    }

                }, error: { (str) in
                    PublicMethod.dismissWithErrorStr(str: "登录失败")

                })
            })
        }
//        self.navigationController?.pushViewController(svc, animated: true)
        
        
    }
    
    //连接融云
    func connectRongYun(success: (() -> ())!, error: ((_ str:String?) -> ())!) {
        
        if (UserModel.getUserModel().im_token != nil) {
            
             self.connectToRCIM()
            success()
        }
        else{
        
        LoginRequest.getPost(methodName: IM_GetToken, params: ["app_token":UserModel.getUserModel().token!], hadToast: true, fail: { (dic) in
            error("")
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            DLog(dic)
            let userModel = UserModel.getUserModel()
            userModel.avater = dic["avater"] as? String
            userModel.realname = dic["realname"] as? String
            userModel.im_token = dic["im_token"] as? String
            userModel.im_userid = dic["im_userid"] as? String
            userModel.tcp_userid = dic["userid"] as? String
            userModel.saveUserModel()
            
            sharePublicDataSingle.publicData.userid = dic["userid"] as! String
            sharePublicDataSingle.publicData.avater = dic["avater"] as! String
            sharePublicDataSingle.publicData.realname = dic["realname"] as! String
            sharePublicDataSingle.publicData.im_token = dic["im_token"] as! String
            sharePublicDataSingle.publicData.im_userid = dic["im_userid"] as! String
            sharePublicDataSingle.startGetMessageNot()
           
            DataOperation.initDataBase()
            
            let username:String = sharePublicDataSingle.publicData.userid + sharePublicDataSingle.publicData.corpid
            let getRemote:Bool? = UserDefaults.standard.object(forKey: getRemoteKey + username) as! Bool?
            if getRemote == nil {
                UserDefaults.standard.set(true, forKey: getRemoteKey + username)
            }
            var time:String? = (UserDefaults.standard.object(forKey: username) as? String)
            
            if (time == nil ){
                time = "0"
            }
            if UserModelTcp.allObjects().count == 0 {
                UserDefaults.standard.set("0", forKey: username)
                time = "0"
            }
            
            UserRequest.initData(params: ["app_token":UserModel.getUserModel().token!,"updatetime":time!], hadToast: true, fail: { (error) in
                //                DLog(error)
            }, success: { (dic) in
                PublicMethod.dismiss()
                success()
                self?.connectToRCIM()
                //本地后台通知
                //                RCIM.shared().disableMessageNotificaiton = true
                RCIM.shared().disableMessageAlertSound = true
            })
           
        }
        }
    }
    
    //连接融云服务器
    func connectToRCIM(){
        
        RCIM.shared().connect(withToken: UserModel.getUserModel().im_token, success: { (userId) in
//            success()
            DLog("登陆成功。当前登录的用户ID：\(userId)")
            if !sharePublicDataSingle.publicData.pushToken.isEmpty {
                RCIMClient.shared().setDeviceToken(sharePublicDataSingle.publicData.pushToken)
            }
        }, error: { (status) in
//            error("登陆的错误码为:\(status)")
            DLog("登陆的错误码为:\(status)")
        }) {
//            error("token错误")
            DLog("token错误")
        }
        //本地后台通知
        RCIM.shared().disableMessageAlertSound = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func forgetClick(){
//        let canBack = UIViewController()
//        let web = UIWebView()
//        web.loadRequest(URLRequest.init(url: URL.init(string: passport + "/user/user/forget")!))
//        canBack.view = web
//        canBack.title = "找回密码"
//        self.navigationController?.isNavigationBarHidden = false
////        canBack.url = passport + "/user/user/forget"
        self.navigationController?.pushViewController(FindPasswordVC(), animated: true)
        
    }
    @objc func buyButtonClick(){
        //        let canBack = UIViewController()
        //        let web = UIWebView()
        //        web.loadRequest(URLRequest.init(url: URL.init(string: passport + "/user/user/forget")!))
        //        canBack.view = web
        //        canBack.title = "找回密码"
        //        self.navigationController?.isNavigationBarHidden = false
        ////        canBack.url = passport + "/user/user/forget"
        
        var textURL = "http://t-oppo.xslp.cn/h5/product/intro.html?id=1&src=app&src_d=ios"
        
        let info = Bundle.main.infoDictionary
        let isOnline  =  info!["EnvironmentIsOnline"] as! String
        if (isOnline == "1") {
            textURL = "https://oppo.xslp.cn/h5/product/intro.html?id=1&src=app&src_d=ios";
        }
            
        let cleanURL = URL.init(string: textURL)
        UIApplication.shared.open(cleanURL!, options: [:]) { (isSuccess) in
            
        }
        
        //self.navigationController?.pushViewController(HYLoginBuyVC(), animated: true)
        
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
