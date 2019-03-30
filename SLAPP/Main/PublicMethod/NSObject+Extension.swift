//
//  NSObject+Extension.swift
//  SLAPP
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension NSObject {
    
    
    /// 友盟统计事件
    ///
    /// - Parameter name: 要统计的事件名称
    func umAnalyticsWithName(name:String){
        DLog("统计事件"+name)
      
       MobClick.event(name)
    }
    
    
    /// 服务器环境地址配置
    func config(){
        let info = Bundle.main.infoDictionary
        let isOnline  =  String.noNilStr(str: info?["EnvironmentIsOnline"])
        if isOnline == "1" {
            
             passport = "https://passport.xslp.cn/index.php?s="
             host_url = "http://gw.xslp.cn/index.php?" //网络接口 //正式
             h5_host = "http://sl.xslp.cn/"
             tcp_host = "http://tcp.xslp.cn/"
             ryKey = "sfci50a7sqloi"  //融云key
             defaultHeaderImageURL = "http://tcp.xslp.cn/static/images/userpic.jpg"
             umAnalyticsKey = "5b077084f43e486f0e0000dc" //友盟统计Appkey
             umChannel = "App Store" //友盟统计Channel
            
        }else{
            //测试地址
            passport = "https://t-passport.xslp.cn/index.php?s="
            host_url = "http://t-gw.xslp.cn/index.php?" //网络接口 //测试
            h5_host = "http://t-sl.xslp.cn/"
            tcp_host = "http://t-tcp.xslp.cn/"
            ryKey = "qf3d5gbjqpxeh"
            defaultHeaderImageURL = "http://t-tcp.xslp.cn/static/images/userpic.jpg"
            umAnalyticsKey = "5b076fa8f43e487fa7000098" //友盟统计Appkey
            umChannel = "App Store" //友盟统计Channel
        }
        
    }
    
}


extension UIViewController {
    
    /// 更新权限和部门信息
    ///
    /// - Parameter finish:
    func updateInfo(finish:@escaping ()->()){
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: LOGINER_MESSAGE, params: ["token":UserModel.getUserModel().token], hadToast: true, fail: { (dic) in
            PublicMethod.dismissWithError()
        }) {[weak self] (dic) in
            PublicMethod.dismiss()
             let userModel = UserModel.getUserModel()
             userModel.is_root = String.noNilStr(str: dic["is_root"])
             userModel.depId = String.noNilStr(str: dic["dep_id"])
             userModel.saveUserModel()
             finish()
        }
    }
    
    
    
    
    
    
    func showAlert(titleStr:String,finish:@escaping ()->()){

        let alert = UIAlertController.init(title: "温馨提示", message: titleStr, preferredStyle: .alert, btns: [kCancel:"取消","sure":"确定"], btnActions: {[weak self] (ac, str) in
            if str != kCancel {
                finish();
            }else{
                
            }
        })
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
}
