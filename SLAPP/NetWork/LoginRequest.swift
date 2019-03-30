//
//  LoginRequest.swift
//  SLAPP
//
//  Created by 柴进 on 2018/1/18.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class LoginRequest: BaseRequest {

    /// 登录
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func login(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: LOGIN_URL), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    /// 登录2
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func login2(params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: LOGIN_URL_COMPANY), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    
    ///  获取数据
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
  @objc public class func getPost(methodName:String, params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->())
    {
       
        self.basePost(url: SignTool.getSignUrlNotoken(params: params, methodName: methodName), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }
    ///  获取数据带task
    ///
    /// - Parameters:
    ///   - params: 请求参数
    ///   - hadToast: 是否提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func getPostWithTask(methodName:String, params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()) -> URLSessionDataTask
    {
        return self.basePostWithTask(url: SignTool.getSignUrlNotoken(params: params, methodName: methodName), params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
    }

    
    
    
    /// 上传录音
    ///
    /// - Parameters:
    ///   - name: 文件名字
    ///   - data: 要上传的数据
    ///   - url: 上传地址
    ///   - hadToast: 是否开启提醒
    ///   - fail: 失败返回
    ///   - success: 成功返回
    public static func postRecordWith(params:Dictionary<String,Any>,data:Data,url:String,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()){
       
//       let params = ["token":UserModel.getUserModel().token,"type":"4","parallelism_id":"0","parallelism_name":"测试"]
        
        guard params["parallelism_name"] != nil else {
            fail([:])
            return
        }
        let filename = "aaaa"+".mp3"
        self.baseUpload(url: url,name: "file",params: params, fileDatas: [data], fileNames: [filename], type: "mp3", hadToast: hadToast, fail: fail, success: success)

    }
    
    
    public static func sendHeadImage(image:UIImage,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()){
        let filename = "aaaa.jpg"
        let data = UIImageJPEGRepresentation(image, 0.5)
        self.baseUpload(url: passport+SEND_HEAD_IMAGE,name: "file",params: [:].addToken(), fileDatas: [data!], fileNames: [filename], type: "jpg", hadToast: hadToast, fail: fail, success: success)
    }
    
    public static func sendScanImage(image:UIImage,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()){
        let data = UIImageJPEGRepresentation(image, 0.5)
        self.baseUpload(url: passport+SEND_FOLLOW_IMAGE,name: "file",params: ["token":UserModel.getUserModel().token ?? "", "dir":"Contact"], fileDatas: [data!], fileNames: ["jpg"], type: "jpg", hadToast: hadToast, fail: fail, success: success)
    }
    
    public static func sendVCardImage(image:UIImage,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()){
        
        let filename = "public.jpg"
        let data = UIImageJPEGRepresentation(image, 0.5)
        self.baseUploadVcard(url: "http://bcr2.intsig.net/BCRService/BCR_VCF2?user=ios@salesvalley.cn&json=1&lang=15&pass=6TPDJ8WDNQEQJKGY&size=2048",name: "file",params: [:], fileDatas: [data!], fileNames: [filename], type: "jpg", hadToast: hadToast, fail: fail, success: success)
        
    }
    
    
        
    
//    public static func passportWithTask(methodName:String, params:Dictionary<String, Any>,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (_ success:Dictionary<String, Any>) ->()) -> URLSessionDataTask
//    {
//        let str = "https://t-passport.xslp.cn/api.php?"
//        return self.basePostWithTask(url:str.appending(SignToolOC.sign(withParams: params, andMethodName: USER_UPDATE, andToken: UserModel.getUserModel().token)) , params: ["param_json":SignTool.makeJsonStrWith(object: params)], hadToast: hadToast, fail: fail, success: success);
//    }
//
    
//    public static func passportImage(image:UIImage,hadToast:Bool,fail:@escaping ( _ fail:Dictionary<String, Any>) ->() ,success:@escaping (Dictionary<String, Any>)->())
//    {
//
//        let params = ["username":UserDefaultRead(key: kUserName),"password":UserDefaultRead(key: kPassword)]
//        let finalParams  = ["param_json":SignTool.makeJsonStrWith(object: params)];
//        let url = passport.appending(SignToolOC.sign(withParams: params, andMethodName: "xslp.user.modify_head", andToken:UserModel.getUserModel().token))
//        let data = UIImageJPEGRepresentation(image, 0.5)
//        self.passortCerbaseUpload(url: url,name: "uploadfile",params: finalParams, fileDatas: [data!], fileNames: ["image.jpg"], type: "image/jpg", hadToast: hadToast, fail: fail, success: success)
//    }
    
    
}
