//
//  GroupNoticeEditViewController.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/20.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class GroupNoticeEditViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "群公告"
        self.setRightBtnWithArray(items: ["完成"])
        
        self.view.addSubview(inputTextView)
        inputTextView.mas_makeConstraints { (make) in
            make!.top.equalTo()(20)
            make!.left.equalTo()(10)
            make!.right.equalTo()(-10)
            make!.height.equalTo()(300)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func rightBtnClick(button: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    lazy var inputTextView: UITextView = {
        var inputTextView = UITextView.init()
        inputTextView.font = FONT_16
        inputTextView.textColor = UIColor.black
        return inputTextView
    }()
}
