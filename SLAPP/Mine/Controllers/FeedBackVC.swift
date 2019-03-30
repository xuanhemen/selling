//
//  FeedBackVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/27.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
class FeedBackVC: UIViewController {

   lazy  var  suggestions:KMPlaceholderTextView = {
        let text = KMPlaceholderTextView()
        text.placeholder = "请填写反馈意见"
        return text
    }()
    
    lazy  var  contact:UITextField = {
        let text = UITextField()
        text.placeholder = "请填写电子邮件、手机号或者QQ"
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        self.configUI()
        self.setRightBtnWithArray(items: ["发送"])
       
    }
    
    override func rightBtnClick(button: UIButton) {
        
        if suggestions.text.isEmpty {
            
            PublicMethod.toastWithText(toastText: "反馈意见不能为空")
            return
        }
        let info = Bundle.main.infoDictionary
        let majorVersion :AnyObject? = info?["CFBundleShortVersionString"] as AnyObject
        
        
        PublicMethod.showProgress()
        LoginRequest.getPost(methodName: RECOMMEND, params: ["version":"CC","suggestions":suggestions.text!,"os":UIDevice.current.systemVersion,"brand":"iphone","resolution":"1","model":majorVersion,"contact":"1"].addToken(), hadToast: true, fail: { (dic) in
            PublicMethod.dismiss()
        }) { [weak self](dic) in
            PublicMethod.dismiss()
            self?.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    func configUI(){
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(suggestions)
        self.view.addSubview(contact)
        
        suggestions.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalTo(0)
            make.height.equalTo(150)
        }
        
//        let lable = UILabel()
//        self.view.addSubview(lable)
//        lable.text = "联系方式"
//        lable.backgroundColor = UIColor.white
//        lable.snp.makeConstraints {[weak self] (make) in
//            make.height.equalTo(50)
//            make.left.right.equalTo(0)
//            make.top.equalTo((self?.suggestions.snp.bottom)!).offset(20)
//        }
        
//        let line = UIView()
//        line.backgroundColor = UIColor.lightGray
//        lable.addSubview(line)
//        line.snp.makeConstraints { (make) in
//            make.height.equalTo(0.5)
//            make.left.right.equalTo(0)
//            make.bottom.equalToSuperview().offset(0.5)
//        }
        
//        contact.backgroundColor = UIColor.white
//        contact.snp.makeConstraints {[weak lable] (make) in
//            make.height.equalTo(50)
//            make.left.right.equalTo(0)
//            make.top.equalTo((lable?.snp.bottom)!).offset(0)
//        }
        
        
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
