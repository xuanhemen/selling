//
//  UILable+Extension.swift
//  SLAPP
//
//  Created by rms on 2018/2/3.
//  Copyright © 2018年 柴进. All rights reserved.
//

import Foundation

extension UILabel {
    
    func changeLineSpace(text: String, space: CGFloat){
        
        let attributedString = NSMutableAttributedString.init(string: text)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = space
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
        self.sizeToFit()
    }
    
    
    //计算lable高度（针对中文做了处理）
    static func getHeightWith(str:String,font:CGFloat,width:CGFloat)->(CGFloat){
        let lab = UILabel.init(frame: CGRect(x: 0, y: 0, width:width, height: 0))
        lab.text = str
        lab.font = UIFont.systemFont(ofSize: font)
        lab.numberOfLines = 0
        lab.sizeToFit()
        return lab.frame.size.height+lab.font.ascender
    }
    
}
