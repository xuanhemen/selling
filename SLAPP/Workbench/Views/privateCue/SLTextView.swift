//
//  SLTextView.swift
//  SLAPP
//
//  Created by 董建伟 on 2019/1/12.
//  Copyright © 2019年 柴进. All rights reserved.
//

import UIKit

class SLTextView: UIView,UITextViewDelegate {

    lazy var textView = UITextView.init()
    var rect: CGRect?
    typealias CommentInfo = (String) -> Void
    var comment: CommentInfo?
    override init(frame: CGRect){
        super.init(frame:frame)
        self.frame = CGRect(x: 0, y: SCREEN_HEIGHT+50, width: SCREEN_WIDTH, height: 50)
        
       // rect = self.frame
        textView.backgroundColor = RGBA(R: 245, G: 245, B: 245, A: 1)
        textView.isEditable = true
        textView.delegate = self
        self.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 50))
        }
    }
    func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = value.cgRectValue
//        self.frame = CGRect(x: 0, y: SCREEN_HEIGHT-keyboardRect.size.height-100, width: SCREEN_WIDTH, height: 50)
        self.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: SCREEN_WIDTH, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-keyboardRect.size.height)
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        self.removeFromSuperview()
       // self.frame = rect!
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.comment!(textView.text)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
