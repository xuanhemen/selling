//
//  AttributedString+Extension.swift
//  SLAPP
//
//  Created by fank on 2018/12/5.
//  Copyright © 2018年 柴进. All rights reserved.
//

extension NSMutableAttributedString {
    
    class func attributeStringWithText(textOne:String, textTwo:String, textThree:String, colorOne:UIColor, colorTwo:UIColor, fontOne:UIFont, fontTwo:UIFont) -> NSMutableAttributedString {
        
        let attr = NSMutableAttributedString(string: textOne + textTwo + textThree)
        
        attr.setAttributes([NSAttributedStringKey.foregroundColor:colorOne, NSAttributedStringKey.font:fontOne], range: NSMakeRange(0, textOne.count))
        
        attr.setAttributes([NSAttributedStringKey.foregroundColor:colorTwo, NSAttributedStringKey.font:fontTwo], range: NSMakeRange(textOne.count, textTwo.count))
        
        attr.setAttributes([NSAttributedStringKey.foregroundColor:colorOne, NSAttributedStringKey.font:fontOne], range: NSMakeRange(textOne.count + textTwo.count, textThree.count))
        
        return attr
    }
    
}
