//
//  RepeatMessageView.swift
//  GroupChatPlungSwiftPro
//
//  Created by 柴进 on 2017/4/21.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

class RepeatMessageView: UIView,UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var inputText = UITextField()
    var enterBtn = UIButton()
    var whiteView = UIView()
    var resourceView = UIView()
    
    
    init(type:String , modelArr:Array<GroupModel> , message:String) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        //根据微信截图设置缩放比例
        let scall = SCREEN_WIDTH/640.0
        
        //黑遮罩
        let blackBackView = UIView(frame: self.frame)
        blackBackView.backgroundColor = UIColor.black
        blackBackView.alpha = 0.5
        self.addSubview(blackBackView)
        
        var whiteHeight = SCREEN_WIDTH/8*7 - 60*scall
        
        //定制消息
        if message == "[图片]" {
            whiteHeight += 320*scall
            self.resourceView = UIImageView(frame: CGRect(x: (SCREEN_WIDTH/8*7 - 320*scall)/2, y: 240*scall, width: 320*scall, height: 320*scall))
            self.resourceView.contentMode = UIViewContentMode.scaleAspectFit
            
        }
        
        //白主体框
        self.whiteView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH/8*7, height: whiteHeight))
        self.whiteView.layer.masksToBounds = true
        self.whiteView.layer.cornerRadius = 5.0
        self.whiteView.clipsToBounds = true
//        whiteView.layer.borderWidth = 1.0
//        whiteView.layer.borderColor = UIColor.black.cgColor
        self.whiteView.backgroundColor = UIColor.white
        self.whiteView.alpha = 1.0
        
        
        self.whiteView.addSubview(self.resourceView)
        //发送给
        let sendToText = UILabel(frame: CGRect(x: 40.0*scall, y: 40.0*scall, width: 200.0, height: 20.0))
        sendToText.text = "发送给:"
        sendToText.font = UIFont.boldSystemFont(ofSize: 20)
        self.whiteView.addSubview(sendToText)
        
        //头像
//        let headIcon = UIImageView.init(frame: CGRect(x: 40.0*scall, y: 100.0*scall, width: 80*scall, height: 80*scall))
//        headIcon.sd_setImage(with: URL.init(string: model.icon_url), completed: nil)
//        headIcon.layer.masksToBounds = true
//        headIcon.layer.cornerRadius = 3.0
//        self.whiteView.addSubview(headIcon)
        
        //组群名
        let groupName = UILabel.init(frame: CGRect(x: 40.0*scall, y: 100.0*scall, width: 480*scall, height: 80*scall))
        groupName.numberOfLines = 0
        groupName.font = FONT_14
        groupName.text = ((modelArr as NSArray).value(forKeyPath: "group_name") as! NSArray).componentsJoined(by: ",")
        self.whiteView.addSubview(groupName)
        
        //分割线
        let line0 = UIView(frame: CGRect(x: 40.0*scall, y: 210*scall, width: 480*scall, height: 0.5))
        line0.backgroundColor = UIColor.gray
        line0.alpha = 0.5
        self.whiteView.addSubview(line0)
        
        //消息文字
        let messageText = UILabel(frame: CGRect(x: 40.0*scall, y: 240*scall, width: 480*scall, height: 20.0*scall))
        messageText.text = message
        messageText.font = UIFont.systemFont(ofSize: 18.0)
        messageText.textColor = UIColor.gray
        messageText.alpha = 0.7
        self.whiteView.addSubview(messageText)
        
        //输入框
        self.inputText = UITextField.init(frame: CGRect(x: (SCREEN_WIDTH/8*7-480*scall)/2, y: self.whiteView.frame.height-210*scall, width: 480.0*scall, height: 70*scall))
        self.inputText.placeholder = "给朋友留言"
        self.inputText.borderStyle = UITextBorderStyle.roundedRect
        self.inputText.delegate = self
        self.inputText.returnKeyType = UIReturnKeyType.done
        self.whiteView.addSubview(inputText)
        
        
        //确定取消按钮
        let cancelBtn = UIButton(type: UIButtonType.system)
        self.enterBtn = UIButton(type: UIButtonType.system)
        cancelBtn.frame = CGRect(x: 0.0, y: self.whiteView.frame.height-100.0*scall, width: self.whiteView.frame.width/2, height: 100.0*scall)
        self.enterBtn.frame = CGRect(x: self.whiteView.frame.width/2, y: self.whiteView.frame.height-100.0*scall, width: self.whiteView.frame.width/2, height: 100.0*scall)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        self.enterBtn.setTitle("发送", for: UIControlState.normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.enterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.enterBtn.setTitleColor(UIColor.green, for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(self.cleanBtn(btn:)), for: UIControlEvents.touchUpInside)
        
        self.whiteView.addSubview(cancelBtn)
        self.whiteView.addSubview(self.enterBtn)
        
        //按钮分割线
        let line1 = UIView(frame: CGRect(x: 0.0, y: self.whiteView.frame.height-100.0*scall, width: self.whiteView.frame.width, height: 0.5))
        let line2 = UIView(frame: CGRect(x: self.whiteView.frame.width/2, y: self.whiteView.frame.height-100.0*scall, width: 0.5, height: 100.0*scall))
        line1.alpha = 0.5
        line2.alpha = 0.5
        line1.backgroundColor = UIColor.gray
        line2.backgroundColor = UIColor.gray
        self.whiteView.addSubview(line1)
        self.whiteView.addSubview(line2)
            
        
//        if type == "pic" {
//            <#code#>
//        }
        
        self.addSubview(self.whiteView)
       self.whiteView.center = self.center
    }
    
    @objc func cleanBtn(btn:UIButton) {
        self.removeFromSuperview()
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    var keyHeight = CGFloat()
    
    
    @objc func keyboardWillShow(aNotification: NSNotification) {
        
        let userinfo = aNotification.userInfo!
        
        let nsValue = userinfo[UIKeyboardFrameEndUserInfoKey]
        
        let keyboardRec = (nsValue as AnyObject).cgRectValue
        
        let height = keyboardRec?.size.height
        
        self.keyHeight = height!
        
        UIView.animate(withDuration: 0.5, animations: {
            
            var frame = self.frame
            
            frame.origin.y = -self.keyHeight + (SCREEN_HEIGHT - self.whiteView.frame.height)/2
            
            self.frame = frame

        }, completion: nil)
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.5, animations: {
            
            var frame = self.frame
            
            frame.origin.y = 0
            
            self.frame = frame
            
        }, completion: nil)
        
        return true

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//        
//        UIView.animate(withDuration: 0.5, animations: {
//            
//            var frame = self.frame
//            
//            frame.origin.y = 0
//            
//            self.frame = frame
//            
//        }, completion: nil)
//        
//        return true
//
//    }

}
