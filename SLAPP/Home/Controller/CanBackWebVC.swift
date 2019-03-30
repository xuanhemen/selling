//
//  CanBackWebVC.swift
//  SLAPP
//
//  Created by apple on 2018/3/4.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class CanBackWebVC: UIViewController,UIWebViewDelegate {

    @IBAction func backBtnClick(_ sender: Any) {
        
        if ((url?.range(of: "projectSurvey")) != nil) {
            if (currentUrlStr == url) {
                self.navigationController?.popViewController(animated: true)
                return
            }else{
                if index <= 0 {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                if web.canGoBack {
                    web.goBack()
                    index -= 1
                    if index <= 0 {
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                }else{
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        
        
    }
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var web: UIWebView!
    var index = 0
    var url:String?
    var currentUrlStr:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = kGrayColor_Slapp
        self.navigationController?.isNavigationBarHidden = true
        web.delegate = self
        web.loadRequest(URLRequest.init(url: URL.init(string: url!)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 0))
        backBtn.isHidden = false
//        backBtn.backgroundColor = UIColor.red
//        if ((url?.range(of: "addProject")) != nil) {
//            backBtn.isHidden = true
//
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setCookie()
    }
    
    /// 清楚cookies
    func deleleCookie(){
        
        let myCookies = HTTPCookieStorage.shared
        for c:HTTPCookie in myCookies.cookies!{
            myCookies.deleteCookie(c)
        }
    }
    
//    func setCookie(){
//
//        self.deleleCookie()
//        var cookieProperties =  [HTTPCookiePropertyKey : Any]()
//        cookieProperties[.name] = "xslp_sso_token"
//        cookieProperties[HTTPCookiePropertyKey.value] = UserModel.getUserModel().token!
//        cookieProperties[.domain] = url.host
//        cookieProperties[.path] = url.path
//        let cookie = HTTPCookie(properties: cookieProperties)
//        HTTPCookieStorage.shared.setCookie(cookie!)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if ((url?.range(of: "projectSurvey")) != nil) {
        self.navigationController?.isNavigationBarHidden = false
        }else{
             self.navigationController?.isNavigationBarHidden = true
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        DLog(request.url?.absoluteString)
        currentUrlStr = (request.url?.absoluteString)!
        if currentUrlStr != url {
            index += 1
        }
        return true
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

}
