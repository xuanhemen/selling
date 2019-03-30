//
//  ApplyJoinGroupTextView.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/16.
//  Copyright © 2017年 柴进. All rights reserved.
//

import UIKit

fileprivate let maxTextLength = 30
class ApplyJoinGroupTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        self.font = FONT_14
        self.textColor = UIColor.black
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.hexString(hexString: headerBorderColor).cgColor
        self.layer.borderWidth = 0.5
        self.textContainerInset = UIEdgeInsetsMake(12, 5, 0, 0)
        self.addSubview(placeholderLabel)
        self.addSubview(textLengthLabel)
        placeholderLabel.text = placeholder
        placeholderLabel.mas_makeConstraints { (make) in
            make!.top.equalTo()(12)
            make!.left.equalTo()(10)
        }
        textLengthLabel.mas_makeConstraints { (make) in
            make!.top.equalTo()(inputTV_height_MAX - 20)
            make!.left.equalTo()(frame.size.width - 40 - 10)
            make!.width.equalTo()(40)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var placeholder : String?{
    
        didSet{
            placeholderLabel.text = placeholder
            if (placeholder?.contains("申请消息"))! {
                textLengthLabel.isHidden = false
                textLengthLabel.text = "0/\(maxTextLength)"
            }else{
                textLengthLabel.isHidden = true
            }
        }
    }
    
    lazy var placeholderLabel: UILabel = {
        var placeholderLabel = UILabel.init()
        placeholderLabel.font = FONT_14
        placeholderLabel.textColor = UIColor.lightGray
        return placeholderLabel
    }()
    
    lazy var textLengthLabel: UILabel = {
        var textLengthLabel = UILabel.init()
        textLengthLabel.font = FONT_14
        textLengthLabel.textColor = UIColor.lightGray
        textLengthLabel.textAlignment = .right
        textLengthLabel.text = "0/\(maxTextLength)"
        return textLengthLabel
    }()
}

extension ApplyJoinGroupTextView : UITextViewDelegate{

    func textViewDidChange(_ textView: UITextView) {//同样的代码:适配iOS8
        if textView.textInputMode?.primaryLanguage == "zh-Hans" {
            let selectedRange : UITextRange? = textView.markedTextRange
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textView.position(from: (selectedRange?.start)!, offset: 0)!
            }
            if position == nil {
                if (textView.text?.characters.count)! > 0 {
                    placeholderLabel.isHidden = true
                }else{
                    placeholderLabel.isHidden = false
                }
                
                if (textView.text?.characters.count)! > maxTextLength {
                    textView.text = textView.text?.substring(to: (textView.text?.index((textView.text?.startIndex)!, offsetBy: maxTextLength))!)
                    textLengthLabel.text = "\(maxTextLength)/\(maxTextLength)"
                    return
                }
                textLengthLabel.text = "\((textView.text?.characters.count)!)/\(maxTextLength)"
            }else{
                
            }
        }else{
            if (textView.text?.characters.count)! > 0 {
                placeholderLabel.isHidden = true
            }else{
                placeholderLabel.isHidden = false
            }
            
            if (textView.text?.characters.count)! > maxTextLength {
                textView.text = textView.text?.substring(to: (textView.text?.index((textView.text?.startIndex)!, offsetBy: maxTextLength))!)
                textLengthLabel.text = "\(maxTextLength)/\(maxTextLength)"
                return
            }
            textLengthLabel.text = "\((textView.text?.characters.count)!)/\(maxTextLength)"
        }

        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        var str = textView.text?.replacingCharacters(in: (textView.text?.changeToRange(from: range)!)!, with: text)
        if textView.textInputMode?.primaryLanguage == "zh-Hans" {
            let selectedRange : UITextRange? = textView.markedTextRange
            var position : UITextPosition? = nil
            if (selectedRange != nil) {
                position = textView.position(from: (selectedRange?.start)!, offset: 0)!
            }
            if position == nil {
                if (str?.characters.count)! > 0 {
                    placeholderLabel.isHidden = true
                }else{
                    placeholderLabel.isHidden = false
                }
                
                if (str?.characters.count)! > maxTextLength {
                    textView.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
                    textLengthLabel.text = "\(maxTextLength)/\(maxTextLength)"
                    return false
                }

            }else{
                
            }
        }else{
            if (str?.characters.count)! > 0 {
                placeholderLabel.isHidden = true
            }else{
                placeholderLabel.isHidden = false
            }
            
            if (str?.characters.count)! > maxTextLength {
                textView.text = str?.substring(to: (str?.index((str?.startIndex)!, offsetBy: maxTextLength))!)
                textLengthLabel.text = "\(maxTextLength)/\(maxTextLength)"
                return false
            }

        }

        return true
    }
}
