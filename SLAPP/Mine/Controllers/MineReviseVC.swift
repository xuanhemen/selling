//
//  MineReviseVC.swift
//  SLAPP
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class MineReviseVC: BaseVC,UIWebViewDelegate {
   
    var url:URL?
   
    @IBOutlet weak var web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web.loadRequest(URLRequest.init(url: url!))
        web.delegate = self
        // Do any additional setup after loading the view.
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        PublicMethod.showProgress()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        PublicMethod.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        PublicMethod.dismissWithError()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
