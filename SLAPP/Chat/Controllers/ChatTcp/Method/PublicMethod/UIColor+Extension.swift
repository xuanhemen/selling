//
//  UIColor+Extension.swift
//  GroupChatPlungSwiftPro
//
//  Created by rms on 17/3/2.
//  Copyright © 2017年 柴进. All rights reserved.
//

import Foundation

extension UIColor {
    
    static func hexString (hexString: String) -> UIColor {
        if hexString.isEmpty {
            return UIColor.white
        }
        // 默认颜色
        let DEFAULT_VOID_COLOR : UIColor = UIColor.white
        
        
        var cString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if cString.characters.count < 6 {
            return DEFAULT_VOID_COLOR
        }
        
        if cString.hasPrefix("0x") {
            cString = (cString as NSString).substring(from: 2)
        } else if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.characters.count != 6 {
            return DEFAULT_VOID_COLOR
        }
        
        var range : NSRange = NSRange(location: 0, length: 2)
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
