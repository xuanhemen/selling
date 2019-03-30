//
//  ReviseVC.swift
//  SLAPP
//
//  Created by apple on 2018/2/28.
//  Copyright © 2018年 柴进. All rights reserved.
//

import UIKit

class ReviseVC: UIViewController {
    
    var titleStr = ""
    
    let text = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleStr
        self.view.backgroundColor = UIColor.groupTableViewBackground
        let backView = UIView()
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.right.equalTo(0)
            make.top.equalTo(10)
        }
        backView.addSubview(text)
        text.placeholder = "请填写"
        text.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(30)
        }
        self.setRightBtnWithArray(items: ["保存"])
    }
    override func rightBtnClick(button: UIButton) {
        guard !(text.text?.isEmpty)! else {
            PublicMethod.toastWithText(toastText: "姓名不能为空");            return
        }
        PublicMethod.showProgress()
        
        LoginRequest.getPost(methodName: USER_UPDATE, params: ["username":text.text].addToken(), hadToast: true, fail: { (dic) in
        PublicMethod.dismissWithError()
        }) { (dic) in
            PublicMethod.dismiss()
            self.navigationController?.popViewController(animated: true)
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

}
