//
//  SignTool.swift
//  GroupChatPlungSwiftPro
//
//  Created by harry on 17/3/15.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

let KSecret = "f0c5ccf7d9b775bb8a92664522b03f02"
let KAppKey = "106"
class SignTool: NSObject {

    

    
}

//MARK: - ---------------------对外接口----------------------
extension SignTool{

    
    
    /// 获取签名后的Url  不要添加token
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - methodName: 请求方法名
    /// - Returns: 返回签名后的url
    public static func getSignUrlNotoken(params:Dictionary<String, Any>,methodName:String)->(String)
    {
       var url = String()
        url = host_url + self.signWith(params: params , methodName: methodName, needToken: false)
       return url
    }
    
    
    
    public static func passPortSignUrlNotoken(params:Dictionary<String, Any>,methodName:String)->(String)
    {
        var url = String()
        url = passport + self.signWith(params: params , methodName: methodName, needToken: false)
        return url
    }
    
    
    
    
    /// 获取签名后的url  需要token
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - methodName: 方法名称
    /// - Returns: 返回签名后的url
    public static func getSignUrl(params:Dictionary<String, Any>,methodName:String)->(String)
    {
        var url = String()
        url = host_url + self.signWith(params: params , methodName: methodName, needToken: true)
        return url
    }

    
    
    
    
    /// 做签名加密
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - methodName: 请求接口名称
    ///   - needToken: 是否需要加入token
    /// - Returns: 返回加密后的签名
    public static func signWith(params:Dictionary<String, Any>,methodName:String,needToken:Bool)->(String)
    {
       
        if needToken == true {
           //需要token
          let signDic:NSDictionary = ["app_key":KAppKey,
                                        "method":methodName,
                                        "access_token":sharePublicDataSingle.publicData.access_token,
                                        "timestamp":self.timeStamp(),
                                        "v":"V10",
                                        
            ]
          
         let md5SignStr = self.md5SignWith(params: signDic, paramsJsonStr: self.makeJsonStrWith(object: params)).uppercased()
            
            let finalStr = String.init(format: "app_key=%@&v=%@&method=%@&timestamp=%@&sign=%@&access_token=%@",signDic["app_key"] as! String, signDic["v"] as! String, signDic["method"] as! String,signDic["timestamp"] as! String, md5SignStr,signDic["access_token"] as! String)
         return finalStr
        }
        else
        {
          
            let signDic:NSDictionary = ["app_key":KAppKey,
                                        "method":methodName,
//                                        "access_token":self.getToken(),
                                        "timestamp":self.timeStamp(),
                                        "v":"V10",
                                        "access_token":"",
                                        ]
            
            let md5SignStr = self.md5SignWith(params: signDic, paramsJsonStr: self.makeJsonStrWith(object: params)).uppercased()
            
            
            let finalStr = String.init(format: "app_key=%@&v=%@&method=%@&timestamp=%@&sign=%@&access_token=",signDic["app_key"] as! String, signDic["v"] as! String, signDic["method"] as! String, signDic["timestamp"] as! String, md5SignStr)
            return finalStr
            
        }
        
     
    }
    
}


//MARK: - ---------------------本类内部方法，不对外提供----------------------
extension SignTool
{
    
    /// 获取token
    ///
    /// - Returns: 返回token
    fileprivate static func getToken()->(String)
    {
       return "123"
    }
    
    
    /// 做MD5加密
    ///
    /// - Parameters:
    ///   - params: <#params description#>
    ///   - paramsJsonStr: <#paramsJsonStr description#>
    /// - Returns: <#return value description#>
    fileprivate static func md5SignWith(params:NSDictionary,paramsJsonStr:String)->(String)
    {
//        if params["access_token"] == nil {
//            let str = String.init().appending(KSecret)
//                .appending("access_token")
//                .appending("app_key")
//                .appending(KAppKey)
//                .appending("method")
//                .appending(params["method"] as! String)
//                .appending("param_json")
//                .appending(paramsJsonStr)
//                .appending("timestamp")
//                .appending(params["timestamp"] as! String)
//                .appending("v")
//                .appending(params["v"] as! String)
//                .appending(KSecret);
//            
//            
////            let str = String.init(format: "%@app_key%@method%@param_json%@timestamp%@v%@%@", KSecret,params["app_key"] as! String,params["method"] as! String,paramsJsonStr,params["timestamp"] as! String,params["v"] as! String,KSecret)
//            return BaseRequest.md5StringFromString(str: str)!
//        }
//        else
//        {
//            let str = String.init(format: "%@access_token%@app_key%@method%@param_json%@timestamp%@v%@%@", KSecret,params["access_token"] as! String,params["app_key"] as! String,params["method"] as! String,paramsJsonStr,params["timestamp"] as! String,params["v"] as! String,KSecret)
//            return BaseRequest.md5StringFromString(str: str)!
//            
//        }
        var str = String.init().appending(KSecret)
            .appending("access_token")
            
        if params["access_token"] as! String != "" {
            str = str.appending(params["access_token"] as! String)
        }
        str = str.appending("app_key")
            .appending(KAppKey)
            .appending("method")
            .appending(params["method"] as! String)
            .appending("param_json")
            .appending(paramsJsonStr)
            .appending("timestamp")
            .appending(params["timestamp"] as! String)
            .appending("v")
            .appending(params["v"] as! String)
            .appending(KSecret);
        
        
        //            let str = String.init(format: "%@app_key%@method%@param_json%@timestamp%@v%@%@", KSecret,params["app_key"] as! String,params["method"] as! String,paramsJsonStr,params["timestamp"] as! String,params["v"] as! String,KSecret)
        return BaseRequest.md5StringFromString(str: str)!
    
    }
    
    
    /// 做json串处理
    ///
    /// - Parameter object: <#object description#>
    static func makeJsonStrWith(object:Any)->(String)
    {
      return  BaseRequest.makeJsonStringWithObject(object: object)
    }
    

    
    /// 获取时间戳
    ///
    /// - Returns: <#return value description#>
    fileprivate static func timeStamp()->(String)
    {
       let timeStamp = NSDate.timeIntervalSinceReferenceDate
       return String.init(format: "%0.f", timeStamp)
        
    }
    
}



