//
//  BaseRequest.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/2.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import MJRefresh
import SwiftyJSON

let manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)

class BaseRequest: NSObject {
    
   
    
   
    //MARK:----------------------AF网络请求相关----------------------
    
    public static func initManager()->(AFHTTPSessionManager)
    {
        
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
  //      manager.requestSerializer.setValue("gzip", forHTTPHeaderField: "Content-Encoding")
//            [NSSet setWithObject:@"text/html"]
        return manager
    }
    

    //MARK:----------------------POST请求先关----------------------
    /// post请求
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - params: 请求参数
    ///   - hadToast: 是否添加提醒
    ///   - fail: 失败返回闭包(返回空闭包)
    ///   - success: 成功返回闭包
    public static func basePost(url:String,params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        DLog(url)
       let manager = self.initManager()
       let task:URLSessionDataTask? =  manager.post(url, parameters: params, progress: nil, success: { (task:URLSessionDataTask, any:Any) in
         if any is Dictionary<String, Any>{
            
            let dic = any as! Dictionary<String, Any>
            if dic["status"] as! String == "1" {
                success(any as! Dictionary<String, Any>)
                
            }else
            {
                fail(any as! Dictionary<String, Any>)
                self.logout(dic: dic)
                if hadToast == true{
                    SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic["msg"] ?? "网络出现错误"))
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }
               
                
                
            }
            
         }else{
//            let json = JSON(any)
            let str = String.init(data: any as! Data, encoding: String.Encoding.utf8)
//            DLog(str ?? "")
            
            DLog(str)
            
            var dic = try?JSONSerialization.jsonObject(with: any as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
//            let dic = json.dictionary
            
            if dic != nil{
                self.logout(dic: dic!)
            }
            
            
            if String.changeToString(inValue: dic?["status"] ?? "2") == "1" || String.changeToString(inValue: dic?["code"] ?? "2") == "1"{
               
                if dic?["data"] is Dictionary<String, Any>{
                    success(dic?["data"] as! Dictionary<String, Any>)
                }else{
                    success(dic!)
                }
            }else{
                if String.changeToString(inValue: dic?["status"] ?? "2") == "666" {
                    print("666666666666")
                    fail(dic!)
                }
                
                DLog(String.changeToString(inValue: dic?["msg"] ?? "错了"))
                if (dic != nil){
                    fail(dic!)
                }else{
                    //QF -- mark 修改
                    fail(["msg":"QF增加错误返回,dic为空","code":"2","status":"2"])
                }
                
                if hadToast == true{
                    SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic?["msg"] ?? "网络出现错误"))
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }
                
            }
//            [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]
            
        }
        }) { (task:URLSessionDataTask?,err:Error) in
            
            fail([:])
            if hadToast == true{
             SVProgressHUD.showError(withStatus: "网络出现错误")
             SVProgressHUD.dismiss(withDelay: 0.5)
            }
            let view = UIApplication.shared.keyWindow?.viewWithTag(10086)
            if view is UITableView {
                (view as! UITableView).mj_header.endRefreshing()
            }
           DLog(err.localizedDescription.description )
        }
        task?.resume()
    }
    
    
    
    
    /// 403
    ///
    /// - Parameter dic: 退出
  static func logout(dic:Dictionary<String,Any>)
    {
        if(String.noNilStr(str: dic["status"]) == "403"){
            
            SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic["msg"] ?? "网络出现错误"))
            if APPDelegate.window?.rootViewController is TabBarController {
                let tab:TabBarController = APPDelegate.window?.rootViewController as! TabBarController
                let nav:BaseNavigationController = tab.viewControllers?.last as! BaseNavigationController
                let vc:MineViewController = nav.viewControllers.first as! MineViewController
                vc.Logout()
            }
            return
        }
        
        
    }
    
    
    //MARK:----------------------POST请求先关带（task）----------------------
    /// post请求
    ///
    /// - Parameters:
    ///   - url: 请求地址
    ///   - params: 请求参数
    ///   - hadToast: 是否添加提醒
    ///   - fail: 失败返回闭包(返回空闭包)
    ///   - success: 成功返回闭包
    public static func basePostWithTask(url:String,params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()) -> URLSessionDataTask
    {
        let manager = self.initManager()
        let task:URLSessionDataTask? =  manager.post(url, parameters: params, progress: nil, success: { (task:URLSessionDataTask, any:Any) in
            if any is Dictionary<String, Any>{
                
                success(any as! Dictionary<String, Any>)
            }else{
                let str = String.init(data: any as! Data, encoding: String.Encoding.utf8)
                DLog(str ?? "")
                let dic = try?JSONSerialization.jsonObject(with: any as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                if String.changeToString(inValue: dic?["status"] ?? "2") == "1" || String.changeToString(inValue: dic?["code"] ?? "2") == "1"{
                    
                    if dic?["data"] is Dictionary<String, Any>{
                        success(dic?["data"] as! Dictionary<String, Any>)
                    }else{
                        success(dic!)
                    }
                }else{
                    DLog(String.changeToString(inValue: dic?["msg"] ?? "错了"))
                    if (dic != nil){
                        fail(dic!)
                    }
                    
                    if hadToast == true{
                        SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic?["msg"] ?? "网络出现错误"))
                        SVProgressHUD.dismiss(withDelay: 0.5)
                    }
                    
                }
                //            [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]
                
            }
        }) { (task:URLSessionDataTask?,err:Error) in
            
            if hadToast == true{
                SVProgressHUD.showError(withStatus: "网络出现错误")
                SVProgressHUD.dismiss(withDelay: 0.5)
            }
            let view = UIApplication.shared.keyWindow?.viewWithTag(10086)
            if view is UITableView {
                (view as! UITableView).mj_header.endRefreshing()
            }
            DLog(err.localizedDescription.description )
        }
        task?.resume()
        return task!
    }
    
    
    //MARK:----------------------Json 与 String 互转----------------------
    
    /// 将类转化为json串
    ///
    /// - Parameter object: 需要转化的类
    /// - Returns: 返回转换后的json串
  @objc  public static func makeJsonStringWithObject(object:Any)->(String)
    {
        let result :Data = try! JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonStr:String = String.init(data: result, encoding: .utf8)!
       return jsonStr
    }
    
    
    /// 将json串转成类
    ///
    /// - Parameter jsonStr: 需要转化的json串
    /// - Returns: 返回转换后的类
  @objc  public static func makeJsonWithString(jsonStr:String)->(Any)
    {
        let data:Data = jsonStr.data(using: .utf8)!
        let result = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
        return result
    }
    
    
    
    //MARK:----------------------MD5加密----------------------
    
    /// MD5 加密
    ///
    /// - Parameter str: 需要加密的字符串
    /// - Returns: MD5加密后的字符串
    public static func md5StringFromString(str:String)->(String?)
    {
        guard !str.isEmpty  else {
            return nil
        }
        
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    
    
   //MARK:----------------------其他相关----------------------
    
   /// 获取当前所在的最前边的UIViewController
   ///
   /// - Returns: 返回
   public static func appTopController() ->(UIViewController)
    {
        let appRoot = UIApplication.shared.keyWindow?.rootViewController
        var topVC = appRoot
        while ((topVC?.childViewControllers) != nil) {
            if topVC! is UITabBarController {
                topVC = (topVC! as! UITabBarController).selectedViewController
            }
            else if topVC! is UINavigationController
            {
               topVC = (topVC! as! UINavigationController).topViewController
            }
            else
            {
                break
            }
        }
        
        return topVC!
    }
    
    
    
    /// 错误提醒
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - message: 错误具体信息
    public static func analysisFailMessage(code:String,message:String)->()
    {
    
    
    }
    
    
    class func baseUploadVcard(url:String,name:String,params:Dictionary<String,Any>,fileDatas:Array<Data>,fileNames:Array<String>,type:String,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->(),success:@escaping (Dictionary<String, Any>)->()){
        
        manager.responseSerializer.acceptableContentTypes =  (NSSet.init(object: "application/json") as! Set<String>)
        let postTask = manager.post(url, parameters: params, constructingBodyWith: { (formData) in
           
            for i in 0...fileDatas.count - 1{
                let fileData = fileDatas[i]
                formData.appendPart(withFileData: fileData, name: name, fileName: fileNames[i], mimeType: type)
            }
            
        }, progress: { (_) in
            
        }, success: { (task, any:Any) in
            
            if any is Dictionary<String, Any>{
                
                success(any as! Dictionary<String, Any>)
            }else{
                let str = String.init(data: any as! Data, encoding: String.Encoding.utf8)
                
                DLog(str ?? "")
                let dic = try?JSONSerialization.jsonObject(with: any as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                if dic != nil {
                    success(dic!)
                }else{
                    fail([:])
                }
                
            }
        }) { (task, error) in
            
            DLog(error.localizedDescription)
            fail([:])
            if hadToast == true{
                //撤销HUD
//                SVProgressHUD.showError(withStatus: "网络出现错误")
//                SVProgressHUD.dismiss(withDelay: 0.5)
            }
            let view = UIApplication.shared.keyWindow?.viewWithTag(10086)
            if view is UITableView {
                (view as! UITableView).mj_header.endRefreshing()
            }
           
        
        task?.resume()
            
            
        }
        postTask?.resume()
    }
    class func baseUpload(url:String,name:String,params:Dictionary<String,Any>,fileDatas:Array<Data>,fileNames:Array<String>,type:String,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->(),success:@escaping (Dictionary<String, Any>)->()){
        
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        let postTask = manager.post(url, parameters: params, constructingBodyWith: { (formData) in
            
            for i in 0...fileDatas.count - 1{
                let fileData = fileDatas[i]
                formData.appendPart(withFileData: fileData, name: name, fileName: fileNames[i], mimeType: type)
            }
            
        }, progress: { (_) in
            
        }, success: { (task, any:Any) in
            
            if any is Dictionary<String, Any>{
                
                success(any as! Dictionary<String, Any>)
            }else{
                let str = String.init(data: any as! Data, encoding: String.Encoding.utf8)
                
                DLog(str ?? "")
                let dic = try?JSONSerialization.jsonObject(with: any as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                if String.changeToString(inValue: dic?["status"] ?? "2") == "1" {
                    if dic?["data"] is Dictionary<String, Any>{
                        success(dic?["data"] as! Dictionary<String, Any>)
                    }else{
                        success(dic!)
                    }
                }else{
                    DLog(String.changeToString(inValue: dic?["msg"] ?? "错了"))
                    if (dic != nil){
                        fail(dic!)
                    }
                    
                    if hadToast == true{
                        SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic?["msg"] ?? "出现错误"))
                        SVProgressHUD.dismiss(withDelay: 0.5)
                    }
                    
                }
                //            [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]
                
            }
            
            //            success(response as! Dictionary<String, Any>)
        }) { (task, error) in
            
            DLog(error.localizedDescription)
            fail([:])
            if hadToast == true{
//                SVProgressHUD.showError(withStatus: "网络出现错误")
//                SVProgressHUD.dismiss(withDelay: 0.5)
            }
            let view = UIApplication.shared.keyWindow?.viewWithTag(10086)
            if view is UITableView {
                (view as! UITableView).mj_header.endRefreshing()
            }
            
            
            task?.resume()
            
            
        }
        postTask?.resume()
    }
    
    
    class func passortCerbaseUpload(url:String,name:String,params:Dictionary<String,Any>,fileDatas:Array<Data>,fileNames:Array<String>,type:String,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->(),success:@escaping (Dictionary<String, Any>)->()){
//                let manager = self.initManager()
        let manager = AFHTTPSessionManager.init(baseURL: URL.init(string: "https://passport.xslp.cn"), sessionConfiguration: URLSessionConfiguration.default)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        manager.securityPolicy  = self.customSecurityPolicy()
        let postTask = manager.post(url, parameters: params, constructingBodyWith: { (formData) in
            
            for i in 0...fileDatas.count - 1{
                let fileData = fileDatas[i]
                formData.appendPart(withFileData: fileData, name: name, fileName: fileNames[i], mimeType: type)
            }
            
        }, progress: { (_) in
            
        }, success: { (task, any:Any) in
            
            if any is Dictionary<String, Any>{
                
                success(any as! Dictionary<String, Any>)
            }else{
                let str = String.init(data: any as! Data, encoding: String.Encoding.utf8)
                
                DLog(str ?? "")
                let dic = try?JSONSerialization.jsonObject(with: any as! Data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
                if String.changeToString(inValue: dic?["status"] ?? "2") == "1" {
                    if dic?["data"] is Dictionary<String, Any>{
                        success(dic?["data"] as! Dictionary<String, Any>)
                    }else{
                        success(dic!)
                    }
                }else{
                    DLog(String.changeToString(inValue: dic?["msg"] ?? "错了"))
                    if (dic != nil){
                        fail(dic!)
                    }
                    
                    if hadToast == true{
                        SVProgressHUD.showError(withStatus: String.changeToString(inValue: dic?["msg"] ?? "网络出现错误"))
                        SVProgressHUD.dismiss(withDelay: 0.5)
                    }
                    
                }
                //            [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding]
                
            }
            
            //            success(response as! Dictionary<String, Any>)
        }) { (task, error) in
            
            DLog(error.localizedDescription)
            fail([:])
            if hadToast == true{
                SVProgressHUD.showError(withStatus: "网络出现错误")
                SVProgressHUD.dismiss(withDelay: 0.5)
            }
            let view = UIApplication.shared.keyWindow?.viewWithTag(10086)
            if view is UITableView {
                (view as! UITableView).mj_header.endRefreshing()
            }
            
            
            task?.resume()
            
            
        }
        postTask?.resume()
    }
    
    
    
    
    class func customSecurityPolicy()->(AFSecurityPolicy){
    
        let path = Bundle.main.path(forResource: "CLApp", ofType: "cer")
        let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: path!))
        let sec = AFSecurityPolicy.init(pinningMode: .certificate, withPinnedCertificates: [data])
        sec.allowInvalidCertificates = true
        sec.validatesDomainName = true
        let set:Set = [data]
//        sec.pinnedCertificates = set
        return sec
//        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//        // AFSSLPinningModeCertificate 使用证书验证模式
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = YES;
//
//        NSSet *set = [[NSSet alloc]initWithObjects:certData, nil];
//        securityPolicy.pinnedCertificates = set;
//        return securityPolicy;
    }
    
}
